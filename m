Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F23B8D4F;
	Mon, 23 Mar 2026 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282531; cv=none; b=lBAMRgSHfO28krZx1IfxGkIqvC1A7Z5QcTEO7KzBKrUW1jXSkfprC0YpnBaJzlY1CE0NlF5glOkKbd6vr7+KYcEtNs2mM89152QdH0DvKmf+wyQv6P2eyN5AwwPG1SJNwIewbsvrLEhYxlMToePlqOcEIEH4Hd3SVEJJYfmfJVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282531; c=relaxed/simple;
	bh=0k2Hq2TsMGq6LwX5UEwG/5rddOrWoD6wRi08WmrArMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcD166cTvmqDQ93tRGn+/sXgwozasJ4f8A0KaC3eZ3egLf8BgSdZYCQAAUtd36LAtk00uYiU2TJB5lMNDiVYSeYnHtgWeFqgtSbkg/5481lYBRsi6rkQJLpuYPrfxqhsik7Ae4nH9AmECB9XSETF3JgDn8BvTpXxdvR/71onnpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iKCyhYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iKCyhYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D7BC4CEF7;
	Mon, 23 Mar 2026 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282531;
	bh=0k2Hq2TsMGq6LwX5UEwG/5rddOrWoD6wRi08WmrArMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iKCyhYsz3uDNRLcwXn41v06Iw3WQ9hDH19CDgti8/wmzsM2ZCEqBCa1V3G34OBtm
	 M7iiyWI84A7dGvEuf0AOiAlgwaGJ7Kild1Bb6nZA0/XmvW/3IGSGO+Z7V58kpfW8Bq
	 4kCcpN1trVeOfbWk9+p4/DGYuaHhIfbd++LsmKs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Valerio <pvalerio@redhat.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/481] net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()
Date: Mon, 23 Mar 2026 14:41:58 +0100
Message-ID: <20260323134528.577733359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0abc73c8a40fd64ac1739c90bb4f42c418d27a5e ]

Reset eBPF program pointer to old_prog and do not decrease its ref-count
if mtk_open routine in mtk_xdp_setup() fails.

Fixes: 7c26c20da5d42 ("net: ethernet: mtk_eth_soc: add basic XDP support")
Suggested-by: Paolo Valerio <pvalerio@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260303-mtk-xdp-prog-ptr-fix-v2-1-97b6dbbe240f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3f2f725ccceb3..20d14e3ae6efd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3119,12 +3119,21 @@ static int mtk_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 		mtk_stop(dev);
 
 	old_prog = rcu_replace_pointer(eth->prog, prog, lockdep_rtnl_is_held());
+
+	if (netif_running(dev) && need_update) {
+		int err;
+
+		err = mtk_open(dev);
+		if (err) {
+			rcu_assign_pointer(eth->prog, old_prog);
+
+			return err;
+		}
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-	if (netif_running(dev) && need_update)
-		return mtk_open(dev);
-
 	return 0;
 }
 
-- 
2.51.0



