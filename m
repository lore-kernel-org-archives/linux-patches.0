Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBD9470121;
	Wed, 23 Sep 2026 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173624; cv=none; b=WdzPBpveNpcfpqNvEhpbREGlGEG8UObxkrPrsKW/p2fjSQWqS40Iojr8i8FXbe6d/KwjaECegKBIjCjxcW5blnvO8ykv9CR33/HXA02XO53PBIoxv1CUDLfd3umS4hj1sDbWWnyy/OPDrUGARcMZGqNkhcCxH1p/uyrnhKII690=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173624; c=relaxed/simple;
	bh=/BCWuqM22Ri1EHkApuOV7vud61wp7TXj7ZdkoPrnZ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuQ5gPKwNHQfjC5tmocz/51vrnq7oVwCD16n0OZy7cAb2vhw9kRr/vGardyVrDZd201MdNWxfT9tKnwiPcmrO+K1cSx6ORvdA3eoQ4r/tB9+MDb/5sZ94rtccHbCk06BeIFgq1lw+9vpc3iGKrH+ib2I3l4zDgMSPB5EICljVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjuudaZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjuudaZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0D81F000FF;
	Wed, 23 Sep 2026 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173622;
	bh=1lRp4Dy8VeNERvU+HG+TM1mqMfciDGJLYYu4Jqcrk2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjuudaZIP0xD4ckHRZ49vJWFvepfXA23nIQ2YkMq6Gd1yhP1hR8iD9niFXt92Lwu+
	 5MuzEywSo/YrLkLpNq//RIkR/bZfeGBqoFRYtgEnopXw3/PCjv+5HBcVoXUDDT5XVs
	 LeeOaBmp6u6Tz05yajmLKHR/40srqUT1c3ZMU/v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	"Pimen Flavian Dei (Drivesec S.r.l.)" <fdei@drivesec.com>,
	"Alberto Carboneri (Drivesec S.r.l.)" <acarboneri@drivesec.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 305/438] scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()
Date: Wed, 23 Sep 2026 16:05:26 +0200
Message-ID: <20260923140652.682874296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -727,6 +727,7 @@ int scsi_cdl_enable(struct scsi_device *
 		struct scsi_mode_data data;
 		struct scsi_sense_hdr sshdr;
 		char *buf_data;
+		size_t avail, offset;
 		int len;
 
 		ret = scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
@@ -735,11 +736,24 @@ int scsi_cdl_enable(struct scsi_device *
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


