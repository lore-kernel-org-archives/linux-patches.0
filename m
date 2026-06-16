Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1954328610;
	Tue, 16 Jun 2026 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629518; cv=none; b=mYEWmvd+uBUaOPfR1squb2s0/Gvy30Wgctb7xotrufq3VVrOGYH9zSwbFcV4ZaygisPduCYcIi6G/LhhFMuE5I/JN7X3tH15Ho3lxYEFJ/A0bGY55nqGwVN8IEXCPtuRl2s1zHFZxOTuiNJOeZchqUXOth/ZpQtIygaFuf9v9Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629518; c=relaxed/simple;
	bh=C/ce/y3ePRfbqEUVOiWKqHMq1Ixjly/Q0+ODLYFxM8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO/jfnc+PQxDm4hHXE77lzUOMFndnEbFpJTZNFWd9ig3GElYpxS8+7De/fpaqbxS8haIkmnOnA2drk3PdKfRORgXpn0CvZ5pcZxvb/ADkJf1pvbPyw/XHxIMxaRq+pdGpc9gxBxIZS9aascjusAd4RVpr1VUdz8TMxzm6EV2iOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lff8iDdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lff8iDdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1811F000E9;
	Tue, 16 Jun 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629517;
	bh=iJydEXHTU/xdU3/XmJsMeSkItJ3m22VCfItmTAU+rNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lff8iDdLhoy15ivvsl6ovJyn6wMmxT/j9VAXEaZza26WN3hLJ0qIKzMP5oOWAbeZf
	 j5+asdO8lUAS5g/jen1AsrdKyWRqb6eCuSHa8hNtUVKIpC/x6oeLe/S+FcpYbg8Bc7
	 rRTmmACVgZBPwuEM9mVeZwimqZxl/0byyh9yvhlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 301/452] USB: serial: io_ti: fix heap overflow in build_i2c_fw_hdr()
Date: Tue, 16 Jun 2026 20:28:48 +0530
Message-ID: <20260616145133.326669574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -844,6 +844,11 @@ static int build_i2c_fw_hdr(u8 *header,
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


