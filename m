Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D423769FD;
	Thu, 30 Jul 2026 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426971; cv=none; b=I/7J3ejj7kS+JgkKPCzv5Aq+S6dwD3hQ0dgpb4lqnGkNmK+ZYfB7jehKfWpNagG9Ir/wUIYPzS31bOli1aMZhWyEs0oCCW2/fWvkuhHr475N43JDLmrraRab2MDcZmO5jIEcxwrlTN0IO5zNzXoxptVY1SS47s89L/0e0rECxE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426971; c=relaxed/simple;
	bh=A7xDWYjQbQegkJiw5NThic+VVNraVGzmjO+0+Jusw7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMMdXgFJzOBD46k+jvJ4Uv9Y0ziYeSaRHriymnHAs9e7SubzBsdt+NDH5uuVwUVMmotsMwzjCN+bfU3YJYnslPHMzR7FNYzzamm81Z3p12+1IW1aWH+Yl/MxG12ySuzCs3FcfISyKQhLmjCilwAleelCXHhqYMuAMAhmA89+HwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKxuDh9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKxuDh9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D78E1F000E9;
	Thu, 30 Jul 2026 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426970;
	bh=9SATUZgItT9OPbDGLitCxnqbmwy8y+2EU/GBMibqHU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKxuDh9vQyd178xcyA623ujVzkm/xZy3hom8EsSQtE55wjCUb+ShIXiI/MesG3H4k
	 sAE1u4lPoaXZTjL6OeVx39m4bagmTNwmVE1tqcqKEsu/g0lCsrnwogwi2mlVCfD4fg
	 rkeCGXpI48TaDsRvVDn47D/HML9MWFv3TdxcVcac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 568/602] ata: libata-core: Reject an invalid concurrent positioning ranges count
Date: Thu, 30 Jul 2026 16:16:00 +0200
Message-ID: <20260730141447.981925432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 533a0b940f901c15e5cbbd4b5d66e871c209e8ce ]

ata_dev_config_cpr() takes the number of range descriptors from buf[0]
of the concurrent positioning ranges log (up to 255), which the device
reports independently of the log size in the GPL directory. The count is
then walked at a fixed 32-byte stride in two places with no bound: the
log read here, and the INQUIRY VPD page B9h emitter, which writes one
descriptor per range into the fixed 2048-byte ata_scsi_rbuf. A device
reporting a count larger than its own log overflows the read buffer (up
to 7704 bytes past a 512-byte slab), and a count above 62 overflows the
response buffer on the emit side.

Bound the count once, on probe, against both the log the device returned
and the number of descriptors the VPD B9h response buffer can hold
(ATA_DEV_MAX_CPR, derived from the rbuf size). Reject an out-of-range
count with a warning; this keeps the emitter in bounds with no separate
change there.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Fixes: c745dfc541e7 ("libata: fix reading concurrent positioning ranges log")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[ adapted `kzalloc_flex()` allocation to `kzalloc(struct_size(...), GFP_KERNEL)` and adjusted context offsets. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   18 ++++++++++++++++++
 drivers/ata/libata-scsi.c |    2 --
 drivers/ata/libata.h      |    9 +++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2804,6 +2804,24 @@ static void ata_dev_config_cpr(struct at
 	if (!nr_cpr)
 		goto out;
 
+	/*
+	 * The device reports the number of CPR descriptors independently of the
+	 * log size, and that count is also used to emit VPD page B9h into the
+	 * fixed-size rbuf. Reject a count larger than what that buffer can hold
+	 * (ATA_DEV_MAX_CPR) or larger than the log the device actually returned.
+	 */
+	if (nr_cpr > ATA_DEV_MAX_CPR) {
+		ata_dev_warn(dev,
+			     "Too many concurrent positioning ranges\n");
+		goto out;
+	}
+
+	if (buf_len < 64 + (size_t)nr_cpr * 32) {
+		ata_dev_warn(dev,
+			     "Invalid number of concurrent positioning ranges\n");
+		goto out;
+	}
+
 	cpr_log = kzalloc(struct_size(cpr_log, cpr, nr_cpr), GFP_KERNEL);
 	if (!cpr_log)
 		goto out;
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -37,8 +37,6 @@
 #include "libata.h"
 #include "libata-transport.h"
 
-#define ATA_SCSI_RBUF_SIZE	2048
-
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
 static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -145,6 +145,15 @@ static inline void ata_acpi_bind_dev(str
 #endif
 
 /* libata-scsi.c */
+#define ATA_SCSI_RBUF_SIZE	2048
+
+/*
+ * Maximum number of concurrent positioning ranges (CPR) supported. The ACS
+ * specifications allow up to 255, but we limit this to the number of CPR
+ * descriptors that fit in the rbuf buffer used to emit VPD page B9h.
+ */
+#define ATA_DEV_MAX_CPR		min(255, ((ATA_SCSI_RBUF_SIZE - 64) / 32))
+
 extern struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 extern int ata_scsi_add_hosts(struct ata_host *host,


