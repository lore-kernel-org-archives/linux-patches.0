Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784734F88C;
	Tue, 14 May 2024 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683885; cv=none; b=UCiWsT+Dvbjpyz6yQNmFTQkONErJIljhif+9lMYGc/SjHlvAtVj4ezV/BSxNBBGzxpQIeOGVyq5rmJHYQNHzbb3tgywQF+uUNA6gOK7Jcz34H4jo/GtyFBUp9nP57rMzFzpAwHmAt528S3RBX5K740qe1semtKPxC39Sem9sVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683885; c=relaxed/simple;
	bh=RwLa6B3ijzOSCskSXZ8RCcfKOE3ulnK+V6elcBb4ap4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEW3+NqfAY5cexX+daS+/rzV285+Tc2k4uCFCo04L/Kc+E8dKabm8wd8Uvm1ThqjYiq9aUThsa+HwbyadnTEnrbPsoc80fqVnR0Nmw3EAQJCfclUViewKcbKeWuwCUPpP+f7I33zMJDkjJ4kr2m6CkLxlwkRZ/UfoE3NJUZvsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEkBstDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEkBstDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA97DC2BD10;
	Tue, 14 May 2024 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683885;
	bh=RwLa6B3ijzOSCskSXZ8RCcfKOE3ulnK+V6elcBb4ap4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEkBstDGQP1HFIMR1QI2HniPYLyQkiTSIq93vgvwqAM5Q2CcvGhZAi8zPuEQ0Fpb7
	 x8WvWau01Mhmea2TOGa3QNd2135EIMyhdrng1pzOVomyWK4U3PszYXz0/g3T5rJJkR
	 zJSDltem+9rHiv7KPMYk1JE+juVCz8LYPDiOwYkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.8 290/336] clk: sunxi-ng: common: Support minimum and maximum rate
Date: Tue, 14 May 2024 12:18:14 +0200
Message-ID: <20240514101049.564827132@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Oltmanns <frank@oltmanns.dev>

commit b914ec33b391ec766545a41f0cfc0de3e0b388d7 upstream.

The Allwinner SoC's typically have an upper and lower limit for their
clocks' rates. Up until now, support for that has been implemented
separately for each clock type.

Implement that functionality in the sunxi-ng's common part making use of
the CCF rate liming capabilities, so that it is available for all clock
types.

Suggested-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Frank Oltmanns <frank@oltmanns.dev>
Cc: stable@vger.kernel.org
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20240310-pinephone-pll-fixes-v4-1-46fc80c83637@oltmanns.dev
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/sunxi-ng/ccu_common.c |   19 +++++++++++++++++++
 drivers/clk/sunxi-ng/ccu_common.h |    3 +++
 2 files changed, 22 insertions(+)

--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -44,6 +44,16 @@ bool ccu_is_better_rate(struct ccu_commo
 			unsigned long current_rate,
 			unsigned long best_rate)
 {
+	unsigned long min_rate, max_rate;
+
+	clk_hw_get_rate_range(&common->hw, &min_rate, &max_rate);
+
+	if (current_rate > max_rate)
+		return false;
+
+	if (current_rate < min_rate)
+		return false;
+
 	if (common->features & CCU_FEATURE_CLOSEST_RATE)
 		return abs(current_rate - target_rate) < abs(best_rate - target_rate);
 
@@ -122,6 +132,7 @@ static int sunxi_ccu_probe(struct sunxi_
 
 	for (i = 0; i < desc->hw_clks->num ; i++) {
 		struct clk_hw *hw = desc->hw_clks->hws[i];
+		struct ccu_common *common = hw_to_ccu_common(hw);
 		const char *name;
 
 		if (!hw)
@@ -136,6 +147,14 @@ static int sunxi_ccu_probe(struct sunxi_
 			pr_err("Couldn't register clock %d - %s\n", i, name);
 			goto err_clk_unreg;
 		}
+
+		if (common->max_rate)
+			clk_hw_set_rate_range(hw, common->min_rate,
+					      common->max_rate);
+		else
+			WARN(common->min_rate,
+			     "No max_rate, ignoring min_rate of clock %d - %s\n",
+			     i, name);
 	}
 
 	ret = of_clk_add_hw_provider(node, of_clk_hw_onecell_get,
--- a/drivers/clk/sunxi-ng/ccu_common.h
+++ b/drivers/clk/sunxi-ng/ccu_common.h
@@ -31,6 +31,9 @@ struct ccu_common {
 	u16		lock_reg;
 	u32		prediv;
 
+	unsigned long	min_rate;
+	unsigned long	max_rate;
+
 	unsigned long	features;
 	spinlock_t	*lock;
 	struct clk_hw	hw;


