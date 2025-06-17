Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B932F235C;
	Tue, 17 Jun 2025 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176258; cv=none; b=SutRp+sRttJ9LiKIDx02lgLb4m3p4TxVPKna7jtLQOVuMLQucLW08/6yKU1TUPuJTyF7sc6mfEZ4pEzJArtSUICPK3ltPQgsKQ3yNcIjSEZJJWsh39tvQtCyrB9mfiTXhY2JEDWDNC22G5Yd6lgzHv8DUufjAv47vsIDrHpaeqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176258; c=relaxed/simple;
	bh=vxr4iflg2GFx4jsNsLu9Ib9oKjo2ShLpAUKYmtZB+XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJxFzQ7pFkLSp3tpw09ayUvyGlr8gMdQkeu1BJGkdAoXWa2hqo80I9HIcm+bX666RcuUb3eCCINrPLGvemuFNWB0kQXfAY9v6XQzTJ6EuKAr4ZjY1xdv8MJlg+2gDRO6acgWG0fHPXHyemXB2d+bbGx4fNuYVA7beXT8MsLVRYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bzl6q4wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bzl6q4wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB32AC4CEE3;
	Tue, 17 Jun 2025 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176258;
	bh=vxr4iflg2GFx4jsNsLu9Ib9oKjo2ShLpAUKYmtZB+XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bzl6q4wHISLlICP5NtSZF3cbem1or9u2F8e+KPTaUip2fDsRk9ORbwALQKMgBCh6a
	 gHmoVDv68wKIbW9p0oQG0lJsCPrni1vVNWevVZEgzGdr2zEpUdrHSzW/toU7LrnkoE
	 h6Aq81DV0iqg87u0XU8PmwIFhezjkp+taI0eQzh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/512] octeontx2-pf: QOS: Perform cache sync on send queue teardown
Date: Tue, 17 Jun 2025 17:22:57 +0200
Message-ID: <20250617152428.179910119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 479c58016099d19686e36f6c50f912360839a7fa ]

QOS is designed to create a new send queue whenever  a class
is created, ensuring proper shaping and scheduling. However,
when multiple send queues are created and deleted in a loop,
SMMU errors are observed.

This patch addresses the issue by performing an data cache sync
during the teardown of QOS send queues.

Fixes: ab6dddd2a669 ("octeontx2-pf: qos send queues management")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250522094742.1498295-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
index 9d887bfc31089..ac9345644068e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
@@ -256,6 +256,26 @@ int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx)
 	return err;
 }
 
+static int otx2_qos_nix_npa_ndc_sync(struct otx2_nic *pfvf)
+{
+	struct ndc_sync_op *req;
+	int rc;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_ndc_sync_op(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->nix_lf_tx_sync = true;
+	req->npa_lf_sync = true;
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
 void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx)
 {
 	struct otx2_qset *qset = &pfvf->qset;
@@ -285,6 +305,8 @@ void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx)
 
 	otx2_qos_sqb_flush(pfvf, sq_idx);
 	otx2_smq_flush(pfvf, otx2_get_smq_idx(pfvf, sq_idx));
+	/* NIX/NPA NDC sync */
+	otx2_qos_nix_npa_ndc_sync(pfvf);
 	otx2_cleanup_tx_cqes(pfvf, cq);
 
 	mutex_lock(&pfvf->mbox.lock);
-- 
2.39.5



