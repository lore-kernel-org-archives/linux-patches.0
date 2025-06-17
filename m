Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E78E204F73;
	Tue, 17 Jun 2025 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177754; cv=none; b=XxDBOk/VUjlG/K0px2uCLOlPMGTN4SSk61LFnIpZ2TNfjIhrYEOtWuioOnW9F5gnCIPjISLSqaIksmh0qIYF4SRky+LPlGUeCXnR0MMDI03DoL/i9G19I8IzwRaq2MauUJUMfGlybAYXD7GCM6+3UoWegxz75Lui26DT0zauIOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177754; c=relaxed/simple;
	bh=vm0+0x4oRmhmzc5p7qzOSmmQBb96y21v+brywTG+WPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehYSa526sHnmgWv/5rD6DrV/gf2nDfLFubmXiLviiBLC2oeuKz3YVlGIKPPAT10OxSnTOW3f3TuUQA4815nN/3e+gu4+j3CldreU4U3u+jCmw7lZmWSrqOG//XimCMVNSW8aMZnHZ7AaGphsXcIRHo2rl6nvd1jfMLZIuixZf8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO764FtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO764FtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AF4C4CEF0;
	Tue, 17 Jun 2025 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177753;
	bh=vm0+0x4oRmhmzc5p7qzOSmmQBb96y21v+brywTG+WPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO764FtOg1uar0vqVaxoeRTbm95pL3/DEOmXrDZj/3djRfGhSCZ805HPlIgHDSkMU
	 y9jOBP4gGjUpDxCKFSjMPH/ubQ2COevL4/iH+kGi4o3IJFhLJywUunfvaa0WSr4bvH
	 XR37LWAHqJ/EOm6+XC+gsUFECOtWBXSu7uEEXwyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 333/780] octeontx2-pf: QOS: Perform cache sync on send queue teardown
Date: Tue, 17 Jun 2025 17:20:41 +0200
Message-ID: <20250617152505.011468492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5dbae0e513b6..58d572ce08eff 100644
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



