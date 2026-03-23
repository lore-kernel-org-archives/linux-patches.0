Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FF4242D70;
	Mon, 23 Mar 2026 15:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278016; cv=none; b=XQju7O34Pgn3ibIUlAENkDMsTmCLQZthldBre7AWk7o997xpA70FN4g7zElgGrSoZTTiB49vyf1LABvP6UISPDuuE0CfcT5Zc69GC1QT2zNYEAaXtQVk5Z0e0Oir6C5FKZ2cMpH0YU0EPQZij/dWi/A/hPcCmTtFNTw1TLmY3gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278016; c=relaxed/simple;
	bh=V/7lWuIAdHNJejPMsicTHajl78RgYfGyLU1NZvKE9z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2+cqj9BABm9ukLnvEnJtmQeLlmiWy0ZP4z8AUQn8KX9T9ONIjGw50dO3gCY+H9hBkbCeOc55H4RrSZvChLdycXKLPzwMLEEV6PPYCM9m92V2DPGJJQYyNKFzqjA8FM6H2N0IJCurwSgGolFRM5tNiRgcQFGsfEnNng/TmOyeUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uo2tjt6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uo2tjt6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6E1C4CEF7;
	Mon, 23 Mar 2026 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278016;
	bh=V/7lWuIAdHNJejPMsicTHajl78RgYfGyLU1NZvKE9z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uo2tjt6bWdm1fuOcIaetiaCioQTH5P7XRVzawMenFOj106q66MJXTMGHKYcQ4b4Rt
	 FxdQ/JlI93FN0d+59fDmH7gmdeLm5Swd9JIwmyUA9gjIbtEwZQtMaTtBBFkGYE0arx
	 tiSCXsI+/y45xoE/nFRWkQTwyCuuZ82jtUDEVeqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Valerio <pvalerio@redhat.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/567] net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()
Date: Mon, 23 Mar 2026 14:41:33 +0100
Message-ID: <20260323134538.114660723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c843e6531449b..e2d3bda1dc923 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3529,12 +3529,21 @@ static int mtk_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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



