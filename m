Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EC9352C4F;
	Tue, 10 Mar 2026 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141187; cv=none; b=DqAChtL1wNsKC491vwB/QrPNNeVw6hWpomtjoG9Zp/dcoWB65S1n0XABbf32UXJAk7sf8mSx7CvxvGVINFezhQ/FYIVKoZBhwNK899Cy5MbluFUy2kjQWphU47IrD8ulPzSWk5mmt4mVV0ZX4NOHt4w7y45NfDJ/7q4X+hs/J2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141187; c=relaxed/simple;
	bh=zAcaXmyjSRZ/cdpJJO9AYPI02gt6wzNIvpiw0uRETTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZXTPZzHUQxxeBfsNqe1u49z2+y3Ek7DH/Xpo1Rk2xf1GBzQIn0rO6TP0IfrtSImQQ5xGq/+2LqNr+3oZH5gWkYiBrLe0o60EdJVRUOkGDkDJEbuKxA3yauUJkOUBlVoI42qR4rZDaIgy1Luh9MOqJnd7L0ebBFglhkVZGNhbGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVBlPgyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVBlPgyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C0C19423;
	Tue, 10 Mar 2026 11:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141186;
	bh=zAcaXmyjSRZ/cdpJJO9AYPI02gt6wzNIvpiw0uRETTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVBlPgyODgXPfbT3V4R3cHO0ZCKuuwN41622VPrLD8HyG9jlz58GWLeR9zAx1mflP
	 2Uye/QXuD/gLcMHjsZlm1aDCI/js0TuYWXiFdl3RcZBpvZlbwE3/hDBoNfp5KTqeuS
	 EoFBfvBN1ggDB4Jb5n5wHmx+GPqcs6QbNQzH9UzR4yaBsnlzZCcQHTOBv7fTWzIYMY
	 XgygRnOvkerevBZekrRL8/nQi8jwgAMCo3Oxy+zt0NnqtnOi80DjiFxZzPeuuWDFXS
	 juLQnM9lhKehdDdqs5Wo8geQVECdflDQjD3vclrsfVvgmh5w5Wz6ObPEt3mweeZaL8
	 c+5+NeD6nIgWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Conor Dooley <conor.dooley@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 188/311] pinctrl: generic: move function to amlogic-am4 driver
Date: Tue, 10 Mar 2026 07:03:55 -0400
Message-ID: <4cf5da46942294bda67b63cb9c1cab08feb254c9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 9c5a40f2922a5a6d6b42e7b3d4c8e253918c07a1 ]

pinconf_generic_dt_node_to_map_pinmux() is not actually a generic
function, and really belongs in the amlogic-am4 driver. There are three
reasons why.

First, and least, of the reasons is that this function behaves
differently to the other dt_node_to_map functions in a way that is not
obvious from a first glance. This difference stems for the devicetree
properties that the function is intended for use with, and how they are
typically used. The other generic dt_node_to_map functions support
platforms where the pins, groups and functions are described statically
in the driver and require a function that will produce a mapping from dt
nodes to these pre-established descriptions. No other code in the driver
is require to be executed at runtime.
pinconf_generic_dt_node_to_map_pinmux() on the other hand is intended for
use with the pinmux property, where groups and functions are determined
entirely from the devicetree. As a result, there are no statically
defined groups and functions in the driver for this function to perform
a mapping to. Other drivers that use the pinmux property (e.g. the k1)
their dt_node_to_map function creates the groups and functions as the
devicetree is parsed. Instead of that,
pinconf_generic_dt_node_to_map_pinmux() requires that the devicetree is
parsed twice, once by it and once at probe, so that the driver
dynamically creates the groups and functions before the dt_node_to_map
callback is executed. I don't believe this double parsing requirement is
how developers would expect this to work and is not necessary given
there are drivers that do not have this behaviour.

