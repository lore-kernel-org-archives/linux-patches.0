Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83945134AC;
	Mon, 12 Aug 2024 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479917; cv=none; b=QlNJP/ut4pRquHZZHKnFJX75LhBU6QlAgA3uv5iFvZDlcXivkG8Pa3I4nXRju98a3qpd4dwua5ANxbMox6j+gZOdJSYpX2ay+IY09JWbHqPkTpEQaiFe04yPSoDJZNDqAVpVr9/+i6D1dgj4b6H2My2N46sQ7sRsunSJECpgJXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479917; c=relaxed/simple;
	bh=VQoEggnSULYq+Rl8/ZJuzCeBKYfV61eQGL4uqmyxxSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXVn6Y9VMlB6A1YwK7EyNoxVR6ndxNFrAra5MWNlXdSTARlrVNtKwiSEz0W7n3AmbKXZdY1QWdCWuaSelMMlkVRQPLUGMLim/HJpBQh1mApA9j4zLBsIokqIbTIkAj+Jl5ijKbROvQ6I27yOLD0d180BwMpIyfepZK1Efk8UtqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N52mXqX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N52mXqX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC05C32782;
	Mon, 12 Aug 2024 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479917;
	bh=VQoEggnSULYq+Rl8/ZJuzCeBKYfV61eQGL4uqmyxxSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N52mXqX0bbq15XrjIbZS4CkdCyAXJtDwnkYVIKy1O1k6UgVH96CB4mGMr20xZ+rky
	 d2B7k+PQBIXusqiATp2Qql3XUgp0ZwYnctpidA4FXUGao5mp4W3m9CbQyP+KODj3LJ
	 JYnwaXyAgl6/0Nj2ZgeDQ2vNYpIX8LL1OOs2YGP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 040/263] regmap: kunit: Fix memory leaks in gen_regmap() and gen_raw_regmap()
Date: Mon, 12 Aug 2024 18:00:41 +0200
Message-ID: <20240812160148.079531281@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit c3820641da87442251e0c00b6874ef1022da8f58 ]

- Use kunit_kcalloc() to allocate the defaults table so that it will be
  freed when the test case ends.
- kfree() the buf and *data buffers on the error paths.
- Use kunit_add_action_or_reset() instead of kunit_add_action() so that
  if it fails it will call regmap_exit().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://msgid.link/r/20240411103724.54063-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-kunit.c | 72 +++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/base/regmap/regmap-kunit.c b/drivers/base/regmap/regmap-kunit.c
index be32cd4e84da4..292e86f601978 100644
--- a/drivers/base/regmap/regmap-kunit.c
+++ b/drivers/base/regmap/regmap-kunit.c
@@ -145,9 +145,9 @@ static struct regmap *gen_regmap(struct kunit *test,
 	const struct regmap_test_param *param = test->param_value;
 	struct regmap_test_priv *priv = test->priv;
 	unsigned int *buf;
-	struct regmap *ret;
+	struct regmap *ret = ERR_PTR(-ENOMEM);
 	size_t size;
-	int i;
+	int i, error;
 	struct reg_default *defaults;
 
 	config->cache_type = param->cache;
@@ -172,15 +172,17 @@ static struct regmap *gen_regmap(struct kunit *test,
 
 	*data = kzalloc(sizeof(**data), GFP_KERNEL);
 	if (!(*data))
-		return ERR_PTR(-ENOMEM);
+		goto out_free;
 	(*data)->vals = buf;
 
 	if (config->num_reg_defaults) {
-		defaults = kcalloc(config->num_reg_defaults,
-				   sizeof(struct reg_default),
-				   GFP_KERNEL);
+		defaults = kunit_kcalloc(test,
+					 config->num_reg_defaults,
+					 sizeof(struct reg_default),
+					 GFP_KERNEL);
 		if (!defaults)
-			return ERR_PTR(-ENOMEM);
+			goto out_free;
+
 		config->reg_defaults = defaults;
 
 		for (i = 0; i < config->num_reg_defaults; i++) {
@@ -190,12 +192,19 @@ static struct regmap *gen_regmap(struct kunit *test,
 	}
 
 	ret = regmap_init_ram(priv->dev, config, *data);
-	if (IS_ERR(ret)) {
-		kfree(buf);
-		kfree(*data);
-	} else {
-		kunit_add_action(test, regmap_exit_action, ret);
-	}
+	if (IS_ERR(ret))
+		goto out_free;
+
+	/* This calls regmap_exit() on failure, which frees buf and *data */
+	error = kunit_add_action_or_reset(test, regmap_exit_action, ret);
+	if (error)
+		ret = ERR_PTR(error);
+
+	return ret;
+
+out_free:
+	kfree(buf);
+	kfree(*data);
 
 	return ret;
 }
@@ -1497,9 +1506,9 @@ static struct regmap *gen_raw_regmap(struct kunit *test,
 	struct regmap_test_priv *priv = test->priv;
 	const struct regmap_test_param *param = test->param_value;
 	u16 *buf;
-	struct regmap *ret;
+	struct regmap *ret = ERR_PTR(-ENOMEM);
 	size_t size = (config->max_register + 1) * config->reg_bits / 8;
-	int i;
+	int i, error;
 	struct reg_default *defaults;
 
 	config->cache_type = param->cache;
@@ -1515,15 +1524,16 @@ static struct regmap *gen_raw_regmap(struct kunit *test,
 
 	*data = kzalloc(sizeof(**data), GFP_KERNEL);
 	if (!(*data))
-		return ERR_PTR(-ENOMEM);
+		goto out_free;
 	(*data)->vals = (void *)buf;
 
 	config->num_reg_defaults = config->max_register + 1;
-	defaults = kcalloc(config->num_reg_defaults,
-			   sizeof(struct reg_default),
-			   GFP_KERNEL);
+	defaults = kunit_kcalloc(test,
+				 config->num_reg_defaults,
+				 sizeof(struct reg_default),
+				 GFP_KERNEL);
 	if (!defaults)
-		return ERR_PTR(-ENOMEM);
+		goto out_free;
 	config->reg_defaults = defaults;
 
 	for (i = 0; i < config->num_reg_defaults; i++) {
@@ -1536,7 +1546,8 @@ static struct regmap *gen_raw_regmap(struct kunit *test,
 			defaults[i].def = be16_to_cpu(buf[i]);
 			break;
 		default:
-			return ERR_PTR(-EINVAL);
+			ret = ERR_PTR(-EINVAL);
+			goto out_free;
 		}
 	}
 
@@ -1548,12 +1559,19 @@ static struct regmap *gen_raw_regmap(struct kunit *test,
 		config->num_reg_defaults = 0;
 
 	ret = regmap_init_raw_ram(priv->dev, config, *data);
-	if (IS_ERR(ret)) {
-		kfree(buf);
-		kfree(*data);
-	} else {
-		kunit_add_action(test, regmap_exit_action, ret);
-	}
+	if (IS_ERR(ret))
+		goto out_free;
+
+	/* This calls regmap_exit() on failure, which frees buf and *data */
+	error = kunit_add_action_or_reset(test, regmap_exit_action, ret);
+	if (error)
+		ret = ERR_PTR(error);
+
+	return ret;
+
+out_free:
+	kfree(buf);
+	kfree(*data);
 
 	return ret;
 }
-- 
2.43.0



