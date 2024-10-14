Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92D31ABEB4;
	Mon, 14 Oct 2024 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916445; cv=none; b=CXMsnDSTwoQownu53qDYLzL2sGn1z4IwYslocsJ2OmJSIMDWdGVmnxQZh6pzqU91NQiPQn90x76N0q3GbEdcF52rSPM3t849/Fu2RnObpd+WrTCzsXNbtESE0Xw/RrleZwQR5u2N15D6s7DsWyJYSmsw2I+pmbSEx5gM90GMqqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916445; c=relaxed/simple;
	bh=M3nUZ0Oj1hwRMe1ECPoco9QNxBJC7Bn/srW5hfEauYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwNEenwvi9qsqlwyqtCegNxfHmKFxkOcXLwWteUNJrFzMM+1TtO21fskGt+/hiyzHUUAH4IeMtp+tLnru2ZO79YtlYOCXzTCLn9iTGis1kpEruRJr8M3dMV9ieAiBmrCaStMvmwAMvFbrXjWwfLC2wytY1ZdFAQn7VQyP25NRjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgrULXBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgrULXBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C28FC4CEDA;
	Mon, 14 Oct 2024 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916445;
	bh=M3nUZ0Oj1hwRMe1ECPoco9QNxBJC7Bn/srW5hfEauYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgrULXBLtrYZYug9hGKbxjCv689chIw45DGoj4K8ZnxYhQUVO19xiq9jfx1gkMIcI
	 ocz7vmQ3WxN7m28it7kn15G+I03OP13b2NVK/d40pnmI2CZ8gl4IoGmySoI3NlHKAQ
	 RgrW2XiGJ++TzBUgr14g9jhYOMDiPkq5gjGeZs1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Lee Duncan <lduncan@suse.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 185/214] scsi: fnic: Move flush_work initialization out of if block
Date: Mon, 14 Oct 2024 16:20:48 +0200
Message-ID: <20241014141052.200321509@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Wilck <martin.wilck@suse.com>

commit f30e5f77d2f205ac14d09dec40fd4bb76712f13d upstream.

After commit 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a
work queue"), it can happen that a work item is sent to an uninitialized
work queue.  This may has the effect that the item being queued is never
actually queued, and any further actions depending on it will not
proceed.

The following warning is observed while the fnic driver is loaded:

kernel: WARNING: CPU: 11 PID: 0 at ../kernel/workqueue.c:1524 __queue_work+0x373/0x410
kernel:  <IRQ>
kernel:  queue_work_on+0x3a/0x50
kernel:  fnic_wq_copy_cmpl_handler+0x54a/0x730 [fnic 62fbff0c42e7fb825c60a55cde2fb91facb2ed24]
kernel:  fnic_isr_msix_wq_copy+0x2d/0x60 [fnic 62fbff0c42e7fb825c60a55cde2fb91facb2ed24]
kernel:  __handle_irq_event_percpu+0x36/0x1a0
kernel:  handle_irq_event_percpu+0x30/0x70
kernel:  handle_irq_event+0x34/0x60
kernel:  handle_edge_irq+0x7e/0x1a0
kernel:  __common_interrupt+0x3b/0xb0
kernel:  common_interrupt+0x58/0xa0
kernel:  </IRQ>

It has been observed that this may break the rediscovery of Fibre
Channel devices after a temporary fabric failure.

This patch fixes it by moving the work queue initialization out of
an if block in fnic_probe().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Fixes: 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a work queue")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240930133014.71615-1-mwilck@suse.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fnic_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -830,7 +830,6 @@ static int fnic_probe(struct pci_dev *pd
 		spin_lock_init(&fnic->vlans_lock);
 		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
 		INIT_WORK(&fnic->event_work, fnic_handle_event);
-		INIT_WORK(&fnic->flush_work, fnic_flush_tx);
 		skb_queue_head_init(&fnic->fip_frame_queue);
 		INIT_LIST_HEAD(&fnic->evlist);
 		INIT_LIST_HEAD(&fnic->vlans);
@@ -948,6 +947,7 @@ static int fnic_probe(struct pci_dev *pd
 
 	INIT_WORK(&fnic->link_work, fnic_handle_link);
 	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
+	INIT_WORK(&fnic->flush_work, fnic_flush_tx);
 	skb_queue_head_init(&fnic->frame_queue);
 	skb_queue_head_init(&fnic->tx_queue);
 