Secondly and thirdly, the function bakes in some assumptions that only
really match the amlogic platform about how the devicetree is constructed.
These, to me, are problematic for something that claims to be generic.

The other dt_node_to_map implementations accept a being called for
either a node containing pin configuration properties or a node
containing child nodes that each contain the configuration properties.
IOW, they support the following two devicetree configurations:

| cfg {
| 	label: group {
| 		pinmux = <asjhdasjhlajskd>;
| 		config-item1;
| 	};
| };

| label: cfg {
| 	group1 {
| 		pinmux = <dsjhlfka>;
| 		config-item2;
| 	};
| 	group2 {
| 		pinmux = <lsdjhaf>;
| 		config-item1;
| 	};
| };

pinconf_generic_dt_node_to_map_pinmux() only supports the latter.

The other assumption about devicetree configuration that the function
makes is that the labeled node's parent is a "function node". The amlogic
driver uses these "function nodes" to create the functions at probe
time, and pinconf_generic_dt_node_to_map_pinmux() finds the parent of
the node it is operating on's name as part of the mapping. IOW, it
requires that the devicetree look like:

| pinctrl@bla {
|
| 	func-foo {
| 		label: group-default {
| 			pinmuxes = <lskdf>;
| 		};
| 	};
| };

and couldn't be used if the nodes containing the pinmux and
configuration properties are children of the pinctrl node itself:

| pinctrl@bla {
|
| 	label: group-default {
| 		pinmuxes = <lskdf>;
| 	};
| };

