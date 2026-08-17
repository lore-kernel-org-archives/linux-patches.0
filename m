Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C44426D03;
	Mon, 17 Aug 2026 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978334; cv=none; b=LqAJponGdTtNvNkrHillc8fbIeETduTSJsG3+BIpnKivlpr+92UD7jaLlksSn19uTkwdkPxhcHbJhxPfOvJ5wOwmA1Ep5CCJMlQ/EhGBAIV/X3YchpN6H4kwzZ0qt5H2CWmEOeeSO1vHop+VkYiCM4nBfx25Ol5la85ggmb678M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978334; c=relaxed/simple;
	bh=IfPY2xz+i6FACi+l0d543Bd01jWIqudEZrnCjRMd0QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su1baClmsVbwGxCtEdDhJIYemNcBEK1IYN2QRaswWbl+EwbXRHqwWbreJDQGMWfr/vEIoMBNXX9hxTAjoa7Ac5Ih8O7K0D3D4dA06iXjtqTiUKrk9JozpARw+5t/3Orj+4Jl5RKsE9hO+Ia9t1R7rDmg1sZrin952OCGuEcyXgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMVLfYv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMVLfYv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0901F000E9;
	Mon, 17 Aug 2026 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978333;
	bh=D0U1SVVdtWXG/ZLRAj76Nsw90dYY1J0RL35ArmZNODA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMVLfYv0vKVUUlU7040AwRjO9RUu5RpszKiKItu3PUICmLAHkIRPBvJ1+zzYY2uap
	 kw4bhjraOTIV/ID5oEP/l497uzZn4yqgq4SujLeLMLvnLUGc+nOFHF3Om+iNzkpa1o
	 uOxWWgzcdYimdYoe/apZl7bif0tqOjMYu1Z3slk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 165/181] ptp: ocp: Fix board ID over-read
Date: Mon, 17 Aug 2026 15:34:19 +0200
Message-ID: <20260817132542.174654930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Byagowi <ahmadexp@gmail.com>

commit 6b69f2ef10cdb018c0b127a7cab88e590bbddba4 upstream.

The EEPROM board ID is a fixed 13-byte field and is not guaranteed to
contain a NUL terminator. Passing it directly to
devlink_info_version_fixed_put() treats it as a C string and may read
beyond the field.

Format at most OCP_BOARD_ID_LEN bytes into the existing local buffer
before reporting the ID. Use a precision limit because the snprintf()
output size alone does not bound the source string scan.

Fixes: 0cfcdd1ebcfe ("ptp: ocp: add nvmem interface for accessing eeprom")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Byagowi <ahmadexp@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260804210751.48248-1-ahmadexp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_ocp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1914,9 +1914,11 @@ ptp_ocp_devlink_info_get(struct devlink
 	if (err)
 		return err;
 
+	snprintf(buf, sizeof(buf), "%.*s", OCP_BOARD_ID_LEN,
+		 (const char *)bp->board_id);
 	err = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
-			bp->board_id);
+			buf);
 	if (err)
 		return err;
 


