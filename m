Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B284013341E;
	Tue, 14 May 2024 10:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682637; cv=none; b=ZVqG7mULNpT+Hh3LN0C4LVBmxWuTqOMBTPSNzF2jVJi/kA2rbXtRs2pmsgLEXVQ+JRr1uCMVFPA090cY/gaW4iPzACZQuAclTfR+oa5cjb6PfpBEaJ3dq7DbKVUqjJMPjLpgGE7KI+olYMKc9CxcXgw5xEJBDIxGaLJ6vIbVCa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682637; c=relaxed/simple;
	bh=8dIbCMjUGJmPvY4gUpbDJgZzGA3fxfkEA+HarKnEx6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Seev7up+jTw/5BB+M1LgEfYG+uwGykp0ZW7mGL3Y0pBEgboc/3DeGzB8WNtrhd2GB1B4aCrub0g4g9k+nBRVA+MfHje8cGiylZevf5KbacRZ8i2H155+DSj9cKzTqIA3gverlN/5BW/naORsGNpnbJ+oW3ELXEukOMo3gW3+w/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08eMftUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08eMftUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D99C2BD10;
	Tue, 14 May 2024 10:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682637;
	bh=8dIbCMjUGJmPvY4gUpbDJgZzGA3fxfkEA+HarKnEx6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08eMftUPMDDRLorDLZrDei1DkVuo8YfzU7LkHwvMxHzZ8XcqiKL/f96GGAPglRIby
	 j4fmpvbtki3DZzh9OFiWey+oacDKmkDLM9Vwxr2X9iluolXlyvfoY34BR9x+oKC+aq
	 62g39PUH4ypSWHt2/jvkHwQGr0YTfXYZsOH6uIK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Ioffe <ioffe@google.com>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 092/336] swiotlb: initialise restricted pool list_head when SWIOTLB_DYNAMIC=y
Date: Tue, 14 May 2024 12:14:56 +0200
Message-ID: <20240514101042.079067176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit 75961ffb5cb3e5196f19cae7683f35cc88b50800 ]

Using restricted DMA pools (CONFIG_DMA_RESTRICTED_POOL=y) in conjunction
with dynamic SWIOTLB (CONFIG_SWIOTLB_DYNAMIC=y) leads to the following
crash when initialising the restricted pools at boot-time:

  | Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
  | Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
  | pc : rmem_swiotlb_device_init+0xfc/0x1ec
  | lr : rmem_swiotlb_device_init+0xf0/0x1ec
  | Call trace:
  |  rmem_swiotlb_device_init+0xfc/0x1ec
  |  of_reserved_mem_device_init_by_idx+0x18c/0x238
  |  of_dma_configure_id+0x31c/0x33c
  |  platform_dma_configure+0x34/0x80

faddr2line reveals that the crash is in the list validation code:

  include/linux/list.h:83
  include/linux/rculist.h:79
  include/linux/rculist.h:106
  kernel/dma/swiotlb.c:306
  kernel/dma/swiotlb.c:1695

because add_mem_pool() is trying to list_add_rcu() to a NULL
'mem->pools'.

Fix the crash by initialising the 'mem->pools' list_head in
rmem_swiotlb_device_init() before calling add_mem_pool().

Reported-by: Nikita Ioffe <ioffe@google.com>
Tested-by: Nikita Ioffe <ioffe@google.com>
Fixes: 1aaa736815eb ("swiotlb: allocate a new memory pool when existing pools are full")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 877c4b8fad195..1955b42f42fc9 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1717,6 +1717,7 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 		mem->for_alloc = true;
 #ifdef CONFIG_SWIOTLB_DYNAMIC
 		spin_lock_init(&mem->lock);
+		INIT_LIST_HEAD_RCU(&mem->pools);
 #endif
 		add_mem_pool(mem, pool);
 
-- 
2.43.0



