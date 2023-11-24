Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DD439FD4;
	Fri, 24 Nov 2023 18:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8PVdwq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20052C433C8;
	Fri, 24 Nov 2023 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849054;
	bh=xiPZxniWrmx06EaC03adoIq3gltg6/N3K0De35JTdOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8PVdwq63hDtyFcxnY7HKzf4bQnLT+OCTQPYSJkgi1e46VNGLx9UdJ6gNr3efF+mg
	 qSr24Jj/ImanQB4kuufdyaMxNj/7NzcsaGwz/QlmSZeNk+mUqoGoV6c1qHT0nKFukq
	 RKjVbrS2OsHYZGvro1zf43setWqkNH5VzLhdr9lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/530] clocksource/drivers/timer-imx-gpt: Fix potential memory leak
Date: Fri, 24 Nov 2023 17:42:55 +0000
Message-ID: <20231124172028.378791731@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit 8051a993ce222a5158bccc6ac22ace9253dd71cb ]

Fix coverity Issue CID 250382:  Resource leak (RESOURCE_LEAK).
Add kfree when error return.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20231009083922.1942971-1-ping.bai@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-imx-gpt.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/timer-imx-gpt.c b/drivers/clocksource/timer-imx-gpt.c
index 28ab4f1a7c713..6a878d227a13b 100644
--- a/drivers/clocksource/timer-imx-gpt.c
+++ b/drivers/clocksource/timer-imx-gpt.c
@@ -434,12 +434,16 @@ static int __init mxc_timer_init_dt(struct device_node *np,  enum imx_gpt_type t
 		return -ENOMEM;
 
 	imxtm->base = of_iomap(np, 0);
-	if (!imxtm->base)
-		return -ENXIO;
+	if (!imxtm->base) {
+		ret = -ENXIO;
+		goto err_kfree;
+	}
 
 	imxtm->irq = irq_of_parse_and_map(np, 0);
-	if (imxtm->irq <= 0)
-		return -EINVAL;
+	if (imxtm->irq <= 0) {
+		ret = -EINVAL;
+		goto err_kfree;
+	}
 
 	imxtm->clk_ipg = of_clk_get_by_name(np, "ipg");
 
@@ -452,11 +456,15 @@ static int __init mxc_timer_init_dt(struct device_node *np,  enum imx_gpt_type t
 
 	ret = _mxc_timer_init(imxtm);
 	if (ret)
-		return ret;
+		goto err_kfree;
 
 	initialized = 1;
 
 	return 0;
+
+err_kfree:
+	kfree(imxtm);
+	return ret;
 }
 
 static int __init imx1_timer_init_dt(struct device_node *np)
-- 
2.42.0



