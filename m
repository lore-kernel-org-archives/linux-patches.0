Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B240C6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C161EC433C8;
	Sun, 17 Sep 2023 19:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979860;
	bh=zfZICG2oq/ZB60ihnsb9cWRv+5wFq8oHuhem0VFuE20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwE7d+MZw/NynF2hBOrrkedti5XJcprBeUfoLaL84GJoo1vbXNaPYEQviU5YTKH9Y
	 tr20GVM7pEsDYEHuaxEDKLjld+bqtK71+22wxziN/ADszOnvu8INk/pJdPVeoOw+9f
	 riyuHmEX4mtYM8QU1xhZ7PSrz2+56EYfHC/aiQ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.5 027/285] clk: qcom: turingcc-qcs404: fix missing resume during probe
Date: Sun, 17 Sep 2023 21:10:27 +0200
Message-ID: <20230917191052.593015081@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

commit a9f71a033587c9074059132d34c74eabbe95ef26 upstream.

Drivers that enable runtime PM must make sure that the controller is
runtime resumed before accessing its registers to prevent the power
domain from being disabled.

Fixes: 892df0191b29 ("clk: qcom: Add QCS404 TuringCC")
Cc: stable@vger.kernel.org      # 5.2
Cc: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-9-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/turingcc-qcs404.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/clk/qcom/turingcc-qcs404.c
+++ b/drivers/clk/qcom/turingcc-qcs404.c
@@ -125,11 +125,22 @@ static int turingcc_probe(struct platfor
 		return ret;
 	}
 
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret)
+		return ret;
+
 	ret = qcom_cc_probe(pdev, &turingcc_desc);
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
 
 static const struct dev_pm_ops turingcc_pm_ops = {


