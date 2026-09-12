Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8C274B39;
	Sat, 12 Sep 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232319; cv=none; b=AldyU2iTUy2Xxp3yzMdSZrcqPvsVKqT14W5fB2koNEO2kDF8Wf2e77t+oNKCt9fXSYhrxNruvwpT+XW4KQhUKtZjgx98iY44gzTG+dU40lUVmmfmtO4BoZfkpt7DIQ9QJnXKNpM0TFsr4pU5deNZKHoxNG/YsqO+NWlZEF5/Ti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232319; c=relaxed/simple;
	bh=oAl/YCuONKCF4w1QFDZb4gk2AjtkmFyFWZEob1h1TJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUHmJ+ukZxTeGY0dPaIA4QGGX3py4bNkP8aGSA0BzWl6XCvh5PWkFdBU9CdsRHAuTDbirnkxhlxHxctsVJeM9F0a0OxI67HL4wYL4fXz/Rt7TJxoFIXxFZ+FvzpwxQzcCd3PP3eiXVr9P3OGkUUG9vU3ZgnxPHojd9ByNdKlZm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUeTxQ36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUeTxQ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7AE1F000FF;
	Sat, 12 Sep 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232318;
	bh=jzltJ49nPwx/LCOuEGLiqEidFX8EwNcaK7CMHnn1LZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUeTxQ36d3pkssi8qbZclUISKw+OiE4AghoHt7hJ+Qn/oXJv7DTj6MGRWsJC4KmEi
	 vcMzsFdqxpdxVybKcgsDvIFgpIBZIgqwsxwOWdRR5xTIHP+tThY7H0OhIJNXgtqjOn
	 MXtbTckux5R2KoYqDIGcFJsNL+E7ikzyG8Wjv+j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1151/1191] clk: qcom: rcg2: add clk_rcg2_shared_floor_ops
Date: Sat, 12 Sep 2026 09:04:39 +0200
Message-ID: <20260912065613.999528279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit aec8c0e28ce4a1f89fd82fcc06a5cc73147e9817 ]

Generally SDCC clocks use clk_rcg2_floor_ops, however on SAR2130P
platform it's recommended to use rcg2_shared_ops for all Root Clock
Generators to park them instead of disabling. Implement a mix of those,
clk_rcg2_shared_floor_ops.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241027-sar2130p-clocks-v5-6-ecad2a1432ba@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 1c06e3956054 ("clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg.h  |  1 +
 drivers/clk/qcom/clk-rcg2.c | 48 +++++++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
index 6b26d55d7bf8f..4279ec01ac10c 100644
--- a/drivers/clk/qcom/clk-rcg.h
+++ b/drivers/clk/qcom/clk-rcg.h
@@ -174,6 +174,7 @@ extern const struct clk_ops clk_byte2_ops;
 extern const struct clk_ops clk_pixel_ops;
 extern const struct clk_ops clk_gfx3d_ops;
 extern const struct clk_ops clk_rcg2_shared_ops;
+extern const struct clk_ops clk_rcg2_shared_floor_ops;
 extern const struct clk_ops clk_rcg2_shared_no_init_park_ops;
 extern const struct clk_ops clk_dp_ops;
 
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 18e43206a27ec..12ab7708014f3 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1017,15 +1017,23 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
 	return clk_rcg2_clear_force_enable(hw);
 }
 
-static int clk_rcg2_shared_set_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long parent_rate)
+static int __clk_rcg2_shared_set_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long parent_rate,
+				      enum freq_policy policy)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	const struct freq_tbl *f;
 
-	f = qcom_find_freq(rcg->freq_tbl, rate);
-	if (!f)
+	switch (policy) {
+	case FLOOR:
+		f = qcom_find_freq_floor(rcg->freq_tbl, rate);
+		break;
+	case CEIL:
+		f = qcom_find_freq(rcg->freq_tbl, rate);
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	/*
 	 * In case clock is disabled, update the M, N and D registers, cache
@@ -1038,10 +1046,28 @@ static int clk_rcg2_shared_set_rate(struct clk_hw *hw, unsigned long rate,
 	return clk_rcg2_shared_force_enable_clear(hw, f);
 }
 
+static int clk_rcg2_shared_set_rate(struct clk_hw *hw, unsigned long rate,
+				    unsigned long parent_rate)
+{
+	return __clk_rcg2_shared_set_rate(hw, rate, parent_rate, CEIL);
+}
+
 static int clk_rcg2_shared_set_rate_and_parent(struct clk_hw *hw,
 		unsigned long rate, unsigned long parent_rate, u8 index)
 {
-	return clk_rcg2_shared_set_rate(hw, rate, parent_rate);
+	return __clk_rcg2_shared_set_rate(hw, rate, parent_rate, CEIL);
+}
+
+static int clk_rcg2_shared_set_floor_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long parent_rate)
+{
+	return __clk_rcg2_shared_set_rate(hw, rate, parent_rate, FLOOR);
+}
+
+static int clk_rcg2_shared_set_floor_rate_and_parent(struct clk_hw *hw,
+		unsigned long rate, unsigned long parent_rate, u8 index)
+{
+	return __clk_rcg2_shared_set_rate(hw, rate, parent_rate, FLOOR);
 }
 
 static int clk_rcg2_shared_enable(struct clk_hw *hw)
@@ -1179,6 +1205,18 @@ const struct clk_ops clk_rcg2_shared_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
 
+const struct clk_ops clk_rcg2_shared_floor_ops = {
+	.enable = clk_rcg2_shared_enable,
+	.disable = clk_rcg2_shared_disable,
+	.get_parent = clk_rcg2_shared_get_parent,
+	.set_parent = clk_rcg2_shared_set_parent,
+	.recalc_rate = clk_rcg2_shared_recalc_rate,
+	.determine_rate = clk_rcg2_determine_floor_rate,
+	.set_rate = clk_rcg2_shared_set_floor_rate,
+	.set_rate_and_parent = clk_rcg2_shared_set_floor_rate_and_parent,
+};
+EXPORT_SYMBOL_GPL(clk_rcg2_shared_floor_ops);
+
 static int clk_rcg2_shared_no_init_park(struct clk_hw *hw)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-- 
2.53.0



