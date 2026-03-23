Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267143AC0D3;
	Mon, 23 Mar 2026 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282251; cv=none; b=FL+BDNdGb48nQCFnj2SfKM5mnTZzRxaMp5at4LoXNBOHO7wZMk3jny5rXR0ppVxL0AMwhkm/gqL0pp3lu1qUWUeAbJ+ehKVovQKuAo6WYcxLa9BMmCBY4LpDt9aKhFZP9Xf3xnLmZzMzhH/Fnmu3akKQrAB0Re4EC3nhyIgjyBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282251; c=relaxed/simple;
	bh=nm8IykcwuJ/H5fp6oQRWCJ0dmneg4SLS1Fq9HG+tsmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1Q4HNrprCEEOT4H+7tK/5N/YzlyV3erD0vzIAR6x7WdtxZojlsmEtJ5spxb4ydem8C/h/7nL2xV4zs+8io5d2BzG6DAx1Jvgg8r17C9MEAyyYPTlpB9zhP1wsFP5vSkpDuhEdtMFMLR/T4t7WhJWxOeZqPKiSDyyWli6GKL3gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Vlo3ddS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Vlo3ddS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E22EC4CEF7;
	Mon, 23 Mar 2026 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282250;
	bh=nm8IykcwuJ/H5fp6oQRWCJ0dmneg4SLS1Fq9HG+tsmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Vlo3ddSOdZ0BnU036c8QdlAsQ+Sk8QSoVC/44uo/IfEDwY4uDpC8V0fFsyr6gvrf
	 zNrXBVN7Y7kWqZaegvwoPJW71ycXZ4Lto28tNWU7h2mfGF7z5uN8KhKJLjd95itR2T
	 /tBp3bmgoEaLw+ZR/1izy3YQpFR6L7b2q9d8C61M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 085/481] IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()
Date: Mon, 23 Mar 2026 14:41:07 +0100
Message-ID: <20260323134527.335217217@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 117942ca43e2e3c3d121faae530989931b7f67e1 upstream.

Fix a user triggerable leak on the system call failure path.

Cc: stable@vger.kernel.org
Fixes: ec34a922d243 ("[PATCH] IB/mthca: Add SRQ implementation")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/2-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -428,6 +428,8 @@ static int mthca_create_srq(struct ib_sr
 
 	if (context && ib_copy_to_udata(udata, &srq->srqn, sizeof(__u32))) {
 		mthca_free_srq(to_mdev(ibsrq->device), srq);
+		mthca_unmap_user_db(to_mdev(ibsrq->device), &context->uar,
+				    context->db_tab, ucmd.db_index);
 		return -EFAULT;
 	}
 
@@ -436,6 +438,7 @@ static int mthca_create_srq(struct ib_sr
 
 static int mthca_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 {
+	mthca_free_srq(to_mdev(srq->device), to_msrq(srq));
 	if (udata) {
 		struct mthca_ucontext *context =
 			rdma_udata_to_drv_context(
@@ -446,8 +449,6 @@ static int mthca_destroy_srq(struct ib_s
 		mthca_unmap_user_db(to_mdev(srq->device), &context->uar,
 				    context->db_tab, to_msrq(srq)->db_index);
 	}
-
-	mthca_free_srq(to_mdev(srq->device), to_msrq(srq));
 	return 0;
 }
 


