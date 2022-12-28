Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E641C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564B8C433F0;
	Wed, 28 Dec 2022 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245055;
	bh=j0yrMKeJO2r/tfnUtHUOregZlgkJhmlss1ORUpzt048=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzXT+XxnStBnaevcTnG0apJ3xTuTEdvxq3zBE1Ij1P86M6RO7fX15UemdKEy8l2HJ
	 khdUg5DaWA18UC7rTeQtVBtg2HhSpA3oTf0AHPaiqvQoDu6BvYuE0DUz391sFkGla7
	 cGiIgdNTyMgf42lOJz6CFhscY2ytBYRym4f2S4iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0825/1073] remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcss_qcs404_power_on()
Date: Wed, 28 Dec 2022 15:40:13 +0100
Message-Id: <20221228144350.423195240@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 7ff5d60f18bba5cbaf17b2926aa9da44d5beca01 ]

q6v5_wcss_qcs404_power_on() have no fail path for readl_poll_timeout().
Add fail path for readl_poll_timeout().

Fixes: 0af65b9b915e ("remoteproc: qcom: wcss: Add non pas wcss Q6 support for QCS404")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221204082757.18850-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_wcss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_wcss.c b/drivers/remoteproc/qcom_q6v5_wcss.c
index de232337e082..ba24d745b2d6 100644
--- a/drivers/remoteproc/qcom_q6v5_wcss.c
+++ b/drivers/remoteproc/qcom_q6v5_wcss.c
@@ -351,7 +351,7 @@ static int q6v5_wcss_qcs404_power_on(struct q6v5_wcss *wcss)
 	if (ret) {
 		dev_err(wcss->dev,
 			"xo cbcr enabling timed out (rc:%d)\n", ret);
-		return ret;
+		goto disable_xo_cbcr_clk;
 	}
 
 	writel(0, wcss->reg_base + Q6SS_CGC_OVERRIDE);
@@ -417,6 +417,7 @@ static int q6v5_wcss_qcs404_power_on(struct q6v5_wcss *wcss)
 	val = readl(wcss->reg_base + Q6SS_SLEEP_CBCR);
 	val &= ~Q6SS_CLK_ENABLE;
 	writel(val, wcss->reg_base + Q6SS_SLEEP_CBCR);
+disable_xo_cbcr_clk:
 	val = readl(wcss->reg_base + Q6SS_XO_CBCR);
 	val &= ~Q6SS_CLK_ENABLE;
 	writel(val, wcss->reg_base + Q6SS_XO_CBCR);
-- 
2.35.1



