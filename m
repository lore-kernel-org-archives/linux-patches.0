Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018655;
	b=5pJqcyrJXMzhHSNINZg6Rd0lUwRQ6RxdBj5qBsLDWY6uiXCZcesXQMGQSC5HH80VkSzx
	 qXPC1zqMAliTTTGAE/6OlIk0aG9l5Yj2xjUJ8MbRYdvAofzXznBoNRj4Gla5mqSTw0EjM
	 oLmPgceyvRlurYc9+K1hO4jn9ygLNLF9X1a3vXj0KD3cf3EbYhwoHAmMu8lLz9HY1/6Zk
	 +N20yCpotpXS7E3QDGIICKzl5B22bnS3zRbASouuD8/mTCzr2buHFTXGO46Eo045dVZqk
	 kocjTJRRXbudg4zStGbB9LCYusy20rd5Zs/O2CHiBd3v+RY2RnSle4WPTVFc1ZhAO7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8rc542BMIaMj+PnY4rYEtGt9vauHkVEbBNf+Kqf7bQc=;
	b=rdmBPUvn7/EJ2LzZNPUtyz2YttHhVIDHZUAZ0bwGIefcNu9XTUAHmjLeBaQq8REl91F0
	 uAzY+q9s4hsZSDsd31pPDDoVjwv52XlFIkAGBl2Oic67hcHZbzdFRXRLiIeHUqmDnR4rz
	 Y/6vhHhctT8yGK0oL9EBTvEZ8TFvSa7S+/yn2x8dqb9kqvED9SnrHt2pDvUUmtk4+FpMP
	 jYN35VT5oYdmOztc6EtbigI45zg9JxkLTC6svtC232x9PgUYCpo01zp/08b6dQFXHMJIC
	 pjJuQnhTGjzMrCuf+AUyWbFcbeWJdJeIgQrqj4s0T3Nvfp/6iHgwS/x2PmXTgFmYXGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1Vg9DmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F542606A32A;
	Wed, 18 Nov 2026 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1Vg9DmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E641F000C4;
	Wed, 18 Nov 2026 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018655;
	bh=8rc542BMIaMj+PnY4rYEtGt9vauHkVEbBNf+Kqf7bQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1Vg9DmVz+DO4o3S9IEJQNz7nrWwgViatqsPYSh5nA37rtn0egSeeWAtUNFdFrrdD
	 nFE3BppJmU6Pli/OGt4sJbEI+0AFcuDtUwRX9Y+yuke9F6DCes70EjPvW0ZNL42l4g
	 N9Hj6zR8yF2r+K72ovFXb9ztDL6XuOYNbbZcaWR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1318/2651] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:42:38 +0100
Message-ID: <20261118150335.440014287@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit f3017892457d8bb664ea4b912910dc254e2dd825 ]

plx_dma_create() registered the interrupt handler with request_irq()
before initializing plxdev->bar. If the device raised an interrupt in
that window, plx_dma_isr() would dereference the still-NULL bar.

Move the bar assignment ahead of request_irq() so everything the
handler can touch is initialized before it can run.

Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Link: https://lore.kernel.org/all/20260610112121.676561-1-jjy600901@snu.ac.kr
Fixes: c2dbcaa8c672 ("dmaengine: plx-dma: Implement hardware initialization and cleanup")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/all/20260610112121.676561-1-jjy600901@snu.ac.kr/T/#u
Link: https://patch.msgid.link/20260902062153.31048-11-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/plx_dma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/plx_dma.c b/drivers/dma/plx_dma.c
index 84941a918b01f..409898e92c320 100644
--- a/drivers/dma/plx_dma.c
+++ b/drivers/dma/plx_dma.c
@@ -504,17 +504,17 @@ static int plx_dma_create(struct pci_dev *pdev)
 	if (!plxdev)
 		return -ENOMEM;
 
-	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
-			 KBUILD_MODNAME, plxdev);
-	if (rc)
-		goto free_plx;
-
 	spin_lock_init(&plxdev->ring_lock);
 	tasklet_setup(&plxdev->desc_task, plx_dma_desc_task);
 
 	RCU_INIT_POINTER(plxdev->pdev, pdev);
 	plxdev->bar = pcim_iomap_table(pdev)[0];
 
+	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
+			 KBUILD_MODNAME, plxdev);
+	if (rc)
+		goto free_plx;
+
 	dma = &plxdev->dma_dev;
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
-- 
2.53.0



