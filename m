Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B9D25A323;
	Tue, 27 May 2025 17:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365468; cv=none; b=qLdb10+3za/DQX4qi2GJ1O2n6tLsfvvCov8o16BGuzsfIhIKNge07VUnVpmoXC5i1Pke09+nCjjzKsCxtAS3Ec/f0Ab0HgoXvlUBnXxmTLQpKsuUZDkjNETt8z9/NwRakWlCz+c5zrgByEdPd56Yub/lVeFUgyNRTBY7sJcrVJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365468; c=relaxed/simple;
	bh=dKosc52lM0bxJ4UODjH9Xqi7uSqd/avXFzlYsipKJKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBls5ghr+59rvygdiwgRA78Oh7jVoX9NG6TgtBPan3AV6yZMl+ktDFvlKbbYlp7P+DcPJLxeA86MYfUgdQz0SZhUMgG+50QzABDoeuBPsscodXF1RYTc88rSMtwghIghI9xVl0n3QvQ7LekTWnmqM2wt5LQpVpEp0B2bbJebgaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYpPvBUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYpPvBUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DD4C4CEE9;
	Tue, 27 May 2025 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365468;
	bh=dKosc52lM0bxJ4UODjH9Xqi7uSqd/avXFzlYsipKJKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYpPvBUJNe7Kb4nJUJZmjLJL6evzSgDboBtD8JkGbyD1MgQ2b2ytQn87pFN5FVIFV
	 lvpNBYxkvEUJH0xTvYbCsXNyQC2giOtZNsMJ1sWAFOiS+QujbTtzZ6ZZb9uJJeiyIr
	 nRg0KsVwuDHi/+tmJtu0DJkWh35NIJ/UtaTS37/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <si.yanteng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Chong Qiao <qiaochong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 386/626] net: stmmac: dwmac-loongson: Set correct {tx,rx}_fifo_size
Date: Tue, 27 May 2025 18:24:39 +0200
Message-ID: <20250527162500.701489082@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 8dbf0c7556454b52af91bae305ca71500c31495c ]

Now for dwmac-loongson {tx,rx}_fifo_size are uninitialised, which means
zero. This means dwmac-loongson doesn't support changing MTU because in
stmmac_change_mtu() it requires the fifo size be no less than MTU. Thus,
set the correct tx_fifo_size and rx_fifo_size for it (16KB multiplied by
queue counts).

Here {tx,rx}_fifo_size is initialised with the initial value (also the
maximum value) of {tx,rx}_queues_to_use. So it will keep as 16KB if we
don't change the queue count, and will be larger than 16KB if we change
(decrease) the queue count. However stmmac_change_mtu() still work well
with current logic (MTU cannot be larger than 16KB for stmmac).

Note: the Fixes tag picked here is the oldest commit and key commit of
the dwmac-loongson series "stmmac: Add Loongson platform support".

Acked-by: Yanteng Si <si.yanteng@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20250210134328.2755328-1-chenhuacai@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index ab7c2750c1042..702ea5a00b56d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -590,6 +590,9 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (ret)
 		goto err_disable_device;
 
+	plat->tx_fifo_size = SZ_16K * plat->tx_queues_to_use;
+	plat->rx_fifo_size = SZ_16K * plat->rx_queues_to_use;
+
 	if (dev_of_node(&pdev->dev))
 		ret = loongson_dwmac_dt_config(pdev, plat, &res);
 	else
-- 
2.39.5



