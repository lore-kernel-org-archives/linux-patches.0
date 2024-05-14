Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D911E495;
	Tue, 14 May 2024 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684866; cv=none; b=d9HbESV3enbv79JHkRaO/+uLTyIbHn8g1T6+T3Qn/0AJYomDvErB7mfD5vqQ+9itxWYNCcNDa1UPWNFvjTU0BE8lwhTt14YB42tezqxnslCi67U46qu2Pxq2SD9Q+4lk5dzVyEw2SYVssHmkqtnuica0qk0LgUMbjJ/AO3Jz5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684866; c=relaxed/simple;
	bh=rErdi7z6jtFwgoIWy9GOktR5vvqKBJA+zHeVDPYCx44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klTu4MkwliGvd5wEwHPs+l8A2LVt6+GJqwsozD0rWOI6yUdEPG6ncjNMCsgbQjORqXbbrdA4DuioFzjN9tAUAYV7DChWquj53eXxLA6+D1EiyHKvUFf/gwe+gxp0iy4hN56J3ekGTbFlhG2orCZZxPL0C+0mVZu/63QbKd/RIIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxw3Q9ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxw3Q9ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD6AC2BD10;
	Tue, 14 May 2024 11:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684866;
	bh=rErdi7z6jtFwgoIWy9GOktR5vvqKBJA+zHeVDPYCx44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxw3Q9ubbk7fGg9iOChnT+Aie/Cz5D28b7RGU4dgi1yJAxdqnzSjBRKm5091hYCVm
	 ZQrJ0T0/EPnutVbDPziet57XS2uITbjs5Arvb02Ul8r8V5qufEj8vWQp0PIYhBTJyZ
	 QkfhVkb8yqnHmUPaFzSgT/WOr/7ZbM2E4MxQRNQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Ioffe <ioffe@google.com>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/301] swiotlb: initialise restricted pool list_head when SWIOTLB_DYNAMIC=y
Date: Tue, 14 May 2024 12:16:04 +0200
Message-ID: <20240514101035.761996319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index 675ae318f74f8..a7d5fb473b324 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1692,6 +1692,7 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 		mem->for_alloc = true;
 #ifdef CONFIG_SWIOTLB_DYNAMIC
 		spin_lock_init(&mem->lock);
+		INIT_LIST_HEAD_RCU(&mem->pools);
 #endif
 		add_mem_pool(mem, pool);
 
-- 
2.43.0



