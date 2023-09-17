Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8050746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C492C433C8;
	Sun, 17 Sep 2023 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982959;
	bh=zJJc7Z4X4cr0S0sB+e/L2f3x5JeBd6JGMhl/mun95aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8hZp0p+f/wUjKqnWOJBruksCuhTTbYAvrdnSnCxdE4TW0FpLzVODgU5i3V7wNCpH
	 v94QqU+1+fcBMA8uQqGamY4FNbrZMWkRRjthtM6AgmTGcufFJoUTi4F8iyp1vITU5x
	 OBOEeX4iFLfCy6XAkyktcxvacCVvi4RVnFrB7dRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 402/511] clk: qcom: q6sstop-qcs404: fix missing resume during probe
Date: Sun, 17 Sep 2023 21:13:49 +0200
Message-ID: <20230917191123.496821414@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 97112c83f4671a4a722f99a53be4e91fac4091bc upstream.

Drivers that enable runtime PM must make sure that the controller is
runtime resumed before accessing its registers to prevent the power
domain from being disabled.

Fixes: 6cdef2738db0 ("clk: qcom: Add Q6SSTOP clock controller for QCS404")
Cc: stable@vger.kernel.org      # 5.5
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-7-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/q6sstop-qcs404.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/q6sstop-qcs404.c
+++ b/drivers/clk/qcom/q6sstop-qcs404.c
@@ -173,21 +173,32 @@ static int q6sstopcc_qcs404_probe(struct
 		return ret;
 	}
 
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret)
+		return ret;
+
 	q6sstop_regmap_config.name = "q6sstop_tcsr";
 	desc = &tcsr_qcs404_desc;
 
 	ret = qcom_cc_probe_by_index(pdev, 1, desc);
 	if (ret)
-		return ret;
+		goto err_put_rpm;
 
 	q6sstop_regmap_config.name = "q6sstop_cc";
 	desc = &q6sstop_qcs404_desc;
 
 	ret = qcom_cc_probe_by_index(pdev, 0, desc);
 	if (ret)
-		return ret;
+		goto err_put_rpm;
+
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
+
+err_put_rpm:
+	pm_runtime_put_sync(&pdev->dev);
+
+	return ret;
 }
 
 static const struct dev_pm_ops q6sstopcc_pm_ops = {


