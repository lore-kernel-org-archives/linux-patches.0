Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3B3B19DE;
	Fri, 15 May 2026 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862459; cv=none; b=ftPpdqmPGA0TdNNh+g3fQX2gPGVjWeozQ6Z+vEyLdbaXeRxH/ECcGVqQtGQeycrptrlnUshhD57R/V3jGrYoYqcKp00KOEfz0jJkcEpU2HenDEz7WUFfv1babt84v1CeqaaGF5o+6mrztr1MZ4lT2Vh3XEmS+GZL08tReMaVoAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862459; c=relaxed/simple;
	bh=ydAhWQjEy33gMyQjBh5w4nuQHEo7DUch1XkHe6pwC6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxNh27p7SjtaOWEF/5Rfy3AfcnE3j6qPdoXedsEJX4BV+4jO3xHISxsXL3TMglFNcUW6CEgJwI3bPCEkOVyp4jyWs2c17yoL625kOYMqli82X5lL0Z+++pRpMD0POe/XbYiV84LlbZfRxvpDWyj1/sc8QlDYQDhX9lU0SJTNuv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBX8KWeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBX8KWeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B46C2BCB0;
	Fri, 15 May 2026 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862458;
	bh=ydAhWQjEy33gMyQjBh5w4nuQHEo7DUch1XkHe6pwC6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBX8KWeYKl62ag8ZVgA7wCcfyZEfgvUa7y350KVDIiYEXFNmFK1VVhpt9CNCDbu/Y
	 aD8Ln+RFjXgmo8mOv1b4Qgom/af7wn70Q/sJWBNp72qNpoaQVCsIK7ui+q41LfyhNm
	 TEi0/P2c2kHa+qg9B3iX3lhOBsnq+8wRpdcZ1eHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Luo <sunny.luo@amlogic.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 057/201] spi: amlogic-spisg: fix controller deregistration
Date: Fri, 15 May 2026 17:47:55 +0200
Message-ID: <20260515154659.769593021@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 84d31bb1f6256eea0db6cf64a3c7a53145f92bb9 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: cef9991e04ae ("spi: Add Amlogic SPISG driver")
Cc: stable@vger.kernel.org	# 6.17: b8db95529979
Cc: stable@vger.kernel.org	# 6.17
Cc: Sunny Luo <sunny.luo@amlogic.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-amlogic-spisg.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -800,7 +800,7 @@ static int aml_spisg_probe(struct platfo
 		goto out_clk;
 	}
 
-	ret = devm_spi_register_controller(dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi controller registration failed\n");
 		goto out_clk;
@@ -823,6 +823,8 @@ static void aml_spisg_remove(struct plat
 {
 	struct spisg_device *spisg = platform_get_drvdata(pdev);
 
+	spi_unregister_controller(spisg->controller);
+
 	if (!pm_runtime_suspended(&pdev->dev)) {
 		pinctrl_pm_select_sleep_state(&spisg->pdev->dev);
 		clk_disable_unprepare(spisg->core);


