Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054712;
	b=1vlkthOKlp1rKNs43dDlZ1DyRzALnmTJbgwlGoaTQXZIfQ00cm1RLxh4EOIOPT15Claa
	 ss+h7oeKrQ3gqZ2Ak3ewrMDTNTCyykKM4fJ1WekvWL423tLaT9vSAt8KQK8DVUBhfdDGJ
	 1PzXubA76vrb4tzLFW1KLRay7gy4Fc5DQFbIDkwhFXxehkeayET8xKwiecl0CnKdKdlpm
	 rVnwIBz4xEBAcZgcBuTu2DKN1lKBdCUCCWooSm5DaEXOvAM/+RD9+iVUBIRttJLrznPsV
	 YmD1YO8vA76B88rYG7XqfBLgEqT2CTvJnPMfvQJmuCWlCE4k8yGa1Z3GN2pk7cKwF2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOpS1CdlPFkVfF1cv3sxRmYJwJz0e1CVvUDS2/I27JU=;
	b=oiCpZRKYqP6s4AduTyBTS9AtbpkQOL69Bzg6QiuTdu7vfrKTShf4T9k8EHvFKpqjkUvh
	 MjPAyE00ZLpW/3MAXHcfuhnrNRcfalDTZ2hrJKRIg6f6NKexzFVi/+Hhr9YJhhrl5jMlo
	 QCGD2bFNG/JOQULOO2SME7BA9BpGhNajJbCdVHd8qbk5W0vMKIfxCDGBgmUSzfWp/Lfxp
	 6gYtwoJ/1Mue5UWNIHaUm7eiHTaY+Yxfpabv3wtvGC/ucCbx/Ff+0m1iXm466elziBE8R
	 bsKOk7ZEHIk/idXbCeSYJb3FgWJE4QLLMZpA4eu55r7Qlt/A+pLsVqkhphGOnDb/NFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2V+ceaf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B1606A31C;
	Thu, 19 Nov 2026 02:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2V+ceaf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5401F000C4;
	Thu, 19 Nov 2026 02:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054712;
	bh=FOpS1CdlPFkVfF1cv3sxRmYJwJz0e1CVvUDS2/I27JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2V+ceafiMEVKbTgg+Xl9LQZZcTDz5/lFVbPmdt45ROphR40IXXQBlmcGOwMCDPJq
	 hCYmv5IIJsLO6BHeRzJXKqCvMg5awwjE7AhiSkX3CEMGVIurADTUJbgRzRmN5vu7rB
	 ewW/whFl3zzExtt2ttYSdxTb1DynxKaXHHVzv7jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1370/2214] clk: fix self-consuming provider module pinning
Date: Wed, 18 Nov 2026 15:50:46 +0100
Message-ID: <20261118150106.231153342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit a1c8d531c694e193dc48ef2428877d5ea2e35134 ]

clk_hw_get_clk() lets a provider get a struct clk for one of its own
struct clk_hw.

When a struct clk is created, the module usage count of the provider
is unconditionally increased. For a self-consuming provider, this means
it pins itself and the module can never be unloaded.

Increasing the module usage count should only be done when the consumer
lives in a different module from the provider. Use THIS_MODULE to
capture caller's module and increase the module usage count accordingly.

It is OK for consumer-only APIs such as clk_get() or of_clk_get() to
pass a NULL owner. As a result, any provider module will get pinned,
same as before.

Fixes: 30d6f8c15d2c ("clk: add api to get clk consumer from clk_hw")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c            | 46 ++++++++++++++++++++----------------
 drivers/clk/clk.h            |  5 ++--
 drivers/clk/clkdev.c         |  4 ++--
 include/linux/clk-provider.h | 22 ++++++++++++++---
 4 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 13f7e2ea644d9..ea5980206c49e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -108,6 +108,7 @@ struct clk {
 	unsigned long max_rate;
 	unsigned int exclusive_count;
 	struct hlist_node clks_node;
+	bool pinning;
 };
 
 /***           runtime pm          ***/
@@ -3825,13 +3826,15 @@ static void free_clk(struct clk *clk)
  * @hw: clk_hw associated with the clk being consumed
  * @dev_id: string describing device name
  * @con_id: connection ID string on device
