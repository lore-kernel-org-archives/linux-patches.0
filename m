Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018038;
	b=HnMjyZxjNKlEdnBBMLEkXpElVgUI9+9CRRvz5TIagWcS8nOgPhQWUuUBSqHnBX5c0zMo
	 MBD6m5hC+2PSL5KNptk3OHHKihgJC3jjzp/JSKnBBlfuaPAqh7jCjIXGX84sKYsnx0lvn
	 9gmQENIPJimAKaIJ7f0N76brgM1pkJh+oKQ/YnkFXmbcWcZSEx+pivkfjEw4OjXg8gZxA
	 G8uKCnT0AaJl6rFuW1+nO/OnkJYKlMyVLB8tc/wsL0+oUe7ZZjJ08zuDFBfn8uamaiimf
	 Ce5RLKEXS+LJuVWwEmWzV/L6jCWocDNU6Nyr41P9/jhuT5BJ+bz/vxjMl0EGlMLaYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWlhzHALa/4+xJdWp/ayjUxkQfE1qFe6fuam1d8necQ=;
	b=ptZ1hkj4NcR7wlBoFriCluL7ygk8/VwMDyFV8rpRB4GUfNiFDxeL0MLJD+ShL3wvWS48
	 w2d480lNpRBd9DxRtUk9PIrK28sNFfe1zcSRp7p8bHbm3C+q4qr5kakHUzxH1nFVRjp5q
	 a7rhXMD5dmxZ/HhzFB4QRPIwf/tPu81IPveuPUd2e2LVGIoVekie1TsH1fXFUJjm5i0t8
	 Vr5SCjruPSfFTdT5cCbtr39eLgvI1zXdWYPxG5JT+483WdCa0JvH1oAQjMTHcBxy6wgR3
	 wDyTJLiWwZ5TvYTq9OPhiYoZNaHdR7RF5UQXflnGmzZ1ybTGHNT5rc6ClR0319fpmsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3OuZ0Mb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4083E60A2609;
	Wed, 18 Nov 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3OuZ0Mb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7351F000C7;
	Wed, 18 Nov 2026 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018038;
	bh=OWlhzHALa/4+xJdWp/ayjUxkQfE1qFe6fuam1d8necQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3OuZ0MbUMoc3ITxxJ5Efgo57lteaHj79Xo66X4jN/XupwH6Z6z3qji9KMgemxkv7
	 tn8oLXYeMeDD/Y04U/qdQ9eBhBY5IiFeRbmBlZnQRG8R+EGdEaAbwBDstcUXGSapSE
	 IZ8/WNXi6wbTJdtHHResavJNi+yj+EbWWCvvYhKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chancel Liu <chancel.liu@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1099/2651] pinctrl: pinctrl-generic-mux: Fix provider resource leak on re-parse
Date: Wed, 18 Nov 2026 15:38:59 +0100
Message-ID: <20261118150327.562414226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 707855c21198c6a0b73efa053ac4fe733cbe1985 ]

The pinctrl core re-parses a consumer's pinctrl on every probe attempt
(pinctrl_bind_pins() runs before the driver's probe(), and again on each
deferred-probe retry or re-bind), so .dt_node_to_map() must be side-effect
free and safe to call repeatedly.

mux_pinmux_dt_node_to_map() instead allocated provider-side resources on
every call - the mux_pin_function, the group name table and a mux_state
reference, plus a group name and a pinctrl_generic_add_group()
registration via pinctrl_generic_to_map(). All of these are allocated
with devm_*() against the provider device, so they live for the provider's
lifetime and are only released when the provider itself is unbound. The
.dt_free_map() path never touches them; it frees the per-consumer
pinctrl_map only. Every re-parse therefore adds another set of
provider-side allocations that are never reclaimed, so a consumer that
repeatedly defers probe or is re-bound leaks memory and mux_state
references on the provider without bound.

The groups and functions of a board-level mux are static and fully
described by the device tree, so build them once at probe time in the new
mux_pinctrl_probe_dt(). mux_pinmux_dt_node_to_map() then only looks up the
already registered group and builds the per-consumer mux map, which the
core frees via .dt_free_map. As the mux has no pin electrical
configuration, no config map is emitted.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260824022020.2812810-1-chancel.liu%40oss.nxp.com
Fixes: 34acc5a8adfb ("pinctrl: add generic board-level pinctrl driver using mux framework")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-generic-mux.c | 76 ++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-generic-mux.c b/drivers/pinctrl/pinctrl-generic-mux.c
index 202b72351efb7..de85b4e75eb80 100644
--- a/drivers/pinctrl/pinctrl-generic-mux.c
+++ b/drivers/pinctrl/pinctrl-generic-mux.c
@@ -10,13 +10,11 @@
 #include <linux/mutex.h>
 #include <linux/mux/consumer.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/slab.h>
 
 #include "core.h"
