Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E67863E;
	Mon,  1 Apr 2024 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990545; cv=none; b=XDWirS3/LS7T1oEyn9I8G4uqwuA9wVPa+YaSWi1zW3jZN8LGV3cjPkh/RTv9oetn0FYKTbX66v0ik9L7cXofT2wIjbBHnRygYKYOnoobd7haNn4geCkeu0NKd5xbbsF1Cm8Ll8i4w64+L2S/c3g2BuaanB+JzjFHRvRLSvXFU44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990545; c=relaxed/simple;
	bh=75cXP3ygDjUKxg87C1EKzq3O1Gr0IYq8YaB6+RX7NDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9ycWc4U7jRBN58/TdmAs93URYCfELKgBlu1CQzeFxqzYCeKTJy0ch2ESvJcOVU9LCAqtKNm5nDjev015ixTK/7bY5z1kRFUSfbQdJQKidiPwspvM15igrxdpgPFaWdDBBgv/PkKeflvloTaqEDKPHQbLMvD8WVkPGTBeoWOxQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ke0mI5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ke0mI5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20153C433C7;
	Mon,  1 Apr 2024 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990545;
	bh=75cXP3ygDjUKxg87C1EKzq3O1Gr0IYq8YaB6+RX7NDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ke0mI5ZO36+OcVInAnpbXnpScIrcClwCcKITblL7yAlz/onMqSPhOF2BB4IdueRn
	 Lzm9yMALgfZ6YSH9Xq6HgcyItbM9DY288e6p59yqalULMCVd7KX92IQpNdSmolPFqh
	 EyS2GF3fXXq74josFPRctHIMRae18qlLS3+XUYd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 387/396] scsi: qla2xxx: Delay I/O Abort on PCI error
Date: Mon,  1 Apr 2024 17:47:16 +0200
Message-ID: <20240401152559.453248058@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 591c1fdf2016d118b8fbde427b796fac13f3f070 upstream.

Currently when PCI error is detected, I/O is aborted manually through the
ABORT IOCB mechanism which is not guaranteed to succeed.

Instead, wait for the OS or system to notify driver to wind down I/O
through the pci_error_handlers api.  Set eeh_busy flag to pause all traffic
and wait for I/O to drain.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-11-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2741,7 +2741,13 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rp
 		return;
 
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
-		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		/* Will wait for wind down of adapter */
+		ql_dbg(ql_dbg_aer, fcport->vha, 0x900c,
+		    "%s pci offline detected (id %06x)\n", __func__,
+		    fcport->d_id.b24);
+		qla_pci_set_eeh_busy(fcport->vha);
+		qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
+		    0, WAIT_TARGET);
 		return;
 	}
 }
@@ -2763,7 +2769,11 @@ qla2x00_terminate_rport_io(struct fc_rpo
 	vha = fcport->vha;
 
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
-		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		/* Will wait for wind down of adapter */
+		ql_dbg(ql_dbg_aer, fcport->vha, 0x900b,
+		    "%s pci offline detected (id %06x)\n", __func__,
+		    fcport->d_id.b24);
+		qla_pci_set_eeh_busy(vha);
 		qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
 			0, WAIT_TARGET);
 		return;


