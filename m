Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F39C6AC2;
	Tue,  5 Dec 2023 03:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxfshfdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F0FC433C8;
	Tue,  5 Dec 2023 03:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747781;
	bh=Dqo1q/FMCq58QvnMgSy7cHIbqe0E3CARPB9f1kslVoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxfshfdY8IYTvsgoIC4432HXxCj8tD6C9LttEwKdI2VrjGHuMbXEh32wUzaH8f5HG
	 WKX2+odMbyBzGXm2hvKKILnp8SHwOckDxiUtXW0G6tpCRd3fJjdG+4zpdLHIn8fEzY
	 XM26og4G18iQd8AgDoBr5gTE4pqWMaIsmTnRGzEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/67] net: ravb: Check return value of reset_control_deassert()
Date: Tue,  5 Dec 2023 12:17:26 +0900
Message-ID: <20231205031522.218867536@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit d8eb6ea4b302e7ff78535c205510e359ac10a0bd ]

reset_control_deassert() could return an error. Some devices cannot work
if reset signal de-assert operation fails. To avoid this check the return
code of reset_control_deassert() in ravb_probe() and take proper action.

Along with it, the free_netdev() call from the error path was moved after
reset_control_assert() on its own label (out_free_netdev) to free
netdev in case reset_control_deassert() fails.

Fixes: 0d13a1a464a0 ("ravb: Add reset support")
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b180e2225227c..709c770b391c5 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2188,7 +2188,10 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->features = info->net_features;
 	ndev->hw_features = info->net_hw_features;
 
-	reset_control_deassert(rstc);
+	error = reset_control_deassert(rstc);
+	if (error)
+		goto out_free_netdev;
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
@@ -2373,11 +2376,11 @@ static int ravb_probe(struct platform_device *pdev)
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
 out_release:
-	free_netdev(ndev);
-
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(rstc);
+out_free_netdev:
+	free_netdev(ndev);
 	return error;
 }
 
-- 
2.42.0



