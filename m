Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2114547ECF2;
	Thu, 20 Aug 2026 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248279; cv=none; b=SjmrmP9uoVq1y5DUXgJQLmEoXvFGtZxNUeP61oSnhLNw598+SR+NIO+OfxYnSsdjKZREsBLRPDjWdhBdc6rSlpwkkCgYreGDpFmjxvf40cSxBd/mbJCVakG87vm8/39+ztryfXWplval3KttuJOzQRhGF8/zNO8prkEEaqDNWCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248279; c=relaxed/simple;
	bh=HXUndwuYXSro1XbB8xdLxsChF2pE9wiBhWwRsnUCjAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXTaoXOOAFZdzJta6+SIRS9GPWuxlg3+UKWF4p0qeZNc2XkIicWoSMalCOup/E3s40k8IF0Mnw1NJz7jScx99tML2Lfh//c7XIUi/MEjKxrFNYYWKZBBAWxywgV3sb9Nr+OycpUxOSyXsRA5WC41wWHmYDtBNdj9QGq38zN1tfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WtdPrzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WtdPrzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745421F000E9;
	Thu, 20 Aug 2026 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248278;
	bh=dFVAexLq8lt28yX6+lLbtw+P6HNMgpOf5NCk9bliZ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WtdPrzUQf5Z9F9mDqb65AvI964Sfnjx6V/G4a7UrasA9g38jMg5PQb4gtFFYGFSB
	 2vyBkB7dpO4ODXoBJodUXccKPlN00AJOFn8dGpN1wcF1lxiOr1Aul0vLsHs4g6dSbv
	 FLhovIiE6tnZbTJ9OH4uM4Dqiis5KKF+1id0DdDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/303] ata: libata-core: Reject an invalid concurrent positioning ranges count
Date: Thu, 20 Aug 2026 16:55:08 +0200
Message-ID: <20260820145258.476963002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   18 ++++++++++++++++++
 drivers/ata/libata-scsi.c |    2 --
 drivers/ata/libata.h      |    9 +++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2598,6 +2598,24 @@ static void ata_dev_config_cpr(struct at
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
 
-#define ATA_SCSI_RBUF_SIZE	576
-
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
 static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -112,6 +112,15 @@ static inline void ata_acpi_bind_dev(str
 #endif
 
 /* libata-scsi.c */
+#define ATA_SCSI_RBUF_SIZE	576
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


