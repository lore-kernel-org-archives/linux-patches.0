Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F13184556;
	Tue, 30 Jul 2024 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360086; cv=none; b=YGogADgtkdpyB3ki4W0Cp77nO3XZ5VK7xF2NvQdQwJQfaQ6FIqT3C1furjSvfmwO/XMafejl7mXq2kwfYbFslH1wyvVNuwjB9C1T1l4IHDpohrXsr/FP0I2zXr09Hg/k7QKvmxrU+kIYhFN6fIt1q1h+7wq0zScIMRQD3nv0ptk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360086; c=relaxed/simple;
	bh=oxvlNXz5mLJpqEi/Df1NCC1mzd6TUjkWoHvq/113Qvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taEPVSIWoSPiVxmaflgXnu7MaGXFKV2qTENjo/3+GO17e/HMBy9REIOsc2TEeWAJc6kquhI/t9ECaSvxEJXIUOp/LNeMQBwrI+1qXFe1aELRZ7ExrMe7CNI+Q9h5wTSJb7PuepJZ2ulZKufo3yWXpBSpWBRKG8piDgfHZ6Bk6Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OC9x28PW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OC9x28PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54DFC32782;
	Tue, 30 Jul 2024 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360086;
	bh=oxvlNXz5mLJpqEi/Df1NCC1mzd6TUjkWoHvq/113Qvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OC9x28PWmepn0smeTO2R5AcocC1ZXSpJxt1QJM+jG7AgvXsnJAnE15p3FfPDqesFh
	 5JKaVC+XC3W7AojLkOvD0fdhRtGBeq6NaeqPIpfmh9bio/ZQnGWzPhjYJNY/w+P7qs
	 bLQ5sdJaCaVPtYg1wV8ntQUuVhYG9GNFkC3EVd4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 567/568] nvme-pci: add missing condition check for existence of mapped data
Date: Tue, 30 Jul 2024 17:51:14 +0200
Message-ID: <20240730151702.318956035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7c71431dbd6cc..796c2a00fea4a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -863,7 +863,8 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	nvme_start_request(req);
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



