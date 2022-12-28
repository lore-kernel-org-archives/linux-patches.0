Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0611863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DFCC433D2;
	Wed, 28 Dec 2022 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242175;
	bh=vhdYd04zJAa+hJ/s4tO4/r2IJOf29sXY983cBiErQC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIfLsNNztOPveJfbFp6Xlzok+dpCelZh4jOfGwgo/3ykc28nuik6DsOb0VXVEpEvE
	 swXjMtnM/WLC90Zrvjx9OFGLZ9DRg6U/YTn8HrOSBJb/xxkay+xWHawSSHy7Evybb6
	 mL1iU6eG+eweqbGfd2D+vu904tBli04RekGYNoQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 571/731] remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcss_qcs404_power_on()
Date: Wed, 28 Dec 2022 15:41:18 +0100
Message-Id: <20221228144313.107935004@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 9e67e323a55a..cfd34ffcbb12 100644
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



