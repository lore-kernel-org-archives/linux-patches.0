Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF1C13D258;
	Thu, 11 Apr 2024 10:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831942; cv=none; b=MtQQNvbvWbmuRUqdCY7NxUFEjedPbkUZOb2LW6r/bhjJhEkFpz2vK3LAjLLVvuzOP5uY5J/uSDDtkYzVQ26RsCKHyyn8sR0+m7GcVcxXPVcKfaF835zBhvY1pgl0ieyFzwJesKokyNF9OGuvTsdtPJN29jvf06ubYAAf7rcXI1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831942; c=relaxed/simple;
	bh=OccvTqZw+TeK4hgQ+AWuinV6W5AcheibAiFJ51JQg3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDU+zaGmT54MsBYAsZx/80YFjbcPBlpTjku2gk3Xw5iNol2Lvv2KhK8U7ZBDczDfGzGawXMuJSiZyeo+AEBxCh6Ek1O6gR7wOyXkf3DVscejAhbRBXbF9mqVXhg7A84DpPpN8f1pySSi3Q2wHW93oy+8VAH3V8ZP69nYbCM4dKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOO4WvnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOO4WvnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F25C433C7;
	Thu, 11 Apr 2024 10:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831942;
	bh=OccvTqZw+TeK4hgQ+AWuinV6W5AcheibAiFJ51JQg3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOO4WvnKM2n95sJ9RHbs++MSHQyreTOPZGcm20ziANPfH2hZYCpcDrTiltt2x2nXd
	 iCRloF8cI1vpqnv4mSTgaXxBF/Ye/HxgvxwjumNwtVErYyB9uOPwk1/kVDwoVqC/bf
	 j8goP4o1GhXQ7f6Muk3uAuwy8IdAShYX/xCEsAvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 177/294] scsi: qla2xxx: Delay I/O Abort on PCI error
Date: Thu, 11 Apr 2024 11:55:40 +0200
Message-ID: <20240411095440.956945739@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2689,7 +2689,13 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rp
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
@@ -2711,7 +2717,11 @@ qla2x00_terminate_rport_io(struct fc_rpo
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


