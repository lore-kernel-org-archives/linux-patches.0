Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F971714A1;
	Thu, 15 Aug 2024 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730212; cv=none; b=Uw9w+ueJ4TDPYC8+XlrYbKI73zuia2qk7xcR745ay9FbjarOWrqdZbMAJ4t/7HZTM3BXH1paOfCbGkX5AqS00gDsidxyI1WzG7oAorXh115I6Jrs4iJnteWM1M2JFhmlHRkfhUVZm1HUg0jgc2EQKB3Qlfu8n3rw5ve+urEn7cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730212; c=relaxed/simple;
	bh=kSKiaHWolATUZNo8+f9jDNg/XVipxZJ5MJbt6xWwXAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVjZbe2osKYtlGD2xNDgQNOn3KuJ7u6MOTkZzG0cy//Z/o1FGfWYHhPN594SYEcsrdupn1RoeOgWFkVc+VPE1N3CGRIL2uZUvGLMJ/IbMayKGfqfb0bZy7iRvDd1s3rE+q8Z1x30lgCp0zii5KBw0p/HApV/JdLVTSl9c/dkfCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3ffb4dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3ffb4dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386ACC32786;
	Thu, 15 Aug 2024 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730212;
	bh=kSKiaHWolATUZNo8+f9jDNg/XVipxZJ5MJbt6xWwXAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3ffb4dK5h8uNIDUHzYfDVYyYjBE/y81Pkbkqot7CYr/anuzKv5KILrYndE0Tr56h
	 7u2SC/XlZYuTX/BGDHaGKDOYpvzn/OaPv52J98DD2ROQPcQjXi8YipJw9YIVEhGljT
	 O4yJYM43QMqkLsRRV88U2nJ+IMNzYjkR84kU7zuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/484] nvme-pci: add missing condition check for existence of mapped data
Date: Thu, 15 Aug 2024 15:22:34 +0200
Message-ID: <20240815131952.838590101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 01f16989d0d84..1df3e083f3c67 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -914,7 +914,8 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	blk_mq_start_request(req);
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



