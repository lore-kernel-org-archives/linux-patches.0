Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D118735BDDB;
	Wed,  3 Dec 2025 16:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779855; cv=none; b=TrU8Cwr3seWp8VB6xegt7dU87sj+MT6O1eM3vjzAYkedUIuEuyAmVhZQQjs6lybGCH+32ivu0A/dLyP/QCSAtNf3QCKqOLpMHCoKxLt52uWAZiQpW0sF3moV0xf92/sgdu0oDuI7oDXKWqVXtQfs7CNCso+4hyYIzfAtH/6MLWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779855; c=relaxed/simple;
	bh=5lRYY6pBuXAQr6F/S6giWCE0CatHNeA45454S9Y3dD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKN2MQ/boSCfdIbEaA9zS/T5RcugffpGofsTAxoQ3CTD/Mp6hoWjasFST7/kyedeowxyd74mEjaSpj9UhpV6c8EOVaTD+j+QTMDMqYKvaBdmtm0+pOToNcuJ/D4lpzt5VXQOX4vol8IQE7aRyjLF+pvFgfMbo4hUkhRgS9/70SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0hF/bcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0hF/bcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4828CC4CEF5;
	Wed,  3 Dec 2025 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779855;
	bh=5lRYY6pBuXAQr6F/S6giWCE0CatHNeA45454S9Y3dD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0hF/bcnne1Z+ZIPcSMRqwgXFHEB6I0lyT8r3ujcQEEFMVyQ1DStQ0ntyGqSmgrKS
	 xtM1c7gO+YgleprkTFPjtwf4bxLf0R6OoEwQSTeIdSqYZFcVmbCoYSTdRmicYYRu89
	 kDDpbpC+avQDTZRQ69QOQR4gWEzTnb0MS3X7Xt6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 381/568] regulator: fixed: fix GPIO descriptor leak on register failure
Date: Wed,  3 Dec 2025 16:26:23 +0100
Message-ID: <20251203152454.650920463@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6724a229d237..e273275e60259 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -287,6 +287,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
 				    "Failed to register regulator: %ld\n",
 				    PTR_ERR(drvdata->dev));
+		gpiod_put(cfg.ena_gpiod);
 		return ret;
 	}
 
-- 
2.51.0



