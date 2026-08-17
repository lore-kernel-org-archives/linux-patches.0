Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91BF43F0B1;
	Mon, 17 Aug 2026 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974594; cv=none; b=VejZRTspSqRAvcuUWNH2XLCd6lzlzUCAjPyO2IHoVGrKKMWnbtlpTb5I4PXPogR0LtjoVYx2j/Q+vEEqX6REZviPJnAhciOJI//9OwfjI5ge71+LYntaeJ6DAHtkPG2kRsqIfykVHslmXzwXpVjuy5pYqjJyE5ySqlmFlveStv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974594; c=relaxed/simple;
	bh=KStJJKDRfOYFCppFrZv1sXiFjd7nv4+HWfvEYh66ZFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l49N7MXlqiRm8E3C3nJq8paL6H32w6X+MXChO/A7Y++5fVyAKVT5NVDyqV3I6J2q0j6wPj362aMdj4xiXoPjH3TI1o4Nn2Ozr9hZS+/hWBcfWMLq5tRy3bxZlxxZ/uHxoQLc83+32D/Pg9Jx0bGtN0bHupX5Sxw8hgoEnz5yCxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUBGdETf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUBGdETf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A821F00A3D;
	Mon, 17 Aug 2026 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974585;
	bh=NoFYcp0lHj/yMiE1zIX9SobIjmbgx8lQ3+redTuF3ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUBGdETfqby5f8k3S/VZBK1YIJ8+X5qrdrrP+XvRJn3mgaIZzOTFJsgaywMLROd6W
	 PrDtmolArt/j/li4BF3GguYyDFwwg8Hu5j1QwdjoBlz13VBmFIdPCczFsYG4Kst/uG
	 AmA5tT7mYFJbWLYEjNmsIWHwpYUJL5gid/8VSc3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 249/271] ptp: ocp: Fix board ID over-read
Date: Mon, 17 Aug 2026 15:32:54 +0200
Message-ID: <20260817132546.989473540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2180,9 +2180,11 @@ ptp_ocp_devlink_info_get(struct devlink
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
 


