Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DCD1A3A80;
	Mon,  2 Jun 2025 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872758; cv=none; b=KcyY/FOP4Yv3lD81dZQi6rfinwdmkxbvyRcQNVCRboKu9TyJnI3WrM+NNoc8yVmd1Il6N+tGK+DrjSLkqWzpZhW6iK3uVE8dO89YQaAtpwB2mk6fzJh9lVB9FptxSCYzKllj4kcubbbv1xjb8S5pbtQ58ncGofzOiL8aU4ZXTv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872758; c=relaxed/simple;
	bh=v1Ar+JsT7rzWNohnPXGMDPsXRPNbN3L2qBHunhHhWyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXy0yeiWpKAWwVkXoGV9OojAexGlcS+2EW0EqsX/LcDWIBwLbuJzqev7x16lebTZeXlVkBszs9ObJpOaaOhK3CMDgBLZSahOcY5R/2hVi8sXrri032fhO4c6+/qjC/bP4vccAJ6jyt5+nQ8h4eqmZp9FJGhD1Mmo3rlVP+4Zh9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmM+GLEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmM+GLEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B1C4CEEB;
	Mon,  2 Jun 2025 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872758;
	bh=v1Ar+JsT7rzWNohnPXGMDPsXRPNbN3L2qBHunhHhWyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmM+GLEsMH4vovVqKQ6vUXmBidzXADmH8aPI2h21s5+kF9R7O1GtyPKxZzduOUDvI
	 mdpJtSenfj7Lg2SkEXbyXDVw633JafZvhqcZ/GCri00ObAosUlo0tfvBEVzU6PVhuZ
	 xlqJQgmLef1+kDRbuZeaWD0fR+ksfmBUIpgDg6G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Adamson <alan.adamson@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 59/73] nvme: multipath: enable BLK_FEAT_ATOMIC_WRITES for multipathing
Date: Mon,  2 Jun 2025 15:47:45 +0200
Message-ID: <20250602134244.017327277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Adamson <alan.adamson@oracle.com>

[ Upstream commit a21675ee3b1ba094e229ae4cd8bddf7d215ab1b9 ]

A change to QEMU resulted in all nvme controllers (single and
multi-controller subsystems) to have its CMIC.MCTRS bit set which
indicates the subsystem supports multiple controllers and it is possible
a namespace can be shared between those multiple controllers in a
multipath configuration.

When a namespace of a CMIC.MCTRS enabled subsystem is allocated, a
multipath node is created.  The queue limits for this node are inherited
from the namespace being allocated. When inheriting queue limits, the
features being inherited need to be specified. The atomic write feature
(BLK_FEAT_ATOMIC_WRITES) was not specified so the atomic queue limits
were not inherited by the multipath disk node which resulted in the sysfs
atomic write attributes being zeroed. The fix is to include
BLK_FEAT_ATOMIC_WRITES in the list of features to be inherited.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f39823cde62c7..ac17e650327f1 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -638,7 +638,8 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 
 	blk_set_stacking_limits(&lim);
 	lim.dma_alignment = 3;
-	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
 	if (head->ids.csi == NVME_CSI_ZNS)
 		lim.features |= BLK_FEAT_ZONED;
 
-- 
2.39.5



