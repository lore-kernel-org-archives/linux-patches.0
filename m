Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157412459EA;
	Tue, 29 Apr 2025 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947534; cv=none; b=r30bIgkFMYb3P3FkCwLeTgyvBPO6unBEoPBm2G6OoCqOC0/qCAl+pvIXFaD8XgR6u0nrjJCxmnkE70A4r2bC/CEEb8l6sYHOxN/nSk3WSoYy8RWjRkhgbZ+Gn+XswGkmKP7K65iQ8fFnoKvVnOeP76r9G/1iuPagusVXoy3L4c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947534; c=relaxed/simple;
	bh=11qJrq7XFR9MtHfpBjR+U0JXIUyHYmwDOTn5gXeghEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLCEqqA+3jkzuaZiglOdc9aPtMALUOxA+rCEkERXSSWNYXXeJrqzPaD8AHjQwHJMlGy+1loozGi5AUOxJrqAEevbisnWktFLDmHCdMQvulCOvQYgQzCxyAXM+m6yWWNzxw8z8t8ezrrBpdTmci9EECIQnXDNcpUdXqMPP4NqYd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDyx72m3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDyx72m3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7867BC4CEE3;
	Tue, 29 Apr 2025 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947534;
	bh=11qJrq7XFR9MtHfpBjR+U0JXIUyHYmwDOTn5gXeghEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDyx72m3wXd7Bj0SNWkxqIg8esjTDih1jCohXulLZ2mHJzwGb616GPh68bQ8MwxgF
	 xo5hmiNoejp4vqAVkFE+qNF2grYYCdEc3U6VoIYR8AeJlVZLeAIOMQkYfJjTOPOcII
	 48AZ8dqmR0u1kDGIhTwzwC9HNFYwv5oIkB/wPh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/280] of: resolver: Simplify of_resolve_phandles() using __free()
Date: Tue, 29 Apr 2025 18:39:26 +0200
Message-ID: <20250429161116.134873836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5cf96776dd7d3..fce8bdac45f3e 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -250,24 +250,20 @@ static int adjust_local_phandle_references(struct device_node *local_fixups,
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



