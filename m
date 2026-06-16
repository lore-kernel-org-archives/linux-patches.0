Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0201F4534B9;
	Tue, 16 Jun 2026 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627273; cv=none; b=gYcuqmmEX+Ulfrs+NVJ8hx7UlQQOVJyJWeosK3DbGbcphsZ6t5Ldq46I3kop2AQlqRnEJmSU7fYwfY7Nz9kME7EjCyo9aBTKqTDOPvXz9Z6lu9dCbt0t/RBdlB4f7UsyFjqeNp2QdfUZfGmSxJM91D6z6yNSwLw/lNRpWi3m/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627273; c=relaxed/simple;
	bh=sGkUPqCTuQm1sq5U0jvmw4OxrT/EVl11kzUA30jpDZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUcLTUlNjGp0K9BzTAtVEeMuJnhSy+quL4KkdeWcbFYKZtn3Z/5zF/bPvtvaUAFtmrByMs7g2v7LZp8acSMzsAkpaiAWN3OTsbeE6deyaXPcNYN4+AgBE9qk+zj+1VuBca5yz/YDPIyBrvEQZTlX0bnjMhax5RAVPQ1GMqPTGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbPk8C3+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbPk8C3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E1D1F000E9;
	Tue, 16 Jun 2026 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627272;
	bh=vROBRPhe1Qy8F1WaYQENg+9MNWj9kw59Osvp6fZJqAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbPk8C3+YpBHgPfxp2IfVhfYvZtLLwFtLDaQTQrpsqjpEaXX4TmD+4wyrY9TSS0NE
	 Yt5dIWZDUgs2WZehWIxv3XOohOCY1RuxkQqsxcQlL2fJo7uE1aSkxc6I/MrngGtf4a
	 QxRq0jT1u0AcJVFu/0/6Ym/a1AiE7X4npNtQP87c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 139/261] USB: serial: io_ti: fix heap overflow in get_manuf_info()
Date: Tue, 16 Jun 2026 20:29:37 +0530
Message-ID: <20260616145051.523729680@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


