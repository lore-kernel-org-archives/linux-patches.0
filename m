Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F94933FE27;
	Wed,  3 Dec 2025 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777319; cv=none; b=IbPIvQgnzttmUBCkaBnc45pGMd47rKObCs0jHCFUOR8nU8SYA+ulpJlX1c1CLRxlhEcgzNIFTE6fQUm/tItcwke8WrqUSkzdJwN9oPK/0VnbFpuVbQ7am+6PdD6ZhQ5xRPczMdtiCJnGhek033eE+6uM0BolU6g2M95zPXanAnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777319; c=relaxed/simple;
	bh=xJTP6zkJDvF+Lx4u+iVesrAvCoVQffyTlIj3LScdApk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9QsBnVdtD3ZmRc1KUelVvIYPmycs1ERtQl88FKnlhWYkuqYHEFmSi6LgOu6rnyzUN0Eqr3P1w5Km6+W99wXshIBOSjwstpS+BVsXQMoqxTIyAFKdb+lugy1f+jwA3bKqf3kpbHDmJsSMdv1G1XcJPFt57/vD58cc045p5U/hO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdFpk70v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdFpk70v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0666C19423;
	Wed,  3 Dec 2025 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777319;
	bh=xJTP6zkJDvF+Lx4u+iVesrAvCoVQffyTlIj3LScdApk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdFpk70vygjZN869bzgg/gXUuTO4Koh0svWFbZsgVSAdw86tXN4tZesmwaXTbRLJX
	 xqttFsT7GQ3c8PlGMRFxl4wVmkWiDzqvgAB8O1ZKP7sFbwh6BAUgdENgkTe62Teo4o
	 gP4lbdfO7LmkObwUIEyGvYjN+hPN9AR3RJLTaQcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.17 115/146] usb: storage: sddr55: Reject out-of-bound new_pba
Date: Wed,  3 Dec 2025 16:28:13 +0100
Message-ID: <20251203152350.673719391@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

commit b59d4fda7e7d0aff1043a7f742487cb829f5aac1 upstream.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

new_pba comes from the status packet returned after each write.
A bogus device could report values beyond the block count derived
from info->capacity, letting the driver walk off the end of
pba_to_lba[] and corrupt heap memory.

Reject PBAs that exceed the computed block count and fail the
transfer so we avoid touching out-of-range mapping entries.

Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/B2DC73A3EE1E3A1D+202511161322001664687@tencent.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/sddr55.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -469,6 +469,12 @@ static int sddr55_write_data(struct us_d
 		new_pba = (status[3] + (status[4] << 8) + (status[5] << 16))
 						  >> info->blockshift;
 
+		/* check if device-reported new_pba is out of range */
+		if (new_pba >= (info->capacity >> (info->blockshift + info->pageshift))) {
+			result = USB_STOR_TRANSPORT_FAILED;
+			goto leave;
+		}
+
 		/* check status for error */
 		if (status[0] == 0xff && status[1] == 0x4) {
 			info->pba_to_lba[new_pba] = BAD_BLOCK;


