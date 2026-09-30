Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3BB36826E;
	Wed, 30 Sep 2026 19:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796305; cv=none; b=lziODEfkILQrhzfONBPfnmyZyYM1ow3VBZR1zVvuirncBnnkO5HTXfK81d5dhyN5Wu33YMU5cAnKxv4Pm7aXXT6i81KrcXrHvr3GGhjBlgu3Rd78D7bQuqIbZtqdOCMjJivA8UaZtGFpF7BCPMeU2ay9J/DrdNo5p3OBQEa3uLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796305; c=relaxed/simple;
	bh=PHgPnxA31PEohGnR8HZ5FKAM+VRJhrFvBmnK8ZtOCAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHJ2H2Zuyy19RWUsaL2OClcENW8fZ0wMvxC8aN571Ma4/uRNKNqU3dtUsBQshdS0lYFNpfUsBh68gSd1WhlXPztw2W+7hmPKf6whUo1knw34ENVSeZAwDImCbk1+Qkecn2CN8RigjVxyKwKIjpIFsTXf3UcgE7pSou2QosIvnr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir4jBxjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir4jBxjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3AF1F000FF;
	Wed, 30 Sep 2026 19:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796304;
	bh=0BWpDXz2NfT57RE1z/yH83gToV5sg8orw6dAqgZ6wrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir4jBxjXTjFZUuObCGIp+cq8aMNtBM0CmJwDunHjgyEm1n254zk84pRYKhjh3/7zW
	 I0TQx2FKNArRyfpreT0FnnwHtqrRIGWl4gSvHBH6w5PcyVqxD6romj+47H0xF6ZiG8
	 8/HYfGzdCKPGRsYUw5QFhhqxrXDY2IYyVIrb+4BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	"Pimen Flavian Dei (Drivesec S.r.l.)" <fdei@drivesec.com>,
	"Alberto Carboneri (Drivesec S.r.l.)" <acarboneri@drivesec.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0867/1193] scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()
Date: Wed, 30 Sep 2026 17:25:51 +0200
Message-ID: <20260930152453.498850040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -711,6 +711,7 @@ int scsi_cdl_enable(struct scsi_device *
 		struct scsi_mode_data data;
 		struct scsi_sense_hdr sshdr;
 		char *buf_data;
+		size_t avail, offset;
 		int len;
 
 		ret = scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
@@ -719,11 +720,24 @@ int scsi_cdl_enable(struct scsi_device *
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


