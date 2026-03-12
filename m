Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BFC27057D;
	Thu, 12 Mar 2026 20:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346511; cv=none; b=EZ45m2V4HvTsJ0mqOoErDtlI8Uwc10I5xEyxBNpgWNDLiMjqT3LLF1+IfjanGJgt4MvgYMwDz8gaO6Y3i1+WqfaWRA6TgOQ4EeP4SzRr0lUDhuVhEa5REX4GKmHObAi2+Wj0NmCbHFmnRPQOtgYI6m3OXLzxmvd8kbQz5m8BRSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346511; c=relaxed/simple;
	bh=eVFILVAiuXVLhhTIryQ3labexSPej0cs2OuDfK0IVmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRgKBR18k3Tkzv1M4FrE+BkYdiO4LqWZFJSJXWLGwL0FuBdZXuIeBYWI7gH6JY4c7COQw0ll9MmXwcdQpgHo3tMteFGlmDPr1wwowIc6dgPFJlLusK5wi0rxUuJE/M4Ga1JbKkHJ1hnc2LRV6J69Cac/mSfChM/n5ixSjBtl0O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxOGnTko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxOGnTko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA19C2BCB0;
	Thu, 12 Mar 2026 20:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346511;
	bh=eVFILVAiuXVLhhTIryQ3labexSPej0cs2OuDfK0IVmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxOGnTkogMCtoEUc6MyK065lr6TGEU6CCXgSyQOB0VWMhT7THxn2/wWzvUVduwX0f
	 7NrXnG4UwBQfpGfWAYIzcirs1u3pWza6HmeuA7LmWqm821XTBC2RG+Nqe16iJd94QY
	 e0376fFumwJDjTCE6LpftkVAolB/Jd/oN4K1pVGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/265] ata: libata: Introduce ata_port_eh_scheduled()
Date: Thu, 12 Mar 2026 21:07:28 +0100
Message-ID: <20260312201020.416542752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 7aae547bbe442affc4afe176b157fab820a12437 ]

Introduce the inline helper function ata_port_eh_scheduled() to test if
EH is pending (ATA_PFLAG_EH_PENDING port flag is set) or running
(ATA_PFLAG_EH_IN_PROGRESS port flag is set) for a port. Use this helper
in ata_port_wait_eh() and __ata_scsi_queuecmd() to replace the hardcoded
port flag tests.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250704104601.310643-1-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c   | 2 +-
 drivers/ata/libata-scsi.c | 5 +++--
 drivers/ata/libata.h      | 5 +++++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 205c62cf9e32d..bd910dda8c0b1 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -826,7 +826,7 @@ void ata_port_wait_eh(struct ata_port *ap)
  retry:
 	spin_lock_irqsave(ap->lock, flags);
 
-	while (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS)) {
+	while (ata_port_eh_scheduled(ap)) {
 		prepare_to_wait(&ap->eh_wait_q, &wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock_irqrestore(ap->lock, flags);
 		schedule();
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 58070edec7c77..d27bf8e2b69cc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4339,9 +4339,10 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 	 * scsi_queue_rq() will defer commands if scsi_host_in_recovery().
 	 * However, this check is done without holding the ap->lock (a libata
 	 * specific lock), so we can have received an error irq since then,
-	 * therefore we must check if EH is pending, while holding ap->lock.
+	 * therefore we must check if EH is pending or running, while holding
+	 * ap->lock.
 	 */
-	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS))
+	if (ata_port_eh_scheduled(ap))
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	if (unlikely(!scmd->cmd_len))
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index e78995833e7e6..2d6f7231dcba5 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -51,6 +51,11 @@ static inline bool ata_dev_is_zac(struct ata_device *dev)
 		ata_id_zoned_cap(dev->id) == 0x01;
 }
 
+static inline bool ata_port_eh_scheduled(struct ata_port *ap)
+{
+	return ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS);
+}
+
 #ifdef CONFIG_ATA_FORCE
 extern void ata_force_cbl(struct ata_port *ap);
 #else
-- 
2.51.0



