Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7155D302146;
	Mon, 13 Apr 2026 17:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099821; cv=none; b=O0D1G7iw1fzGNwE0Dr6ER1RZFukjsNWMqMKiEltrIVki5GFx8HGM3r1YiWSoVbLdp6DvjKJ76pLdnD2ElH0GVgUo014jvG1mY1ulDoP0ppEUlHiDhUrjTgAnYHe07jDKPatyu/Ea3nfJF5gv+f+zUKX0QcJa5bzyIGfR1M9Kzh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099821; c=relaxed/simple;
	bh=Jc+pmzlE0d+uy2KM5n6NakSi74tJqwbqbLxQk1PrFqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fuYuRE1dFuOiE/7WpZKd9rbz/CXrKH7Vdt5c/4IMkE1cDwN7pIcif1lOPaNLPM2hjQbLSgJONlUAqhNzRzNKeAhjGLyFpJpFWl4OqJyfESfQeyl/S65v/AU1fECLSnQwSSkud0LxauERma3XSKhE1e3fj2HDHRAVi3dejZKzlAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ckili5+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ckili5+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08935C2BCAF;
	Mon, 13 Apr 2026 17:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099821;
	bh=Jc+pmzlE0d+uy2KM5n6NakSi74tJqwbqbLxQk1PrFqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ckili5+9/Zi4DVsAuR0Ki+aZcATcVcQNuXx13UKKfpdVue9ZyrkFMM/sJ7EZ+m8zR
	 Cy1aInXL/j4TKL2GTrYNtnnlIuROrYUOlQwyJBITii9rSykYCxDVVj+XcYBYHlTrRw
	 s5X6rUzCy6EdKHKmLLF/pTo4j0/dmdFphE2+bOVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Michael Walle <michael@walle.cc>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/491] device property: Allow error pointer to be passed to fwnode APIs
Date: Mon, 13 Apr 2026 18:02:10 +0200
Message-ID: <20260413155837.211887074@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 002752af7b89b74c64fe6bec8c5fde3d3a7810d8 ]

Some of the fwnode APIs might return an error pointer instead of NULL
or valid fwnode handle. The result of such API call may be considered
optional and hence the test for it is usually done in a form of

	fwnode = fwnode_find_reference(...);
	if (IS_ERR(fwnode))
		...error handling...

Nevertheless the resulting fwnode may have bumped the reference count
and hence caller of the above API is obliged to call fwnode_handle_put().
Since fwnode may be not valid either as NULL or error pointer the check
has to be performed there. This approach uglifies the code and adds
a point of making a mistake, i.e. forgetting about error point case.

To prevent this, allow an error pointer to be passed to the fwnode APIs.

