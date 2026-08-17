Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C44B04A9;
	Mon, 17 Aug 2026 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975297; cv=none; b=mJQ3bwzPgPV2ktn+6vLyz3WltDUZZauBl5fCcdtA2yRCiZfxoZ89phZ648CQTwY17nt4YJJSymP/IeEj8uRGNpzMSXvcl5EffQNchPTLUCAiwnzjMhVkl9+WrSKfDI2YbiZgdHO065+Q00HH0DMY7vRH8Ew6ZI48oHzFPiOwvnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975297; c=relaxed/simple;
	bh=Hy9NweQ/KTDTeI+cqC0HscN/1D8famk7wV71shQjfn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQh+ThO0pCAgqGdTUXt6QSR7frMhu5eVx8bmJNEp2B0Cpans9Dt82okbmTYcQFBZwpx+NNLWd5QDWJKMv9R53xkPCVf0hKps16nI0OOuzX0/mQWKn2tKSx8Y2meugBoqpcefw/2J1olSI76/QevZd+5xhgMccaRVQoYwiYvV/DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMxiRI76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMxiRI76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5161F000E9;
	Mon, 17 Aug 2026 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975296;
	bh=uWA5AaGCH4lTB8kOzGPK0S2kiPQy0H8j9J5+IaAxtjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMxiRI76Vppg8O2+FfetpJbpjFH4np55tz7g0apJhJQGA5D/vV8xxPeyBePhkmS+O
	 Urz6GEM118pDSeMQrBfNdKR1jCUmWjyHNkXoiS8GPnnxE3sXzSjp2YLkZpHHTTrysD
	 8p2EsX+2Lr2NsslIJObFotXiVsWdoNZYyLhDFMBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 229/250] ptp: ocp: Fix board ID over-read
Date: Mon, 17 Aug 2026 15:33:10 +0200
Message-ID: <20260817132545.862127578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1916,9 +1916,11 @@ ptp_ocp_devlink_info_get(struct devlink
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
 


