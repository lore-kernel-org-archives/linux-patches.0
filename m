Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF6D3AEF2D;
	Thu, 17 Sep 2026 18:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670830; cv=none; b=IMe/0Boz9wVjnXIY5hfnkDufhQGJnK4OyugfpN2MUMb5g9W6UP/aArkKj136jYb4O4DtkNtIgNH93eYGYa/YA6PaeLZoLzdBM91VnsCpkEoK1lllxg5NUnlwwXs9udVKHYrNvE1a44J5qaitotGnFVn1V+L1y3aHZjlwIEl4RS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670830; c=relaxed/simple;
	bh=uiGcWRFgBbPeszVGevnalnlyk4t9f/MzV6BpnvxmkWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0AdqFeQ1B8DEiZRvTKD2wF57hA6joNVi3Jv9o/qeVpXMOK6SVJiHHCUZZdgiMxI0Qrj/e4SR3fIWWtS++4v71S0/PojnfzjORb0HO8Bkymac0IFFgJYxTaEGjS45gY1xNroSd8J0otTDgNf9WTkAmJySzANf2YywT4WYPmQ+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orFNGyZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orFNGyZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F49A1F000FF;
	Thu, 17 Sep 2026 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670828;
	bh=x2Gs05fwjZgjEBfgsFkht4hpi36PP3zeM+Vn8nQvX80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orFNGyZqlIzR7qrVf2WlsuOzDv5HSbici9kKkK00vBEnZvYH596ZrhI+ouUCxshr9
	 6+BYgQjhkNC0wf9skA7pbs2qBuq1fCOoY5WIseHFLW0scdrPwuEydyIxL0Jm/J/N96
	 3mrFE7z/2F1WFST9qUHbBbRjHrNdEjyOtsLVS/nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0783/1102] net: sun4i-emac: fix missing of_node_put() for phy_node
Date: Thu, 17 Sep 2026 16:12:06 +0100
Message-ID: <20260917151600.120756132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e351ba1de844c..e080b1ee344e1 100644
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



