Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717321DED49;
	Wed,  6 Nov 2024 12:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895653; cv=none; b=mRrm42Hjj1mJL7pwyA6ljPDrJgLWUPULmMz4CDiySuiVV9LE0ROEfIuWNETpVaolCouZ5jzAHUYD2/DxYb/1pvhKqOI7asj3Ckpa1RKEGeuhlTAZQtThcplH1o1At0GWoeSwMp4xmo0X7B9eBrieRV+jfTpV3mVImydUHDycTjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895653; c=relaxed/simple;
	bh=BDQi3SApF0gx7xJhxJaXfdnhXDepMiuaudDowHZufO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ7Db85m96AnFBwRadKcD9pRpg9eyUCI3Y6xKmq6um3oYFBD5nKH8X6+wNuL3cs39R13ZADGLWSBwIl2Gq4wJMai7ayKHCr6b37Z4h9a7UP6YXBJG5Wg1aVIqWHSqkxHwhjbW+prPQVAscjmf2ypolnG9afIedcvUrOP7qilQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgFiTj1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgFiTj1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED670C4CECD;
	Wed,  6 Nov 2024 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895653;
	bh=BDQi3SApF0gx7xJhxJaXfdnhXDepMiuaudDowHZufO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgFiTj1oiUicv5qfHxx3WpfFNgnyKk1008UWreKX+kEOjRjfuMu1RJ/zIiPOEq9Lw
	 z0YsO3fLrywf3bY4yWCuavrHcxSA/Z64b9dFYYMKy0aYqTeVIF/j9O/0d8sBHVuCbS
	 nj1wlXnYMd6O9ntWiYzZeAX2eaT0xux36HrWCX9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Edworthy <phil.edworthy@renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Russell King <linux@armlinux.org.uk>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 254/350] clk: Add (devm_)clk_get_optional() functions
Date: Wed,  6 Nov 2024 13:03:02 +0100
Message-ID: <20241106120327.186603490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Edworthy <phil.edworthy@renesas.com>

[ Upstream commit 60b8f0ddf1a927ef02141a6610fd52575134f821 ]

This adds clk_get_optional() and devm_clk_get_optional() functions to get
optional clocks.

They behave the same as (devm_)clk_get() except where there is no clock
producer. In this case, instead of returning -ENOENT, the function
returns NULL. This makes error checking simpler and allows
clk_prepare_enable, etc to be called on the returned reference
without additional checks.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Russell King <linux@armlinux.org.uk>
[sboyd@kernel.org: Document in devres.txt]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: a6191a3d1811 ("gpio: aspeed: Use devm_clk api to manage clock source")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-model/devres.txt |  1 +
 drivers/clk/clk-devres.c              | 11 ++++++++
 include/linux/clk.h                   | 36 +++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 43681ca0837f8..5a2d8c7ce2474 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -235,6 +235,7 @@ certainly invest a bit more effort into libata core layer).
 
 CLOCK
   devm_clk_get()
+  devm_clk_get_optional()
   devm_clk_put()
   devm_clk_hw_register()
   devm_of_clk_add_hw_provider()
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index d854e26a8ddbc..a062389ccd3d5 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -34,6 +34,17 @@ struct clk *devm_clk_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL(devm_clk_get);
 
+struct clk *devm_clk_get_optional(struct device *dev, const char *id)
+{
+	struct clk *clk = devm_clk_get(dev, id);
+
+	if (clk == ERR_PTR(-ENOENT))
+		return NULL;
+
+	return clk;
+}
+EXPORT_SYMBOL(devm_clk_get_optional);
+
 struct clk_bulk_devres {
 	struct clk_bulk_data *clks;
 	int num_clks;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 0a2382d3f68c8..55b08adaaa3c1 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -388,6 +388,17 @@ int __must_check devm_clk_bulk_get(struct device *dev, int num_clks,
  */
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
+/**
+ * devm_clk_get_optional - lookup and obtain a managed reference to an optional
+ *			   clock producer.
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Behaves the same as devm_clk_get() except where there is no clock producer.
+ * In this case, instead of returning -ENOENT, the function returns NULL.
+ */
+struct clk *devm_clk_get_optional(struct device *dev, const char *id);
+
 /**
  * devm_get_clk_from_child - lookup and obtain a managed reference to a
  *			     clock producer from child node.
@@ -655,6 +666,12 @@ static inline struct clk *devm_clk_get(struct device *dev, const char *id)
 	return NULL;
 }
 
+static inline struct clk *devm_clk_get_optional(struct device *dev,
+						const char *id)
+{
+	return NULL;
+}
+
 static inline int __must_check devm_clk_bulk_get(struct device *dev, int num_clks,
 						 struct clk_bulk_data *clks)
 {
@@ -774,6 +791,25 @@ static inline void clk_bulk_disable_unprepare(int num_clks,
 	clk_bulk_unprepare(num_clks, clks);
 }
 
+/**
+ * clk_get_optional - lookup and obtain a reference to an optional clock
+ *		      producer.
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Behaves the same as clk_get() except where there is no clock producer. In
+ * this case, instead of returning -ENOENT, the function returns NULL.
+ */
+static inline struct clk *clk_get_optional(struct device *dev, const char *id)
+{
+	struct clk *clk = clk_get(dev, id);
+
+	if (clk == ERR_PTR(-ENOENT))
+		return NULL;
+
+	return clk;
+}
+
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
-- 
2.43.0



