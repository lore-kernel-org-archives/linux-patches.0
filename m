Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955DF2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D225C433D2;
	Wed, 12 Apr 2023 08:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289061;
	bh=u4QMldzwkCH7K8evFHAHipIsjqvDKlM5fwCfMdglvxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=td5QOkaAYf1N7puLVmhw3Csuin/LtTafrGjmiHoPLWhX2KIanjt3VJ9Krk1BmPeI5
	 LMfVgQ4Jtu4kH+jbLyKP1ccM/LDyDvvGT6hXgnHdjgRXALjYgvRCA7hrVLO6p+Z7Ue
	 DXICxO9dVfdipWuMsNu3R7o4+xDNc7HEs78qq5sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 122/164] net: stmmac: Add queue reset into stmmac_xdp_open() function
Date: Wed, 12 Apr 2023 10:34:04 +0200
Message-Id: <20230412082841.779494923@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Yoong Siang <yoong.siang.song@intel.com>

commit 24e3fce00c0b557491ff596c0682a29dee6fe848 upstream.

Queue reset was moved out from __init_dma_rx_desc_rings() and
__init_dma_tx_desc_rings() functions. Thus, the driver fails to transmit
and receive packet after XDP prog setup.

This commit adds the missing queue reset into stmmac_xdp_open() function.

Fixes: f9ec5723c3db ("net: ethernet: stmicro: stmmac: move queue reset to dedicated functions")
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230404044823.3226144-1-yoong.siang.song@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6627,6 +6627,8 @@ int stmmac_xdp_open(struct net_device *d
 		goto init_error;
 	}
 
+	stmmac_reset_queues_param(priv);
+
 	/* DMA CSR Channel configuration */
 	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);


