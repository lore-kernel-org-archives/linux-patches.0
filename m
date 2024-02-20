Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598FB152DED;
	Tue, 20 Feb 2024 21:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464468; cv=none; b=ZYDRe/ZZZ1516BMtchH8bl4ACi8bVXu1ETAyCR+TAYlpKNzDWf6KCA/t1mWQgwqLqA9fMg91zMTsN1fjcr+QOsGc673bndapc5p7Oe043qSz5hAsGmLjiW01VDS2vTFFizp9MRNTWuAzlQEhUOlK2D/i9H26gFqx25p59px24Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464468; c=relaxed/simple;
	bh=bnU+ya6pCbyORJHTXvfVPbaJVoKRABs3NKOOWlot77s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcnyaEwnyTaiEWrsQW6CMh/shRbNkO1QGzudghepzEwuI40nLcWGXkA/IsASAifhbxzQBOOLUPYorvwgmO3kptiPDJtX/HEKq0rlc8D5fxv3V73y4Mmbfu9vOxndwJw3Thq8dCWX9qgJLC40j0U3+EN7hYaYRccHmt+m4boa1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lonoI3te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lonoI3te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE873C433F1;
	Tue, 20 Feb 2024 21:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464468;
	bh=bnU+ya6pCbyORJHTXvfVPbaJVoKRABs3NKOOWlot77s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lonoI3te6kh2ZUTJy3mEaKFuZI3Eb/01BZZFtX7tACIIbG4pNHuwIHp5LaWai8pJs
	 dczIJbXd5ar4KQEqG6W1uf78JtrWKAG8IAdd339OEbD+ZydCyKeF0GUkLDDfWf6QlP
	 X+2V+BJN8xYTivenfUZTP8aL2fObvi35xryKK6pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 035/309] of: property: Improve finding the consumer of a remote-endpoint property
Date: Tue, 20 Feb 2024 21:53:14 +0100
Message-ID: <20240220205634.281431582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit f4653ec9861cd96a1a6a3258c4a807898ee8cf3c ]

We have a more accurate function to find the right consumer of a
remote-endpoint property instead of searching for a parent with
compatible string property. So, use that instead. While at it, make the
code to find the consumer a bit more flexible and based on the property
being parsed.

Fixes: f7514a663016 ("of: property: fw_devlink: Add support for remote-endpoint")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20240207011803.2637531-2-saravanak@google.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 47 +++++++++----------------------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index afdaefbd03f6..41c3da8a54b6 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1062,36 +1062,6 @@ of_fwnode_device_get_match_data(const struct fwnode_handle *fwnode,
 	return of_device_get_match_data(dev);
 }
 
-static struct device_node *of_get_compat_node(struct device_node *np)
-{
-	of_node_get(np);
-
-	while (np) {
-		if (!of_device_is_available(np)) {
-			of_node_put(np);
-			np = NULL;
-		}
-
-		if (of_property_present(np, "compatible"))
-			break;
-
-		np = of_get_next_parent(np);
-	}
-
-	return np;
-}
-
-static struct device_node *of_get_compat_node_parent(struct device_node *np)
-{
-	struct device_node *parent, *node;
-
-	parent = of_get_parent(np);
-	node = of_get_compat_node(parent);
-	of_node_put(parent);
-
-	return node;
-}
-
 static void of_link_to_phandle(struct device_node *con_np,
 			      struct device_node *sup_np)
 {
@@ -1221,10 +1191,10 @@ static struct device_node *parse_##fname(struct device_node *np,	     \
  * @parse_prop.prop_name: Name of property holding a phandle value
  * @parse_prop.index: For properties holding a list of phandles, this is the
  *		      index into the list
+ * @get_con_dev: If the consumer node containing the property is never converted
+ *		 to a struct device, implement this ops so fw_devlink can use it
+ *		 to find the true consumer.
  * @optional: Describes whether a supplier is mandatory or not
- * @node_not_dev: The consumer node containing the property is never converted
- *		  to a struct device. Instead, parse ancestor nodes for the
- *		  compatible property to find a node corresponding to a device.
  *
  * Returns:
  * parse_prop() return values are
@@ -1235,8 +1205,8 @@ static struct device_node *parse_##fname(struct device_node *np,	     \
 struct supplier_bindings {
 	struct device_node *(*parse_prop)(struct device_node *np,
 					  const char *prop_name, int index);
+	struct device_node *(*get_con_dev)(struct device_node *np);
 	bool optional;
-	bool node_not_dev;
 };
 
 DEFINE_SIMPLE_PROP(clocks, "clocks", "#clock-cells")
@@ -1351,7 +1321,10 @@ static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_pinctrl6, },
 	{ .parse_prop = parse_pinctrl7, },
 	{ .parse_prop = parse_pinctrl8, },
-	{ .parse_prop = parse_remote_endpoint, .node_not_dev = true, },
+	{
+		.parse_prop = parse_remote_endpoint,
+		.get_con_dev = of_graph_get_port_parent,
+	},
 	{ .parse_prop = parse_pwms, },
 	{ .parse_prop = parse_resets, },
 	{ .parse_prop = parse_leds, },
@@ -1402,8 +1375,8 @@ static int of_link_property(struct device_node *con_np, const char *prop_name)
 		while ((phandle = s->parse_prop(con_np, prop_name, i))) {
 			struct device_node *con_dev_np;
 
-			con_dev_np = s->node_not_dev
-					? of_get_compat_node_parent(con_np)
+			con_dev_np = s->get_con_dev
+					? s->get_con_dev(con_np)
 					: of_node_get(con_np);
 			matched = true;
 			i++;
-- 
2.43.0



