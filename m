Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388B61D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A47C433C8;
	Tue, 25 Jul 2023 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282994;
	bh=M7RP5fHiDnz/6Q1wtOFuEbRhZFYz3HCyMDIRP345iCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbge7ugRTucZMflxop+uxVgw158TkgEGTALkyJJgRAGxfGf5YM6JBinTbrMkTluzQ
	 qYnY6K3EKkCWOzdWLLQZVDByqFfx+xTyU7GqQM6xE2ZxUp4FmPPhbIh7ZUByZ2TCV5
	 eCWJlLIn1Q9mifv2qG1vFhRHt2orT63Bryah+UqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/183] pinctrl: renesas: rzv2m: Handle non-unique subnode names
Date: Tue, 25 Jul 2023 12:45:21 +0200
Message-ID: <20230725104511.319913230@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f46a0b47cc0829acd050213194c5a77351e619b2 ]

The eMMC and SDHI pin control configuration nodes in DT have subnodes
with the same names ("data" and "ctrl").  As the RZ/V2M pin control
driver considers only the names of the subnodes, this leads to
conflicts:

    pinctrl-rzv2m b6250000.pinctrl: pin P8_2 already requested by 85000000.mmc; cannot claim for 85020000.mmc
    pinctrl-rzv2m b6250000.pinctrl: pin-130 (85020000.mmc) status -22
    renesas_sdhi_internal_dmac 85020000.mmc: Error applying setting, reverse things back

Fix this by constructing unique names from the node names of both the
pin control configuration node and its child node, where appropriate.

Reported by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

Fixes: 92a9b825257614af ("pinctrl: renesas: Add RZ/V2M pin and gpio controller driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://lore.kernel.org/r/607bd6ab4905b0b1b119a06ef953fa1184505777.1688396717.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzv2m.c | 28 ++++++++++++++++++-------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index e8c18198bebd2..35f382b055e83 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -207,6 +207,7 @@ static int rzv2m_map_add_config(struct pinctrl_map *map,
 
 static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 				   struct device_node *np,
+				   struct device_node *parent,
 				   struct pinctrl_map **map,
 				   unsigned int *num_maps,
 				   unsigned int *index)
@@ -224,6 +225,7 @@ static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	struct property *prop;
 	int ret, gsel, fsel;
 	const char **pin_fn;
+	const char *name;
 	const char *pin;
 
 	pinmux = of_find_property(np, "pinmux", NULL);
@@ -307,8 +309,19 @@ static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		psel_val[i] = MUX_FUNC(value);
 	}
 
+	if (parent) {
+		name = devm_kasprintf(pctrl->dev, GFP_KERNEL, "%pOFn.%pOFn",
+				      parent, np);
+		if (!name) {
+			ret = -ENOMEM;
+			goto done;
+		}
+	} else {
+		name = np->name;
+	}
+
 	/* Register a single pin group listing all the pins we read from DT */
-	gsel = pinctrl_generic_add_group(pctldev, np->name, pins, num_pinmux, NULL);
+	gsel = pinctrl_generic_add_group(pctldev, name, pins, num_pinmux, NULL);
 	if (gsel < 0) {
 		ret = gsel;
 		goto done;
@@ -318,17 +331,16 @@ static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	 * Register a single group function where the 'data' is an array PSEL
 	 * register values read from DT.
 	 */
-	pin_fn[0] = np->name;
-	fsel = pinmux_generic_add_function(pctldev, np->name, pin_fn, 1,
-					   psel_val);
+	pin_fn[0] = name;
+	fsel = pinmux_generic_add_function(pctldev, name, pin_fn, 1, psel_val);
 	if (fsel < 0) {
 		ret = fsel;
 		goto remove_group;
 	}
 
 	maps[idx].type = PIN_MAP_TYPE_MUX_GROUP;
-	maps[idx].data.mux.group = np->name;
-	maps[idx].data.mux.function = np->name;
+	maps[idx].data.mux.group = name;
+	maps[idx].data.mux.function = name;
 	idx++;
 
 	dev_dbg(pctrl->dev, "Parsed %pOF with %d pins\n", np, num_pinmux);
@@ -375,7 +387,7 @@ static int rzv2m_dt_node_to_map(struct pinctrl_dev *pctldev,
 	index = 0;
 
 	for_each_child_of_node(np, child) {
-		ret = rzv2m_dt_subnode_to_map(pctldev, child, map,
+		ret = rzv2m_dt_subnode_to_map(pctldev, child, np, map,
 					      num_maps, &index);
 		if (ret < 0) {
 			of_node_put(child);
@@ -384,7 +396,7 @@ static int rzv2m_dt_node_to_map(struct pinctrl_dev *pctldev,
 	}
 
 	if (*num_maps == 0) {
-		ret = rzv2m_dt_subnode_to_map(pctldev, np, map,
+		ret = rzv2m_dt_subnode_to_map(pctldev, np, NULL, map,
 					      num_maps, &index);
 		if (ret < 0)
 			goto done;
-- 
2.39.2



