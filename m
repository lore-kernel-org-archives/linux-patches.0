Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AF1746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C767EC433C8;
	Sun, 17 Sep 2023 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982963;
	bh=NFQnkpo+DI1vsdvroWqU4dcSWF9d4eSvsZVH6FMn8QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2+leRJSawxxrBdnG2p2CfMnDqO9JKCz2XbjE5QnmH6dRSSQ0Lr2+W0m2+L/+Acj1
	 crvOnPbgBmIgGppQZKExLD8yafn32PJeJ62tcRByF288zCSJIusoUOWdJZtV+Cgf40
	 Xcvfb4nGK8TXis87GWegprU9O32S4SqfI9OLhI5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 403/511] clk: qcom: mss-sc7180: fix missing resume during probe
Date: Sun, 17 Sep 2023 21:13:50 +0200
Message-ID: <20230917191123.521232901@linuxfoundation.org>
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

commit e2349da0fa7ca822cda72f427345b95795358fe7 upstream.

Drivers that enable runtime PM must make sure that the controller is
runtime resumed before accessing its registers to prevent the power
domain from being disabled.

Fixes: 8def929c4097 ("clk: qcom: Add modem clock controller driver for SC7180")
Cc: stable@vger.kernel.org      # 5.7
Cc: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-8-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/mss-sc7180.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/clk/qcom/mss-sc7180.c
+++ b/drivers/clk/qcom/mss-sc7180.c
@@ -87,11 +87,22 @@ static int mss_sc7180_probe(struct platf
 		return ret;
 	}
 
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret)
+		return ret;
+
 	ret = qcom_cc_probe(pdev, &mss_sc7180_desc);
 	if (ret < 0)
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
 
 static const struct dev_pm_ops mss_sc7180_pm_ops = {


