Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA623EDE59;
	Tue, 12 May 2026 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608742; cv=none; b=bNxieYzOK61oKRVGb7dFCeoWDOzhxaAC1rM5jfR8Xok8FBrMmKx41USUtvbsU9d7Xw8Sq1Z3R9e68hdP1Sp0WSn56qLM97X3f/fet9Q4/DWIp5bU64G/b/nw9TSPp977h4O0V3AP6cGDXYV+ekXmUk76svEj1xuD8rxbsxuyUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608742; c=relaxed/simple;
	bh=LoH7y5RhFiCCMZ91x7NvMe1ks31tzHrvqxxEgyz9aV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ0Do7nL+LMj+RRj+J4zRNYNGeVlLhTEuz7lCrBVo+B8CnTP06fYNspl7MONwO/63E1RXOvHKZrG6w4yP7qyLuBA+2JU97gAs5Cfbch4BOZ0rSVrGetgQIDKtt7JEwK1T3WwtmlcwbBi6TafTKyFKEKbnIdJsAOV9eKV41SFzLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmFulghs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmFulghs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64C7C2BCB0;
	Tue, 12 May 2026 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608742;
	bh=LoH7y5RhFiCCMZ91x7NvMe1ks31tzHrvqxxEgyz9aV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmFulghscdQU5SRElakuqMYouZKMYOeIEt+zzpezFJgE77r3eUOPfgi20xIGdA8l1
	 Dmgag9Dk95yqU0k/7hPYuKSAlWHej49NU9j3YLaUnXrdd8VmgMp8yfNM/LTVMGURnw
	 Fcvs33g/NU52p8/zEpQwQeROEXrNmuMJP9/nAWcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 196/270] RDMA/mana: Remove user triggerable WARN_ON() in mana_ib_create_qp_rss()
Date: Tue, 12 May 2026 19:39:57 +0200
Message-ID: <20260512173942.575892062@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 159f2efabc89d3f931d38f2d35876535d4abf0a3 upstream.

Sashiko points out that the user can specify WQs sharing the same CQ as a
part of the uAPI and this will trigger the WARN_ON() then go on to corrupt
the kernel.

Just reject it outright and fail the QP creation.

Cc: stable@vger.kernel.org
Fixes: c15d7802a424 ("RDMA/mana_ib: Add CQ interrupt support for RAW QP")
Link: https://sashiko.dev/#/patchset/0-v2-1c49eeb88c48%2B91-rdma_udata_rep_jgg%40nvidia.com?part=1
Link: https://patch.msgid.link/r/5-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/cq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -144,8 +144,9 @@ int mana_ib_install_cq_cb(struct mana_ib
 
 	if (cq->queue.id >= gc->max_num_cqs)
 		return -EINVAL;
-	/* Create CQ table entry */
-	WARN_ON(gc->cq_table[cq->queue.id]);
+	/* Create CQ table entry, sharing a CQ between WQs is not supported */
+	if (gc->cq_table[cq->queue.id])
+		return -EINVAL;
 	if (cq->queue.kmem)
 		gdma_cq = cq->queue.kmem;
 	else


