Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2EE11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D94C433C8;
	Mon, 28 Aug 2023 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218549;
	bh=+MHqt2axvNaAVe6EIIb74ZgLQL8RgP1BaqfNsrDZNYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYKWeSlYAYTlaaJhjti+nCweGfrm6fn4XDjGZWqvDbMGABW+rA0ltsy2kk1sRlwzr
	 m32FjVOQh+bF16SFKWFNk8FQlj3yUyxt0SAib9O4/CHAPXD6SSIje2d59mZjnua3/Q
	 irox/o9jNlgyYoz8+PaDjuJUUg8iy4nScSli3EyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/129] clk: Fix undefined reference to `clk_rate_exclusive_{get,put}
Date: Mon, 28 Aug 2023 12:13:42 +0200
Message-ID: <20230828101157.869113955@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 2746f13f6f1df7999001d6595b16f789ecc28ad1 ]

The COMMON_CLK config is not enabled in some of the architectures.
This causes below build issues:

pwm-rz-mtu3.c:(.text+0x114):
undefined reference to `clk_rate_exclusive_put'
pwm-rz-mtu3.c:(.text+0x32c):
undefined reference to `clk_rate_exclusive_get'

Fix these issues by moving clk_rate_exclusive_{get,put} inside COMMON_CLK
code block, as clk.c is enabled by COMMON_CLK.

Fixes: 55e9b8b7b806 ("clk: add clk_rate_exclusive api")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202307251752.vLfmmhYm-lkp@intel.com/
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230725175140.361479-1-biju.das.jz@bp.renesas.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/clk.h | 80 ++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 4f750c481b82b..0a2382d3f68c8 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -175,6 +175,39 @@ int clk_get_scaled_duty_cycle(struct clk *clk, unsigned int scale);
  */
 bool clk_is_match(const struct clk *p, const struct clk *q);
 
+/**
+ * clk_rate_exclusive_get - get exclusivity over the rate control of a
+ *                          producer
+ * @clk: clock source
+ *
+ * This function allows drivers to get exclusive control over the rate of a
+ * provider. It prevents any other consumer to execute, even indirectly,
+ * opereation which could alter the rate of the provider or cause glitches
+ *
+ * If exlusivity is claimed more than once on clock, even by the same driver,
+ * the rate effectively gets locked as exclusivity can't be preempted.
+ *
+ * Must not be called from within atomic context.
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_rate_exclusive_get(struct clk *clk);
+
+/**
+ * clk_rate_exclusive_put - release exclusivity over the rate control of a
+ *                          producer
+ * @clk: clock source
+ *
+ * This function allows drivers to release the exclusivity it previously got
+ * from clk_rate_exclusive_get()
+ *
+ * The caller must balance the number of clk_rate_exclusive_get() and
+ * clk_rate_exclusive_put() calls.
+ *
+ * Must not be called from within atomic context.
+ */
+void clk_rate_exclusive_put(struct clk *clk);
+
 #else
 
 static inline int clk_notifier_register(struct clk *clk,
@@ -221,6 +254,13 @@ static inline bool clk_is_match(const struct clk *p, const struct clk *q)
 	return p == q;
 }
 
+static inline int clk_rate_exclusive_get(struct clk *clk)
+{
+	return 0;
+}
+
+static inline void clk_rate_exclusive_put(struct clk *clk) {}
+
 #endif
 
 /**
@@ -364,38 +404,6 @@ struct clk *devm_clk_get(struct device *dev, const char *id);
  */
 struct clk *devm_get_clk_from_child(struct device *dev,
 				    struct device_node *np, const char *con_id);
-/**
- * clk_rate_exclusive_get - get exclusivity over the rate control of a
- *                          producer
- * @clk: clock source
- *
- * This function allows drivers to get exclusive control over the rate of a
- * provider. It prevents any other consumer to execute, even indirectly,
- * opereation which could alter the rate of the provider or cause glitches
- *
- * If exlusivity is claimed more than once on clock, even by the same driver,
- * the rate effectively gets locked as exclusivity can't be preempted.
- *
- * Must not be called from within atomic context.
- *
- * Returns success (0) or negative errno.
- */
-int clk_rate_exclusive_get(struct clk *clk);
-
-/**
- * clk_rate_exclusive_put - release exclusivity over the rate control of a
- *                          producer
- * @clk: clock source
- *
- * This function allows drivers to release the exclusivity it previously got
- * from clk_rate_exclusive_get()
- *
- * The caller must balance the number of clk_rate_exclusive_get() and
- * clk_rate_exclusive_put() calls.
- *
- * Must not be called from within atomic context.
- */
-void clk_rate_exclusive_put(struct clk *clk);
 
 /**
  * clk_enable - inform the system when the clock source should be running.
@@ -665,14 +673,6 @@ static inline void clk_bulk_put(int num_clks, struct clk_bulk_data *clks) {}
 
 static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
 
-
-static inline int clk_rate_exclusive_get(struct clk *clk)
-{
-	return 0;
-}
-
-static inline void clk_rate_exclusive_put(struct clk *clk) {}
-
 static inline int clk_enable(struct clk *clk)
 {
 	return 0;
-- 
2.40.1



