Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28F633F5BE;
	Thu, 28 May 2026 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999298; cv=none; b=VhPexFqU0hKzi+oF0BFeG+Lgr0oPhW8fShssTnf5lpJj4tHPKM0hb0BNi7F4cGkagB50Qz4RI91p2QzmwWXkFnaudFNdWsoSqpPZvqzYvFKc5a2zNznZftlXwov3b3nnVJ3EWQOaWdWmi3UP1Bvavjj+JY2mjmtrlImR8orDYxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999298; c=relaxed/simple;
	bh=rMyW32hcDrpu9WFTLWpAtBD0qeqGOKqSISx8FlDgeJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0NVNwz4t5ttwV6CE48GL2cSJoUp7ht5Ai1nAhXJWtx1zJge6T7g2Qhe+XGiBeFdF/DvV+5CKwssEv7LNFHWAZwrTbIQ/FEUScWb2AXCEZLjrNJqCHXBVgYcRhgGEP6NsgEuW7hFf8+kOA2tVEZsuw//Hp2cpjPApUwtFibIbaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHYe2xe1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHYe2xe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9C91F000E9;
	Thu, 28 May 2026 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999296;
	bh=t8hXbONr3GG8GT07+/xV9TS0JD50/jOdQmlaKTO+9C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHYe2xe12SYdhn3yYL1Qiw6Mahvhl2LPta0iRsEKOpwHT666en+MXqmSiIvxKY1zx
	 9lcEm7i2RvHkwtt/6zfH6PCtzEpcMMXza3FdIB9MyTgpZafgfGlMBq7ld7YlIiwUmv
	 h4vH724WpDF3LfROfdgts1yn/CVQIHSM34ibuwOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Kelly <linux@tkel.ly>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 017/377] ata: libata-scsi: do not use the deferred QC feature on PMPs with CBS
Date: Thu, 28 May 2026 21:44:15 +0200
Message-ID: <20260528194638.886403662@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit f233124fb36cd57ef09f96d517a38ab4b902e15e upstream.

When using Port Multipliers (PMPs) with Command-Based Switching (CBS), you
can only issue commands to one link at a time. For PMPs with CBS, there is
already code to handle commands being sent to different links in
sata_pmp_qc_defer_cmd_switch() using ap->excl_link. sata_sil24 also makes
use of ap->excl_link.

A user on the list reported that commit 0ea84089dbf6 ("ata: libata-scsi:
avoid Non-NCQ command starvation") broke PMPs with CBS. The commit
introduced code that stores a deferred qc in ap->deferred_qc, to later be
issued via a workqueue. It turns out that this change is incompatible with
the existing ap->excl_link handling used by PMPs with CBS.

Thus, modify sata_pmp_qc_defer_cmd_switch() and sil24_qc_defer() to return
ATA_DEFER_LINK_EXCL, and make sure that the deferred QC handling via
workqueue is not used for this return value.

This way, PMPs with CBS will work once again. Note that the starvation
referenced in commit 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ
command starvation") can only happen on libsas ports, and libsas does not
support Port Multipliers, thus there is no harm of reverting back to the
previous way of deferring commands for PMPs with CBS.

Non-libsas ports connected to anything but a PMP with CBS (e.g. a normal
drive or a PMP with FBS) will continue using the deferred workqueue, since
it does result in lower completion latencies for non-NCQ commands, even
though the workqueue is not strictly needed to avoid starvation for
non-libsas ports.

If we want to modify the scope of the workqueue issuing to also handle
PMPs with CBS, then we should ensure that we can save both NCQ and non-NCQ
commands in ap->deferred_qc, while also removing the existing PMP CBS
handling using ap->excl_link, such that we don't duplicate features.

While at it, also add a comment explaining how the ap->excl_link mechanism
works.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Tested-by: Tommy Kelly <linux@tkel.ly>
Reported-by: Tommy Kelly <linux@tkel.ly>
Closes: https://lore.kernel.org/linux-ide/ce09cc21-a8e9-4845-b205-35411e22fba9@tkel.ly/
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-pmp.c  |   13 ++++++++++++-
 drivers/ata/libata-scsi.c |    8 ++++++++
 drivers/ata/sata_sil24.c  |    6 +++++-
 include/linux/libata.h    |    1 +
 4 files changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -110,13 +110,24 @@ int sata_pmp_qc_defer_cmd_switch(struct
 {
 	struct ata_link *link = qc->dev->link;
 	struct ata_port *ap = link->ap;
+	int ret;
 
 	if (ap->excl_link == NULL || ap->excl_link == link) {
 		if (ap->nr_active_links == 0 || ata_link_active(link)) {
 			qc->flags |= ATA_QCFLAG_CLEAR_EXCL;
-			return ata_std_qc_defer(qc);
+			ret = ata_std_qc_defer(qc);
+			if (ret == ATA_DEFER_LINK)
+				return ATA_DEFER_LINK_EXCL;
+			return ret;
 		}
 
+		/*
+		 * Note: ap->excl_link contains the link that is next in line,
+		 * i.e. implicit round robin. If there is only one link
+		 * dispatching, ap->excl_link will be left unclaimed, allowing
+		 * other links to set ap->excl_link, ensuring that the currently
+		 * active link cannot queue any more.
+		 */
 		ap->excl_link = link;
 	}
 
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1787,6 +1787,14 @@ static int ata_scsi_qc_issue(struct ata_
 	case ATA_DEFER_LINK:
 		ret = SCSI_MLQUEUE_DEVICE_BUSY;
 		goto defer_qc;
+	case ATA_DEFER_LINK_EXCL:
+		/*
+		 * Drivers making use of ap->excl_link cannot store the QC in
+		 * ap->deferred_qc, because the ap->excl_link handling is
+		 * incompatible with the ap->deferred_qc workqueue handling.
+		 */
+		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto free_qc;
 	case ATA_DEFER_PORT:
 		ret = SCSI_MLQUEUE_HOST_BUSY;
 		goto free_qc;
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -789,6 +789,7 @@ static int sil24_qc_defer(struct ata_que
 	struct ata_link *link = qc->dev->link;
 	struct ata_port *ap = link->ap;
 	u8 prot = qc->tf.protocol;
+	int ret;
 
 	/*
 	 * There is a bug in the chip:
@@ -826,7 +827,10 @@ static int sil24_qc_defer(struct ata_que
 		qc->flags |= ATA_QCFLAG_CLEAR_EXCL;
 	}
 
-	return ata_std_qc_defer(qc);
+	ret = ata_std_qc_defer(qc);
+	if (ret == ATA_DEFER_LINK)
+		return ATA_DEFER_LINK_EXCL;
+	return ret;
 }
 
 static enum ata_completion_errors sil24_qc_prep(struct ata_queued_cmd *qc)
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -335,6 +335,7 @@ enum {
 	/* return values for ->qc_defer */
 	ATA_DEFER_LINK		= 1,
 	ATA_DEFER_PORT		= 2,
+	ATA_DEFER_LINK_EXCL	= 3,
 
 	/* desc_len for ata_eh_info and context */
 	ATA_EH_DESC_LEN		= 80,


