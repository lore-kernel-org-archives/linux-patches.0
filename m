Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6783D1CC6;
	Wed, 20 May 2026 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301732; cv=none; b=htQ17KrGBNigCEMaOAfR5oHFJqdR4aiuUhpPlNrUOHSge8H3RnBOsEZCYTI8CqSwJyIiMDHSJ9XoTm+qkW8fiZH8af1hTKefF3vmuOiSCTBeZXi9AXnmNMu7wyheLKeUhqZ2Bo38FmSJKkxa4ZJDiBY/yQgvXbzJgx/sPurBuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301732; c=relaxed/simple;
	bh=3kcxQMbrqcvMU5/ckb1x4fgzeap3wevfbL8biv5052k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEWDgF4PxXp1yZ5jsXRy84dq7h3bdEH+OHyt1tCpmNKGfsiZNtqTt7gdJUehybZvi0YPQhiMDSbVGBUwqtnxbMrXR8+zYc76OckGVofBJV9JzFRJKGAT6P6QP4RcQV/z0h2jfBq3+hFBbuBUpFKlgt9x3eu9nGOcapYO3NsDijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPZdTa3G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPZdTa3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC15A1F00899;
	Wed, 20 May 2026 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301731;
	bh=y3wzFYlaPTgctW2fgqXg3QrGR0/yLJDEQBMSO+G6rG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPZdTa3G5AmxWygCIRwSC3CiRR0DEH92XwERNwcegFiLQdmjED+tVdLcKSn96QMpY
	 MOeOxN7RIqlpMmiEOaqLVbPDgQSPsLHLtKypj9qCndXsLgBp0cGF5oT34AgCi5OwXQ
	 B8eYOl1oqBJv1DhzqtxT/AgliAixpjbm3OtR6Yig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 655/666] RDMA/mana: Remove user triggerable WARN_ON() in mana_ib_create_qp_rss()
Date: Wed, 20 May 2026 18:24:26 +0200
Message-ID: <20260520162125.481757585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 159f2efabc89d3f931d38f2d35876535d4abf0a3 ]

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
[ adjusted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/cq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -120,8 +120,9 @@ int mana_ib_install_cq_cb(struct mana_ib
 
 	if (cq->queue.id >= gc->max_num_cqs)
 		return -EINVAL;
-	/* Create CQ table entry */
-	WARN_ON(gc->cq_table[cq->queue.id]);
+	/* Create CQ table entry, sharing a CQ between WQs is not supported */
+	if (gc->cq_table[cq->queue.id])
+		return -EINVAL;
 	gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
 	if (!gdma_cq)
 		return -ENOMEM;


