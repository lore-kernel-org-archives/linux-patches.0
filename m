Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D7F352FFC;
	Tue, 26 Aug 2025 14:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219232; cv=none; b=c+JtJgSItFFrGfeSkSUPeq2p5eLsCZdJijLiYeG0Aps/F+JigqxlyTMoPyFLCiF7jdAhv8EcZFior52jJWPuAS14nsJX/R1SVDP0ZZn34HPHp3i8Ydj20XkQpy3uJR9rlCOzUP2jSpRpzVFv12p0HN/XxyRYkBVVjFgnitFZPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219232; c=relaxed/simple;
	bh=TyUDVZw2ycnJVYdmcP8QZczFU1hJl2r5nPYWxYoilE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUyqhxjztPKK87AvxMKNvbQIYwGpXlWsw+JNSx9C38aE/EpC+HhpcKz2H2qfI/a/Jg8Rjg35PtW779IRCwA/XWLcG+Q68JX5rItq+dXSFRgcBEqrKjSFy/maKHoSwoYeda4OOfdwxcLdjAL8FIH2Us03SCxPJ9h+SAIHyxCgnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEuty4R2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEuty4R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A73EC4CEF1;
	Tue, 26 Aug 2025 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219232;
	bh=TyUDVZw2ycnJVYdmcP8QZczFU1hJl2r5nPYWxYoilE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEuty4R2Gn7MOdbDRswMPxvCWOG0g6/p5ON5NzNOyDfB/vOFEPdRzMiMCw0uEZcnG
	 6qxFrNYNvjWEjkN3WQFPKSS8RzrQ9pI2nO3UxrYYFIfw/PW/OvnFr652F+NgYQ5KSh
	 dg1X0g0Jh039LZJXIniSxqS6KZ4aAcLwJZv3ljxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 303/403] media: gspca: Add bounds checking to firmware parser
Date: Tue, 26 Aug 2025 13:10:29 +0200
Message-ID: <20250826110915.186328923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit aef89c0b2417da79cb2062a95476288f9f203ab0 upstream.

This sd_init() function reads the firmware.  The firmware data holds a
series of records and the function reads each record and sends the data
to the device.  The request_ihex_firmware() function
calls ihex_validate_fw() which ensures that the total length of all the
records won't read out of bounds of the fw->data[].

However, a potential issue is if there is a single very large
record (larger than PAGE_SIZE) and that would result in memory
corruption.  Generally we trust the firmware, but it's always better to
double check.

Fixes: 49b61ec9b5af ("[media] gspca: Add new vicam subdriver")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/vicam.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -227,6 +227,7 @@ static int sd_init(struct gspca_dev *gsp
 	const struct ihex_binrec *rec;
 	const struct firmware *fw;
 	u8 *firmware_buf;
+	int len;
 
 	ret = request_ihex_firmware(&fw, VICAM_FIRMWARE,
 				    &gspca_dev->dev->dev);
@@ -241,9 +242,14 @@ static int sd_init(struct gspca_dev *gsp
 		goto exit;
 	}
 	for (rec = (void *)fw->data; rec; rec = ihex_next_binrec(rec)) {
-		memcpy(firmware_buf, rec->data, be16_to_cpu(rec->len));
+		len = be16_to_cpu(rec->len);
+		if (len > PAGE_SIZE) {
+			ret = -EINVAL;
+			break;
+		}
+		memcpy(firmware_buf, rec->data, len);
 		ret = vicam_control_msg(gspca_dev, 0xff, 0, 0, firmware_buf,
-					be16_to_cpu(rec->len));
+					len);
 		if (ret < 0)
 			break;
 	}


