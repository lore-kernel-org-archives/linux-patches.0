Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE9F6FB1;
	Tue,  5 Dec 2023 03:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNk6MKNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B8EC433C8;
	Tue,  5 Dec 2023 03:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747505;
	bh=xS80tae4Mg12m0PDB2cKc32qoYWlH5vek1zsBIlvS2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNk6MKNU0LY24+noKe0DvhvFyti1odmc+3RH8KkI6ScQnKogzDBRYxYuuu4BKMUkk
	 AB5Nut0G0x+FMT6+JZX0YZXegat6TUSeXCREk9zlggg/GVSmdek3XnO3CJ/1siy0yO
	 P0cqPUVwR76O4vj3IAfei+TbPQvLArC716GWmw1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/135] net: ravb: Use pm_runtime_resume_and_get()
Date: Tue,  5 Dec 2023 12:17:02 +0900
Message-ID: <20231205031537.070309696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9d4a35f006c68..a9cd390dedbd8 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2072,7 +2072,9 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->hw_features = NETIF_F_RXCSUM;
 
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	error = pm_runtime_resume_and_get(&pdev->dev);
+	if (error < 0)
+		goto out_rpm_disable;
 
 	/* The Ether-specific entries in the device structure. */
 	ndev->base_addr = res->start;
@@ -2247,6 +2249,7 @@ static int ravb_probe(struct platform_device *pdev)
 	free_netdev(ndev);
 
 	pm_runtime_put(&pdev->dev);
+out_rpm_disable:
 	pm_runtime_disable(&pdev->dev);
 	return error;
 }
-- 
2.42.0