-#include "pinconf.h"
 #include "pinmux.h"
 #include "pinctrl-utils.h"
 
@@ -38,39 +36,73 @@ mux_pinmux_dt_node_to_map(struct pinctrl_dev *pctldev,
 			  struct pinctrl_map **maps, unsigned int *num_maps)
 {
 	unsigned int num_reserved_maps = 0;
-	struct mux_pin_function *function;
-	const char **group_names;
 	int ret;
 
-	function = devm_kzalloc(pctldev->dev, sizeof(*function), GFP_KERNEL);
-	if (!function)
-		return -ENOMEM;
-
-	group_names = devm_kcalloc(pctldev->dev, 1, sizeof(*group_names), GFP_KERNEL);
-	if (!group_names)
-		return -ENOMEM;
-
-	function->mux_state = devm_mux_state_get_from_np(pctldev->dev, NULL, np_config);
-	if (IS_ERR(function->mux_state))
-		return PTR_ERR(function->mux_state);
+	*maps = NULL;
+	*num_maps = 0;
 
-	ret = pinctrl_generic_to_map(pctldev, np_config, np_config, maps,
-				     num_maps, &num_reserved_maps, group_names,
-				     0, &np_config->name, NULL, 0);
+	if (pinctrl_get_group_selector(pctldev, np_config->name) < 0)
+		return -ENODEV;
 
+	ret = pinctrl_utils_reserve_map(pctldev, maps, &num_reserved_maps,
+					num_maps, 1);
 	if (ret)
 		return ret;
 
-	ret = pinmux_generic_add_function(pctldev, np_config->name, group_names,
-					  1, function);
+	ret = pinctrl_utils_add_map_mux(pctldev, maps, &num_reserved_maps,
+					num_maps, np_config->name,
+					np_config->name);
 	if (ret < 0) {
 		pinctrl_utils_free_map(pctldev, *maps, *num_maps);
+		*maps = NULL;
+		*num_maps = 0;
 		return ret;
 	}
 
 	return 0;
 }
 
+static int mux_pinctrl_probe_dt(struct pinctrl_dev *pctldev,
+				struct device_node *np)
+{
+	struct device *dev = pctldev->dev;
+
+	for_each_available_child_of_node_scoped(np, grp) {
+		struct mux_pin_function *function;
+		const char **group_names;
+		int ret;
+
+		function = devm_kzalloc(dev, sizeof(*function), GFP_KERNEL);
+		if (!function)
+			return -ENOMEM;
+
+		group_names = devm_kcalloc(dev, 1, sizeof(*group_names), GFP_KERNEL);
+		if (!group_names)
+			return -ENOMEM;
+
+		group_names[0] = grp->name;
+
+		function->mux_state = devm_mux_state_get_from_np(dev, NULL, grp);
+		if (IS_ERR(function->mux_state))
+			return dev_err_probe(dev, PTR_ERR(function->mux_state),
+					     "failed to get mux-state for %pOFn\n",
+					     grp);
+
+		ret = pinctrl_generic_add_group(pctldev, grp->name, NULL, 0, NULL);
+		if (ret < 0)
+			return dev_err_probe(dev, ret,
+					     "failed to add group %pOFn\n", grp);
+
+		ret = pinmux_generic_add_function(pctldev, grp->name, group_names,
+						  1, function);
+		if (ret < 0)
+			return dev_err_probe(dev, ret,
+					     "failed to add function %pOFn\n", grp);
+	}
+
+	return 0;
+}
+
 static const struct pinctrl_ops mux_pinctrl_ops = {
 	.get_groups_count = pinctrl_generic_get_group_count,
 	.get_group_name = pinctrl_generic_get_group_name,
@@ -157,6 +189,10 @@ static int mux_pinctrl_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to register pinctrl.\n");
 
+	ret = mux_pinctrl_probe_dt(mpctl->pctl, dev->of_node);
+	if (ret)
+		return ret;
+
 	ret = pinctrl_enable(mpctl->pctl);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to enable pinctrl.\n");
-- 
2.53.0



