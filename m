Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1A7353A71;
	Wed, 30 Sep 2026 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783100; cv=none; b=YzN39+GT9XXVW8Bqr4wfnTEdrQatjKg+K2E+71zRAXoCS7o7hS/WDIBihRGT8k+p66kPbLTjS1vKsa4memr7dQx1S7ypramMidXx2MFawnI5pvxu7syEm3TYmLslaXrbgPYi5Tt5McXJGOJMBdiT66m+0eRXDDSRE+vmcjVkse0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783100; c=relaxed/simple;
	bh=CdnwvTM0d5vwZ9XhrDL+ntxyoV9VVS5FpohJ1N6AAI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq9JhJdilllRJfDDXXLESdsQxjWy9KwhAsmPWO6nwc4LGU1G3Od+tNXW9cZMMdU+NJz6KJuO+S5kEqf0iRPuZJLY25czbju1LLZ6wqgfQ3+AW7ldidHNfw8X8tNK9ZZjk6h4zFi5jdUc/pnqBUIZ3x1PU5eZ0HpUdTv9HApcO7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrjz7CvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrjz7CvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F191F00898;
	Wed, 30 Sep 2026 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783091;
	bh=w18Qq5pp4ibnFMRnSL6tx28gpZs0t6F7apGSUGyImwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrjz7CvYPntfBGa+DNwmdv8I5446FqQkcljnpE02/BWzgRPnDCAGn4dbljHBDkvih
	 v2jpeV1vm4HNWqRIGBQ8ZM707QlwI3EdqdzIOmXPKkw7VruiRLnkw2pKO8kCZzqMut
	 v33DjB+cfUwjB+B5PLwAufMnsgjel6CiBo/sjCIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/595] net: sun4i-emac: fix missing of_node_put() for phy_node
Date: Wed, 30 Sep 2026 17:22:50 +0200
Message-ID: <20260930152353.665136362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Youhong <liyouhong@kylinos.cn>

[ Upstream commit af406abfecad2f48d8f1fc646d3994f0982bac62 ]

of_parse_phandle() returns a node pointer with an elevated refcount.
Add the missing of_node_put() on the probe error path after
register_netdev() fails and in emac_remove().

Fixes: 492205050d77 ("net: Add EMAC ethernet driver found on Allwinner A10 SoC's")
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260904080758.2432748-1-dayou5941@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 8ce1fb0a8d554..f52ea6f7b65da 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -890,6 +890,7 @@ static int emac_probe(struct platform_device *pdev)
 	return 0;
 
 out_release_sram:
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
@@ -911,6 +912,7 @@ static int emac_remove(struct platform_device *pdev)
 	struct emac_board_info *db = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
 	irq_dispose_mapping(ndev->irq);
-- 
2.53.0



