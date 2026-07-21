Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1ED44AB6A;
	Tue, 21 Jul 2026 21:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668801; cv=none; b=BbLBZYToOIAhFyW0OYoRCXjVlQqNqNrOue171Qy+Sxvlyt281gUfCzmK7vyfu04svHOVSmfwSlinGZGe0X9td2QwIlvEv2PpbK9t+y7VjmWuLkxqGweZeMvhvIHwGOwXEzoEjT3v8zNRzyABRytKmNbHMDeiBXCXRb++l2jg5Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668801; c=relaxed/simple;
	bh=kI81iJcUi3BCH6OKj8ADB4do5lQfnVgRmCaBeMhGS60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZO6Mwb30HA9BMw5eygQVdY7xjISWwYfZIDWroQTnX3YSuFYNWvXzrDm9Bd24dwS86cwELJGO0cj2Zk9nMPk1iRlNQEm49ZELB/zSevWO4ayW5bzygeu5tjEuWH1xRfK/qvpRLkKmI5dkYRBYCCKfX/I9yA8ekkrzxYoEpfyIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkoA7uLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkoA7uLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BB41F000E9;
	Tue, 21 Jul 2026 21:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668800;
	bh=KeNPWbZkg+cLA9tEy2tG0R50j9InvQzgHP06fsHHADg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkoA7uLrtiuqF3RyT/Q8KSKw3GCzuBNfHtVMbOS1V1ArI2scnvZW8xAAjG+Jkb7Ev
	 db8zs/fkxS1WXyE4GOU7SPJ/K/YdjaymlVAZROP3BdU7Sf5/J5hfjByStq4ThyTdMU
	 Qzk3WRazDtsJlvb3iYAsznJEmArVgZnS64Ytlq2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0313/1067] RDMA/mlx5: Fix devx subscribe-event unwind NULL dereference
Date: Tue, 21 Jul 2026 17:15:14 +0200
Message-ID: <20260721152431.594707766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit 43f8f7946814c8e5f464518246fdbc69b6e32326 ]

MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT() links event_sub into sub_list
before initializing the fields used by the shared error path.

If eventfd_ctx_fdget() then fails, the unwind path dereferences
event_sub->ev_file in uverbs_uobject_put() and calls
subscribe_event_xa_dealloc() with an unset xa_key_level1.

subscribe_event_xa_alloc() creates the XA entry exactly once for a given
key_level1, on the first occurrence of that key. The unwind path must
therefore call subscribe_event_xa_dealloc() exactly once for it as well.

Enforce that by adding devx_key_in_sub_list() and calling
subscribe_event_xa_dealloc() only when the last matching pending entry is
being cleaned up.

Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20260428224319.37682-1-prathameshdeshpande7@gmail.com
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 80c26551564fb3..06bd84bffdf74d 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1851,6 +1851,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	return err;
 }
 
+static bool devx_key_in_sub_list(struct list_head *list, u32 key_level1)
+{
+	struct devx_event_subscription *s;
+
+	list_for_each_entry(s, list, event_list)
+		if (s->xa_key_level1 == key_level1)
+			return true;
+
+	return false;
+}
+
 static void
 subscribe_event_xa_dealloc(struct mlx5_devx_event_table *devx_event_table,
 			   u32 key_level1,
@@ -2100,10 +2111,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 		num_alloc_xa_entries++;
 		event_sub = kzalloc(sizeof(*event_sub), GFP_KERNEL);
 		if (!event_sub) {
+			if (!devx_key_in_sub_list(&sub_list, key_level1))
+				subscribe_event_xa_dealloc(devx_event_table,
+							   key_level1,
+							   obj,
+							   obj_id);
 			err = -ENOMEM;
 			goto err;
 		}
 
+		event_sub->ev_file = ev_file;
+		event_sub->xa_key_level1 = key_level1;
 		list_add_tail(&event_sub->event_list, &sub_list);
 		uverbs_uobject_get(&ev_file->uobj);
 		if (use_eventfd) {
@@ -2118,9 +2136,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 		}
 
 		event_sub->cookie = cookie;
-		event_sub->ev_file = ev_file;
-		/* May be needed upon cleanup the devx object/subscription */
-		event_sub->xa_key_level1 = key_level1;
 		event_sub->xa_key_level2 = obj_id;
 		INIT_LIST_HEAD(&event_sub->obj_list);
 	}
@@ -2165,10 +2180,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 	list_for_each_entry_safe(event_sub, tmp_sub, &sub_list, event_list) {
 		list_del(&event_sub->event_list);
 
-		subscribe_event_xa_dealloc(devx_event_table,
-					   event_sub->xa_key_level1,
-					   obj,
-					   obj_id);
+		if (!devx_key_in_sub_list(&sub_list, event_sub->xa_key_level1))
+			subscribe_event_xa_dealloc(devx_event_table,
+						   event_sub->xa_key_level1,
+						   obj,
+						   obj_id);
 
 		if (event_sub->eventfd)
 			eventfd_ctx_put(event_sub->eventfd);
-- 
2.53.0



