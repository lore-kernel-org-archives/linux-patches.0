Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42CB519E0C;
	Thu, 17 Sep 2026 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666057; cv=none; b=h0f7HxKFJeNT33M+aKhWH5UtshWgVYOIfaDzGJw/RmPVVEA4WIFcCxB9RqgtdgV+Hu5bM0yipC6SQdskiWza2sWTD7m/L3z4yfyNzx4nLbnzLyqgOFfCfHydWNZ8LlAVd9JLidCdsqA1I7y72TuRfL3dsf/nATfmCy2UclnypHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666057; c=relaxed/simple;
	bh=3DH01gZyJ78jlp0sQ0Jo/Cr7cHTaupVc5OOUPVmDEa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSQJS4UUetsUFH0G+FanpV4p8SYo82Ow5Lyr2l4GTE1JXiJCpbt7lFJShFyRP3CIfPU/hmTn2vCj4+pHSqm8wJsJWgMuyEngLYa45Ncz3Vb+USCqPVvzEDUULGOLZGjoN2VmUKpuf8iZhks6iK9PECA+trSdw7cYkw/57ZERQlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pJsHKnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pJsHKnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDAD1F00899;
	Thu, 17 Sep 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666054;
	bh=8L2Upfao/a/W0ZEfam9pJSdIfYSBKzWGW2o5DUVxSMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pJsHKntljSqAux1/r+jqGOTdYwJiFWVScAETDpl85ARiG7eixuzcIdAJUPtD4YYn
	 +J+k8qz5mXHL3vVeTU93mpl0+qlv+rVXGOz1k9RfvrD6kEhMA8Va6jp+nuRESqi+1A
	 23gezb7Ev/ip2XpKY4DXvUN3FK0jdhrOwvi1lw0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0910/1250] devlink: Refactor resource functions to be generic
Date: Thu, 17 Sep 2026 16:11:45 +0100
Message-ID: <20260917151616.660179694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 7be3163c49b24bf923d32f333096963159e03a14 ]

