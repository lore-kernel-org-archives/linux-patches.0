Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BF3200112;
	Tue, 26 Aug 2025 11:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208911; cv=none; b=hrR53AWj5gPieJMnyNplPhyU2Wvtvmi5FZtUYeZml7v7ok21WReIh+3u7vFavqWrgocJicCKm7mtv2Ucodrrmcm0zNrNYFu8N4ShXywijKqBatIxzQhly9KwXtWxZNP8+4ksAPiIQALQfPx6IoOWJc0/BzFEbqWqCsDQLFe4CU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208911; c=relaxed/simple;
	bh=k1vYu9v6e1GsV9KZ4HRM5O1kjT/IpN3u6iG6S+fxqbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOw2HlfuosUAyz5E2yKaGCl52urnynODZdsi8LaT3EJuUHYos1x8FU0XQ7SceBxaJeSf6AmWwQHVvVA7r+SIjLUIQWy0A1XQboPmRdDshwgYMOT0Fa1cJgOPUlKQv1UfIdhm5CBJlDrrMQSj5y4PZsM2AZBvX2zLM71C9fv1hVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LEwIlpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LEwIlpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93532C4CEF1;
	Tue, 26 Aug 2025 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208910;
	bh=k1vYu9v6e1GsV9KZ4HRM5O1kjT/IpN3u6iG6S+fxqbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LEwIlpwg1b9Cvl6xGIvCvO+trOZ1npvfCGNq79wmJLl/GbmwnhMOZ7opLWwUeQqJ
	 zcURdJMRfdCc4Yf8a5V1Dn4fwDrioYLyncNxf89nPIe2VtGrO/YAgKooCSkl4YszAN
	 4aVXpV0MXf+QNN0gM5RKGUheqOTVpcDiSOtmSMmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/322] net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path
Date: Tue, 26 Aug 2025 13:11:47 +0200
Message-ID: <20250826110923.116467234@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 62c30c544359aa18b8fb2734166467a07d435c2d ]

Ensure ndo_fill_forward_path() is called with RCU lock held.

Fixes: 2830e314778d ("net: ethernet: mtk-ppe: fix traffic offload with bridged wlan")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Link: https://patch.msgid.link/20250814012559.3705-1-dqfext@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index c855fb799ce1..e9bd32741983 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -101,7 +101,9 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
 		return -1;
 
+	rcu_read_lock();
 	err = dev_fill_forward_path(dev, addr, &stack);
+	rcu_read_unlock();
 	if (err)
 		return err;
 
-- 
2.50.1



