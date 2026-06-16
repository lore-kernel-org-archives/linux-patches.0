Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510503D45CB;
	Tue, 16 Jun 2026 18:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634122; cv=none; b=aeolkAEQ0GJLPLlXQ/YDxwJvHwU1BYTdVcP3rS2UTqxrGz5erkeIIRBaR5tWxmMHLGGHLMsH6uqIfmZxhHrH0dYcroq7R1O74i97L6fxWj/uHv7jkIycp3/esIUsIys2Ua9eq/K/MaAcMtvg0zyvRiJiBOpLsgfVkJbcP33DXjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634122; c=relaxed/simple;
	bh=PVpr63UxBemehGr+3PH63rtN+0+NWum5Ng2pfLIbYdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcZ2MfM3ikzUVoG9WHNENN8ATy6aNoMTPt7DNZXWZA5ZD1Pa5pNSw0rw/P7kFk+8h1LtB2FMQDdu0JevT7BIx8ySaEN9KpwNJwSOsBGRRrw6ZOaB96hp9pd0yfQPrpYgT9bwNFrlSGpzuRkJjx6+3xFH8eNHQQIIwuOEO/1E3Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=co1XN1bV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="co1XN1bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162291F000E9;
	Tue, 16 Jun 2026 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634121;
	bh=R+6hKvyquz6DnMNrc9rAfwex4ZCHHuWB5nlaxo5sJU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=co1XN1bVPv62GEpG3T49e4t/PIiEFqtC575eDVDWefyiNRcOXUgWjTqixtgZubnSb
	 NrvxjqHbn3q0axG56MeUqkcbBi2f/3k/Nc7mhy47RW20hKvjVEs9awMILtApUxsUds
	 iuf5iSaGvu/50IahoVdUdnMeXJy/a2VXRqyAQCZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 206/411] USB: serial: io_ti: fix heap overflow in build_i2c_fw_hdr()
Date: Tue, 16 Jun 2026 20:27:24 +0530
Message-ID: <20260616145111.695542157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Korwel <adriank20047@gmail.com>

commit 0fd2b00b2d3d05e3eaa13342b3dfb0fa85c226ae upstream.

build_i2c_fw_hdr() allocates a fixed-size buffer of
(16*1024 - 512) + sizeof(struct ti_i2c_firmware_rec) bytes, then
copies le16_to_cpu(img_header->Length) bytes into it without
validating that Length fits within the available space after the
firmware record header.

img_header->Length is a __le16 from the firmware file and can be
up to 65535. check_fw_sanity() validates the total firmware size
but not img_header->Length specifically.

Fix by rejecting images where img_header->Length exceeds the
available destination space.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Korwel <adriank20047@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_ti.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -843,6 +843,11 @@ static int build_i2c_fw_hdr(u8 *header,
 	/* Pointer to fw_down memory image */
 	img_header = (struct ti_i2c_image_header *)&fw->data[4];
 
+	if (le16_to_cpu(img_header->Length) >
+			buffer_size - sizeof(struct ti_i2c_firmware_rec)) {
+		kfree(buffer);
+		return -EINVAL;
+	}
 	memcpy(buffer + sizeof(struct ti_i2c_firmware_rec),
 		&fw->data[4 + sizeof(struct ti_i2c_image_header)],
 		le16_to_cpu(img_header->Length));


