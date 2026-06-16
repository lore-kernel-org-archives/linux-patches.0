Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B645E47AF68;
	Tue, 16 Jun 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631731; cv=none; b=Ub0+pW/QiO58s7hEryPJwPO/FavGfG9ow5WdeOYXcRD1+Gn81R1wFpjbGtbaoMCDsQhZ/0M2vsxrJcOXlwSoaEyMWpiHAONaxhtjQ61I0UZUx8yUJi4i2DHtnsIjjEj4OWmNx0kpCuVoPmBUhHqBtiiGJ9RghQFIoHOifB8D9hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631731; c=relaxed/simple;
	bh=EE4WtZBLRMUo3N6KJgz7JvCJcwgsbCxloYAfXiLUhh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk9dgMkpzOdc5TJuA/9b0XePGAzAbSPSRF+zAkAoGfTTLMwV9VZNrcAU+2opdLpXo0t55TR+zGh8DgiqzIPkqYaD7WmgMxTW4O0gAQ5WY8+BWP+vyxpsjGcX2Mh/x2km+1I7vF5tLnm1MER6nwdKxteMe0jlP9Yy4emdFZqlSfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dau/Cy6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dau/Cy6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F84D1F00A3A;
	Tue, 16 Jun 2026 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631725;
	bh=H27Zf1T8vykfVzZ6B+kTzFzNP9jw9JUDE2vMlCrSkZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dau/Cy6F0O3M1w+pJrF89R53OzVaPAQycFkC3ARVH8nWZP1wcnEAC9cgQRrRLiw/U
	 02o5KdiYz8jw5XmVRFR8DQAsy56R/fg+Ml5nIL6nNKzMUaEo3MnYfeDreT4+ogsZR6
	 q7c9uE6vyZ3o+YGmXsbLC5pbWOMqFd8eqV3fbYAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 274/522] USB: serial: io_ti: fix heap overflow in get_manuf_info()
Date: Tue, 16 Jun 2026 20:27:01 +0530
Message-ID: <20260616145138.787216305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


