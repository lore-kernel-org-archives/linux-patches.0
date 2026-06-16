Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E933263A;
	Tue, 16 Jun 2026 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623786; cv=none; b=h3tpP3EiMFyavvxd8dZ9CyTACYvFO5C1GDuUd99hULFb5KI8GT04+xZeXndH1WzxGJ62ZhBTtdEO1H7podQSrirhv71qJe8P6RBgQD2FzUXuU/2UMO45a2G+z6rPyjvyspH9Y7Rnw+cQS6Q4DQdMXluCEYRxJLUUQylf3lKK5PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623786; c=relaxed/simple;
	bh=AYEFIYyJM93d8/NvNEtxiZMONS9fXGh16kN4hMtM0gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBB+uoEmnj3JVZVGE5pebfyZasA1bhAAOv5EzUrMOXLSKHuqr516g1HsmH2l6zEk1MvyIuj2jTXlk8/Ed1jFIcgqq+LEtZ+Ay/gKKbotNGI3jpGhTi8IDM0SO4lVGjI1aADNZZdIUAfSOQH05Hp4XYTfL7cNKQL0QMgxvdUeRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFr23OFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFr23OFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9247E1F000E9;
	Tue, 16 Jun 2026 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623785;
	bh=OhASrVquR9JNQbJKzNG5pby32skt8IW9PjfW2whiXL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFr23OFgkarQS2MucanuEoDcgkSzF5ORkjiq8LW1y3SRx1bROBVfa1IZGInmOZLrV
	 VYr3emIuCBhLh4kZCVCtz+YNDZwBsZALNLzc5qa6JooOsdrE64bK3omKWzn+fZCjF4
	 4hRz5KkQvhWvm0z7h6xnrskDiFkYg5pWWWqLTyLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 208/378] USB: serial: io_ti: fix heap overflow in build_i2c_fw_hdr()
Date: Tue, 16 Jun 2026 20:27:19 +0530
Message-ID: <20260616145121.321450895@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


