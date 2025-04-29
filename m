Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7B121772B;
	Tue, 29 Apr 2025 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945687; cv=none; b=CfX82wSpzBWpx7RP0Izl3zznv62N4HAiiP1U2vDcCT0fBZa+6+uKZhDVEUPENyf5EjAyIsdmnBzIqxMdvPrZYnLJSXN0T4fAIv3B99NVoTO7rLrIVn+6EuDeaXTLDeGrHj0isnWg47pVRpAxopR2sWc2hll51FDL2tNFZ47L9cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945687; c=relaxed/simple;
	bh=gGvmWgRd5g/+aoe6dKCtotfuZsN5tClxsAkhWFIY9YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKb6AE7whpPyEWr7mcXaLvKpBq8NRoEAyxp5mtUxoOostTgOrAjZ8pZ/SVXixbFhpLpFziMNtgCXANTOrye5gxpYnEwKUltMUKxg6vPZzgIYAFHNVXTpEt1dH760tmscM3CRr+UvdO0+0i99Iy9nqUNVNQMkYc8c74PY8q29EUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGDSU1Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGDSU1Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEFAC4CEE3;
	Tue, 29 Apr 2025 16:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945686;
	bh=gGvmWgRd5g/+aoe6dKCtotfuZsN5tClxsAkhWFIY9YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGDSU1FnxFY078QmOexZ87bS88tBOo5I2tySul62R+qqC0x3QltNu1yTYz/5bhZCw
	 x3zO7QX9jRWIKHrY15mdFgIw+lRaPEtCUfamRnxgC5pRItctEhhm/02Tm9CRmBWZ1g
	 OHmxSmZ2PS/zqyfZ1mbMriJGXv2wVx/Xebd6ef7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 016/311] of: resolver: Simplify of_resolve_phandles() using __free()
Date: Tue, 29 Apr 2025 18:37:33 +0200
Message-ID: <20250429161121.696862948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 5275e8b5293f65cc82a5ee5eab02dd573b911d6e ]

Use the __free() cleanup to simplify of_resolve_phandles() and remove
all the goto's.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: a46a0805635d ("of: resolver: Fix device node refcount leakage in of_resolve_phandles()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/resolver.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index 779db058c42f5..c871e35d49217 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -250,24 +250,20 @@ static int adjust_local_phandle_references(const struct device_node *local_fixup
 int of_resolve_phandles(struct device_node *overlay)
 {
 	struct device_node *child, *local_fixups, *refnode;
-	struct device_node *tree_symbols, *overlay_fixups;
+	struct device_node *overlay_fixups;
 	struct property *prop;
 	const char *refpath;
 	phandle phandle, phandle_delta;
 	int err;
 
-	tree_symbols = NULL;
-
 	if (!overlay) {
 		pr_err("null overlay\n");
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (!of_node_check_flag(overlay, OF_DETACHED)) {
 		pr_err("overlay not detached\n");
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	phandle_delta = live_tree_max_phandle() + 1;
@@ -279,7 +275,7 @@ int of_resolve_phandles(struct device_node *overlay)
 
 	err = adjust_local_phandle_references(local_fixups, overlay, phandle_delta);
 	if (err)
-		goto out;
+		return err;
 
 	overlay_fixups = NULL;
 
@@ -288,16 +284,13 @@ int of_resolve_phandles(struct device_node *overlay)
 			overlay_fixups = child;
 	}
 
-	if (!overlay_fixups) {
-		err = 0;
-		goto out;
-	}
+	if (!overlay_fixups)
+		return 0;
 
-	tree_symbols = of_find_node_by_path("/__symbols__");
+	struct device_node __free(device_node) *tree_symbols = of_find_node_by_path("/__symbols__");
 	if (!tree_symbols) {
 		pr_err("no symbols in root of device tree.\n");
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	for_each_property_of_node(overlay_fixups, prop) {
@@ -311,14 +304,12 @@ int of_resolve_phandles(struct device_node *overlay)
 		if (err) {
 			pr_err("node label '%s' not found in live devicetree symbols table\n",
 			       prop->name);
-			goto out;
+			return err;
 		}
 
 		refnode = of_find_node_by_path(refpath);
-		if (!refnode) {
-			err = -ENOENT;
-			goto out;
-		}
+		if (!refnode)
+			return -ENOENT;
 
 		phandle = refnode->phandle;
 		of_node_put(refnode);
@@ -328,11 +319,8 @@ int of_resolve_phandles(struct device_node *overlay)
 			break;
 	}
 
-out:
 	if (err)
 		pr_err("overlay phandle fixup failed: %d\n", err);
-	of_node_put(tree_symbols);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(of_resolve_phandles);
-- 
2.39.5