Currently the resource functions take devlink pointer as parameter
and take the resource list from there.
Allow resource functions to work with other resource lists that will
be added in next patches and not only with the devlink's resource list.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260407194107.148063-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7f26a5e8040b ("net/mlx5e: Move representor vnic reporter to eswitch devlink port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/devlink.h  |   2 +-
 net/devlink/resource.c | 114 ++++++++++++++++++++++++++---------------
 2 files changed, 73 insertions(+), 43 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9e824f61e40f6..bfc1ba754d0d7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1828,7 +1828,7 @@ int devl_resource_register(struct devlink *devlink,
 			   u64 resource_size,
 			   u64 resource_id,
 			   u64 parent_resource_id,
-			   const struct devlink_resource_size_params *size_params);
+			   const struct devlink_resource_size_params *params);
 void devl_resources_unregister(struct devlink *devlink);
 void devlink_resources_unregister(struct devlink *devlink);
 int devl_resource_size_get(struct devlink *devlink,
diff --git a/net/devlink/resource.c b/net/devlink/resource.c
index 2d6324f3d91f2..499678e8d686e 100644
--- a/net/devlink/resource.c
+++ b/net/devlink/resource.c
@@ -36,15 +36,16 @@ struct devlink_resource {
 };
 
 static struct devlink_resource *
-devlink_resource_find(struct devlink *devlink,
-		      struct devlink_resource *resource, u64 resource_id)
+__devlink_resource_find(struct list_head *resource_list_head,
+			struct devlink_resource *resource,
+			u64 resource_id)
 {
 	struct list_head *resource_list;
 
 	if (resource)
 		resource_list = &resource->resource_list;
 	else
-		resource_list = &devlink->resource_list;
+		resource_list = resource_list_head;
 
 	list_for_each_entry(resource, resource_list, list) {
 		struct devlink_resource *child_resource;
@@ -52,14 +53,23 @@ devlink_resource_find(struct devlink *devlink,
 		if (resource->id == resource_id)
 			return resource;
 
-		child_resource = devlink_resource_find(devlink, resource,
-						       resource_id);
+		child_resource = __devlink_resource_find(resource_list_head,
+							 resource,
+							 resource_id);
 		if (child_resource)
 			return child_resource;
 	}
 	return NULL;
 }
 
+static struct devlink_resource *
+devlink_resource_find(struct devlink *devlink,
+		      struct devlink_resource *resource, u64 resource_id)
+{
+	return __devlink_resource_find(&devlink->resource_list,
+				       resource, resource_id);
+}
+
 static void
 devlink_resource_validate_children(struct devlink_resource *resource)
 {
@@ -314,26 +324,12 @@ int devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
-/**
- * devl_resource_register - devlink resource register
- *
- * @devlink: devlink
- * @resource_name: resource's name
- * @resource_size: resource's size
- * @resource_id: resource's id
- * @parent_resource_id: resource's parent id
- * @size_params: size parameters
- *
- * Generic resources should reuse the same names across drivers.
- * Please see the generic resources list at:
- * Documentation/networking/devlink/devlink-resource.rst
- */
-int devl_resource_register(struct devlink *devlink,
-			   const char *resource_name,
-			   u64 resource_size,
-			   u64 resource_id,
-			   u64 parent_resource_id,
-			   const struct devlink_resource_size_params *size_params)
+static int
+__devl_resource_register(struct devlink *devlink,
+			 struct list_head *resource_list_head,
+			 const char *resource_name, u64 resource_size,
+			 u64 resource_id, u64 parent_resource_id,
+			 const struct devlink_resource_size_params *params)
 {
 	struct devlink_resource *resource;
 	struct list_head *resource_list;
@@ -343,7 +339,8 @@ int devl_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	resource = devlink_resource_find(devlink, NULL, resource_id);
+	resource = __devlink_resource_find(resource_list_head, NULL,
+					   resource_id);
 	if (resource)
 		return -EEXIST;
 
@@ -352,12 +349,13 @@ int devl_resource_register(struct devlink *devlink,
 		return -ENOMEM;
 
 	if (top_hierarchy) {
-		resource_list = &devlink->resource_list;
+		resource_list = resource_list_head;
 	} else {
 		struct devlink_resource *parent_resource;
 
-		parent_resource = devlink_resource_find(devlink, NULL,
-							parent_resource_id);
+		parent_resource = __devlink_resource_find(resource_list_head,
+							  NULL,
+							  parent_resource_id);
 		if (parent_resource) {
 			resource_list = &parent_resource->resource_list;
 			resource->parent = parent_resource;
@@ -372,46 +370,78 @@ int devl_resource_register(struct devlink *devlink,
 	resource->size_new = resource_size;
 	resource->id = resource_id;
 	resource->size_valid = true;
-	memcpy(&resource->size_params, size_params,
-	       sizeof(resource->size_params));
+	memcpy(&resource->size_params, params, sizeof(resource->size_params));
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
 
 	return 0;
 }
+
+/**
+ * devl_resource_register - devlink resource register
+ *
+ * @devlink: devlink
+ * @resource_name: resource's name
+ * @resource_size: resource's size
+ * @resource_id: resource's id
+ * @parent_resource_id: resource's parent id
+ * @params: size parameters
+ *
+ * Generic resources should reuse the same names across drivers.
+ * Please see the generic resources list at:
+ * Documentation/networking/devlink/devlink-resource.rst
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int devl_resource_register(struct devlink *devlink, const char *resource_name,
+			   u64 resource_size, u64 resource_id,
+			   u64 parent_resource_id,
+			   const struct devlink_resource_size_params *params)
+{
+	return __devl_resource_register(devlink, &devlink->resource_list,
+					resource_name, resource_size,
+					resource_id, parent_resource_id,
+					params);
+}
 EXPORT_SYMBOL_GPL(devl_resource_register);
 
-static void devlink_resource_unregister(struct devlink *devlink,
-					struct devlink_resource *resource)
+static void devlink_resource_unregister(struct devlink_resource *resource)
 {
 	struct devlink_resource *tmp, *child_resource;
 
 	list_for_each_entry_safe(child_resource, tmp, &resource->resource_list,
 				 list) {
-		devlink_resource_unregister(devlink, child_resource);
+		devlink_resource_unregister(child_resource);
 		list_del(&child_resource->list);
 		kfree(child_resource);
 	}
 }
 
-/**
- * devl_resources_unregister - free all resources
- *
- * @devlink: devlink
- */
-void devl_resources_unregister(struct devlink *devlink)
+static void
+__devl_resources_unregister(struct devlink *devlink,
+			    struct list_head *resource_list_head)
 {
 	struct devlink_resource *tmp, *child_resource;
 
 	lockdep_assert_held(&devlink->lock);
 
-	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
+	list_for_each_entry_safe(child_resource, tmp, resource_list_head,
 				 list) {
-		devlink_resource_unregister(devlink, child_resource);
+		devlink_resource_unregister(child_resource);
 		list_del(&child_resource->list);
 		kfree(child_resource);
 	}
 }
+
+/**
+ * devl_resources_unregister - free all resources
+ *
+ * @devlink: devlink
+ */
+void devl_resources_unregister(struct devlink *devlink)
+{
+	__devl_resources_unregister(devlink, &devlink->resource_list);
+}
 EXPORT_SYMBOL_GPL(devl_resources_unregister);
 
 /**
-- 
2.53.0



