Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE58391832;
	Wed, 23 Sep 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174871; cv=none; b=bVzV7mWoNbbfWhQ9o9vFCEirIlpVSkEOnKvAGHgdAMKdWdm0leEFLwyWsYT4AWvyKuvDsh6FnriVJEBAKnvefeQmswrOujrzcJJLmpjDrEAtHnew7PkftP8bWRQaSk8IpsmrZ8Z1JMBXvt3YwDze4LKY/Ua13TTZyY1TkLT1GBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174871; c=relaxed/simple;
	bh=HJUTjVmphlvoRMLBFvzkkwtJxfpAvnP4qISsr17faJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8Nv9JjlweoEOcqVpLqCxivzrzsE7OL4pC/pu6yO08ogml44j+6ZbOVMhSKXo4l8dcHBzCt6IBvFo5HJYz8pTBqg6kGn4ST5UG90dcfzDNBWbBa5a+4JEfa6iOhUQfFZ+GtxSaaLM3Z3gSN16L53jIX1eZcVS1MikfYKnViGuJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JacMqx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JacMqx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F2E1F000FF;
	Wed, 23 Sep 2026 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174870;
	bh=iMuwIPrTgKbB4C1tH9ovM7TP5N+1t0yPT890otgCjSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JacMqx6EUQfL7dxx7gt/fyyUX8+b+fMEmtq1rs5W3h1cereSk0DlUzy5ofd5ct3l
	 F34UZ7EfSt69tkXTB87CdLTzmrMFjSQM290zzgyBpbK51eyl3YZzGYNanlNmXpITlc
	 +RAwTTWTDT0AJDe+0stKN4Un79lLgbk+X+syGwmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	"Pimen Flavian Dei (Drivesec S.r.l.)" <fdei@drivesec.com>,
	"Alberto Carboneri (Drivesec S.r.l.)" <acarboneri@drivesec.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 253/398] scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()
Date: Wed, 23 Sep 2026 16:05:27 +0200
Message-ID: <20260923140649.975661996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Alberto Carboneri <acarboneri@drivesec.com>

commit 3d676e458fe0c566f5a62753dc696b6a862fc412 upstream.

scsi_cdl_enable() uses length fields returned by MODE SENSE to locate
the ATA feature mode page in a 64-byte stack buffer. A target can report
a total length shorter than its mode header and block descriptors. The
unsigned subtraction used for the MODE SELECT length can wrap, and the
separately computed buf_data can point beyond buf.

During automatic scan, enable is false, so the read-modify-write of
buf_data[4] can clear the low two bits of a target-selected
out-of-bounds stack byte. scsi_mode_select() can then copy up to 64
bytes from outside the buffer into the outgoing MODE SELECT payload,
disclosing stack contents to the target.

This is reachable while scanning a USB storage device that identifies as
an ATA device and advertises CDL support. No filesystem mount or
userspace access to the block device is required.

On upstream commit cee9395acd80 ("Linux 7.3-rc1"), a build-specific,
one-vCPU QEMU/Raw Gadget proof using QEMU-only multi-UDC allocator
sampling executed a fixed proof command inside the guest and created a
UID-0-owned marker during automatic enumeration, with KASLR and NX
enabled.

The issue was independently found during security research at Drivesec
S.r.l.

Cap the available length to the buffer size. Validate and consume the
mode header and block descriptor lengths before using the page, and
require the five bytes needed to access the CDL field.

Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-scsi/20260717192313.93D791F000E9@smtp.kernel.org/
Link: https://lore.kernel.org/linux-scsi/20260717222931.AC4EE1F000E9@smtp.kernel.org/
Link: https://lore.kernel.org/linux-scsi/df13ec87ac9b28e3b0a2d9eb26477e276ff0278a.camel@HansenPartnership.com/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Pimen Flavian Dei (Drivesec S.r.l.) <fdei@drivesec.com>
Signed-off-by: Pimen Flavian Dei (Drivesec S.r.l.) <fdei@drivesec.com>
Signed-off-by: Alberto Carboneri (Drivesec S.r.l.) <acarboneri@drivesec.com>
Link: https://lore.kernel.org/linux-scsi/20260717192313.93D791F000E9@smtp.kernel.org/
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260904135410.360314-1-acarboneri@drivesec.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -722,6 +722,7 @@ int scsi_cdl_enable(struct scsi_device *
 		struct scsi_mode_data data;
 		struct scsi_sense_hdr sshdr;
 		char *buf_data;
+		size_t avail, offset;
 		int len;
 
 		ret = scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
@@ -730,11 +731,24 @@ int scsi_cdl_enable(struct scsi_device *
 			return -EINVAL;
 
 		/* Enable or disable CDL using the ATA feature page */
-		len = min_t(size_t, sizeof(buf),
-			    data.length - data.header_length -
-			    data.block_descriptor_length);
-		buf_data = buf + data.header_length +
-			data.block_descriptor_length;
+		avail = min_t(size_t, data.length, sizeof(buf));
+		if (data.header_length > avail)
+			return -EINVAL;
+
+		offset = data.header_length;
+		avail -= data.header_length;
+
+		if (data.block_descriptor_length > avail)
+			return -EINVAL;
+
+		offset += data.block_descriptor_length;
+		avail -= data.block_descriptor_length;
+
+		if (avail < 5)
+			return -EINVAL;
+
+		buf_data = buf + offset;
+		len = avail;
 
 		/*
 		 * If we want to enable CDL and CDL is already enabled on the


