Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345705326C4;
	Thu, 17 Sep 2026 17:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666112; cv=none; b=DF90XxkIFKV0zaLI3HN3BWDgceOqYKkkq5LvTivKSOx0ooAR3tbIGicE7S+PE3wqzxboLDbQkRWD59B9xBX9EiTqS61D9wLZCx5FARFEZsAX7yvBcrbxjfsPv70C/JpWgD3Me/tfpmwqi9AtXBPd8LD1B2hrusdrVLMrrS+M93w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666112; c=relaxed/simple;
	bh=G4XecdAFxXKFKxaE4VD2hYuA5FVzq97uD7n/Jz8XqIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UesMjqITFFFHhLtmEkA9H5by37hvyQ+H4jGQDOXb+n9uDzgoacz+ksFdSzc4/eUKEB4PMRq0VzPejMnCOJpTEMASTpWFaOnbx2cBj6hsad1EGdoMwQdrJVyuhZ/VCfKGDaCw7stFrvWKoe7J8sZDuDqaxxw6n0YzvSR/Yr3nB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18/LFSQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18/LFSQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738BC1F000FF;
	Thu, 17 Sep 2026 17:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666111;
	bh=lYUE1gW6ni+d55quMq2SRGurDolel1Ty3JT/WhrKzkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18/LFSQKz9HeFl/wbTQXN9JB1OlNnPmcT9R8CLbhPwPwCvbTdze/0PzhT2zt2vsor
	 HRqno9TFG0pIUZrRyG6gArDZBi2wuleDJGekGh0mVCsensjFNGUD7OQHT5Rn8frVpp
	 nR5ObfZchdqT2m4l4PYQbncpwczxa9tLtATcajag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0927/1250] net: sun4i-emac: fix missing of_node_put() for phy_node
Date: Thu, 17 Sep 2026 16:12:02 +0100
Message-ID: <20260917151617.136123891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a573c3c61f769..de4a3f1976216 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -1067,6 +1067,7 @@ static int emac_probe(struct platform_device *pdev)
 	return 0;
 
 out_release_sram:
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
@@ -1094,6 +1095,7 @@ static void emac_remove(struct platform_device *pdev)
 	}
 
 	unregister_netdev(ndev);
+	of_node_put(db->phy_node);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
 	irq_dispose_mapping(ndev->irq);
-- 
2.53.0



