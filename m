Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4DB125DB;
	Thu, 15 Aug 2024 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683325; cv=none; b=G+69FjJSdDXlKRuNHLjVHnqVXWSvQuQaAUpoQLfLEBfIUy9M+1koEb35gZlt4scezCNNweKV67hxCkMJ/AWYJT72iehcsYrGrLKO88C3jEtP90PCFzOaQluea8ostFcPY1LYdSmj/LE8BLACC2EwLyZBohFmlONZw53aIdJlzsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683325; c=relaxed/simple;
	bh=hbAtdTfM/2Y5R4Y8ZQs2x0tm78Qpy+psfGstRYG+aaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=faWslja4ck1ah4pfeWiPHNDU5Chk5yHPEBpZHbaMtCmmqWdUQxKCVxihL2PVNNu3yD2q7OZ73+DHienSffzIQF2crbCihMNxQUSGu1fnXGbiQTvKo+JvW5xSoKTo4FUTu5zONPjdpJDnGk1m0cCIjR+hlfRnrWqfyuGezQvnHu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7LfJDxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7LfJDxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EF7C4AF0B;
	Thu, 15 Aug 2024 00:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683324;
	bh=hbAtdTfM/2Y5R4Y8ZQs2x0tm78Qpy+psfGstRYG+aaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7LfJDxnkeYh/hRPa4dDH0H6oUcSQDIFZQWJsQmJGO9NW+Zs7C1/Mb8OaqrV0NcZ8
	 FaICXwwPW4MlLFmkCCeoxOsO7/K7d2ilCYxWXakcy234fTAvxQIUJX5XAthpO4yr1l
	 FqEj6/mklSjCBAzIFjVPTrgcdCrjtWynBtXGJO53WLl16sdUFLwLLr/1WrTnsOIu1P
	 +ijdCW0eKWLmcvAbQ4lrE1N/+CubaJt8XblpIeU0OnJNBpHp3hKpEDsbtTsyr7W0TO
	 JvN0xFvsgiU9LVfdws0E6kMwvuWJNvjV7NO28iqsS79MI7ZIu/LRSWUMiMwTCvKjU5
	 mV7gl7scDxB7g==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 05/12] clk: Fail phase APIs after clk_hw is unregistered
Date: Wed, 14 Aug 2024 17:55:11 -0700
Message-ID: <20240815005520.1192374-6-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815005520.1192374-1-sboyd@kernel.org>
References: <20240815005520.1192374-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The clk phase APIs don't fail when a clk_hw is unregistered. Add some
nodrv clk_ops that return failure so that clk_get_phase() starts failing
when a clk_hw is unregistered.

Cc: Nuno Sá <nuno.sa@analog.com>
Fixes: e59c5371fb9d ("clk: introduce clk_set_phase function & callback")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f5415aa70f81..8909294cc52e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4486,7 +4486,7 @@ EXPORT_SYMBOL_GPL(of_clk_hw_register);
  * after clk_unregister() was called on a clock and until last clock
  * consumer calls clk_put() and the struct clk object is freed.
  */
-static int clk_nodrv_prepare_enable(struct clk_hw *hw)
+static int clk_nodrv_prepare_enable_get_phase(struct clk_hw *hw)
 {
 	return -ENXIO;
 }
@@ -4513,14 +4513,21 @@ static int clk_nodrv_determine_rate(struct clk_hw *hw,
 	return -ENXIO;
 }
 
+static int clk_nodrv_set_phase(struct clk_hw *hw, int degrees)
+{
+	return -ENXIO;
+}
+
 static const struct clk_ops clk_nodrv_ops = {
-	.enable		= clk_nodrv_prepare_enable,
+	.enable		= clk_nodrv_prepare_enable_get_phase,
 	.disable	= clk_nodrv_disable_unprepare,
-	.prepare	= clk_nodrv_prepare_enable,
+	.prepare	= clk_nodrv_prepare_enable_get_phase,
 	.unprepare	= clk_nodrv_disable_unprepare,
 	.determine_rate	= clk_nodrv_determine_rate,
 	.set_rate	= clk_nodrv_set_rate,
 	.set_parent	= clk_nodrv_set_parent,
+	.get_phase	= clk_nodrv_prepare_enable_get_phase,
+	.set_phase	= clk_nodrv_set_phase,
 };
 
 static void clk_core_evict_parent_cache_subtree(struct clk_core *root,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

