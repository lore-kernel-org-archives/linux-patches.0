Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC3143E095;
	Thu, 30 Jul 2026 14:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421853; cv=none; b=cZxNoqta0hWPaLCRaHuwkJRTQBYef1Nau2KbXn7KnjwxedITrdyUE8y698VHxf84sivQ0tjwVhLCsK4k6BB6CVVssgRSl5e4hICA1R+mw0Jc638dFu9Xd0ayFrRA4beHAn5F7yUWoBXpVJZ1IaVvJZja5jkg72bDmq4p5pbL0U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421853; c=relaxed/simple;
	bh=Kr4W6HZkJXI9YHRVuWPSSHsFIigJw8tpWvWr6eA9XAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbC2Av4meh5xE2+VUfXdpQVG03n3Q+paP7W+EekZ+7PaqPy8Ucb6Jt0CngNvsm6m/ui5ilon/+EnoPvLqffqgotUS7JF18PI5R6YSqd/TGpFLuG4PHYS8ZAx5npVgqe2Mo8naQ7yAe+tqFGttVdhmI27EQnB6hsXbIPcqM5BOj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6w4r3DH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6w4r3DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6571F000E9;
	Thu, 30 Jul 2026 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421852;
	bh=a2/YGwiH42xG+nAsFKN/2Z3wHw7RabjR/NE7Lc2qcwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6w4r3DHkVfRt5c3S8znoTxD2By4BLOcEO4dezPv57Pg9IwhcfXnShNZUv/7HsB/S
	 LswsaEuWpjp/6w/7J0r8IPyuUvqE4qRxc7J0eC4m2F3TWnFHbYm7//LlZrSptrDb7I
	 6dEq9cgPy0Ab+d78h1B1d/WcdjwBbmP5wkgkK4Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 242/744] net: airoha: Fix DMA direction for NPU mailbox buffer
Date: Thu, 30 Jul 2026 16:08:35 +0200
Message-ID: <20260730141449.437959186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen Yan <win847@gmail.com>

[ Upstream commit 6f884eb87a79e0c482baef2ad96c96b81d024235 ]

airoha_npu_send_msg() always maps the mailbox buffer with DMA_TO_DEVICE,
but some callers expect the NPU to write response data back into the
same buffer:

- airoha_npu_wlan_msg_get() (NPU_OP_GET): NPU writes response into
  the buffer, then the caller reads it via memcpy()
- airoha_npu_ppe_stats_setup() (NPU_OP_SET): NPU writes back
  npu_stats_addr field in the response

On non-cache-coherent architectures like EN7581 (Cortex-A53 without
hardware cache coherency for NPU DMA), DMA_TO_DEVICE unmap is a no-op
— it does not invalidate the CPU cache. If the NPU-written cache line
is still present in the CPU cache when the caller reads the buffer,
the CPU observes stale data instead of the NPU response.

This is a timing-sensitive bug: small mailbox buffers (~24 bytes)
typically fit in a single cache line and may survive in the cache
until the caller reads them, producing silent data corruption rather
than a crash. The bug is more likely to trigger when the caller reads
the response immediately after dma_unmap_single() without intervening
cache-evicting operations.

Fix by using DMA_BIDIRECTIONAL for both map and unmap, which ensures
dma_unmap_single() invalidates the CPU cache on non-coherent systems.
The mailbox buffers are small so there is no performance concern.

Fixes: c52918744ee1e49cea86622a2633b9782446428f ("net: airoha: npu: Move memory allocation in airoha_npu_send_msg() caller")
Signed-off-by: Wayen Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/178351055214.98729.11403147818632027428@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_npu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_npu.c b/drivers/net/ethernet/airoha/airoha_npu.c
index 17dbdc8325336b..eab3eb4a3ab216 100644
--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -168,7 +168,7 @@ static int airoha_npu_send_msg(struct airoha_npu *npu, int func_id,
 	dma_addr_t dma_addr;
 	int ret;
 
-	dma_addr = dma_map_single(npu->dev, p, size, DMA_TO_DEVICE);
+	dma_addr = dma_map_single(npu->dev, p, size, DMA_BIDIRECTIONAL);
 	ret = dma_mapping_error(npu->dev, dma_addr);
 	if (ret)
 		return ret;
@@ -191,7 +191,7 @@ static int airoha_npu_send_msg(struct airoha_npu *npu, int func_id,
 
 	spin_unlock_bh(&npu->cores[core].lock);
 
-	dma_unmap_single(npu->dev, dma_addr, size, DMA_TO_DEVICE);
+	dma_unmap_single(npu->dev, dma_addr, size, DMA_BIDIRECTIONAL);
 
 	return ret;
 }
-- 
2.53.0



