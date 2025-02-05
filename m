Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98951519AA;
	Wed,  5 Feb 2025 14:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764299; cv=none; b=NUvO2X6U9o9/4DT/QnyXnG75D8ym3uuhoFE61uAYItoaoqRnudQTh/2/otnClSoKG9S8v2JZcHCbicWy4W7wy95IcbLTkK/wDFAoXI0uZIgF5o+e9OT4OlJbgC5SBd8slwVisYI2ShUXnlMHo0OJqgean9R1M83lFzz55EXDS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764299; c=relaxed/simple;
	bh=3So5dhYeksbqW1JJ1JWPA0Wv3l3ZG0LCHxXJA5kE9QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLQpwV/U8CLrae415c+xLM/oKDsGP+N30DXDWqN7enSh6usjqewUDM6h1sAuWkm1+LBwE2QKx1ZVqIOGp3IV60AEQSaZtnLkmYXis5S6CE/Rrcidr+9JNoMjwkdPa1Y/OqlPE+bd8wOXeoZCQZCdB6S0SnTOPkd32vNtV0I2TRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNqNdLVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNqNdLVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287BBC4CED1;
	Wed,  5 Feb 2025 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764299;
	bh=3So5dhYeksbqW1JJ1JWPA0Wv3l3ZG0LCHxXJA5kE9QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNqNdLVRCFKZ6mBahkCyo6gUzlUCcaatLjBIC2917Kgx+Rp2Sp1fJbuvNZD9qqxWY
	 au1HmwxrWFgtHufjDwuDOLpcbsk0bDJ+vK5WOWv5LGiyForyGCvXcRlW1f69p4K1oh
	 /JmYj2Vv0npediJKdGSHdC5u6rMkJRnyBK2U5Q4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/623] OPP: add index check to assert to avoid buffer overflow in _read_freq()
Date: Wed,  5 Feb 2025 14:36:47 +0100
Message-ID: <20250205134458.711994203@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit d659bc68ed489022ea33342cfbda2911a81e7a0d ]

Pass the freq index to the assert function to make sure
we do not read a freq out of the opp->rates[] table when called
from the indexed variants:
dev_pm_opp_find_freq_exact_indexed() or
dev_pm_opp_find_freq_ceil/floor_indexed().

Add a secondary parameter to the assert function, unused
for assert_single_clk() then add assert_clk_index() which
will check for the clock index when called from the _indexed()
find functions.

Fixes: 142e17c1c2b4 ("OPP: Introduce dev_pm_opp_find_freq_{ceil/floor}_indexed() APIs")
Fixes: a5893928bb17 ("OPP: Add dev_pm_opp_find_freq_exact_indexed()")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 0311b18319a45..cf32e642da027 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -101,11 +101,21 @@ struct opp_table *_find_opp_table(struct device *dev)
  * representation in the OPP table and manage the clock configuration themselves
  * in an platform specific way.
  */
-static bool assert_single_clk(struct opp_table *opp_table)
+static bool assert_single_clk(struct opp_table *opp_table,
+			      unsigned int __always_unused index)
 {
 	return !WARN_ON(opp_table->clk_count > 1);
 }
 
+/*
+ * Returns true if clock table is large enough to contain the clock index.
+ */
+static bool assert_clk_index(struct opp_table *opp_table,
+			     unsigned int index)
+{
+	return opp_table->clk_count > index;
+}
+
 /**
  * dev_pm_opp_get_voltage() - Gets the voltage corresponding to an opp
  * @opp:	opp for which voltage has to be returned for
@@ -499,12 +509,12 @@ static struct dev_pm_opp *_opp_table_find_key(struct opp_table *opp_table,
 		unsigned long (*read)(struct dev_pm_opp *opp, int index),
 		bool (*compare)(struct dev_pm_opp **opp, struct dev_pm_opp *temp_opp,
 				unsigned long opp_key, unsigned long key),
-		bool (*assert)(struct opp_table *opp_table))
+		bool (*assert)(struct opp_table *opp_table, unsigned int index))
 {
 	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	/* Assert that the requirement is met */
-	if (assert && !assert(opp_table))
+	if (assert && !assert(opp_table, index))
 		return ERR_PTR(-EINVAL);
 
 	mutex_lock(&opp_table->lock);
