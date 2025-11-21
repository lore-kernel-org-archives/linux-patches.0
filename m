Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2C034029C;
	Fri, 21 Nov 2025 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731118; cv=none; b=jdLrfkee0x9XQ7d71c4HCRMWJUnK/usXXtDGa5s3GT2lJqdhu6jySv9WE/flEGJc05IT8TPEchObVYmyUdtHUwog9Uzm7mLuQtiyBgJ9FQYl7kdX/vFtkBM+dJD7voLJ0PJ/IAGDfVgQy1lQGO/7NXuYLKTi4Fia2en2F3SG3H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731118; c=relaxed/simple;
	bh=NBtwdBv020MQaoXkY0w+D5nvOFn8x5WD0ggJGTBaSMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5637xZ5bl1A8FwniwWoewMTgefJuKPc2EM9MRZTKrwTLnnGFsjNZZb6RXSAYPBjz2r9veyQU+juydF06oRh/SXLfF5IBvvWdPEbOj7Ijj+p+J4Kgu/BCwwj6VEUkBvEXotKxA9DV6ZSZ8gnWah6aoxj3V8M22dyvOvvF4FFySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZ7L9+M2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZ7L9+M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EFEC4CEF1;
	Fri, 21 Nov 2025 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731118;
	bh=NBtwdBv020MQaoXkY0w+D5nvOFn8x5WD0ggJGTBaSMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZ7L9+M2+W2qBXitP2+Si9DPojkWyoD4TVmcPX7IOec04jX0Br2V8tXRk3kM//701
	 GGTdn1s3onjSHTSOMuLdkOfQQnH2Rk6Mi7YVo9CjIgbmVhjPSkBHJpuAusElMIrdFu
	 tCoyIWAxNPuOmZ2jyXK64CdzA/hu/aYzyeDwZWPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 097/247] regulator: fixed: fix GPIO descriptor leak on register failure
Date: Fri, 21 Nov 2025 14:10:44 +0100
Message-ID: <20251121130158.072689827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1cb647ed70c62..a2d16e9abfb58 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -334,6 +334,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
 				    "Failed to register regulator: %ld\n",
 				    PTR_ERR(drvdata->dev));
+		gpiod_put(cfg.ena_gpiod);
 		return ret;
 	}
 
-- 
2.51.0



