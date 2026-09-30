Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4401E51FCD3;
	Wed, 30 Sep 2026 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790317; cv=none; b=J43HISGu8NFUjWAXNHD57FRiYC0FcNtHmKTQm3UlXD05DIFkeqA7R0wBfRNifewSA1s/CGM3euQCdXVonWO9DFWHogXA8AePOFzj0+bKDR7t1NiZL1QLgtyWAc77EiX1rCsN349lCkamCrLJXXffzFD64Y+ZuNnceHTc48B9UpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790317; c=relaxed/simple;
	bh=KIlUpg7QbApdyg90ICwFzW4IICgPoacVxOiJAKuemq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOob9IqG80DIim0YhjxtYZI/w74KyyjIbl8uQhaOmMLFkOblnRm7FYfKfPk/9ZGLJxHyf298pDdNiXYRdKJ49mo27kiTAJtY8bFe7JjwGKa2Z69M04uiVKI1dgMrFMzWslHPQyYGBzDrGlvEy+vi/XWdr6ikZ4lnSNAeB3TVKds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkXrNNX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkXrNNX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCA21F00898;
	Wed, 30 Sep 2026 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790315;
	bh=Cy+QFjDRRsWhhBZCZkpsEwpui7GkSqFiicxYo+istLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkXrNNX0zJcBluBgtjBZCPjj0fyQl2S01/w8SYFE23lltwKke25mKVB/yAiwqS1uy
	 ExV/o+72xjeGEZ3y4A4xNMuvqdQ4qCj8/L9fRg2VpIzqFOPv82/2fwAjEAKFuBHnf6
	 KKXmmvM9kbTsfJXUpmVRVVT4AVJmtkSo2C4QMmSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 741/877] net: macb: initialize PTP state before registering clock
Date: Wed, 30 Sep 2026 17:27:32 +0200
Message-ID: <20260930152430.682268023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e1406330d70e56dd44fa6fbafc86e77e5c80c122 ]

gem_ptp_init() registers the PTP clock before initializing
bp->tsu_clk_lock and the TSU hardware. Since ptp_clock_register()
publishes the PTP character device, userspace may invoke PTP callbacks
before the lock and hardware are ready.

In addition, gem_ptp_init() is called from both the interface open and
resume paths. Reinitializing tsu_clk_lock there can reset the lock while
timestamp processing is using it.

This race is theoretical and has not been observed in practice.

Initialize tsu_clk_lock once during probe and initialize the TSU before
registering the PTP clock.

Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260904030439.3994047-1-runyu.xiao@seu.edu.cn/
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260908103924.607033-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    1 +
 drivers/net/ethernet/cadence/macb_ptp.c  |    5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5227,6 +5227,7 @@ static int macb_probe(struct platform_de
 	}
 	spin_lock_init(&bp->lock);
 	spin_lock_init(&bp->stats_lock);
+	spin_lock_init(&bp->tsu_clk_lock);
 
 	/* setup capabilities */
 	macb_configure_caps(bp, macb_config);
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -341,6 +341,7 @@ void gem_ptp_init(struct net_device *net
 	bp->tsu_rate = bp->ptp_info->get_tsu_rate(bp);
 	bp->ptp_clock_info.max_adj = bp->ptp_info->get_ptp_max_adj();
 	gem_ptp_init_timer(bp);
+	gem_ptp_init_tsu(bp);
 	bp->ptp_clock = ptp_clock_register(&bp->ptp_clock_info, &netdev->dev);
 	if (IS_ERR(bp->ptp_clock)) {
 		pr_err("ptp clock register failed: %ld\n",
@@ -352,10 +353,6 @@ void gem_ptp_init(struct net_device *net
 		return;
 	}
 
-	spin_lock_init(&bp->tsu_clk_lock);
-
-	gem_ptp_init_tsu(bp);
-
 	dev_info(&bp->pdev->dev, "%s ptp clock registered.\n",
 		 GEM_PTP_TIMER_NAME);
 }