These final two reasons are mainly why I believe this is not suitable as
a generic function, and should be moved into the driver that is the sole
user and originator of the "generic" function.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Stable-dep-of: a2539b92e4b7 ("pinctrl: meson: amlogic-a4: Fix device node reference leak in aml_dt_node_to_map_pinmux()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 71 +++++++++++++++++++++-
 drivers/pinctrl/pinconf-generic.c          | 69 ---------------------
 include/linux/pinctrl/pinconf-generic.h    |  5 --
 3 files changed, 70 insertions(+), 75 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index 40542edd557e0..dfa32b11555cd 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -24,6 +24,7 @@
 #include <dt-bindings/pinctrl/amlogic,pinctrl.h>
 
 #include "../core.h"
+#include "../pinctrl-utils.h"
 #include "../pinconf.h"
 
 #define gpio_chip_to_bank(chip) \
@@ -672,11 +673,79 @@ static void aml_pin_dbg_show(struct pinctrl_dev *pcdev, struct seq_file *s,
 	seq_printf(s, " %s", dev_name(pcdev->dev));
 }
 
+static int aml_dt_node_to_map_pinmux(struct pinctrl_dev *pctldev,
+				     struct device_node *np,
+				     struct pinctrl_map **map,
+				     unsigned int *num_maps)
+{
+	struct device *dev = pctldev->dev;
+	struct device_node *pnode;
+	unsigned long *configs = NULL;
+	unsigned int num_configs = 0;
+	struct property *prop;
+	unsigned int reserved_maps;
+	int reserve;
+	int ret;
+
+	prop = of_find_property(np, "pinmux", NULL);
+	if (!prop) {
+		dev_info(dev, "Missing pinmux property\n");
+		return -ENOENT;
+	}
+
+	pnode = of_get_parent(np);
+	if (!pnode) {
+		dev_info(dev, "Missing function node\n");
+		return -EINVAL;
+	}
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs,
+					      &num_configs);
+	if (ret < 0) {
+		dev_err(dev, "%pOF: could not parse node property\n", np);
+		return ret;
+	}
+
+	reserve = 1;
+	if (num_configs)
+		reserve++;
+
+	ret = pinctrl_utils_reserve_map(pctldev, map, &reserved_maps,
+					num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	ret = pinctrl_utils_add_map_mux(pctldev, map,
+					&reserved_maps, num_maps, np->name,
+					pnode->name);
+	if (ret < 0)
+		goto exit;
+
+	if (num_configs) {
+		ret = pinctrl_utils_add_map_configs(pctldev, map, &reserved_maps,
+						    num_maps, np->name, configs,
+						    num_configs, PIN_MAP_TYPE_CONFIGS_GROUP);
+		if (ret < 0)
+			goto exit;
+	}
+
+exit:
+	kfree(configs);
+	if (ret)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
+	return ret;
+}
+
 static const struct pinctrl_ops aml_pctrl_ops = {
 	.get_groups_count	= aml_get_groups_count,
 	.get_group_name		= aml_get_group_name,
 	.get_group_pins		= aml_get_group_pins,
-	.dt_node_to_map		= pinconf_generic_dt_node_to_map_pinmux,
+	.dt_node_to_map		= aml_dt_node_to_map_pinmux,
 	.dt_free_map		= pinconf_generic_dt_free_map,
 	.pin_dbg_show		= aml_pin_dbg_show,
 };
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 38a8daf4a5848..2b030bd0e6adc 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -385,75 +385,6 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(pinconf_generic_parse_dt_config);
 
-int pinconf_generic_dt_node_to_map_pinmux(struct pinctrl_dev *pctldev,
-					  struct device_node *np,
-					  struct pinctrl_map **map,
-					  unsigned int *num_maps)
-{
-	struct device *dev = pctldev->dev;
-	struct device_node *pnode;
-	unsigned long *configs = NULL;
-	unsigned int num_configs = 0;
-	struct property *prop;
-	unsigned int reserved_maps;
-	int reserve;
-	int ret;
-
-	prop = of_find_property(np, "pinmux", NULL);
-	if (!prop) {
-		dev_info(dev, "Missing pinmux property\n");
-		return -ENOENT;
-	}
-
-	pnode = of_get_parent(np);
-	if (!pnode) {
-		dev_info(dev, "Missing function node\n");
-		return -EINVAL;
-	}
-
-	reserved_maps = 0;
-	*map = NULL;
-	*num_maps = 0;
-
-	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs,
-					      &num_configs);
-	if (ret < 0) {
-		dev_err(dev, "%pOF: could not parse node property\n", np);
-		return ret;
-	}
-
-	reserve = 1;
-	if (num_configs)
-		reserve++;
-
-	ret = pinctrl_utils_reserve_map(pctldev, map, &reserved_maps,
-					num_maps, reserve);
-	if (ret < 0)
-		goto exit;
-
-	ret = pinctrl_utils_add_map_mux(pctldev, map,
-					&reserved_maps, num_maps, np->name,
-					pnode->name);
-	if (ret < 0)
-		goto exit;
-
-	if (num_configs) {
-		ret = pinctrl_utils_add_map_configs(pctldev, map, &reserved_maps,
-						    num_maps, np->name, configs,
-						    num_configs, PIN_MAP_TYPE_CONFIGS_GROUP);
-		if (ret < 0)
-			goto exit;
-	}
-
-exit:
-	kfree(configs);
-	if (ret)
-		pinctrl_utils_free_map(pctldev, *map, *num_maps);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(pinconf_generic_dt_node_to_map_pinmux);
-
 int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np, struct pinctrl_map **map,
 		unsigned int *reserved_maps, unsigned int *num_maps,
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 1be4032071c23..89277808ea614 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -250,9 +250,4 @@ static inline int pinconf_generic_dt_node_to_map_all(struct pinctrl_dev *pctldev
 	return pinconf_generic_dt_node_to_map(pctldev, np_config, map, num_maps,
 			PIN_MAP_TYPE_INVALID);
 }
-
-int pinconf_generic_dt_node_to_map_pinmux(struct pinctrl_dev *pctldev,
-					  struct device_node *np,
-					  struct pinctrl_map **map,
-					  unsigned int *num_maps);
 #endif /* __LINUX_PINCTRL_PINCONF_GENERIC_H */
-- 
2.51.0