Fixes: 83b34afb6b79 ("device property: Introduce fwnode_find_reference()")
Reported-by: Nuno Sá <nuno.sa@analog.com>
Tested-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 2692c614f8f0 ("device property: Allow secondary lookup in fwnode_get_next_child_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |   89 +++++++++++++++++++++++++++---------------------
 include/linux/fwnode.h  |   10 ++---
 2 files changed, 56 insertions(+), 43 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -48,12 +48,14 @@ bool fwnode_property_present(const struc
 {
 	bool ret;
 
+	if (IS_ERR_OR_NULL(fwnode))
+		return false;
+
 	ret = fwnode_call_bool_op(fwnode, property_present, propname);
-	if (ret == false && !IS_ERR_OR_NULL(fwnode) &&
-	    !IS_ERR_OR_NULL(fwnode->secondary))
-		ret = fwnode_call_bool_op(fwnode->secondary, property_present,
-					 propname);
-	return ret;
+	if (ret)
+		return ret;
+
+	return fwnode_call_bool_op(fwnode->secondary, property_present, propname);
 }
 EXPORT_SYMBOL_GPL(fwnode_property_present);
 
@@ -233,15 +235,16 @@ static int fwnode_property_read_int_arra
 {
 	int ret;
 
+	if (IS_ERR_OR_NULL(fwnode))
+		return -EINVAL;
+
 	ret = fwnode_call_int_op(fwnode, property_read_int_array, propname,
 				 elem_size, val, nval);
-	if (ret == -EINVAL && !IS_ERR_OR_NULL(fwnode) &&
-	    !IS_ERR_OR_NULL(fwnode->secondary))
-		ret = fwnode_call_int_op(
-			fwnode->secondary, property_read_int_array, propname,
-			elem_size, val, nval);
+	if (ret != -EINVAL)
+		return ret;
 
-	return ret;
+	return fwnode_call_int_op(fwnode->secondary, property_read_int_array, propname,
+				  elem_size, val, nval);
 }
 
 /**
@@ -372,14 +375,16 @@ int fwnode_property_read_string_array(co
 {
 	int ret;
 
+	if (IS_ERR_OR_NULL(fwnode))
+		return -EINVAL;
+
 	ret = fwnode_call_int_op(fwnode, property_read_string_array, propname,
 				 val, nval);
-	if (ret == -EINVAL && !IS_ERR_OR_NULL(fwnode) &&
-	    !IS_ERR_OR_NULL(fwnode->secondary))
-		ret = fwnode_call_int_op(fwnode->secondary,
-					 property_read_string_array, propname,
-					 val, nval);
-	return ret;
+	if (ret != -EINVAL)
+		return ret;
+
+	return fwnode_call_int_op(fwnode->secondary, property_read_string_array, propname,
+				  val, nval);
 }
 EXPORT_SYMBOL_GPL(fwnode_property_read_string_array);
 
@@ -481,15 +486,19 @@ int fwnode_property_get_reference_args(c
 {
 	int ret;
 
+	if (IS_ERR_OR_NULL(fwnode))
+		return -ENOENT;
+
 	ret = fwnode_call_int_op(fwnode, get_reference_args, prop, nargs_prop,
 				 nargs, index, args);
+	if (ret == 0)
+		return ret;
 
-	if (ret < 0 && !IS_ERR_OR_NULL(fwnode) &&
-	    !IS_ERR_OR_NULL(fwnode->secondary))
-		ret = fwnode_call_int_op(fwnode->secondary, get_reference_args,
-					 prop, nargs_prop, nargs, index, args);
+	if (IS_ERR_OR_NULL(fwnode->secondary))
+		return ret;
 
-	return ret;
+	return fwnode_call_int_op(fwnode->secondary, get_reference_args, prop, nargs_prop,
+				  nargs, index, args);
 }
 EXPORT_SYMBOL_GPL(fwnode_property_get_reference_args);
 
@@ -683,12 +692,13 @@ EXPORT_SYMBOL_GPL(fwnode_count_parents);
 struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwnode,
 					    unsigned int depth)
 {
-	unsigned int i;
-
 	fwnode_handle_get(fwnode);
 
-	for (i = 0; i < depth && fwnode; i++)
+	do {
+		if (depth-- == 0)
+			break;
 		fwnode = fwnode_get_next_parent(fwnode);
+	} while (fwnode);
 
 	return fwnode;
 }
@@ -707,17 +717,17 @@ EXPORT_SYMBOL_GPL(fwnode_get_nth_parent)
 bool fwnode_is_ancestor_of(struct fwnode_handle *test_ancestor,
 				  struct fwnode_handle *test_child)
 {
-	if (!test_ancestor)
+	if (IS_ERR_OR_NULL(test_ancestor))
 		return false;
 
 	fwnode_handle_get(test_child);
-	while (test_child) {
+	do {
 		if (test_child == test_ancestor) {
 			fwnode_handle_put(test_child);
 			return true;
 		}
 		test_child = fwnode_get_next_parent(test_child);
-	}
+	} while (test_child);
 	return false;
 }
 
@@ -746,7 +756,7 @@ fwnode_get_next_available_child_node(con
 {
 	struct fwnode_handle *next_child = child;
 
-	if (!fwnode)
+	if (IS_ERR_OR_NULL(fwnode))
 		return NULL;
 
 	do {
@@ -771,16 +781,16 @@ struct fwnode_handle *device_get_next_ch
 	const struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct fwnode_handle *next;
 
+	if (IS_ERR_OR_NULL(fwnode))
+		return NULL;
+
 	/* Try to find a child in primary fwnode */
 	next = fwnode_get_next_child_node(fwnode, child);
 	if (next)
 		return next;
 
 	/* When no more children in primary, continue with secondary */
-	if (fwnode && !IS_ERR_OR_NULL(fwnode->secondary))
-		next = fwnode_get_next_child_node(fwnode->secondary, child);
-
-	return next;
+	return fwnode_get_next_child_node(fwnode->secondary, child);
 }
 EXPORT_SYMBOL_GPL(device_get_next_child_node);
 
@@ -847,6 +857,9 @@ EXPORT_SYMBOL_GPL(fwnode_handle_put);
  */
 bool fwnode_device_is_available(const struct fwnode_handle *fwnode)
 {
+	if (IS_ERR_OR_NULL(fwnode))
+		return false;
+
 	if (!fwnode_has_op(fwnode, device_is_available))
 		return true;
 
@@ -1054,14 +1067,14 @@ fwnode_graph_get_next_endpoint(const str
 		parent = fwnode_graph_get_port_parent(prev);
 	else
 		parent = fwnode;
+	if (IS_ERR_OR_NULL(parent))
+		return NULL;
 
 	ep = fwnode_call_ptr_op(parent, graph_get_next_endpoint, prev);
+	if (ep)
+		return ep;
 
-	if (IS_ERR_OR_NULL(ep) &&
-	    !IS_ERR_OR_NULL(parent) && !IS_ERR_OR_NULL(parent->secondary))
-		ep = fwnode_graph_get_next_endpoint(parent->secondary, NULL);
-
-	return ep;
+	return fwnode_graph_get_next_endpoint(parent->secondary, NULL);
 }
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -149,12 +149,12 @@ struct fwnode_operations {
 			 struct device *dev);
 };
 
-#define fwnode_has_op(fwnode, op)				\
-	((fwnode) && (fwnode)->ops && (fwnode)->ops->op)
+#define fwnode_has_op(fwnode, op)					\
+	(!IS_ERR_OR_NULL(fwnode) && (fwnode)->ops && (fwnode)->ops->op)
+
 #define fwnode_call_int_op(fwnode, op, ...)				\
-	(fwnode ? (fwnode_has_op(fwnode, op) ?				\
-		   (fwnode)->ops->op(fwnode, ## __VA_ARGS__) : -ENXIO) : \
-	 -EINVAL)
+	(fwnode_has_op(fwnode, op) ?					\
+	 (fwnode)->ops->op(fwnode, ## __VA_ARGS__) : (IS_ERR_OR_NULL(fwnode) ? -EINVAL : -ENXIO))
 
 #define fwnode_call_bool_op(fwnode, op, ...)		\
 	(fwnode_has_op(fwnode, op) ?			\


