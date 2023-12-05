Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989256AC2;
	Tue,  5 Dec 2023 03:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1VYflhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE5EC433C7;
	Tue,  5 Dec 2023 03:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747784;
	bh=OIXocjn73WcYsbYoRsp/O3G/f+wx4P9Aqv84ON+hfyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1VYflhuTuisgGFY1vw2hvtnu10CXERGWidzH1WltixZx0XG0zDEgH+V5Iwvekbj9
	 l1r4C2FXl1rF6aDwJptpD3CdHF1dygXFhDoD/7a9OGct/KU0KZWBSH4N3i9FtF5A0g
	 A9yEj/9TS6Y6uF/5pIfed/UicZrczX/sACcaUWVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/67] net: ravb: Use pm_runtime_resume_and_get()
Date: Tue,  5 Dec 2023 12:17:27 +0900
Message-ID: <20231205031522.266826099@linuxfoundation.org>
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

[ Upstream commit 88b74831faaee455c2af380382d979fc38e79270 ]

pm_runtime_get_sync() may return an error. In case it returns with an error
dev->power.usage_count needs to be decremented. pm_runtime_resume_and_get()
takes care of this. Thus use it.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 709c770b391c5..a556faa47f036 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2193,7 +2193,9 @@ static int ravb_probe(struct platform_device *pdev)
 		goto out_free_netdev;
 
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	error = pm_runtime_resume_and_get(&pdev->dev);
+	if (error < 0)
+		goto out_rpm_disable;
 
 	if (info->multi_irqs)
 		irq = platform_get_irq_byname(pdev, "ch22");
@@ -2377,6 +2379,7 @@ static int ravb_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->refclk);
 out_release:
 	pm_runtime_put(&pdev->dev);
+out_rpm_disable:
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(rstc);
 out_free_netdev:
-- 
2.42.0



