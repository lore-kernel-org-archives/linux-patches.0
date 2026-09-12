Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9028247ACE7;
	Sat, 12 Sep 2026 11:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214050; cv=none; b=X9qxFyTUN1RZljpVXOIzi89vaUiwyRhYvNI5ed4i+3XH8ql+6sLjK7tjCODZuAjJUO1QriwlpFa90Zyrh0kFLlRUgITHEBDDmlWOhhk3OtBkEBFSRWhMtEWxM/DPTEraG767hPaRidU0FcnmghyF+DBHff+bO5S7YQtuRyyna7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214050; c=relaxed/simple;
	bh=K+m2mOVNFndVIObtTdu/Ybtjv53PPCjlTnLKGk1Tz8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsyUpNQP3+AMF1qWowGmNKyDFTyunTjyBB9nt7CXXPVzuNQZ6YCo8IvBUPThAa8zb4G6txzh2jNEGjsJcT66fdGyGg2Sk9VkOLmThN5YiNxy9slBpDKWa2xjHIpl5ppI1CFScv62/5GqIhDQjBI1AlHod1PiOLmFQWBFbk+ycMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAVGh8iC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAVGh8iC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6991F000FF;
	Sat, 12 Sep 2026 11:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214045;
	bh=zj5H+y0np4/LvNkrO0BF37HNXHKZBiJG3t2UtmKDYIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAVGh8iC2ih0Vhul4ZBQZF/k9deLcOjtVcVobcY0yJb3+VRXfZHpX+UYpv0uGCqVj
	 Mzk3CVOS5PgsZgfVxKPR+g3qeSrt3VfMyBO3f/CZN/LV52xkLR07UkLAX68XBpWfIK
	 3vTo8QaQE/CQ/9/PWABxhAgowaP5J2WAZExgnqtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 0247/1376] scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started
Date: Sat, 12 Sep 2026 08:44:33 +0200
Message-ID: <20260912065613.045088369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit f7e46ebffc5781aab3f1f5a5d4350addbb5833f4 upstream.

qla_nvme_xmt_ls_rsp() bails out to the out: label when firmware is not
started (!ha->flags.fw_started), but the out: path unconditionally calls
qla_nvme_ls_reject_iocb(), which ends in qla2x00_start_iocbs() and an
unconditional doorbell write to the request queue in-pointer register.
This rings the firmware doorbell and queues an IOCB that stopped or
resetting firmware cannot consume, and touches MMIO during the reset/EEH
window where fw_started is also clear.

Only emit the LS reject IOCB (and ring the doorbell) when fw_started is
set; otherwise just clean up and return. The post-allocation failure
cases (SRB alloc / qla2x00_start_sp() failure) run with firmware started
and still send the reject. Apply the same guard to the reject emission
in qla2xxx_process_purls_pkt().

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-26-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -441,9 +441,11 @@ out:
 	a.vp_idx = vha->vp_idx;
 	a.nport_handle = uctx->nport_handle;
 	a.xchg_address = uctx->exchange_address;
-	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
-	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
-	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
+	if (ha->flags.fw_started) {
+		spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
+		qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
+		spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
+	}
 	kfree(uctx);
 	return rval;
 }
@@ -1205,9 +1207,14 @@ qla2xxx_process_purls_pkt(struct scsi_ql
 		a.vp_idx = vha->vp_idx;
 		a.nport_handle = uctx->nport_handle;
 		a.xchg_address = uctx->exchange_address;
-		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
-		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
-		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);
+		if (vha->hw->flags.fw_started) {
+			spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr,
+					  flags);
+			qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a,
+						true);
+			spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr,
+					       flags);
+		}
 		list_del(&uctx->elem);
 		kfree(uctx);
 	}


