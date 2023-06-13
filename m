Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D268D7E0
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 01:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE91C433EF;
	Tue, 13 Jun 2023 01:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686618722;
	bh=s2B8jsyrAMp70vnL8t+VU1TAoQczCjHuMAecRCqHfbs=;
	h=From:To:Cc:Subject:Date:From;
	b=MDtbZq/YIgU4w5Mjy34aMseasppY5x6FJ2bJ3b/DNb3cmDYOXij8PSXRLNTtAlTPz
	 oA06kJovpjEY4Ob3igRKSNBni3AWzrLC0k79X9basD0M9Uqc3bJK1kxUgbBMskamkC
	 55sRnsgbYtCaOORxmCLwiP1+sbm3MNkSQYyyZKHWyqE4lL6Z2Zp0xPTlvkNw0sbKoS
	 vP3WutOLeUdWFjxLFXYXuXHD4EMmlnO6uGfmapFQQirR/wS4No1G+FtTsFL7bnxdIO
	 kcn4m0RWFdtuKa9L7yiNYU8/DxpxwKB7MqpUObwanJPxa9oEoSEInekRzPg3mYBwiK
	 fSlhp9xn9aaKA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Maxime Ripard <maxime@cerno.tech>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] ASoC: tlv320aic32x4: pll: Remove impossible condition in clk_aic32x4_pll_determine_rate()
Date: Mon, 12 Jun 2023 18:12:00 -0700
Message-ID: <20230613011201.1166753-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Smatch warns:

sound/soc/codecs/tlv320aic32x4-clk.c:219 clk_aic32x4_pll_determine_rate() warn: unsigned 'rate' is never less than zero.

Cc: Maxime Ripard <maxime@cerno.tech>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306101217.08CRVGcK-lkp@intel.com/
Fixes: 25d43ec352ea ("ASoC: tlv320aic32x4: pll: Switch to determine_rate")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-clk.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-clk.c b/sound/soc/codecs/tlv320aic32x4-clk.c
index a7ec501b4c69..c116e82f712d 100644
--- a/sound/soc/codecs/tlv320aic32x4-clk.c
+++ b/sound/soc/codecs/tlv320aic32x4-clk.c
@@ -208,18 +208,14 @@ static int clk_aic32x4_pll_determine_rate(struct clk_hw *hw,
 					  struct clk_rate_request *req)
 {
 	struct clk_aic32x4_pll_muldiv settings;
-	unsigned long rate;
 	int ret;
 
 	ret = clk_aic32x4_pll_calc_muldiv(&settings, req->rate, req->best_parent_rate);
 	if (ret < 0)
 		return -EINVAL;
 
-	rate = clk_aic32x4_pll_calc_rate(&settings, req->best_parent_rate);
-	if (rate < 0)
-		return rate;
+	req->rate = clk_aic32x4_pll_calc_rate(&settings, req->best_parent_rate);
 
-	req->rate = rate;
 	return 0;
 }
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

