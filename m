Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E419334DCCA;
	Tue, 26 Aug 2025 13:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216638; cv=none; b=G4Afpbd7RykwjD4VYC6AvaS2j0v5yE9NKqGYM4ze7oaEm9kIXFOD+EX6Kzl1JWLtQWgNx5ywmNEx1gEfvnZhTHpBzHVEIbpXH6fIw7JJB9od/F/0pWUDHUAVU2C7XEi8fqE4ue6XyAKD79MTy9aPdb5mB7QQaI6d/bm7o5kmSlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216638; c=relaxed/simple;
	bh=3wCi7UugKmw36M0cn2U+8cX7KFnBjW6Ikvqc+ic6gn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjLv7Q1THC1TSAaQT8OxuA7iIDK07lLDvaM8vGPc1hebcqfuVdR1yKJZCaF0JvVslSIG7prFiITe+JB7yxnIoa7zWcfsaRvcyYpL+qRGWWyMMMsX7h8JDOj4XLhwYUFFziR/oroJUYkqgzCv5GAETtKe3NGYuRea94zVYFG5UTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E03bXb39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E03bXb39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775F6C4CEF1;
	Tue, 26 Aug 2025 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216637;
	bh=3wCi7UugKmw36M0cn2U+8cX7KFnBjW6Ikvqc+ic6gn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E03bXb39Nm79ea9fE5KbT3fH40tv3d8LEDq5mUbpjiiVVr/EUYADH3EZiKZGgph3P
	 WLIISAsscqyywsM9thaSX/SQP7KniobZ6PTVKhzN/4mkTxvhzmMPjkPqP6B07VnhPD
	 FnkXLsXWNOFuXs+sVAp02t4Nk9EL4sLMFse99diU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 486/644] media: gspca: Add bounds checking to firmware parser
Date: Tue, 26 Aug 2025 13:09:37 +0200
Message-ID: <20250826110958.533596320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


