Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91FB33A6F1;
	Wed, 30 Sep 2026 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795515; cv=none; b=ghbZgTafxviATsJt0jkNW0hZeUeqij7Jal1dNqb5ZerQvAg/eJ0SLKFToFftUdW44JMtpQSw304mmWfNQ5TvXR7PSO8nx+YdoeI7WvBGVXSCfbHQ7SxVwVKJRjHnLyqmj7TX2vdh3vDNPf7ZJ7RU0Wwornkk2UT2K1XZnJB819I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795515; c=relaxed/simple;
	bh=0afdZctfgPB+hTU+idSGbyOybjYtdHlfoZH9iE4ptd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7aHT4pNriuzExit06w26cq1v4qp4opAfo+PjxCmx0Of6b1+4cIs8nw8kAzHWCCXl/ARQ/ziXA2F2zoRbJZi24C06bxa5fIKXnbdeQcXvpF/LJIxLQfze7sassNoYT2dDm+3Re7wYllVimHVQ2dsTpmrS2xR75GR5nSy4oFYPf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui+oABhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui+oABhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9E51F00898;
	Wed, 30 Sep 2026 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795514;
	bh=hI0Mq4iqtWI+6uxY0ztOxLgJjl67YaR/B8N7cjrdX50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui+oABhc2QG/Za3+3DpA66q6xdzDe0ihOWsZ/h4rv9TQ+ynQvsIf6CFFfbrpXYnaF
	 6Yzqe7JsGRkT1V1Cw3aXek/fCNwwOCzWx1zINCTM6k5TPCoir8BOdp+uFMasJiZRSs
	 7j2NpfryYro/VXEsiME3T5oGIpVixj5B/zNEKq5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0588/1193] net: sun4i-emac: fix missing of_node_put() for phy_node
Date: Wed, 30 Sep 2026 17:21:12 +0200
Message-ID: <20260930152447.309292761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 9a6948cde2403..789a5008fe61e 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -1067,6 +1067,7 @@ static int emac_probe(struct platform_device *pdev)
 	return 0;
 
 out_release_sram:
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
@@ -1094,6 +1095,7 @@ static int emac_remove(struct platform_device *pdev)
 	}
 
 	unregister_netdev(ndev);
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
 	irq_dispose_mapping(ndev->irq);
-- 
2.53.0



