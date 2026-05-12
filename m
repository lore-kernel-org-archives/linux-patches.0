Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC4234E744;
	Tue, 12 May 2026 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609543; cv=none; b=B2WlKK1EpiLMj9M+Ys7/sT9Q8Iy2FjTHcma9TLNxB82Lkz5/GmbafFcz1qq6c1nzMX+ptoQyBzxRIFAD9VZAB4FKZj8WAqNFMN5zF/hbxeGGbfUePccL478FPua47UIJpjaFt16F4wFzclDbFVEZUY4rt+VnSzoArfzSY9smnSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609543; c=relaxed/simple;
	bh=8GKLkrW0Y7VUmiGIqVmT1a15ZTjB/Y57Ak//B9mbToA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDRT8mG3RryMXTqV+G6pZ8v1DpMMjSvlijWXYXVbuAkNp+WuGcpQHoGW00FXnKpnxTwnPRYKcojeOPiL0idSxQVcLNvdL6T01mhc33mnX3HZDgctSb09O/okGs0fzxUHSDN1EZv+xW2AHLok1EiABxl/ZNEOI1mSl41hAXMM+kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4Q4sbTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4Q4sbTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1964C2BCB0;
	Tue, 12 May 2026 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609543;
	bh=8GKLkrW0Y7VUmiGIqVmT1a15ZTjB/Y57Ak//B9mbToA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4Q4sbTnW7mBCKyylfGCG0DjlgB2MUHMBp5+hy2Rjqj/iGdec9azlFaZN/5O1Yj+9
	 Obf22GiV/Fg1y3k4xblFOpAPC6ljFNP8M0vtMLlpzqqPc7cqhLlVKVzZTMgB5zItnr
	 SkXVALH/MlaRqzm5AlKgd8Xf4snsr2RCmEqxPTb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 235/307] RDMA/mana: Remove user triggerable WARN_ON() in mana_ib_create_qp_rss()
Date: Tue, 12 May 2026 19:40:30 +0200
Message-ID: <20260512173945.081072253@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -142,8 +142,9 @@ int mana_ib_install_cq_cb(struct mana_ib
 
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


