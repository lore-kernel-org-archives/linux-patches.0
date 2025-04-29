Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24540C03;
	Tue, 29 Apr 2025 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950297; cv=none; b=NTzaxZlSh4PxFflA+vDJBv9J/2qwtQA0Qh5wUnx0EtOkjoNmXe1Vh0H87pH9kiymKn5E8BlLVy8G2x5ioR32LfCVab5c2wK786vVjBraj3dq33PoqQpM8yIirGs0/qzEUNsNHrNpDRW+9QPgeJoB8GeXSDPC0YOoHcMbvEaytWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950297; c=relaxed/simple;
	bh=TiSHjUaeG8JMbKWhnGRFqROyqoIE7Cl20IGhxdqngMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baAoRSzzj6zxCxb7Wtlj8Q3u4pzb3+hyyX5d8bG+Vqs+Dm/XVpBtv36JGLokh44e4y+W5GYdTSK/DAOIaW10jp8wr7jplV9atpzM3FQxyNxtXfE8ROUQsVxfKTbYqIbXx34dHZ3U8CHbZZCtVsYfcPVlbXU8oilEfm6pGlINHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbBXnWJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbBXnWJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31BDC4CEE3;
	Tue, 29 Apr 2025 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950297;
	bh=TiSHjUaeG8JMbKWhnGRFqROyqoIE7Cl20IGhxdqngMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbBXnWJ8zaQcIjQjOVuxaRx7p/SjgCcUoD4ehBA66wpT0seG9nVmsEWWTLKRkCDo9
	 J6IPwv01SGKpIlRmTKPvNGe+U1F8bkvmIo2IkMy1WqBcL64J7Sfyd1GoZYZau/AEvD
	 hvD5sYMddU/otdYFpogpjwO5d6gd+Hu2fKhFYOjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/204] of: resolver: Simplify of_resolve_phandles() using __free()
Date: Tue, 29 Apr 2025 18:42:01 +0200
Message-ID: <20250429161100.766525691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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
index b278ab4338ceb..2dd19dc6987c7 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -263,24 +263,20 @@ static int adjust_local_phandle_references(struct device_node *local_fixups,
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
@@ -292,7 +288,7 @@ int of_resolve_phandles(struct device_node *overlay)
 
 	err = adjust_local_phandle_references(local_fixups, overlay, phandle_delta);
 	if (err)
-		goto out;
+		return err;
 
 	overlay_fixups = NULL;
 
@@ -301,16 +297,13 @@ int of_resolve_phandles(struct device_node *overlay)
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
@@ -324,14 +317,12 @@ int of_resolve_phandles(struct device_node *overlay)
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
@@ -341,11 +332,8 @@ int of_resolve_phandles(struct device_node *overlay)
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



