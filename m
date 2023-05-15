Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D7FFC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9549C4339B;
	Mon, 15 May 2023 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172201;
	bh=K8shd9osToc3L45Gnffq0Ke+e+wzP7LdhZz9RhTehAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9/5pyJaUStQ6zU1uQWiVYJWOzpemQD2hdIvHk7GwgrEn5yl8MzR/9G00ZJynLhIK
	 atpdZwWc/JZ4AN04Z47pcCLWzPajY7w1IrVIqCzP44bCcOkQCXhOWMgn/SPAuCPcJA
	 uFJGz0KGrTxo/vtSnmWhgd+mPHqfidlq2Mpd2HH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/381] soc: ti: pm33xx: Fix refcount leak in am33xx_pm_probe
Date: Mon, 15 May 2023 18:25:28 +0200
Message-Id: <20230515161740.297243405@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8f3c307b580a4a6425896007325bddefc36e8d91 ]

wkup_m3_ipc_get() takes refcount, which should be freed by
wkup_m3_ipc_put(). Add missing refcount release in the error paths.

Fixes: 5a99ae0092fe ("soc: ti: pm33xx: AM437X: Add rtc_only with ddr in self-refresh support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20230106054022.947529-1-linmq006@gmail.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pm33xx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/pm33xx.c b/drivers/soc/ti/pm33xx.c
index 332588de22f3f..44ec0048911cd 100644
--- a/drivers/soc/ti/pm33xx.c
+++ b/drivers/soc/ti/pm33xx.c
@@ -529,7 +529,7 @@ static int am33xx_pm_probe(struct platform_device *pdev)
 
 	ret = am33xx_pm_alloc_sram();
 	if (ret)
-		return ret;
+		goto err_wkup_m3_ipc_put;
 
 	ret = am33xx_pm_rtc_setup();
 	if (ret)
@@ -576,13 +576,14 @@ static int am33xx_pm_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(dev);
 err_pm_runtime_disable:
 	pm_runtime_disable(dev);
-	wkup_m3_ipc_put(m3_ipc);
 err_unsetup_rtc:
 	iounmap(rtc_base_virt);
 	clk_put(rtc_fck);
 err_free_sram:
 	am33xx_pm_free_sram();
 	pm33xx_dev = NULL;
+err_wkup_m3_ipc_put:
+	wkup_m3_ipc_put(m3_ipc);
 	return ret;
 }
 
-- 
2.39.2



