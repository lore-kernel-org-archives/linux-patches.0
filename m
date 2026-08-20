Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C965E33263B;
	Thu, 20 Aug 2026 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238247; cv=none; b=nShhgUiM5/3ihQKky26ISZUGDruHVGnuLv87KSCVuMKMNNg2Z6ZffokbDJR54Kik8+w3TyVjOOWO7b0v3lAsTV0dAHRokyqTnqKAJLOUov9FnlNfibwDwaBT3cYSfnbmvH7/+CkcXn6hj8ZLY5/8VWjXQFK4xkzUWfGzOYShMNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238247; c=relaxed/simple;
	bh=QnlUYuluotI8reCf10qt3NnyvJ5vFSwVGYr6v/WKVxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsU71IzSjiuSTkWmqfc96T/NtRSio/a+sQvPk++Ns93YTgWNF95PzkNK1/UP0qtjFy5ItIT9K+V/g/RLrcCn70Udl3ZVm18zbnzGkRvSHKFBVg8ampcFX4pQ1ah7FxrdePNVpSVeTyXAUF2C6UiHUmGigadYtW8rUgDZSznLQ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki+U1om9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki+U1om9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A921F000E9;
	Thu, 20 Aug 2026 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238246;
	bh=G9SYm4ogrXl02Ob0IhoAYiCGoNAobfp0B1hTwMDEpWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ki+U1om9xj+8CaTz3sMuePXuULscNeljKsg4u8QkBvWUi/JHQJwnyKjfsL4cFb2WL
	 HON3M3k62vqgs7DCmQ3/Snjbv/QmuMSPGUJrVrPtpBdUzuxTpUA2lxJuW3GsaY6loO
	 m6G07zgCYmSyPXgP1tsipG5+84in5WXvSz+XtmoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 081/228] pmdomain: mediatek: fix remaining %pOF after of_node_put()
Date: Thu, 20 Aug 2026 16:53:43 +0200
Message-ID: <20260820145246.933018343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 3e013bc8b941bd52c8e3a99798d0ae8792cb71ca upstream.

scpsys_get_bus_protection_legacy() looks up several legacy bus
protection regmaps from device-tree nodes.

Two error paths put the device node before checking whether the regmap
lookup failed, but still pass that node to dev_err_probe() with %pOF on
failure. If of_node_put() drops the last reference, the later %pOF
formatting can dereference a freed device node.

Keep the node reference until after the error message has been emitted in
the infracfg and SMI lookup paths. Also drop the SMI node before
returning when the SMI phandle is missing.

Fixes: c29345fa5f66 ("pmdomain: mediatek: Refactor bus protection regmaps retrieval")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -1058,12 +1058,15 @@ static int scpsys_get_bus_protection_leg
 	node = of_find_node_with_property(np, "mediatek,infracfg");
 	if (node) {
 		regmap[0] = syscon_regmap_lookup_by_phandle(node, "mediatek,infracfg");
-		of_node_put(node);
 		num_regmaps++;
-		if (IS_ERR(regmap[0]))
-			return dev_err_probe(dev, PTR_ERR(regmap[0]),
+		if (IS_ERR(regmap[0])) {
+			ret = dev_err_probe(dev, PTR_ERR(regmap[0]),
 					     "%pOF: failed to get infracfg regmap\n",
 					     node);
+			of_node_put(node);
+			return ret;
+		}
+		of_node_put(node);
 	} else {
 		regmap[0] = NULL;
 	}
@@ -1072,17 +1075,22 @@ static int scpsys_get_bus_protection_leg
 	node = of_find_node_with_property(np, "mediatek,smi");
 	if (node) {
 		smi_np = of_parse_phandle(node, "mediatek,smi", 0);
-		of_node_put(node);
-		if (!smi_np)
+		if (!smi_np) {
+			of_node_put(node);
 			return -ENODEV;
+		}
 
 		regmap[1] = device_node_to_regmap(smi_np);
 		num_regmaps++;
 		of_node_put(smi_np);
-		if (IS_ERR(regmap[1]))
-			return dev_err_probe(dev, PTR_ERR(regmap[1]),
+		if (IS_ERR(regmap[1])) {
+			ret = dev_err_probe(dev, PTR_ERR(regmap[1]),
 					     "%pOF: failed to get SMI regmap\n",
 					     node);
+			of_node_put(node);
+			return ret;
+		}
+		of_node_put(node);
 	} else {
 		regmap[1] = NULL;
 	}


