Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F89156C76;
	Wed,  5 Feb 2025 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763770; cv=none; b=OmUdPK0zoWfhEoHVPHeON3a/tgdGnGeA5ohv/jXK85seeVQcf+4V5Ev0j8YAeMAqvd1QNWXOcimq6apXhiOr9+VFdr4PfrZi3WtCDmYpJGbln55EAtk8LVMq5CVdIYB7mispd2oI6gd3oUytdI6cnRMsHvjAvlDmQqwbOzTgNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763770; c=relaxed/simple;
	bh=KrnaoHvIRyuyYuot4uZ2jKvnYjCfcAu3Vr7puKxYbcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnAF9Gf9+ePatm02EApPlcxvn2cMkByIoVmYhoys0p2WyDY9HNts/9WfF/RyItX0APuSTaKRJShPwyWUeGx8tWUYmOAU1uHOb3QDJX92XZ1Ug66iUf1ymP+BWygaY3ilj/vCIfk4XzkSjtM4x0/7Yiz5oz7cM0wR7K5xreb9Nxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IECghdFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IECghdFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A52C4CED1;
	Wed,  5 Feb 2025 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763769;
	bh=KrnaoHvIRyuyYuot4uZ2jKvnYjCfcAu3Vr7puKxYbcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IECghdFWFVnUqqnilMfBn5u0Y/B2QMG2gv3WOzzBYaEeAhmviFRydRJWZ/q9iF0+a
	 DAT+PxO8gJzt6JWvln1ITfm5vsRWFzWgpMfdmXotgUz6VRL8BLIOr0h8MCAu2y952c
	 m+yNvNs2rMXhpjdzjHwGlEMeXEt8vsu7zg4xOCBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/393] mfd: syscon: Use scoped variables with memory allocators to simplify error paths
Date: Wed,  5 Feb 2025 14:40:23 +0100
Message-ID: <20250205134424.271780708@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 33f1e07ab24dc..2ce15f60eb107 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -8,6 +8,7 @@
  * Author: Dong Aisheng <dong.aisheng@linaro.org>
  */
 
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/hwspinlock.h>
@@ -45,7 +46,6 @@ static const struct regmap_config syscon_regmap_config = {
 static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 {
 	struct clk *clk;
-	struct syscon *syscon;
 	struct regmap *regmap;
 	void __iomem *base;
 	u32 reg_io_width;
@@ -54,20 +54,16 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	struct resource res;
 	struct reset_control *reset;
 
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
@@ -152,7 +148,7 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	list_add_tail(&syscon->list, &syscon_list);
 	spin_unlock(&syscon_list_slock);
 
-	return syscon;
+	return_ptr(syscon);
 
 err_reset:
 	reset_control_put(reset);
@@ -163,8 +159,6 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	regmap_exit(regmap);
 err_regmap:
 	iounmap(base);
-err_map:
-	kfree(syscon);
 	return ERR_PTR(ret);
 }
 
-- 
2.39.5



