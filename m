Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06F13B8BBB;
	Sat, 17 Oct 2026 17:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259192; cv=none; b=AKQWVuq/l2rlAyz3GH8fTnvJzASn6YClQivfxilEjto/2168CevBPPqbznf6OSErGsQmIkoJyrTl3QYmbZiacLY9htjqrzrh9OmaHFh07JzYeQx5RDHICv50vYiSUTKPF2s3uxUZbyvU2SxlMTybj9b2w2v1mlh3OSLDpINq2s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259192; c=relaxed/simple;
	bh=7hHJ3qjV5qEMwN/AcyDqbNKZ6v49RRtMODMnn1UbyuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWLjR8Y7w+WBRyJSNBPE4yF6Qj4TfJ1lMJQwLA64C6gxsuht3Ef52b5NzjqaI9pj0fqT/dVAUTljw6gBImpGzF3nHWrLiv1x5B8fbhSVZpExGjghGupuwLPlvgE7klcAtqxU6kMDIZwWmTebv5OtrdFmWx6nSf6dgfZH/bt7cIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx9YQyi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx9YQyi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A05F1F000C5;
	Sat, 17 Oct 2026 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259191;
	bh=LOVMvti1SLLSb7bUdbZwMGztOq2S8vG6+qFjIuTHsMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx9YQyi7kBC0eRYo2qU6EF9mMts7jbOwza2K8arRnxxobII63I6TBSapdArHQh0fq
	 IzwatzXvNjZTADfHXM8VilcN8M++RwQYObfQZai0zZI5xvvjOeep8LCCMosOVNf7ky
	 Dwb+94kzj823fQ5wCQ8OICjB36PP0Eq15vEo4Up4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	David Hu <xuehaohu@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1105/1674] RDMA/irdma: Prevent user-triggered null deref on QP create
Date: Sat, 17 Oct 2026 17:56:17 +0200
Message-ID: <20261017160459.492216390@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit b9b0889071569d43623c260074e159cd8f26adb1 ]

Previously, the user QP creation path would only attempt to
populate iwqp->iwpbl if the user-provided req.user_wqe_bufs
field was non-zero. The problem is that iwqp->iwpbl is
unconditionally dereferenced later on in irdma_setup_virt_qp.

While there was a check for iwqp->iwpbl != NULL, this check
would only occur if req.user_wqe_bufs was non-zero. The end
result is that a user could send a zero user_wqe_bufs value
and trigger a null ptr deref.

Fix this by unconditionally calling irdma_get_pbl and bailing
if it fails, similar to the CQ and SRQ paths.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://patch.msgid.link/r/20260617164013.280790-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Reviewed-by: David Hu <xuehaohu@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c732dfefe7e33..a02c551052dc4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -602,18 +602,17 @@ static int irdma_setup_umode_qp(struct ib_udata *udata,
 
 	iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
 	iwqp->user_mode = 1;
-	if (req.user_wqe_bufs) {
-		info->qp_uk_init_info.legacy_mode = ucontext->legacy_mode;
-		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-		iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
-					    &ucontext->qp_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
 
-		if (!iwqp->iwpbl) {
-			ret = -ENODATA;
-			ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
-			return ret;
-		}
+	info->qp_uk_init_info.legacy_mode = ucontext->legacy_mode;
+	spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
+	iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
+				    &ucontext->qp_reg_mem_list);
+	spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+
+	if (!iwqp->iwpbl) {
+		ret = -ENODATA;
+		ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
+		return ret;
 	}
 
 	if (!ucontext->use_raw_attrs) {
-- 
2.53.0



