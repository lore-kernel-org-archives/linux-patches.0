Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29335187E8;
	Thu, 17 Sep 2026 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665820; cv=none; b=QGoNtz8+GLBbWZKIOGolTr6L1Uc2PM1HJ1JgmPkiEsOxv/2ORE1ckwGJV4Xd1CSXmQBLlbZ8Xe3YnmWy943u8Hjp+KZ9FHr7wxcrMXzFMu1sw5TqSpZrlJ7VGe0IhpRiMckptCgs6oi22824OxsHbMr6/VXaRQz4JnWhMvRh7g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665820; c=relaxed/simple;
	bh=7+qXeDy37Xw2IfzenH/ub5oeC0gkDzFlUvW3MHNRHIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVN3akmuE6h7rdWCB3uXrap3+L+ViQUdvXWzcvnoo4JjIwJSTWB6/0MEkMgitEBZzTMfw9QNQ5uIJ6pOx3KGg45oX9eJvJW9agRjI+885YZU8nugtYELnB/hTGu1ttPXehBFk8VOEQW4/CqeYNmkqkutPiLlG5O6T3h5cJZoVNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luqh0wyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luqh0wyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227621F00893;
	Thu, 17 Sep 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665819;
	bh=70HlZytaoggxyUUG5er1wDCwBBNGLHhASg7c/EprX7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luqh0wyfRtvXAc17Gg/bixc3g4DM5n4ti8KvC809EFGF3QYuTHd/fDxEdypQYXb4r
	 f3YBEobnJnmE1j7XOmdhTH1nDKwQ8CcHXObBRGVLLcc48UvNufCFIG5n70b8aAakwG
	 eoi7bZPvMKH0iVCQy3oaHwz+7vpOQGkJqFAFF+xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0832/1250] iommu/amd: Add NUMA node affinity for IOMMU log buffers
Date: Thu, 17 Sep 2026 16:10:27 +0100
Message-ID: <20260917151614.497711203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 1e0c8d6b695217cb0b16f13e31c7f08b453097b4 ]

Currently, PPR Log and GA logs for AMD IOMMU are allocated using
iommu_alloc_pages_sz(), which does not account for NUMA affinity. This can
lead to remote memory access latencies if the memory is allocated on a
different node than the IOMMU hardware.

Switch to iommu_alloc_pages_node_sz() to ensure that these data structures
are allocated on the same NUMA node as the IOMMU device. If the node
information is unavailable, it defaults to NUMA_NO_NODE.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 00a7dd64888d ("iommu/amd: Do not reallocate GA log buffers on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 6bb9d3661baed..0561c17a24e73 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -854,10 +854,11 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 				  size_t size)
 {
+	int nid = iommu->dev ? dev_to_node(&iommu->dev->dev) : NUMA_NO_NODE;
 	void *buf;
 
 	size = PAGE_ALIGN(size);
-	buf = iommu_alloc_pages_sz(gfp, size);
+	buf = iommu_alloc_pages_node_sz(nid, gfp, size);
 	if (!buf)
 		return NULL;
 	if (check_feature(FEATURE_SNP) &&
@@ -972,14 +973,16 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 
 static int iommu_init_ga_log(struct amd_iommu *iommu)
 {
+	int nid = iommu->dev ? dev_to_node(&iommu->dev->dev) : NUMA_NO_NODE;
+
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
-	iommu->ga_log = iommu_alloc_pages_sz(GFP_KERNEL, GA_LOG_SIZE);
+	iommu->ga_log = iommu_alloc_pages_node_sz(nid, GFP_KERNEL, GA_LOG_SIZE);
 	if (!iommu->ga_log)
 		goto err_out;
 
-	iommu->ga_log_tail = iommu_alloc_pages_sz(GFP_KERNEL, 8);
+	iommu->ga_log_tail = iommu_alloc_pages_node_sz(nid, GFP_KERNEL, 8);
 	if (!iommu->ga_log_tail)
 		goto err_out;
 
-- 
2.53.0