+ * @owner: reference to the module creating the clock
  *
  * This is the main function used to create a clk pointer for use by clk
  * consumers. It connects a consumer to the clk_core and clk_hw structures
  * used by the framework and clk provider respectively.
  */
 struct clk *clk_hw_create_clk(struct device *dev, struct clk_hw *hw,
-			      const char *dev_id, const char *con_id)
+			      const char *dev_id, const char *con_id,
+			      struct module *owner)
 {
 	struct clk *clk;
 	struct clk_core *core;
@@ -3846,7 +3849,13 @@ struct clk *clk_hw_create_clk(struct device *dev, struct clk_hw *hw,
 		return clk;
 	clk->dev = dev;
 
-	if (!try_module_get(core->owner)) {
+	/*
+	 * Pin the provider module only when the consumer lives in a different
+	 * module. A provider getting a clk from its own clk_hw would otherwise
+	 * pin itself and could never be unloaded.
+	 */
+	clk->pinning = owner != core->owner;
+	if (clk->pinning && !try_module_get(core->owner)) {
 		free_clk(clk);
 		return ERR_PTR(-ENOENT);
 	}
@@ -3857,24 +3866,19 @@ struct clk *clk_hw_create_clk(struct device *dev, struct clk_hw *hw,
 	return clk;
 }
 
-/**
- * clk_hw_get_clk - get clk consumer given an clk_hw
- * @hw: clk_hw associated with the clk being consumed
- * @con_id: connection ID string on device
- *
- * Returns: new clk consumer
- * This is the function to be used by providers which need
- * to get a consumer clk and act on the clock element
- * Calls to this function must be balanced with calls clk_put()
+/*
+ * Internal helper backing the clk_hw_get_clk() macro, which passes the caller's
+ * module via THIS_MODULE.
  */
-struct clk *clk_hw_get_clk(struct clk_hw *hw, const char *con_id)
+struct clk *__clk_hw_get_clk(struct clk_hw *hw, const char *con_id,
+			     struct module *owner)
 {
 	struct device *dev = hw->core->dev;
 	const char *name = dev ? dev_name(dev) : NULL;
 
-	return clk_hw_create_clk(dev, hw, name, con_id);
+	return clk_hw_create_clk(dev, hw, name, con_id, owner);
 }
-EXPORT_SYMBOL(clk_hw_get_clk);
+EXPORT_SYMBOL(__clk_hw_get_clk);
 
 static int clk_cpy_name(const char **dst_p, const char *src, bool must_exist)
 {
@@ -4038,8 +4042,9 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 	INIT_HLIST_HEAD(&core->clks);
 
 	/*
-	 * Don't call clk_hw_create_clk() here because that would pin the
-	 * provider module to itself and prevent it from ever being removed.
+	 * Don't call clk_hw_create_clk() here because it would systematically
+	 * add a consumer to the hw clock and all clocks would appear to have
+	 * consumer in the clock summary.
 	 */
 	hw->clk = alloc_clk(core, NULL, NULL);
 	if (IS_ERR(hw->clk)) {
@@ -4429,7 +4434,7 @@ struct clk *devm_clk_hw_get_clk(struct device *dev, struct clk_hw *hw,
 	if (!clkp)
 		return ERR_PTR(-ENOMEM);
 
-	clk = clk_hw_get_clk(hw, con_id);
+	clk = __clk_hw_get_clk(hw, con_id, dev->driver->owner);
 	if (!IS_ERR(clk)) {
 		*clkp = clk;
 		devres_add(dev, clkp);
@@ -4475,7 +4480,8 @@ void __clk_put(struct clk *clk)
 
 	owner = clk->core->owner;
 	kref_put(&clk->core->ref, __clk_release);
-	module_put(owner);
+	if (clk->pinning)
+		module_put(owner);
 	free_clk(clk);
 }
 
@@ -5022,7 +5028,7 @@ struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
 	struct clk_hw *hw = of_clk_get_hw_from_clkspec(clkspec);
 
-	return clk_hw_create_clk(NULL, hw, NULL, __func__);
+	return clk_hw_create_clk(NULL, hw, NULL, __func__, NULL);
 }
 EXPORT_SYMBOL_GPL(of_clk_get_from_provider);
 
@@ -5049,7 +5055,7 @@ static struct clk *__of_clk_get(struct device_node *np,
 {
 	struct clk_hw *hw = of_clk_get_hw(np, index, con_id);
 
-	return clk_hw_create_clk(NULL, hw, dev_id, con_id);
+	return clk_hw_create_clk(NULL, hw, dev_id, con_id, NULL);
 }
 
 struct clk *of_clk_get(struct device_node *np, int index)
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 2d801900cad59..5009380863a9d 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -23,13 +23,14 @@ struct clk_hw *clk_find_hw(const char *dev_id, const char *con_id);
 
 #ifdef CONFIG_COMMON_CLK
 struct clk *clk_hw_create_clk(struct device *dev, struct clk_hw *hw,
-			      const char *dev_id, const char *con_id);
+			      const char *dev_id, const char *con_id,
+			      struct module *owner);
 void __clk_put(struct clk *clk);
 #else
 /* All these casts to avoid ifdefs in clkdev... */
 static inline struct clk *
 clk_hw_create_clk(struct device *dev, struct clk_hw *hw, const char *dev_id,
-		  const char *con_id)
+		  const char *con_id, struct module *owner)
 {
 	return (struct clk *)hw;
 }
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 67f601a410239..a9bc963f1c3e8 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -88,7 +88,7 @@ static struct clk *__clk_get_sys(struct device *dev, const char *dev_id,
 {
 	struct clk_hw *hw = clk_find_hw(dev_id, con_id);
 
-	return clk_hw_create_clk(dev, hw, dev_id, con_id);
+	return clk_hw_create_clk(dev, hw, dev_id, con_id, NULL);
 }
 
 struct clk *clk_get_sys(const char *dev_id, const char *con_id)
@@ -105,7 +105,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 	if (dev && dev->of_node) {
 		hw = of_clk_get_hw(dev->of_node, 0, con_id);
 		if (!IS_ERR(hw) || PTR_ERR(hw) == -EPROBE_DEFER)
-			return clk_hw_create_clk(dev, hw, dev_id, con_id);
+			return clk_hw_create_clk(dev, hw, dev_id, con_id, NULL);
 	}
 
 	return __clk_get_sys(dev, dev_id, con_id);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7d5ca15ac66ba..5149fcf16fa2e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -37,6 +37,7 @@ struct clk;
 struct clk_hw;
 struct clk_core;
 struct dentry;
+struct module;
 
 /**
  * struct clk_rate_request - Structure encoding the clk constraints that
@@ -302,8 +303,9 @@ struct clk_init_data {
  * @core: pointer to the struct clk_core instance that points back to this
  * struct clk_hw instance
  *
- * @clk: pointer to the per-user struct clk instance that can be used to call
- * into the clk API
+ * @clk: pointer to the per-user struct clk instance. This will be removed at
+ * some point in the future, Please consider the field obsolete and do not use
+ * it. Use clk_hw_get_clk() to get a per-user struct clk from a struct clk_hw.
  *
  * @init: pointer to struct clk_init_data that contains the init data shared
  * with the common clock framework. This pointer will be set to NULL once
@@ -1202,10 +1204,24 @@ static inline struct clk_hw *__clk_get_hw(struct clk *clk)
 }
 #endif
 
-struct clk *clk_hw_get_clk(struct clk_hw *hw, const char *con_id);
+struct clk *__clk_hw_get_clk(struct clk_hw *hw, const char *con_id,
+			     struct module *owner);
 struct clk *devm_clk_hw_get_clk(struct device *dev, struct clk_hw *hw,
 				const char *con_id);
 
+/**
+ * clk_hw_get_clk - get clk consumer given a clk_hw
+ * @hw: clk_hw associated with the clk being consumed
+ * @con_id: connection ID string on device
+ *
+ * Return: new clk consumer
+ * This is the function to be used by providers which need
+ * to get a consumer clk and act on the clock element
+ * Calls to this function must be balanced with calls to clk_put()
+ */
+#define clk_hw_get_clk(hw, con_id) \
+	__clk_hw_get_clk((hw), (con_id), THIS_MODULE)
+
 unsigned int clk_hw_get_num_parents(const struct clk_hw *hw);
 struct clk_hw *clk_hw_get_parent(const struct clk_hw *hw);
 struct clk_hw *clk_hw_get_parent_by_index(const struct clk_hw *hw,
-- 
2.53.0



