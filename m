Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3B01A76AD;
	Tue, 30 Jul 2024 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360778; cv=none; b=RzN6jhNhse/Bt2Lyul93wiJXnMxX9hVlbTb2jyI5EbLg5FS/BkHPva/pwubKJqASv7t3wa9ln+r1Nlu9FXGyGzgEpz2kQyPiuF6U2MQyLJRRzSjNhlDpWV2VzGeq2Y6i9THj+eBVK23/sHeU59Jry80OrcYTgBQAd45tgKdFFt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360778; c=relaxed/simple;
	bh=20ea+Bpk5RfAu2AgBpvjFuIauAjSAya7SMtQOENJTSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RufmqdrG6IxLJL5schoUcqTVDpCkS/fRgDARhu90WpiLG0wZRLqHvriuS25w4O9+7Uki5jhdF2p64jydg6C6HbfaDSsChmmT1czIl9a8oIumEAmN2ci/iOmLI7EUEuk8xYbY3QsRXy2UWoOVnfbnloEWpKNv5kBkGT75pW1n2Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PueGPJEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PueGPJEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F2CC32782;
	Tue, 30 Jul 2024 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360778;
	bh=20ea+Bpk5RfAu2AgBpvjFuIauAjSAya7SMtQOENJTSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PueGPJEIe3r4rVSWh10jSYF2hg7vX60AtaA8b1pq3+ek+m34q9nIIAoOKRVbTSvA8
	 aIydthxu/SJo0C6cVQMA7M7uFhn3MCJObkB20UNwpsiQd/eY08B9LjHDb8RDxnDd90
	 zGm/r0AloWf3Kwx4NlmxpENPRkAVMGwuebqlyrdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 805/809] nvme-pci: add missing condition check for existence of mapped data
Date: Tue, 30 Jul 2024 17:51:21 +0200
Message-ID: <20240730151756.777431910@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9e9b05e79c474..5a93f021ca4f1 100644
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



