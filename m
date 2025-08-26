Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447FA20B7EE;
	Tue, 26 Aug 2025 11:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207303; cv=none; b=HDzUsnpO1EFPIuaHHsGkL0lfHKCa7PUdZtm0ZqzqvvOn4bQdmcjaBwLAEDios6FH/ebTXiaUg0A6buhdEedX56A0yakhbUAqLHjbyQBaMO5xCFiGsWULazlr4hUGfSRLKoLkvpzuEnjcKl031VYktdFkySWDNJPNwDPFuHgYtoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207303; c=relaxed/simple;
	bh=OGQ1h5zDeY+65JIojxtawqm61efJfN/6Pmbkp7/Jj08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsdQVNPEvjBmJu6gOtrt3aHqUmkv//qmMXMAg9Sv3WGJeuOB8wrCp75kFVD85MTro3qEhXpZLwdwmNzB4TEjfAP8kPaNeqJCNVKKt0U9vcSI2Ns9yRNQNasq0Ri2c35dt/Ca6RSRk9Y5SJ3eSq+2ZJAIgbcsqQGfRfzElfzzNm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6JMjNxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6JMjNxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C965AC4CEF1;
	Tue, 26 Aug 2025 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207303;
	bh=OGQ1h5zDeY+65JIojxtawqm61efJfN/6Pmbkp7/Jj08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6JMjNxFAb81m95mGcNdFIP8eRcQZKbJ9FKGLY7g0abkmlkzNdK1/u89AilJqBTX0
	 1SPpy4kg6GNszEaLbwFF8V/rQCZ9oVw/VGrri4VlUTq67ThwyOxRdDSmCk88FxQxM8
	 5l3yXF7XO7iy5WFaOYDCQcC/jZxtOjm5ZDsLKcqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 130/457] media: gspca: Add bounds checking to firmware parser
Date: Tue, 26 Aug 2025 13:06:54 +0200
Message-ID: <20250826110940.586199293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


