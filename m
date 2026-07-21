Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237B3472F8C;
	Tue, 21 Jul 2026 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656161; cv=none; b=ZwH1Ud29ES3NEbXriunHGlAB5yFT/ay40vOZnSLy9TrYOsXWeRXc2g14rIN4LTwfEW/4Ex2Ol6Ko9r6WFp01RVj0nUGfnl3f6YwXlKdZ9/r+JidEeyfBnAMwIm4CnjT02BdxrdFBmyrGQySRt3HAGh+5aqEXe1DvUMCLsYfiny8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656161; c=relaxed/simple;
	bh=SwlCJQr8EfeDRMUkqsDZIfTaeo8yEg3pOR0Ctd5Obfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+BkOKOMEsRTzwLatnp0G8Cv2mVlmluy48iZoW7XXhJhOi2iWPhGi/55ICT/vej6VBNy84pcYaSPb1a+r112lVVrH2m1DihBaqeRAfMV4t6JLucDR6TILhW0MNXoOZxo24jHQdwYZchqiEvZR8sarFMOiLxoVj8WSlUKnPuu34Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iwu8kg7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iwu8kg7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534A51F000E9;
	Tue, 21 Jul 2026 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656159;
	bh=JL99RI++cbqQFXBR5bJCrrhRwOgT5km8kTXWrox8+Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iwu8kg7kb2nIhD3kwIgngHbRjGO7MCkZoD6wwzPrj7V3aUJwpT6QGWG0MFmPUNED8
	 EcYLo61XttSfrD7Dwu9OxtROlbKukG6vYb5b2yqeB6ng3+dpKK7ejUWSMiDT787stx
	 HHswgAcqczgPfOfcZu5F9mTDenWak4nUERo9Gwvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung-woo Kim <iam@sung-woo.kim>,
	Christoph Hellwig <hch@lst.de>,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0239/1611] nvme-pci: fix out-of-bounds access in nvme_setup_descriptor_pools
Date: Tue, 21 Jul 2026 17:05:55 +0200
Message-ID: <20260721152520.390109183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mateusz Nowicki <mateusz.nowicki@posteo.net>

[ Upstream commit a192b8cfa447e1b3701a13434a31c392b2e7ed29 ]

nvme_setup_descriptor_pools() indexes dev->descriptor_pools[] using the
numa_node forwarded from hctx->numa_node by its single caller,
nvme_init_hctx_common().  On a non-NUMA kernel hctx->numa_node is
NUMA_NO_NODE (-1).  Because the parameter was declared 'unsigned', the
value becomes UINT_MAX and the index walks off the array (sized to
nr_node_ids), faulting during nvme_alloc_ns() and leaving the namespace
without a /dev node.

Reproduces on any NVMe controller probed by a CONFIG_NUMA=n kernel:

  BUG: unable to handle page fault for address: ffff889101603d38
  RIP: 0010:nvme_init_hctx_common+0x5a/0x190 [nvme]
  Call Trace:
   nvme_init_hctx+0x10/0x20 [nvme]
   nvme_alloc_ns+0x9e/0xa10 [nvme_core]
   nvme_scan_ns+0x301/0x3b0 [nvme_core]
   nvme_scan_ns_async+0x23/0x30 [nvme_core]

Switch the parameter to int and fall back to node 0 when it is
NUMA_NO_NODE; node 0 is always present.

Fixes: d977506f8863 ("nvme-pci: make PRP list DMA pools per-NUMA-node")
Link: https://lore.kernel.org/r/20260309062840.2937858-2-iam@sung-woo.kim
Reported-by: Sung-woo Kim <iam@sung-woo.kim>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8c66fd23a143c1..489583393b8451 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -431,11 +431,16 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
 }
 
 static struct nvme_descriptor_pools *
-nvme_setup_descriptor_pools(struct nvme_dev *dev, unsigned numa_node)
+nvme_setup_descriptor_pools(struct nvme_dev *dev, int numa_node)
 {
-	struct nvme_descriptor_pools *pools = &dev->descriptor_pools[numa_node];
+	struct nvme_descriptor_pools *pools;
 	size_t small_align = NVME_SMALL_POOL_SIZE;
 
+	if (numa_node == NUMA_NO_NODE)
+		numa_node = 0;
+
+	pools = &dev->descriptor_pools[numa_node];
+
 	if (pools->small)
 		return pools; /* already initialized */
 
-- 
2.53.0