@@ -532,7 +542,7 @@ _find_key(struct device *dev, unsigned long *key, int index, bool available,
 	  unsigned long (*read)(struct dev_pm_opp *opp, int index),
 	  bool (*compare)(struct dev_pm_opp **opp, struct dev_pm_opp *temp_opp,
 			  unsigned long opp_key, unsigned long key),
-	  bool (*assert)(struct opp_table *opp_table))
+	  bool (*assert)(struct opp_table *opp_table, unsigned int index))
 {
 	struct opp_table *opp_table;
 	struct dev_pm_opp *opp;
@@ -555,7 +565,7 @@ _find_key(struct device *dev, unsigned long *key, int index, bool available,
 static struct dev_pm_opp *_find_key_exact(struct device *dev,
 		unsigned long key, int index, bool available,
 		unsigned long (*read)(struct dev_pm_opp *opp, int index),
-		bool (*assert)(struct opp_table *opp_table))
+		bool (*assert)(struct opp_table *opp_table, unsigned int index))
 {
 	/*
 	 * The value of key will be updated here, but will be ignored as the
@@ -568,7 +578,7 @@ static struct dev_pm_opp *_find_key_exact(struct device *dev,
 static struct dev_pm_opp *_opp_table_find_key_ceil(struct opp_table *opp_table,
 		unsigned long *key, int index, bool available,
 		unsigned long (*read)(struct dev_pm_opp *opp, int index),
-		bool (*assert)(struct opp_table *opp_table))
+		bool (*assert)(struct opp_table *opp_table, unsigned int index))
 {
 	return _opp_table_find_key(opp_table, key, index, available, read,
 				   _compare_ceil, assert);
@@ -577,7 +587,7 @@ static struct dev_pm_opp *_opp_table_find_key_ceil(struct opp_table *opp_table,
 static struct dev_pm_opp *_find_key_ceil(struct device *dev, unsigned long *key,
 		int index, bool available,
 		unsigned long (*read)(struct dev_pm_opp *opp, int index),
-		bool (*assert)(struct opp_table *opp_table))
+		bool (*assert)(struct opp_table *opp_table, unsigned int index))
 {
 	return _find_key(dev, key, index, available, read, _compare_ceil,
 			 assert);
@@ -586,7 +596,7 @@ static struct dev_pm_opp *_find_key_ceil(struct device *dev, unsigned long *key,
 static struct dev_pm_opp *_find_key_floor(struct device *dev,
 		unsigned long *key, int index, bool available,
 		unsigned long (*read)(struct dev_pm_opp *opp, int index),
-		bool (*assert)(struct opp_table *opp_table))
+		bool (*assert)(struct opp_table *opp_table, unsigned int index))
 {
 	return _find_key(dev, key, index, available, read, _compare_floor,
 			 assert);
@@ -647,7 +657,8 @@ struct dev_pm_opp *
 dev_pm_opp_find_freq_exact_indexed(struct device *dev, unsigned long freq,
 				   u32 index, bool available)
 {
-	return _find_key_exact(dev, freq, index, available, _read_freq, NULL);
+	return _find_key_exact(dev, freq, index, available, _read_freq,
+			       assert_clk_index);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_exact_indexed);
 
@@ -707,7 +718,8 @@ struct dev_pm_opp *
 dev_pm_opp_find_freq_ceil_indexed(struct device *dev, unsigned long *freq,
 				  u32 index)
 {
-	return _find_key_ceil(dev, freq, index, true, _read_freq, NULL);
+	return _find_key_ceil(dev, freq, index, true, _read_freq,
+			      assert_clk_index);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil_indexed);
 
@@ -760,7 +772,7 @@ struct dev_pm_opp *
 dev_pm_opp_find_freq_floor_indexed(struct device *dev, unsigned long *freq,
 				   u32 index)
 {
-	return _find_key_floor(dev, freq, index, true, _read_freq, NULL);
+	return _find_key_floor(dev, freq, index, true, _read_freq, assert_clk_index);
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor_indexed);
 
@@ -1702,7 +1714,7 @@ void dev_pm_opp_remove(struct device *dev, unsigned long freq)
 	if (IS_ERR(opp_table))
 		return;
 
-	if (!assert_single_clk(opp_table))
+	if (!assert_single_clk(opp_table, 0))
 		goto put_table;
 
 	mutex_lock(&opp_table->lock);
@@ -2054,7 +2066,7 @@ int _opp_add_v1(struct opp_table *opp_table, struct device *dev,
 	unsigned long tol, u_volt = data->u_volt;
 	int ret;
 
-	if (!assert_single_clk(opp_table))
+	if (!assert_single_clk(opp_table, 0))
 		return -EINVAL;
 
 	new_opp = _opp_allocate(opp_table);
@@ -2810,7 +2822,7 @@ static int _opp_set_availability(struct device *dev, unsigned long freq,
 		return r;
 	}
 
-	if (!assert_single_clk(opp_table)) {
+	if (!assert_single_clk(opp_table, 0)) {
 		r = -EINVAL;
 		goto put_table;
 	}
@@ -2886,7 +2898,7 @@ int dev_pm_opp_adjust_voltage(struct device *dev, unsigned long freq,
 		return r;
 	}
 
-	if (!assert_single_clk(opp_table)) {
+	if (!assert_single_clk(opp_table, 0)) {
 		r = -EINVAL;
 		goto put_table;
 	}
-- 
2.39.5



