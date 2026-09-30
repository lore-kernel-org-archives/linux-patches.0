Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8250C28B;
	Wed, 30 Sep 2026 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791586; cv=none; b=bFNdW5fLx3S3OcUPlU2KmZZ25Q4IZp789MJRHOdQCy9HTQAxTNVZGWlJULYse3ANrSbSr57MyHBlFGVb9fuY/H8qpUbh0a2d4U2jutbNRpBlAVEABqAYc3+vm+1E9X3Rf08VWNt5swf8s0DS+qjTzEYFc06QNZlyNO1mAAGomhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791586; c=relaxed/simple;
	bh=aYp+umSNLjuv+U43E9+9ETGyPsfj97SNvj3t3Xf9wvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epVkSDY+36QtfsPts0lJ7Evsmk6L6y/0vBUz5zuFpyF05HRVki7v2O06/M7KfR3pHSkVMj3K58qsqzzBUEdVy45289WoyNWScn88csQy8ZNbillRgJcbG8ktkQVsVEGf5aOTKTxZ7RaM50IPUcb1nlKgVf5JcxDxcKoBX6l/1+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMUIsq49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMUIsq49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5BF1F000FF;
	Wed, 30 Sep 2026 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791585;
	bh=do8M/3Dcu4rLfVqnbuVCnWkqZZAJSW5G5OEjITsnsA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMUIsq49CGOp3OqX6QoMRToe4Gp13j+l4DI7FKSXqfvEkBgFFjw+6i5inKBLnyj6z
	 2IcxK8fdGfYqchDKviHsDLGYJgc+g+7q2cXLqRLEGIqDVgOC/hK57mIGQxr05UqjdJ
	 9iVgljTCagU5c7QLF8CtUL4jlsl1UHgVWezzQJTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/752] net: sun4i-emac: fix missing of_node_put() for phy_node
Date: Wed, 30 Sep 2026 17:23:43 +0200
Message-ID: <20260930152405.923901160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ad15eb57d54a0..c7a05423e96a3 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -886,6 +886,7 @@ static int emac_probe(struct platform_device *pdev)
 	return 0;
 
 out_release_sram:
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
@@ -907,6 +908,7 @@ static int emac_remove(struct platform_device *pdev)
 	struct emac_board_info *db = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
 	irq_dispose_mapping(ndev->irq);
-- 
2.53.0



