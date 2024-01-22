Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042F764CE7;
	Tue, 23 Jan 2024 01:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971621; cv=none; b=j+b/RJMaKjpjJgKCwZgd+E8/xgrkg2+JqmN7vso3nHHDRmh9kUPLT/Ktpuj5D6k8k0zvrN1xQJFcrPXB1iTSA+vu/O/H5sh6kZzsAikmRi/js8WwV/mUR0wSAA1TTk4l+kOGmi8imPz/URktSv4bPQKxeTmbuMrVn3XpLlZxp9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971621; c=relaxed/simple;
	bh=MkQjQF1bnF/m9s9kiTonpiaHMwFZwZ88mqklMdZCPHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEtLr/vsQcyFO5WpA51s5mu5l9RBc0cgGVRfK3ajvX/BeetKLi0jFPU5nE0XukpDcTIJPPrhYZbGRhjN5mR6acgOc3+gGK+qEcku12Jn4/7sOlQL9GAL8JZw0JfKaKjj3Zx54LK5uxBi9dPpd4ySSF8GJGcFYJGxm+ra0z1ZMJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Il2z3qqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Il2z3qqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11A3C433C7;
	Tue, 23 Jan 2024 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971620;
	bh=MkQjQF1bnF/m9s9kiTonpiaHMwFZwZ88mqklMdZCPHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Il2z3qqPshMG2oL+/Kk35Lyu7G5+tVv5P0aQxv/rrmIwqVdehjZSgmM2C0u3IQXeE
	 buR54Io7QoQtDwdcpwyHrI/jP4hmpAUKXDz6ilzbCIsOx/JC5YMypDnp0qY37PIg6+
	 Piffi6TwDic4hF+KSmaiQASivJqRWh1sgxWDQ/Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/286] clk: fixed-rate: add devm_clk_hw_register_fixed_rate
Date: Mon, 22 Jan 2024 15:58:13 -0800
Message-ID: <20240122235739.331159819@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1d7d20658534c7d36fe6f4252f6f1a27d9631a99 ]

Add devm_clk_hw_register_fixed_rate(), devres-managed helper to register
fixed-rate clock.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220916061740.87167-3-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: ee0cf5e07f44 ("clk: fixed-rate: fix clk_hw_register_fixed_rate_with_accuracy_parent_hw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-fixed-rate.c | 28 ++++++++++++++++++++++++----
 include/linux/clk-provider.h | 29 +++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 45501637705c..62e994d18fe2 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -49,12 +49,24 @@ const struct clk_ops clk_fixed_rate_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
 
+static void devm_clk_hw_register_fixed_rate_release(struct device *dev, void *res)
+{
+	struct clk_fixed_rate *fix = res;
+
+	/*
+	 * We can not use clk_hw_unregister_fixed_rate, since it will kfree()
+	 * the hw, resulting in double free. Just unregister the hw and let
+	 * devres code kfree() it.
+	 */
+	clk_hw_unregister(&fix->hw);
+}
+
 struct clk_hw *__clk_hw_register_fixed_rate(struct device *dev,
 		struct device_node *np, const char *name,
 		const char *parent_name, const struct clk_hw *parent_hw,
 		const struct clk_parent_data *parent_data, unsigned long flags,
 		unsigned long fixed_rate, unsigned long fixed_accuracy,
-		unsigned long clk_fixed_flags)
+		unsigned long clk_fixed_flags, bool devm)
 {
 	struct clk_fixed_rate *fixed;
 	struct clk_hw *hw;
@@ -62,7 +74,11 @@ struct clk_hw *__clk_hw_register_fixed_rate(struct device *dev,
 	int ret = -EINVAL;
 
 	/* allocate fixed-rate clock */
-	fixed = kzalloc(sizeof(*fixed), GFP_KERNEL);
+	if (devm)
+		fixed = devres_alloc(devm_clk_hw_register_fixed_rate_release,
+				     sizeof(*fixed), GFP_KERNEL);
+	else
+		fixed = kzalloc(sizeof(*fixed), GFP_KERNEL);
 	if (!fixed)
 		return ERR_PTR(-ENOMEM);
 
@@ -90,9 +106,13 @@ struct clk_hw *__clk_hw_register_fixed_rate(struct device *dev,
 	else if (np)
 		ret = of_clk_hw_register(np, hw);
 	if (ret) {
-		kfree(fixed);
+		if (devm)
+			devres_free(fixed);
+		else
+			kfree(fixed);
 		hw = ERR_PTR(ret);
-	}
+	} else if (devm)
+		devres_add(dev, fixed);
 
 	return hw;
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index aa8cbf882914..76f02b214f39 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -350,7 +350,7 @@ struct clk_hw *__clk_hw_register_fixed_rate(struct device *dev,
 		const char *parent_name, const struct clk_hw *parent_hw,
 		const struct clk_parent_data *parent_data, unsigned long flags,
 		unsigned long fixed_rate, unsigned long fixed_accuracy,
-		unsigned long clk_fixed_flags);
+		unsigned long clk_fixed_flags, bool devm);
 struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate);
