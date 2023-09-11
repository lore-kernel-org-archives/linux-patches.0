Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86791170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AB1C433C7;
	Mon, 11 Sep 2023 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441357;
	bh=EAt7e+up0DX7Djs1TryMLYgKJzmlfeQCdgtYXU09g10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S64+dlQWF2STwMDnVqelE3P1iMmT5pChFwJsO8p1Pp8vEQveU5JzED1JiLufU6kvG
	 6xkytRj8tMK+IT/XSJzIHFD+MwQtz9rZ6QcxFPzUfTEesAoQoQkM85jFUAJdLi6jII
	 oU7TliUXbeOtreh6YtyZkioLJ3g+B6M3SRnfqAfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 385/739] clk: qcom: gcc-sc8280xp: fix runtime PM imbalance on probe errors
Date: Mon, 11 Sep 2023 15:43:04 +0200
Message-ID: <20230911134701.946550193@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 10192ab375c39c58d39cba028d9685cefe1ca3c2 ]

Make sure to decrement the runtime PM usage count before returning in
case RCG dynamic frequency switch initialisation fails.

Fixes: 2a541abd9837 ("clk: qcom: gcc-sc8280xp: Add runtime PM")
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8280xp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
index 3e1a62fa3a074..4d1133406ae05 100644
--- a/drivers/clk/qcom/gcc-sc8280xp.c
+++ b/drivers/clk/qcom/gcc-sc8280xp.c
@@ -7539,8 +7539,8 @@ static int gcc_sc8280xp_probe(struct platform_device *pdev)
 
 	regmap = qcom_cc_map(pdev, &gcc_sc8280xp_desc);
 	if (IS_ERR(regmap)) {
-		pm_runtime_put(&pdev->dev);
-		return PTR_ERR(regmap);
+		ret = PTR_ERR(regmap);
+		goto err_put_rpm;
 	}
 
 	/*
@@ -7561,11 +7561,19 @@ static int gcc_sc8280xp_probe(struct platform_device *pdev)
 
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks, ARRAY_SIZE(gcc_dfs_clocks));
 	if (ret)
-		return ret;
+		goto err_put_rpm;
 
 	ret = qcom_cc_really_probe(pdev, &gcc_sc8280xp_desc, regmap);
+	if (ret)
+		goto err_put_rpm;
+
 	pm_runtime_put(&pdev->dev);
 
+	return 0;
+
+err_put_rpm:
+	pm_runtime_put_sync(&pdev->dev);
+
 	return ret;
 }
 
-- 
2.40.1



