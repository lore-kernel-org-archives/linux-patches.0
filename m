Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177EB46A5F3;
	Tue, 21 Jul 2026 15:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648795; cv=none; b=jlaj1f58+f+svZYyP0H7vcfdSv1MhXlyG4qIDHgpmUPpmwU98gjxtv4DJQ83ck4a7iYXXJnRjcxUUQEIbPkjLyrpnmobQ5JI8U+tmjnM+DeJlzdtPMQmpMJvhjjEkLczyjA2HOEKH/cIl+F9rdUIKjO5ufrmpqUkJDGKTZQPjZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648795; c=relaxed/simple;
	bh=jALZQ4eucvoQTQ8Y67pQPLMTthYOcxuhqgJenS9t+uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSUcwlJIPVMWM/0x+pxtcRmb5vlv0ZvY13ULUWn1EtpSyZwZUgURavKxnPYYK1T7IdjQwDh8+h9bJDCOypTdam0mLeCJmy8F+CKoUJnZO7LdsjWOV6XTcAS163QhOsuY/bbYCSjs0VMqRThaDMwmsLihEvBwkNJZKJ6suaTOb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOaW0S0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOaW0S0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9351F000E9;
	Tue, 21 Jul 2026 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648794;
	bh=5h1iiAQpZmzDbd/IcMygFWDcIriSW1r3/Uh2YpyBc5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOaW0S0Ri5Kz62e1M8+qnMn93xXyf8KvNGH8kiOCDIBhc17vr04bFuZh8Xl+gajad
	 2u7Xk4xuPv0a2cbio2nr8GZk8Q79vpOI7i8RGt7+q9T/7Ygp7eXB8mqxdr/IZiLFAw
	 PgFSW2fUVGmgoKQ/tFnMLQZ/lqp6NADuITIQiDSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung-woo Kim <iam@sung-woo.kim>,
	Christoph Hellwig <hch@lst.de>,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0334/2077] nvme-pci: fix out-of-bounds access in nvme_setup_descriptor_pools
Date: Tue, 21 Jul 2026 17:00:07 +0200
Message-ID: <20260721152600.561738872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b5f84620067899..0de6844ca56c0c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -587,11 +587,16 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
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



