Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019447;
	b=amof21SMw88NctWNAmrARcNacAXp3UjS/I8fehvFmVQlr41XXCTtu4SvDTL1Cpu6scHN
	 Qww13BHijvlhbPkYcgSa6SpDnjO41q2dn+VsabztpMLcJFgqTKpH1Ho4U9fdQHf0f1mr4
	 CluAYhmd7VCrK7G6wvqBKNY/9YtWgUjPSaFLr2L5yhKP78eJx3AvKuBNdziEnBBkB4mDH
	 zF/ba6fO+OTnu/xGmJ0DwMQj1uJWlaHh5g3EG6RAb+uTMMV2FDp+spbIdjwq+gy8csGaS
	 yuelSvdsWhh3Fetmpv75VDPiodZ3i2ZDgiQCc6XXqU3ZLFPcLsueolab3gO9EaJaDMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JTaQaq9aopVTb51Z+IJNwBFsg9PD6MxFaGp4Ucbu24Y=;
	b=APO6hN62VlN48EGIQ+hS3SqgAlU//7E7CRNzSObElAZzXaICK3DgRjeGA2DTgPAvVzVO
	 5S25fesjAO2VILwB3Se/bx7Ne5g/r/C/42iZWK3Njujl9nFrD+jNs56UMpa/8duAJyIXP
	 1OcYcmMpqHxHF4RWK4fMmeD7ING6D6yCHSXgmG179ZVf4mRz+MCxlewRT95+NT90YCecW
	 DEpwr2EbZ+9QSb9SP9xgRoO2GBevQ1HcxKHDIaqrO4dK3US2H5oZom+E6istD5sFOEiLn
	 HMpfMarLBKwh6gJ+xQfGJp0mesP8mOboGB354A+pthTs6OGYqSP7sQAhVew/1I6XAvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgY3eHmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A02606B555;
	Wed, 18 Nov 2026 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgY3eHmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4851F000C5;
	Wed, 18 Nov 2026 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019447;
	bh=JTaQaq9aopVTb51Z+IJNwBFsg9PD6MxFaGp4Ucbu24Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgY3eHmisQhoLnOAFQ4ay/ajQ2KvQBFnho5q5VgbJtNjpcwDumZ/kvILKcHzgWa8o
	 UWLIOAK/OajUzZk+syDVfTQHZdH8HektlAYmZ/vUomxAcCwNMa83pFsurx3KzJyrEn
	 XD+f2EdDimTiXlMujOaYuZSuBnHOq1L84JkQ3Etw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Matt Evans <matt@ozlabs.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1572/2651] PCI/P2PDMA: Wait for RCU readers before freeing state
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118150344.528559232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 1b82c6657e957f598b6e19e045e0bbd5cb370083 ]

pci_p2pmem_find_many() scans all PCI devices without locking or protection
against driver unbind, including devices with poolless P2PDMA state.
pci_has_p2pmem() may observe pdev->p2pdma just before driver unbind clears
it, while pci_p2pdma_release() skips the grace period when no pool is
present. This allows devres to free the object while it is still in use.

Clear the pointer with RCU_INIT_POINTER() and always wait for pre-existing
RCU readers before returning. The same grace period continues to protect
gen_pool users for pool-backed providers.

Fixes: 372d6d1b8ae3 ("PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Matt Evans <matt@ozlabs.org>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-2-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 8124bcebfa2d3..52974809e1e18 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -236,9 +236,8 @@ static void pci_p2pdma_release(void *data)
 		return;
 
 	/* Flush and disable pci_alloc_p2p_mem() */
-	pdev->p2pdma = NULL;
-	if (p2pdma->pool)
-		synchronize_rcu();
+	RCU_INIT_POINTER(pdev->p2pdma, NULL);
+	synchronize_rcu();
 	xa_destroy(&p2pdma->map_types);
 
 	if (!p2pdma->pool)
-- 
2.53.0



