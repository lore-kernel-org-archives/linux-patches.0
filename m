Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C3C3B9D9D;
	Tue, 21 Jul 2026 22:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671386; cv=none; b=eyiGAcWVQtjdzKsbrYF8U6q6RT3Mpv0QEU5zD9woYv+XNYH6gXVTQhfZ7MwJWCg0SRENWF5S0pV5/elLToPV7tXYo7nNcDxiWPZO/yRrG9nyIa7UYMfP5J/A+37+oeG/+0FV/5FCmtDp6baGtEIzI9qF1ZV/y7DPCaTc8tkMR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671386; c=relaxed/simple;
	bh=5P3tyrvEo/wlj2bPPWZYOx0U1x0qpNLSFYCHbF9Z18o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9ha4p8Yy2OKeUUoigBmj1dgBNVLS5yTRwxptklbcRZvnKvM2uiSJPzBGxXBr9vQtpJgUbeW69OVbQcLvcel5VAUtBa6rmBg2pv5AILI/RKorQCQpWFMRfx80R2M1pagHBlRc1wsC7As0st4CJxe01u07gmJlI+Eh3xp+DwDhVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uf9a8Rae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf9a8Rae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DA51F000E9;
	Tue, 21 Jul 2026 22:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671384;
	bh=P17tgbWZ53jGw4Ts49npAYJ6DlBRtvgh6XiOxUklgOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uf9a8RaeQJpig+iJ8X8/IRNzUOEu/IUMEjVFXeF/mF0sr6HCzywP/ZE5PxHDbmQQ2
	 heO2yssu00Yat4eN+AkW8RMMWUo2JvhwtFi/jJ7ktn34NVDi5/Mc1SPsw6YYH+C5Gy
	 7X7vy9O02siiQcAZHtVz28cbfysXrA7RI5JViqe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/843] pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path
Date: Tue, 21 Jul 2026 17:17:42 +0200
Message-ID: <20260721152411.121560377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 334f7bcbdc79dc8e5b938ac3372453a5368221cf ]

In the error path of sunxi_pmx_request(), the code calls
regulator_put(s_reg->regulator) to release the regulator. However,
s_reg->regulator is only assigned after a successful regulator_enable().
This causes a memory leak: the regulator obtained via regulator_get()
is never properly released when regulator_enable() fails.

Fixes: dc1445584177 ("pinctrl: sunxi: Fix and simplify pin bank regulator handling")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index afe41ea0ff1e28..8d670af25b0335 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -813,7 +813,7 @@ static int sunxi_pmx_request(struct pinctrl_dev *pctldev, unsigned offset)
 	return 0;
 
 out:
-	regulator_put(s_reg->regulator);
+	regulator_put(reg);
 
 	return ret;
 }
-- 
2.53.0



