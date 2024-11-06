Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839131DED58;
	Wed,  6 Nov 2024 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895986; cv=none; b=kiLu6eyKSdyb4n4WgXiUdyc1aElilJg8hEQwFOj6s87aWT/IZz4BA+8fkekUaXuasN1couq7YQLTWiFrnKaePgqxZxMpxLSZ2rgOfd0x01gYYqJJvPu3H/QX3lPM4wjkbPYyWr6Jt2+kb3K8FPzn6qYRsXZpho4zBHnm22bJtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895986; c=relaxed/simple;
	bh=AXdcEabcCpiYL4B8ConpZKONZkkgvofwyccnMfc7ZUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPToHtczw3aXuq/VhQjCRVfECA9hZMg1AyM7xcp8BCIE8AdGbpS/JYaW84Cyqw6FjM43d9qESFoJoeXIQo6KF4JrUXU/XgMo1/wi8v2jkAcFfOE3w+2tp508idzugKhXdGMbiFrxl1O9JsAEyx02D7cyxT2RewlYoIvYvtnJsns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpSc4iww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpSc4iww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C34C4CECD;
	Wed,  6 Nov 2024 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895986;
	bh=AXdcEabcCpiYL4B8ConpZKONZkkgvofwyccnMfc7ZUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpSc4iwwqFqOYP6XWnvrry5x71NzGiB17OH04HCJl0GgfMQPdbV8va6bxzk/XmyKr
	 vypqeMxy0Uz+ilg+qnylkAGfa2NhwOB3vYV2hHeEBy+yUT8rPZOlJsV2IlcDj14+/b
	 qMW34CRnnvBo4VpvPkAJlsiUyNVhD2ep6zfhtHZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@resnulli.us>,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 052/245] mlxsw: pci: Sync Rx buffers for device
Date: Wed,  6 Nov 2024 13:01:45 +0100
Message-ID: <20241106120320.500598037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit d0fbdc3ae9ecc614ddffde55dccbcacef353da0b ]

Non-coherent architectures, like ARM, may require invalidating caches
before the device can use the DMA mapped memory, which means that before
posting pages to device, drivers should sync the memory for device.

Sync for device can be configured as page pool responsibility. Set the
relevant flag and define max_len for sync.

Cc: Jiri Pirko <jiri@resnulli.us>
Fixes: b5b60bb491b2 ("mlxsw: pci: Use page pool for Rx buffers allocation")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/92e01f05c4f506a4f0a9b39c10175dcc01994910.1729866134.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 2320a5f323b45..d6f37456fb317 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -996,12 +996,13 @@ static int mlxsw_pci_cq_page_pool_init(struct mlxsw_pci_queue *q,
 	if (cq_type != MLXSW_PCI_CQ_RDQ)
 		return 0;
 
-	pp_params.flags = PP_FLAG_DMA_MAP;
+	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 	pp_params.pool_size = MLXSW_PCI_WQE_COUNT * mlxsw_pci->num_sg_entries;
 	pp_params.nid = dev_to_node(&mlxsw_pci->pdev->dev);
 	pp_params.dev = &mlxsw_pci->pdev->dev;
 	pp_params.napi = &q->u.cq.napi;
 	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.max_len = PAGE_SIZE;
 
 	page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(page_pool))
-- 
2.43.0



