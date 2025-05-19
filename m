Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558BB220F55;
	Mon, 19 May 2025 21:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689711; cv=none; b=kx8wF9Ajl8bDwvtNOGe2i0/RpWmyEUCtOivsFWH3FltCCOeIbehByw/8eo5cIk7H2Bh5a7FlKk0E4ZXG3NUHkE/ejFFKAe5z/gffJlwt1UAkfxTfEfg3SOkbkr9remN5JiNOG9uaW6LqntKufuixMc1WK6kRaVAhlisjC00UHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689711; c=relaxed/simple;
	bh=gAtsqcqyq2u2ikHmrRudAkmavnu5hJUFh/jSZy+biYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B4EH55k80jC7V8JGrQUnV5vstWbpzDJdDPEMCEhrXr5sZcNeGz+McXLErNaRw0M9R+q6nGbEcr/VN8H6F2KZsnUKSrtgdOKvd2p8i5f1brwT56K3GF0j3ykxavcWIW/QXURkyNtghR0q846SH5eC4EuTDsP7ayft73wtH9k0KrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyWCh5yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyWCh5yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B5FC4CEEB;
	Mon, 19 May 2025 21:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689711;
	bh=gAtsqcqyq2u2ikHmrRudAkmavnu5hJUFh/jSZy+biYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyWCh5yciQfwC9jY0ddgbIo/IT8Py9+uDRP/LAogltJOnNfFrcZYyUo1ML12a3RA5
	 6yvsXCowjRrXY+AFO5j0BoAUSgg4D7rzEFPO6WDnVKItNmI9XTafy9xTUDPtyZeowB
	 7MMOR09Y3fuMDbQ3yy1z1+rkFVA1kDkCvZGV5LUdksKop2O4vcDdut3ql52RCuTYmJ
	 kmx1UCu+uOrgyxQ8HXw8+N+slbs2s50PRvL1JL34hTR0kwZX1SIYVqPsM5SzBfNY9/
	 vt0qupcOdzVVvSCB2UXbwAZgBmXpp1C3GoPSCK+7A0kZdZkQEys6zg+L4ekU8mppHO
	 ocKSy718mDcKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Adamson <alan.adamson@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	axboe@fb.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 12/23] nvme: multipath: enable BLK_FEAT_ATOMIC_WRITES for multipathing
Date: Mon, 19 May 2025 17:21:19 -0400
Message-Id: <20250519212131.1985647-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

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

