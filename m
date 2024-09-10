Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B29199953;
	Tue, 10 Sep 2024 10:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962980; cv=none; b=C0oakOWDgplbAKqYS4DUMCacJpVlj6RTewXfyucwm0YbVVeRgnNDnEFGkj6MrGLjQhSlOYxvEK/UNMDsUO0mQ/ZyQREvwji4WzvQZvARe8KTk7yrOshIGd3Fn+1jtNAs9A6vrulfN9RHbFtp2EWLkY8od+itF6R9oYh30Y/EVP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962980; c=relaxed/simple;
	bh=JYawUfj5gmK6ulpQxhez81vH9+n7pi6G5wDp5wLWmDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB2AgXAzyQWMwBivBLfZl7+q/JM34WYdOyDwEMVwKZO8xXzfZKEdakR0MukX+fzEs13fgYz6To5CzxWI3iEM0XGqNrXOIIksZNFT8U2vYcWGWPlj9pdi/BF7k8e3XDhPpTyCFHd9OrcQonRJ7irUa0M99I1pJvTUZamBMC8Eyns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbhCFjCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbhCFjCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE15AC4CEC6;
	Tue, 10 Sep 2024 10:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962980;
	bh=JYawUfj5gmK6ulpQxhez81vH9+n7pi6G5wDp5wLWmDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbhCFjCDx4mTUgILNrKRjCx5bIWi71fGAhtznUZlfzxa1LVVKSgmlk3vrk/UR2plH
	 bT0NmPCxZkBmsQIum3T53ykV6xAybIL57UK8RGe0An9yuZzaLkvr6Fva09eytb6yrw
	 RAM4nFS5w/jLBX9UpAZepMR969c86uc+TN7KFwF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/192] regulator: Add of_regulator_bulk_get_all
Date: Tue, 10 Sep 2024 11:31:41 +0200
Message-ID: <20240910092601.148076324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 27b9ecc7a9ba1d0014779bfe5a6dbf630899c6e7 ]

It work exactly like regulator_bulk_get() but instead of working on a
provided list of names, it seek all consumers properties matching
xxx-supply.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Link: https://lore.kernel.org/r/20221115073603.3425396-2-clabbe@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1a5caec7f80c ("regulator: core: Stub devm_regulator_bulk_get_const() if !CONFIG_REGULATOR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c   | 92 ++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |  8 +++
 2 files changed, 100 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index cd726d4e8fbf..c3571781a8cc 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -701,3 +701,95 @@ struct regulator_dev *of_parse_coupled_regulator(struct regulator_dev *rdev,
 
 	return c_rdev;
 }
+
+/*
+ * Check if name is a supply name according to the '*-supply' pattern
+ * return 0 if false
+ * return length of supply name without the -supply
+ */
+static int is_supply_name(const char *name)
+{
+	int strs, i;
+
+	strs = strlen(name);
+	/* string need to be at minimum len(x-supply) */
+	if (strs < 8)
+		return 0;
+	for (i = strs - 6; i > 0; i--) {
+		/* find first '-' and check if right part is supply */
+		if (name[i] != '-')
+			continue;
+		if (strcmp(name + i + 1, "supply") != 0)
+			return 0;
+		return i;
+	}
+	return 0;
+}
+
+/*
+ * of_regulator_bulk_get_all - get multiple regulator consumers
+ *
+ * @dev:	Device to supply
+ * @np:		device node to search for consumers
+ * @consumers:  Configuration of consumers; clients are stored here.
+ *
+ * @return number of regulators on success, an errno on failure.
+ *
+ * This helper function allows drivers to get several regulator
+ * consumers in one operation.  If any of the regulators cannot be
+ * acquired then any regulators that were allocated will be freed
+ * before returning to the caller.
+ */
+int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
+			      struct regulator_bulk_data **consumers)
+{
+	int num_consumers = 0;
+	struct regulator *tmp;
+	struct property *prop;
+	int i, n = 0, ret;
+	char name[64];
+
+	*consumers = NULL;
+
+	/*
+	 * first pass: get numbers of xxx-supply
+	 * second pass: fill consumers
+	 */
+restart:
+	for_each_property_of_node(np, prop) {
+		i = is_supply_name(prop->name);
+		if (i == 0)
+			continue;
+		if (!*consumers) {
+			num_consumers++;
+			continue;
+		} else {
+			memcpy(name, prop->name, i);
+			name[i] = '\0';
+			tmp = regulator_get(dev, name);
+			if (!tmp) {
+				ret = -EINVAL;
+				goto error;
+			}
+			(*consumers)[n].consumer = tmp;
+			n++;
+			continue;
+		}
+	}
+	if (*consumers)
+		return num_consumers;
+	if (num_consumers == 0)
+		return 0;
+	*consumers = kmalloc_array(num_consumers,
+				   sizeof(struct regulator_bulk_data),
+				   GFP_KERNEL);
+	if (!*consumers)
+		return -ENOMEM;
+	goto restart;
+
+error:
+	while (--n >= 0)
+		regulator_put(consumers[n]->consumer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(of_regulator_bulk_get_all);
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index a9ca87a8f4e6..40c80c844ce5 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -244,6 +244,8 @@ int regulator_disable_deferred(struct regulator *regulator, int ms);
 
 int __must_check regulator_bulk_get(struct device *dev, int num_consumers,
 				    struct regulator_bulk_data *consumers);
+int __must_check of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
+					   struct regulator_bulk_data **consumers);
 int __must_check devm_regulator_bulk_get(struct device *dev, int num_consumers,
 					 struct regulator_bulk_data *consumers);
 void devm_regulator_bulk_put(struct regulator_bulk_data *consumers);
@@ -479,6 +481,12 @@ static inline int devm_regulator_bulk_get(struct device *dev, int num_consumers,
 	return 0;
 }
 
+static inline int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
+					    struct regulator_bulk_data **consumers)
+{
+	return 0;
+}
+
 static inline int regulator_bulk_enable(int num_consumers,
 					struct regulator_bulk_data *consumers)
 {
-- 
2.43.0



