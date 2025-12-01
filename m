Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE67E8635C;
	Mon,  1 Dec 2025 11:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588724; cv=none; b=rK8bBv2f+KyvUodN8+ne18glo1RWM8VOpuMEoh9vn192e9z3t92A2E75xx0XWC4QlZiFXlg3ESb61M8r2szc1HiQb2e659GqcttRuwnkY9fPRrzVVUKUpS5WOR37obRvZySx8eWJJHHYwf+c0vEJQhv8qSfx1GagtncPrQmlTl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588724; c=relaxed/simple;
	bh=3C3oBXTQEvwfG8FxeGtBHrIq669dupPdH9OWuaemxtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fxyn2DLXSGfH5QlV6THshhKvy9RUk0EkvmFoUcCwj2Ipyzu7KVD1nM/pOkxYjruwPXpO4WD43aaBRfnoWWGLiNbgOve4w/4A6WyJE/FsedePElNcntMMV48uyGzqzikKDNLGMQaVGfm3KwE5xIKhIV4EyZW44EyBFp/ma3qcH+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMtY/DQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMtY/DQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C747C4CEF1;
	Mon,  1 Dec 2025 11:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588723;
	bh=3C3oBXTQEvwfG8FxeGtBHrIq669dupPdH9OWuaemxtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMtY/DQe53w+7t08RfJddxOKINDx3ZT4hYf+vT0poog74Hbcu3G8BRGzVCEygmBqC
	 fWFEyJBRodEDsG1HWwYrxew8ryVnLYokpaDteDVrSXF+p0ZzlqlRafHn4sECkHkkaQ
	 WhEFB2XtZWbZF0l/daX8g1DsMzXhh3BLh0paUJRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/187] regulator: fixed: fix GPIO descriptor leak on register failure
Date: Mon,  1 Dec 2025 12:24:15 +0100
Message-ID: <20251201112246.529627721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13 ]

In the commit referenced by the Fixes tag,
devm_gpiod_get_optional() was replaced by manual
GPIO management, relying on the regulator core to release the
GPIO descriptor. However, this approach does not account for the
error path: when regulator registration fails, the core never
takes over the GPIO, resulting in a resource leak.

Add gpiod_put() before returning on regulator registration failure.

Fixes: 5e6f3ae5c13b ("regulator: fixed: Let core handle GPIO descriptor")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251028172828.625-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 529f401243245..2bb4924fc3026 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -247,6 +247,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
 				    "Failed to register regulator: %ld\n",
 				    PTR_ERR(drvdata->dev));
+		gpiod_put(cfg.ena_gpiod);
 		return ret;
 	}
 
-- 
2.51.0



