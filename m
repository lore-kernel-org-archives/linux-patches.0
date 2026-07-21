Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DFC4C8FE6;
	Tue, 21 Jul 2026 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647798; cv=none; b=cGu8X7oFekZOpU2fq2CtUwoz2GtJ1p4+EnkEFnWr/7rpXbo+ES/oc73loVC0WcKjYbt8XG6kXB3mfyKLChLds/Q071edlkU/KNWJ1oe2iDdQIko3WTVQq2rYnIp7sQIbxDuAi7u0zEYAbgH9zVGe5d/tEwVwS+sd/H2R16u7dFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647798; c=relaxed/simple;
	bh=O7QkVMee3lauXcnMtqzM4ZPCj3MIToFrFHxJ090el/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cw7KXo9/UXj3AXy32Nlq9UdKWGLAIBcXnWhLBggRMZGF6PyZkqIkvh+3FwI95Bazcw8p4C09Npwz2CVLbT5BoL5MXjfl9kX07sDOO0gIw668hkpGheDzpno9UW/WbMgGyYprYUc9lURcWmSxilDWDes2m9wTbop0XwR1DpXuEnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjhAIBRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjhAIBRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743021F00A3D;
	Tue, 21 Jul 2026 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647797;
	bh=XAV4EFwtuuEVKJwP62ryOIRoAOgPilpbydanahuWivg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjhAIBRCZwGCdmAXE+Y1Ce5ZE5Al+As5tpaKEW7M89kZ2Ks52b4bYVChHbI4IriCP
	 csaSzsoFujUlEZvlhm6RJlV5d/y28XINjNhR40SBaLs8aQPzPauXNzOq4vWiBSHZxn
	 4qwwAlY98J3QxLeoY499yh91DELqso//R59WBXgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Keith Busch <kbusch@kernel.org>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0001/1611] nvme-pci: DMA unmap the correct regions in nvme_free_sgls
Date: Tue, 21 Jul 2026 17:01:57 +0200
Message-ID: <20260721152514.795022215@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit a54afbc8a2138f8c2490510cf26cde188d480c43 upstream.

The call to nvme_free_sgls() in nvme_unmap_data() has the sg_list and sge
parameters swapped.  This wasn't noticed by the compiler because both share
the same type.  On a Xen PV hardware domain, and possibly any other
architectures that takes that path, this leads to corruption of the NVMe
contents.

Fixes: f0887e2a52d4 ("nvme-pci: create common sgl unmapping helper")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[nb: drop the attrs parameter added in 6.19 by commit 61d43b1731e0
 ("nvme-pci: migrate to dma_map_phys instead of map_page"), which is
 not in 6.18.y]
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5e36a5926fe03d..8c66fd23a143c1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -761,8 +761,8 @@ static void nvme_unmap_data(struct request *req)
 
 	if (!blk_rq_dma_unmap(req, dma_dev, &iod->dma_state, iod->total_len)) {
 		if (nvme_pci_cmd_use_sgl(&iod->cmd))
-			nvme_free_sgls(req, iod->descriptors[0],
-				       &iod->cmd.common.dptr.sgl);
+			nvme_free_sgls(req, &iod->cmd.common.dptr.sgl,
+				       iod->descriptors[0]);
 		else
 			nvme_free_prps(req);
 	}
-- 
2.53.0



