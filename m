Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBAE4FDE61;
	Tue, 13 Oct 2026 12:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893484; cv=none; b=Fe4aAARy8Mdu90v8YFfcR590lFQLpMkfv54Dbp00cm8pNozIAO6GZLB2URRredkRnJm8OsrLRd3k48XyabQqDElPdY2CTfTX2AkHCNeCWGvplWPtgodBVYJ2PbcvK8HnYKU9FGmh7gmFK/16Ct4X8CM6YoYcRsWwf0r8ru7A+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893484; c=relaxed/simple;
	bh=TnvWuf4MmvFVOQb08lnfcbwXiJgGMLsVkIVLEH77nAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MomoLWghbZZEppWWF8X9kVNONlC7uOlARrhLkP4EDiaPPJ7ppUJxLpYyYTpzcgaDZ3kZfbhPN4AfhJ+odoBIgVH1HG5aQV10XJzSz3XIMGD5raTNak7+LAF6vroRDs2Xf8YSywBkBZUrK4jBcP3hcehmui0u+B84stlAE5I1yWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXGfDN5G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXGfDN5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38091F000FF;
	Tue, 13 Oct 2026 12:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893483;
	bh=4W2rCQaGpTXD9MIyRGPWrGq+1bolfwZxdzNGyElBGR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXGfDN5GGiE5C0SnzXIdmIiOjmK6KWph6ahQ9qkIkIjECgGBsa4ppUXJIu826IsJ7
	 JOvwU6ZtSUfupENalgI6VYxtcVgd0gN+yd3EAJOl44eo4eza9vlgqDBtGmNbFc60DT
	 D3wbyArgg/6wCUF3fwpgod4iqvDXhvKOFQ+0k6kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/621] nvme-pci: fix dma_vecs leak on p2p memory
Date: Tue, 13 Oct 2026 13:33:55 +0200
Message-ID: <20261013112926.552415346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 85686c72966c5ee637893f124ddb31a1cace7bee ]

We don't unmap P2P memory, so we don't need to track it. The dma_vec
allocation was getting leaked on the completion.

Fixes: b8b7570a7ec87 ("nvme-pci: fix dma unmapping when using PRPs and not using the IOVA mapping")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 993dc5c9cd68c..4efb55f1e3833 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -795,7 +795,8 @@ static bool nvme_pci_prp_save_mapping(struct request *req,
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-	if (dma_use_iova(&iod->dma_state) || !dma_need_unmap(dma_dev))
+	if (dma_use_iova(&iod->dma_state) || !dma_need_unmap(dma_dev) ||
+	    (req->cmd_flags & REQ_P2PDMA))
 		return true;
 
 	if (!iod->nr_dma_vecs) {
-- 
2.53.0