@@ -365,7 +365,20 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  */
 #define clk_hw_register_fixed_rate(dev, name, parent_name, flags, fixed_rate)  \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), (parent_name), NULL, \
-				     NULL, (flags), (fixed_rate), 0, 0)
+				     NULL, (flags), (fixed_rate), 0, 0, false)
+
+/**
+ * devm_clk_hw_register_fixed_rate - register fixed-rate clock with the clock
+ * framework
+ * @dev: device that is registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @fixed_rate: non-adjustable clock rate
+ */
+#define devm_clk_hw_register_fixed_rate(dev, name, parent_name, flags, fixed_rate)  \
+	__clk_hw_register_fixed_rate((dev), NULL, (name), (parent_name), NULL, \
+				     NULL, (flags), (fixed_rate), 0, 0, true)
 /**
  * clk_hw_register_fixed_rate_parent_hw - register fixed-rate clock with
  * the clock framework
@@ -378,7 +391,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 #define clk_hw_register_fixed_rate_parent_hw(dev, name, parent_hw, flags,     \
 					     fixed_rate)		      \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, (parent_hw),  \
-				     NULL, (flags), (fixed_rate), 0, 0)
+				     NULL, (flags), (fixed_rate), 0, 0, false)
 /**
  * clk_hw_register_fixed_rate_parent_data - register fixed-rate clock with
  * the clock framework
@@ -392,7 +405,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 					     fixed_rate)		      \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, NULL,	      \
 				     (parent_data), (flags), (fixed_rate), 0, \
-				     0)
+				     0, false)
 /**
  * clk_hw_register_fixed_rate_with_accuracy - register fixed-rate clock with
  * the clock framework
@@ -408,7 +421,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 						 fixed_accuracy)	      \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), (parent_name),      \
 				     NULL, NULL, (flags), (fixed_rate),       \
-				     (fixed_accuracy), 0)
+				     (fixed_accuracy), 0, false)
 /**
  * clk_hw_register_fixed_rate_with_accuracy_parent_hw - register fixed-rate
  * clock with the clock framework
@@ -423,7 +436,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		parent_hw, flags, fixed_rate, fixed_accuracy)		      \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, (parent_hw)   \
 				     NULL, NULL, (flags), (fixed_rate),	      \
-				     (fixed_accuracy), 0)
+				     (fixed_accuracy), 0, false)
 /**
  * clk_hw_register_fixed_rate_with_accuracy_parent_data - register fixed-rate
  * clock with the clock framework
@@ -438,7 +451,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		parent_data, flags, fixed_rate, fixed_accuracy)		      \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, NULL,	      \
 				     (parent_data), NULL, (flags),	      \
-				     (fixed_rate), (fixed_accuracy), 0)
+				     (fixed_rate), (fixed_accuracy), 0, false)
 /**
  * clk_hw_register_fixed_rate_parent_accuracy - register fixed-rate clock with
  * the clock framework
@@ -452,7 +465,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 						   flags, fixed_rate)	      \
 	__clk_hw_register_fixed_rate((dev), NULL, (name), NULL, NULL,      \
 				     (parent_data), (flags), (fixed_rate), 0,    \
-				     CLK_FIXED_RATE_PARENT_ACCURACY)
+				     CLK_FIXED_RATE_PARENT_ACCURACY, false)
 
 void clk_unregister_fixed_rate(struct clk *clk);
 void clk_hw_unregister_fixed_rate(struct clk_hw *hw);
-- 
2.43.0



