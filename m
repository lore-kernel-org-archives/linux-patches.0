Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FE715CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC73C433D6;
	Tue,  8 Nov 2022 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916472;
	bh=Ep/y4/cstCgemSwJV0Uds14xdtYuEZhoWjh9FLshEdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G85Ax/8JjmuiqpCxj3d8Tj9FHy9GW8PP8NKFnVtXh2BpZHpuKURwLyc6L7+8DZKVY
	 ogj+Yqj8jR0fr4+D3SMxSpD2/JgeU1ExB61hunKjV7XTZPBX3O0dkuk+Afs1P5o8/I
	 PKwou9lTnsztQ+Q8dkKZBa+1Wj50vuOqnWeQOFUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 032/197] sfc: Fix an error handling path in efx_pci_probe()
Date: Tue,  8 Nov 2022 14:37:50 +0100
Message-Id: <20221108133356.269035212@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6c412da54c80a54b1a8b7f89677f6e82f0fabec4 ]

If an error occurs after the first kzalloc() the corresponding memory
allocation is never freed.

Add the missing kfree() in the error handling path, as already done in the
remove() function.

Fixes: 7e773594dada ("sfc: Separate efx_nic memory from net_device memory")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 153d68e29b8b..68a68477ab7b 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1059,8 +1059,10 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	/* Allocate and initialise a struct net_device */
 	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
-	if (!net_dev)
-		return -ENOMEM;
+	if (!net_dev) {
+		rc = -ENOMEM;
+		goto fail0;
+	}
 	probe_ptr = netdev_priv(net_dev);
 	*probe_ptr = probe_data;
 	efx->net_dev = net_dev;
@@ -1132,6 +1134,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	WARN_ON(rc > 0);
 	netif_dbg(efx, drv, efx->net_dev, "initialisation failed. rc=%d\n", rc);
 	free_netdev(net_dev);
+ fail0:
+	kfree(probe_data);
 	return rc;
 }
 
-- 
2.35.1



