Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008FB349CC1;
	Sat, 12 Sep 2026 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226890; cv=none; b=ruXB04ADULODMlxZguwiQp9rCmjQQoEUTS+kXl0tqaIGLs6nxGhlP3NhpXqrnEZnLAY2PCWtW1xdGwAEEC1tmAw0Mu6liJogKQpFIcEwCwvTNTSa8snej0rh4o9fvjIWV/mbss1kHBu/BJT3aQVSPTpOSPUsNuS88rFsVrhFTC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226890; c=relaxed/simple;
	bh=xtx/pFIbv1caMab4MVmunHf6fpTaAGCJMFHYQ4GSiH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua0lqM3PR2m0Im6sShXlXA6g7JSejxG0JLNojtP9GPKqSYzdkK9cTuhP2Jm38Tc6RE9QeWMqoIlIg2UG5BG+IP64VTzB9WREfXBOKROh4x3//Vl81DpOeJwwryZSqjyxlYwTNJqwy53ByLYJZcW8SkBdPAHvT85TEggWfe6AB+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUBLdHjh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUBLdHjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA251F000FF;
	Sat, 12 Sep 2026 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226888;
	bh=9kY9Onzug+DJV8OQILlI6zJL/KGKHO+yVNsEbxAFsW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUBLdHjhP7xM3FbgT/rGAMi02r+QfAwhhu2nXLzZwVhhkJUC5FoQJt2ECbzqSZzXt
	 OKkkli3Iy9IdagO9FzRam3d5jRh7ya6QekL6xv+gq/5OyTvJPBacOHoI0EkYlMSKz9
	 nCjWRV5Wn6l/4m43R94CWvEHn9I/7TVcm64nYdrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0070/1191] HID: picolcd: clamp eeprom debugfs read to bytes actually received
Date: Sat, 12 Sep 2026 08:46:38 +0200
Message-ID: <20260912065549.732798730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

commit e9c667395ac1f8024f623250b32bae4c7af9caa0 upstream.

picolcd_debug_eeprom_read() trusts resp->raw_data[2] -- a length byte
supplied by the device in its REPORT_EE_DATA reply -- clamped only to
the caller's read() count:

	ret = resp->raw_data[2];
	if (ret > s)
		ret = s;
	if (copy_to_user(u, resp->raw_data+3, ret))

It never checks resp->raw_size, the number of bytes picolcd_raw_event()
actually copied into the 64-byte raw_data[] of the kmalloc'd struct
picolcd_pending. A device (or a spoofed picoLCD) returning a length byte
of 0xff, read with a count >= 255, makes copy_to_user() read past
raw_data[] into adjacent slab memory and return it to userspace through
the debugfs "eeprom" file:

	BUG: KASAN: slab-out-of-bounds in _copy_to_user
	Read of size 255 ... picolcd_debug_eeprom_read+0x214/0x2f0 [hid_picolcd]

The debug-dump path in the same file already validates the device length
byte against the received size before trusting it; this read does not.
The file is created S_IRUSR (root-only) and a crafted device is needed,
so it is neither unprivileged- nor remotely-triggerable.

Clamp the copy length to resp->raw_size - 3 (the payload actually
received, minus the 3-byte header), floored at 0 for short replies.

Fixes: 9bbf2b98ba11 ("HID: add experimental access to PicoLCD device's EEPROM and FLASH")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-picolcd_debugfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -98,6 +98,15 @@ static ssize_t picolcd_debug_eeprom_read
 		ret = resp->raw_data[2];
 		if (ret > s)
 			ret = s;
+		/*
+		 * raw_data[2] is a device-supplied length; also clamp it to
+		 * what picolcd_raw_event() actually stored (raw_size), or a
+		 * hostile device overruns the raw_data[] buffer.
+		 */
+		if (ret > resp->raw_size - 3)
+			ret = resp->raw_size - 3;
+		if (ret < 0)
+			ret = 0;
 		if (copy_to_user(u, resp->raw_data+3, ret))
 			ret = -EFAULT;
 		else


