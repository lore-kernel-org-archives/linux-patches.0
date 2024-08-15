Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24053214;
	Thu, 15 Aug 2024 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732686; cv=none; b=dNQYThDBxjBG3nksXD83d0jRjhADzhBj6wEn5iWTPDK4L+7L+dX0Kon9ZffSXD/vXpXK7jljHMcTfOPZoglY5jpAYzd8BDmwK6M7BQCXGgC0J9MORcXa1HX75y3bf3AXq3j97rjtUqL0h43jW2uZA8fgx13Cc9X/FFvo3r+043U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732686; c=relaxed/simple;
	bh=8gjTky3/3QHKEmdg0mrdqZxgtxVtDuXDVnJZ5iKgvZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrCqukQhYG0T6jDaq5YBqvvPSs68BL7K2MYB2jiicq08A3k2C/w0DVeBC/Jg1GiyU8gSiE8KzAncoBsvM4162ZgLudU+0TxobgIoy8dcMMgKdBNj6DAFJhtbGm70cE7AHYarZa1DWeA0QMZy8oT9E172XF4+Ku/T/tdaW0P6zN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtKckIQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtKckIQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22499C4AF0E;
	Thu, 15 Aug 2024 14:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732686;
	bh=8gjTky3/3QHKEmdg0mrdqZxgtxVtDuXDVnJZ5iKgvZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtKckIQXIU+I5yLWlb2baWG9mIkuepvdCADOCtFlqfOmRNZXeWrH9a+EBCWO+zWsL
	 hrgwrwLqTNpb/qlLihTat4Y+1gvcgy3glZw9+YWqAqd7huy4wsejCUcv2eU4ZUiTjz
	 /Fx449iwsxK0G0xISgyCKOf4KHZ1w8u4pbkhPwdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/352] nvme-pci: add missing condition check for existence of mapped data
Date: Thu, 15 Aug 2024 15:24:40 +0200
Message-ID: <20240815131927.560143497@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c31fad1470389666ac7169fe43aa65bf5b7e2cfd ]

nvme_map_data() is called when request has physical segments, hence
the nvme_unmap_data() should have same condition to avoid dereference.

Fixes: 4aedb705437f ("nvme-pci: split metadata handling from nvme_map_data / nvme_unmap_data")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1436aee1f861d..4a4b7aa748354 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -942,7 +942,8 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	spin_unlock(&nvmeq->sq_lock);
 	return BLK_STS_OK;
 out_unmap_data:
-	nvme_unmap_data(dev, req);
+	if (blk_rq_nr_phys_segments(req))
+		nvme_unmap_data(dev, req);
 out_free_cmd:
 	nvme_cleanup_cmd(req);
 	return ret;
-- 
2.43.0



