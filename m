Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2392B3FD947;
	Fri, 15 May 2026 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861929; cv=none; b=qpxFuRTYquFmKJBRPNzorb08X7BZY+XChi7w+UODmQk5CXZwf6Wc3nDCo5LzHiME6c5iCj4zb/kWyUcmdhjOEXVTTE4WlVn2HqnzxxH5uMAyO09zckjSZKyc9sCA6/Qc5nEM6FbIcw0qS9NBmBmlUhoRpYnxOLcGipD0TyZi1N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861929; c=relaxed/simple;
	bh=klHMJwOiid6qfYOGFlhtit9NLzWxTjzHGvSrylyeTSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjV4N5SJQWjpHSvHvDb8bymPdW92dM+O7tUpIfIRv51H04NOcfYS6j+XqiezuCoBAn370gLh8RiEPIoKeS5d0OI+X3vtr2+CqlUc1zMaiKtpS8ZmM+gEJvAgN8im6dro80NqRpCEyFTW29IPSm/HXeNRx9RM++1KwOGbq4djKzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTRuSBC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTRuSBC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD586C2BCB0;
	Fri, 15 May 2026 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861929;
	bh=klHMJwOiid6qfYOGFlhtit9NLzWxTjzHGvSrylyeTSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTRuSBC9MRjCcNBDsZVk5Bvtdz0ViehjsEGsvFJSTNrCbiXLr+tHPb53lX71im6tf
	 Ay+cY6Jrdhp00JT7hWuH6vis9K6Hy4nshcnBmKPAeOFJtuBo8C6qx2i5azo5bcrebT
	 tLe+rb2Ajpv4fYUa+iQzfdKP72zBVWanNedIL7vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Luo <sunny.luo@amlogic.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 042/188] spi: amlogic-spisg: fix controller deregistration
Date: Fri, 15 May 2026 17:47:39 +0200
Message-ID: <20260515154658.227350960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -801,7 +801,7 @@ static int aml_spisg_probe(struct platfo
 		goto out_clk;
 	}
 
-	ret = devm_spi_register_controller(dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi controller registration failed\n");
 		goto out_clk;
@@ -824,6 +824,8 @@ static void aml_spisg_remove(struct plat
 {
 	struct spisg_device *spisg = platform_get_drvdata(pdev);
 
+	spi_unregister_controller(spisg->controller);
+
 	if (!pm_runtime_suspended(&pdev->dev)) {
 		pinctrl_pm_select_sleep_state(&spisg->pdev->dev);
 		clk_disable_unprepare(spisg->core);


