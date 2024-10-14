Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E21ABEA2;
	Mon, 14 Oct 2024 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919097; cv=none; b=KoqgcEqzPwE7YenS6ZXjre2vEgwG8PoWK9SknpEcB2E5CHH1Pf1JKEaByROcqdxupMN84L6+gLUE2ArIoSJPN5Q6PEusatsv1Vp2oA9BqNtJQVlLrheUL0auv7QhDfl+fFp63fNNsoxL2h9aNGMHGWHBmfDbw43XTlsWdCNQtnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919097; c=relaxed/simple;
	bh=AQbRg0jjSw8cgz/HKzCfP/aI55kUE6QqOFo3ahrwar4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW3NQO2Awvd9StY9Ox/TphE3iDTAfzClYLpDrgOgYX3fbyOQ2yBuITPad9Vyog6owZjDJYEb7U0MinpVOz+Ga0QMQrVXjZLY1KgcB5ZLaVt/pxrq67eY9YpGkJyjYVowQf740kCNHYeX9evQ1/IryBRP3oH0TbgE6HqMtNZqWM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8RAHKOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8RAHKOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FB3C4CEC3;
	Mon, 14 Oct 2024 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919097;
	bh=AQbRg0jjSw8cgz/HKzCfP/aI55kUE6QqOFo3ahrwar4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8RAHKOucjUa7GEh3EAhrT6GKmn9bnudqJnhhTo+ZgQMLszK1QpZ4Qxy7vvh1JuTo
	 vwwmF9WFS8HdAjX92x8N/WGGQltu0LX2GCITY9ecTuoFb2ZLwU3qZnq18PPPw4ajIY
	 E7bIVcn/KjeCHxks3vMb8WxyW+UaCkBba7RGdm7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/798] spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Mon, 14 Oct 2024 16:17:47 +0200
Message-ID: <20241014141238.134872650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b6e05ba0844139dde138625906015c974c86aa93 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 43b6bf406cd0 ("spi: imx: fix runtime pm support for !CONFIG_PM")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 93e83fbc3403f..df73a2c7120c9 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1856,8 +1856,8 @@ static int spi_imx_probe(struct platform_device *pdev)
 		spi_imx_sdma_exit(spi_imx);
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(spi_imx->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	clk_disable_unprepare(spi_imx->clk_ipg);
 out_put_per:
-- 
2.43.0



