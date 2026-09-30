Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE684F7CDE;
	Wed, 30 Sep 2026 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785371; cv=none; b=WVzaeFr22cXH01Sd7hqlOekqqGyXZWQTpu5LZbLFLXA00OHIrog2L1M+pqfYBrFcoluRZuC1I6f3RtGMxdhkgJbZD1L9SlBhxlBhiaL3LOE6e8/kt+piIQX3JDIz3JUluALnrkhqi745l52QXpOi/Cs2RxDAmRQHD6U2wgqdpZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785371; c=relaxed/simple;
	bh=5opB1qdawsdOLBoWPn6SoN/5zR6yeQVx3AT7CX/VSow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdcKCuVN5pzlodsUj27sL1lhxXk3gqB3NPDOVK0mAJ9yHeQGRwXxy6xaLkqvSnDTTMRqbI+FKCXynKqetNK7zxnSl5O528/nmgAufePaORpSqfrkYV5j4hfvKdVoDozDB+NZe3mqKOiWBGO16Z3VZtzKMveGVo9u7Tx0Fp/FBdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvpNjgot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvpNjgot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F471F00893;
	Wed, 30 Sep 2026 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785367;
	bh=+bXmZJQhEb/x0HuBemQL5p07Q+WBmdPBZqErppiFDh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvpNjgottqrTFDiBlHEdRYGtMF052sAWtFf6AQaTZ3HmtwOgsaWATihqVsRFBVRnf
	 aDLuntZKVukxTFF2XY5KadWXty9Jx/QhEsycurknp12v7Xh8bukMxiOXNvjsfOJ82f
	 gE/ZtEaGsS3zUnTnfvMvIO6zI7qusq3usDib2whM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 483/982] net: sun4i-emac: fix missing of_node_put() for phy_node
Date: Wed, 30 Sep 2026 17:20:19 +0200
Message-ID: <20260930152427.154347489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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



