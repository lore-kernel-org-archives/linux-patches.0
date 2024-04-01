Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DFC1C0DE7;
	Mon,  1 Apr 2024 16:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989231; cv=none; b=MZX7p0jCeDiBdSWo1Lqb/7YWIrTCRyrMfCVnNVO3jsdUQ3dNcOGgdfyq8uE1aIe6bHmny8QV3MO4TmllcRIic1hUporARL7V1uZPU9kpmwUdN1TVCqaDco9BDJlM9FgzFDzj6SGjZHidgSg6LxhVl0hn4P7XvMBbcz78ajfqGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989231; c=relaxed/simple;
	bh=eA7yvFqox44XKs1F3JHlfRpGqCkeslcpsRQeGGXjMOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7iBw/tsv2/a0w9iQBYQG5MKVzc/iJ2tQyQc5tidfyT0leASLb20gZVf+7BvEeY+wZtqe6OZPRZkwzPR75P+ZAGbBkq5DRxyTwCM1k0p9jFEzxcaGJo1EyDe98WjeQrp7RwcZ7+gQxRnXTvQDc77+JEM/i6AVamo0ewAP4GoGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWlcnf/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWlcnf/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8407C433F1;
	Mon,  1 Apr 2024 16:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989231;
	bh=eA7yvFqox44XKs1F3JHlfRpGqCkeslcpsRQeGGXjMOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWlcnf/tDzp0433TYU0zPOd25TOXN+4SuTljm5MW1Mj9w5gkyVF0WnQDPStIekvrl
	 exEAsuUrEraWLtUfA+YxwlD2U5mMG56bzQiguFzfUUoflJZq9Wd0yt9WuKli+Gkm/G
	 beWxmMMS6WNSYxGSgbVhZ10RUY4Cu1Lvh3JcpvNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 421/432] scsi: qla2xxx: Delay I/O Abort on PCI error
Date: Mon,  1 Apr 2024 17:46:48 +0200
Message-ID: <20240401152605.972233096@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


