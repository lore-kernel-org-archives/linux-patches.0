Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806F534D3A3;
	Tue,  6 Jan 2026 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720034; cv=none; b=lkZrcz7bki8Aj+a+AW+/IAB1TS+5VJR5ZX4B6+qOHy7eo/h1/8cPCJKeAZVOMcOyCgM8AqHq6CjCewlRbhGoDKjbQu0A+q4G1NYLuixTNClXLNgVWYl5o1twgfZBIri28OiJ32Cn3skUI5MdH8qUzv5PVKn0a/DSJOudZjvOWDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720034; c=relaxed/simple;
	bh=ZgMKPSiVFLZihJQoQH4Ih5Msh9f3/NX64iIkq9ZzxQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAF6yTWide/BNo4Ol+aQnmN8fx8rMaU2i4qafbns8oJsKb9UTE5k+kNB4xVz61HARNRJA4TXknc82kS4hzWZtNJGlWeeCtFEfcS0+2kgHWsmB+qitlsUjO+Qlv/DnomJpmyjPjjEDZ9Who1f3T0aiJJOsiMyTThqgGfgAOMxfs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzRsKV1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzRsKV1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ED6C116C6;
	Tue,  6 Jan 2026 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720034;
	bh=ZgMKPSiVFLZihJQoQH4Ih5Msh9f3/NX64iIkq9ZzxQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzRsKV1nBt59IRDuGexSjfmGEg9rm3/K5ZR81eksjkE5HYZg87i4WB2+VE6A8/xwB
	 QbSbyRZ5/EI/GVj5jXklW3OsXIOmAQgxhFVQxmdaj518bpxSlrEOJF/++imSEJicKV
	 kEZXD8qkcN+S1r/ARbPvUMyToWiDR3RHqKvcn+yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/567] ASoC: ak4458: remove the reset operation in probe and remove
Date: Tue,  6 Jan 2026 17:58:17 +0100
Message-ID: <20260106170455.585577296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fb1ab335a4c1..e2e12dbc8cf2 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -790,16 +790,12 @@ static int ak4458_i2c_probe(struct i2c_client *i2c)
 
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



