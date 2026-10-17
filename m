Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7853BF699;
	Sat, 17 Oct 2026 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259064; cv=none; b=JLdZZPGFMvR17eMkPTvXLjfq9fU8xWTliJHY0mVhS9BU0Dc8flpJuZmcOiZezi4oxC6SmysAx0qlCQcVqB9skMWqDc8q6cF+n5lWFIDXx6nkFFSe+iXYq86Pjdy9MEVsdtaCNc9OzT86H4HCQhkWXnN38ynTU0wGZ+n5d3VgDCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259064; c=relaxed/simple;
	bh=I79V3iqnLgQPM2OuMW5Shh3km0TSaTmgNQ2pBalhZYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBRXIIGkYJVSLf+2EjCDhkZ8hGWeh5mC8RQ5YkhXWcEGvYo2DusfguFOEMqG/He8MnNT/En/LifuwVmEwVYCv0ANj4VOqy8uuzd9xvoCqDQxQnjLFW9irSfQAoaKGl8gvOaARZsltT62Oi9rcwKTdlnkmUUvhGzj7PxFjd3ZXYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anLsx7n0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anLsx7n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2AD1F000C5;
	Sat, 17 Oct 2026 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259063;
	bh=8f/aKK2s+VqVSiKtHEY3g/lWSYJJynx3DmDzquFilsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anLsx7n0ksE/qKDF+p5PqeT8XBxoNWWhUIvOUnB9ZoL97sFq6SqzwKgTI3p+UygwE
	 m/4JZklEi/5Ktf08mK6CtKSQSg/KOBtmCAdFt6cVF1F97mQcExDfZZCcP2u+qyaxli
	 SUn0YKMcWs382Tvn+am68mX5h7ptu+/7eJ+mG0ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1089/1674] pds_core: Dont assign interrupt index/bound_intr to notifyq
Date: Sat, 17 Oct 2026 17:56:01 +0200
Message-ID: <20261017160459.085298394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 02daffa903e60a864b43a17f7074bb3f7b7baac7 ]

The notifyq rides on the adminq's interrupt, so there's
no need to setup and/or access the notifyq's interrupt
index or bound_intr. The driver sets the bound_intr
using  qcq->intx = -1 for the notifyq, but luckily
nothing accesses that field for notifyq. Instead of
expecting that remains the case, just clean up
the notifyq's interrupt index and bound_intr fields.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0ad134881508 ("pds_core: fix use-after-free on workqueue during remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c    | 5 +----
 drivers/net/ethernet/amd/pds_core/debugfs.c | 3 ++-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index cd0c698983deb..8a9519e36de14 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -129,6 +129,7 @@ static int pdsc_qcq_intr_alloc(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 	if (index < 0)
 		return index;
 	qcq->intx = index;
+	qcq->cq.bound_intr = &pdsc->intr_info[index];
 
 	return 0;
 }
@@ -227,7 +228,6 @@ int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
 		goto err_out_free_irq;
 	}
 
-	qcq->cq.bound_intr = &pdsc->intr_info[qcq->intx];
 	qcq->cq.num_descs = num_descs;
 	qcq->cq.desc_size = cq_desc_size;
 	qcq->cq.tail_idx = 0;
@@ -432,9 +432,6 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	if (err)
 		goto err_out_teardown;
 
-	/* NotifyQ rides on the AdminQ interrupt */
-	pdsc->notifyqcq.intx = pdsc->adminqcq.intx;
-
 	/* Set up the Core with the AdminQ and NotifyQ info */
 	err = pdsc_core_init(pdsc);
 	if (err)
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index 33b8e8d1fd4c6..734b86804f40f 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -114,7 +114,6 @@ void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 	struct dentry *qcq_dentry, *q_dentry, *cq_dentry;
 	struct dentry *intr_dentry;
 	struct debugfs_regset32 *intr_ctrl_regset;
-	struct pdsc_intr_info *intr = &pdsc->intr_info[qcq->intx];
 	struct pdsc_queue *q = &qcq->q;
 	struct pdsc_cq *cq = &qcq->cq;
 
@@ -152,6 +151,8 @@ void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 	debugfs_create_u16("tail", 0400, cq_dentry, &cq->tail_idx);
 
 	if (qcq->flags & PDS_CORE_QCQ_F_INTR) {
+		struct pdsc_intr_info *intr = &pdsc->intr_info[qcq->intx];
+
 		intr_dentry = debugfs_create_dir("intr", qcq->dentry);
 		if (IS_ERR_OR_NULL(intr_dentry))
 			return;
-- 
2.53.0



