Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A8943D4E8;
	Tue, 16 Jun 2026 17:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629513; cv=none; b=VpT2e+fRc+jORpUK39X+OIadzKbzzUG8pk40cHr3fQ5BZb0LTrIKW2IYIMN/ycEoYpKwhTyazinyORMARbW5hVRhbwYKfL9PDSpLgdg3s1kyyfz8Uh7ZtjU7mSpzBlVTV4QynEjG3VnVc5yNuHiakagnEVPAl4sYi7v4dt/T0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629513; c=relaxed/simple;
	bh=m3ZlHccrlG+3p8NNVTmxyiY9WBq6UQutydFTbi7t7jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd9Zxn/1LrAOW2UtbXdIbXnLA4Xj++bwGGJN4kA2XX0OGHrjOfE0HcFDXoRv1vt0D5Qjqqu1gCQGWzXiWee/zGExiXKg3Kj/jtc7xgknlkqa+lK/XVoDKdwGUF6iOAZApnAj5JTm0znB8SOxGPj7eofIr82valOidO5CL4+kznw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDX5CC0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDX5CC0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E291F000E9;
	Tue, 16 Jun 2026 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629512;
	bh=li2Q4FTphL8nCS1el0dhHPUaS0RdGcTQMBRpAjxdrWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDX5CC0+tQMzDBR9gXagXsFN1KSzBtGLWe1Shtkvw3PmH2Gy6PU9JBJ0NjM+gtfH3
	 HIJZiP56rVKeaaTYMR0mdtBb/tNQYIueOjwWJCg9r5nA8t8Mkt2GeAIvWi2SQCKToC
	 LkMM6qlG9vWtHnzZ+u3uOjarY/G5dyi4uhC5LRbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 300/452] USB: serial: io_ti: fix heap overflow in get_manuf_info()
Date: Tue, 16 Jun 2026 20:28:47 +0530
Message-ID: <20260616145133.279759282@linuxfoundation.org>
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

commit 183c1076eca43bbb3e7bdf597456f91d81c73e74 upstream.

get_manuf_info() reads le16_to_cpu(rom_desc->Size) bytes from the
device I2C EEPROM into a buffer allocated with kmalloc_obj(), which
is sizeof(struct edge_ti_manuf_descriptor) = 10 bytes.

The Size field comes from the device and is only validated (in
check_i2c_image()) to make sure the descriptor fits within
TI_MAX_I2C_SIZE (16384 bytes), not against the destination buffer size.
A malicious USB device can therefore set Size to any value up to 16377,
causing a heap overflow of up to 16367 bytes when plugged into a host
running this driver.

valid_csum() is called after read_rom() and also iterates
buffer[0..Size-1], compounding the out-of-bounds access.

Fix by rejecting descriptors with unexpected length before calling
read_rom().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Korwel <adriank20047@gmail.com>
[ johan: amend commit message; also check for short descriptors ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_ti.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -773,6 +773,12 @@ static int get_manuf_info(struct edgepor
 	}
 
 	/* Read the descriptor data */
+	if (le16_to_cpu(rom_desc->Size) != sizeof(struct edge_ti_manuf_descriptor)) {
+		dev_err(dev, "unexpected Edge descriptor length: %u\n",
+			le16_to_cpu(rom_desc->Size));
+		status = -EINVAL;
+		goto exit;
+	}
 	status = read_rom(serial, start_address+sizeof(struct ti_i2c_desc),
 					le16_to_cpu(rom_desc->Size), buffer);
 	if (status)


