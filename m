Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215378;
	b=XpyEGw7d2V7F2D3D4/YYPr6tO9kS1JHk421VmU8aP2oHw/7RDboesbuIlyPLsJaquEea
	 DsS5zSrrP3zZRxVbF62eBRPSE2C3+GVA8Neo0umzFiCJXN4CYl06TlVGzgvfednnxhUAs
	 7dGYRAbB3H3FetYGoAaQhgVWPrkx3WatV9YowQQ09VxgqJ+RSRfMGI8ZEBfT0OebmYYdG
	 BHERTOO180uSgNW9o+rtN1iYVyWF1U5UBt5Ymvlo94TVfc9AUni42YApVIejxFA3tn5YY
	 MRLO4JCR7W0DTng8vjEJcsUC+UTUo4sjehi2R7qlq1ZeVVdYM8WIhqZkZ/c6LE/+z7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d2/RB31L4hzFHcxozl+74IHT3c0oXOKpqaoO9cx9xXE=;
	b=c37Zlfto1uPZJaz57fYfCWReDdHJyStOzByjGANRxcROcQNWwyaivJ5TBBcRgFJsehkS
	 VsqQaw1kpLMqDQbLy1fXQ2VwFnF1lAcKylhER1yovVEbwcUr5bx+S4dSL8YJLrQOOJztk
	 ozDD1jqPIrZ+9VTH5nVUtyi/bbDZQD4XDZil73Z5FwMW03EEmJWGv+zKyC6Q+rrFlHxC/
	 1a58kygKSB9MHrWsn7DkDZqsnqiLt3KjCdnqWCyLTtUO0zQ9RedragL7kbg9O9NaTnvWx
	 0LoBt8KLkSSOyVgbPSOv1x6MXmiQ3eGPREXW3nezQf/VyuTFUBNJOXYkpEInKcU3bMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7jqfGRd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F235606A324;
	Wed, 28 Oct 2026 19:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7jqfGRd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADCB1F01828;
	Wed, 28 Oct 2026 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215378;
	bh=d2/RB31L4hzFHcxozl+74IHT3c0oXOKpqaoO9cx9xXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7jqfGRd+7ahrGuADKE+LKA70kwAGKF0AmwmNpd28r0UeHjJA6NZgXNorZT2lJKAx
	 xA267A7puBbvO9T5pJf6Ce/3oKZ/5wtOGPQ17wnRQv+0P8neM1T5728CQfclUj+CNP
	 9Ibe1TcXPVU5uo8wUS6aQCJG/IB+w8Dg5iQa0MmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	David Hu <xuehaohu@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1191/1887] RDMA/irdma: Prevent user-triggered null deref on QP create
Date: Wed, 28 Oct 2026 17:54:47 +0100
Message-ID: <20261028170526.509834015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a8856a8613f45..246dfae3ce0e6 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -599,18 +599,17 @@ static int irdma_setup_umode_qp(struct ib_udata *udata,
 
 	iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
 	iwqp->user_mode = 1;
-	if (req.user_wqe_bufs) {
-		info->qp_uk_init_info.legacy_mode = ucontext->legacy_mode;
-		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-		iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
-					    &ucontext->qp_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+	info->qp_uk_init_info.legacy_mode = ucontext->legacy_mode;
 
-		if (!iwqp->iwpbl) {
-			ret = -ENODATA;
-			ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
-			return ret;
-		}
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



