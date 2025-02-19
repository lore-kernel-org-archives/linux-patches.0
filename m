Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736A01CCEE7;
	Wed, 19 Feb 2025 09:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956181; cv=none; b=Vx0BASfnLgh7CyJP4ilAlvYdMtVriqRogT9Px3DcXSlCAPWcMSRB6MoBNU9x1PC2r7wtENQIzsDdm/4Ub2Q3OWdtnS0sH9mo6aHumLQVRwdjQKOKV1z9u1T2YqJznsqcFHREmqx3tnvwqW7xe8yIUv/OZRHvCB0um+E5IDO+20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956181; c=relaxed/simple;
	bh=O+8noV60ER+qfK047huXywH43ZMsl9/cA+Zs/+s8YXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcqf/JyIlS2JhbZUsOQ+grTqwQ/IRiiQiFkWo0mjmqZXR1R65JEmZbk/pxaph5h0lFs0hI4Nzy+9L+sSsLPk0HS+sOKK7aLMlfQhWJvx+6zWrONH7CVmxxaH/bkdHlVeLGGf6fviWSudZp9RsVvQXe1cLti+aElIzqPW8QPwnb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSswlfi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSswlfi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8ABC4CED1;
	Wed, 19 Feb 2025 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956181;
	bh=O+8noV60ER+qfK047huXywH43ZMsl9/cA+Zs/+s8YXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSswlfi7n7FqKjb+OkVtwrevDgDzi3kybSKzkcYEiMWfdKM0i+robIwJe5yRZi1kB
	 e4RR4+9TGnTGs+eT6ceGGPAt6I9MYW/LWFIrv9/E0DKXOWYWkD6Nj/hGf9yTFQAClI
	 l35g5aIaCGP9nilCC+QRqM8n8fgx/OA/j1r5tPQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/578] mfd: syscon: Use scoped variables with memory allocators to simplify error paths
Date: Wed, 19 Feb 2025 09:21:19 +0100
Message-ID: <20250219082655.838436358@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 82f898f47112bc7b787cb9ce8803c4e2f9f60c89 ]

Allocate the memory with scoped/cleanup.h to reduce error handling and
make the code a bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240707114823.9175-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 805f7aaf7fee ("mfd: syscon: Fix race in device_node_get_regmap()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 1ce8f6f9d7f54..cc7b07882fee4 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -8,6 +8,7 @@
  * Author: Dong Aisheng <dong.aisheng@linaro.org>
  */
 
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/hwspinlock.h>
@@ -43,7 +44,6 @@ static const struct regmap_config syscon_regmap_config = {
 static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 {
 	struct clk *clk;
-	struct syscon *syscon;
 	struct regmap *regmap;
 	void __iomem *base;
 	u32 reg_io_width;
@@ -51,20 +51,16 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	struct regmap_config syscon_config = syscon_regmap_config;
 	struct resource res;
 
-	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
+	struct syscon *syscon __free(kfree) = kzalloc(sizeof(*syscon), GFP_KERNEL);
 	if (!syscon)
 		return ERR_PTR(-ENOMEM);
 
-	if (of_address_to_resource(np, 0, &res)) {
-		ret = -ENOMEM;
-		goto err_map;
-	}
+	if (of_address_to_resource(np, 0, &res))
+		return ERR_PTR(-ENOMEM);
 
 	base = of_iomap(np, 0);
-	if (!base) {
-		ret = -ENOMEM;
-		goto err_map;
-	}
+	if (!base)
+		return ERR_PTR(-ENOMEM);
 
 	/* Parse the device's DT node for an endianness specification */
 	if (of_property_read_bool(np, "big-endian"))
@@ -139,7 +135,7 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	list_add_tail(&syscon->list, &syscon_list);
 	spin_unlock(&syscon_list_slock);
 
-	return syscon;
+	return_ptr(syscon);
 
 err_attach:
 	if (!IS_ERR(clk))
@@ -148,8 +144,6 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	regmap_exit(regmap);
 err_regmap:
 	iounmap(base);
-err_map:
-	kfree(syscon);
 	return ERR_PTR(ret);
 }
 
-- 
2.39.5



