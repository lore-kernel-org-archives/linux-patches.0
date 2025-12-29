Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490732C933;
	Mon, 29 Dec 2025 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025416; cv=none; b=tOv0GOEy2VHGVkPMqLvI6/NunEShNXqyac2lwp+Z7F/ogDyeY3w0RSc8poggzwe7zsMmHMAQwrWbjZZwPP1V6MWQzL3yjhp09d2HLjJtX9Qz8KIN2NpDF4npwTX8K/6i8kkI76qf0XLtLDqfzeeNX1yjoOsTa78wlzcWg1Yf4T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025416; c=relaxed/simple;
	bh=tVtxKK38CIqG5WAsaKtGBiFE1hnK7wPwG39OIHSvzek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOQt10lC1CYcVuaM82dyOHhycgZyFFk8MIeJh86jfLQHc+wiw2hBY6VIAgJP/C5DUZ80v0JwHTffL4Ofc4QlRQ2/ySkJl99O4Yfw8BYj47Qw05WodpoU1oBia8uM9YvCFIt+eGSGQNJOu3FgLD2K5lRbcVipmViFjfGck0JIHEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fm1t0Iy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fm1t0Iy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81F6C4CEF7;
	Mon, 29 Dec 2025 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025415;
	bh=tVtxKK38CIqG5WAsaKtGBiFE1hnK7wPwG39OIHSvzek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fm1t0Iy3sXC3+lyE6znyfTEUvAWtlHIwRzisGWqu30SnVfbwogELIHx1lNm538EO0
	 x4OIGFBcV8lgEp3VmmrKIhctQstSDkxDN2LZkNpXdjcyZ4H2R0XkeE+bbtZY8S5AzM
	 XgNDLw5LL9t4X0QldUpt1vEZBW3FumdbJWNk4Ous=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/430] ASoC: ak4458: remove the reset operation in probe and remove
Date: Mon, 29 Dec 2025 17:09:34 +0100
Message-ID: <20251229160730.690963119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 00b960a83c764208b0623089eb70af3685e3906f ]

The reset_control handler has the reference count for usage, as there is
reset operation in runtime suspend and resume, then reset operation in
probe() would cause the reference count of reset not balanced.

Previously add reset operation in probe and remove is to fix the compile
issue with !CONFIG_PM, as the driver has been update to use
RUNTIME_PM_OPS(), so that change can be reverted.

Fixes: 1e0dff741b0a ("ASoC: ak4458: remove "reset-gpios" property handler")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251216070201.358477-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index a6c04dd3de3e..abe742edb10f 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -783,16 +783,12 @@ static int ak4458_i2c_probe(struct i2c_client *i2c)
 
 	pm_runtime_enable(&i2c->dev);
 	regcache_cache_only(ak4458->regmap, true);
-	ak4458_reset(ak4458, false);
 
 	return 0;
 }
 
 static void ak4458_i2c_remove(struct i2c_client *i2c)
 {
-	struct ak4458_priv *ak4458 = i2c_get_clientdata(i2c);
-
-	ak4458_reset(ak4458, true);
 	pm_runtime_disable(&i2c->dev);
 }
 
-- 
2.51.0



