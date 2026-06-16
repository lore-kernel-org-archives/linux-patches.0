Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470EC44103A;
	Tue, 16 Jun 2026 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625651; cv=none; b=RbEy/SI8OeWYH/Fwg0hyUXit/WO3ZVF3XOljOlMBk+1EZ1EMZkf4b52QrBdC1LASQCQ7/o6ZdmVLcB+XwAA/PltvAuhHi3u0BZN8ZW6Ey9KypO5fpndRKWEVVjHXQ+tvbJqw5AKQUtiXQiuAWJhinkLBb5psLsufSqsbA2UZgf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625651; c=relaxed/simple;
	bh=83Anj1u6BGP28mlpO8TW5yA745cM6w1jf8psEDqxA/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmZhAvAtPJNjr/kVXzc7X+C7Je9hGVNmUqjXdhAV9qRxygbewYyZ/uhK7C18/rGtdGytz8HQhRR+vD1xWpip//MNZDbA49ERdAULPBV8GuUocl0NnjTRcuZ79XptgcqIM1xrgYCeJNyk+ati+DZTJQgLw80mdbkoqKKqQQTcnpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGuezqdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGuezqdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB621F000E9;
	Tue, 16 Jun 2026 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625650;
	bh=pmin3lPGbJXe2KcT2tIg0ihe6UiTH9V2/qrMKa5Xwho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGuezqdHTOMATDsilnwTPbz2Fqhtxy0QTySi2mIEBP1Ii03fCYIpjp3E9b+2Gs2WM
	 +KaTOkdpLRPkc+LYEEkBh1yQIP+1D4dtJ0H6f1alJKYw+uqOssFT+4PuJlgLWVQe5S
	 9f8db+Yn+X3thNPY6IRaMNxXifQXj9PyM7Vkchto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 174/325] USB: serial: io_ti: fix heap overflow in get_manuf_info()
Date: Tue, 16 Jun 2026 20:29:30 +0530
Message-ID: <20260616145106.522033932@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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


