Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D57E326D44;
	Tue, 21 Jul 2026 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655827; cv=none; b=ErsYSpn/o6cWmCQmZw9KkPXHKHJH008jKwEz8g4kDs97TX3/jKoe2++TDxLshoyGTx4pzZIyH0GxLi2OoKTD+uvML/M0EcV/3c8sAJBrBJnWz6KaBv1zF8qRZSI5HZ1RBPMnDHA+MJvyi3J4t1VW2Pue8N7+yQ+AuRzXU9G3tc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655827; c=relaxed/simple;
	bh=nl8TgvldY2Of1tfuNlK2jBa55mQsBoPT18mla8naTCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWh2ijj88r725MlkWlw2CEkk9XM8PpaiNji1poSLmXHmjOHq760a4wI6hS3CgKUOayLMPPuHMWItNGLyuQ9nbLToYnAb+G9a/2fWWvLTpj3F61DY7uvnr1Ycp4MSCr7cGbQteMtFjwXtFR/n3ptngGCxBBfaWQ/HNTN6SihuHCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMSNrPoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMSNrPoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106AE1F000E9;
	Tue, 21 Jul 2026 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655826;
	bh=/tZnXuzdmycaosM6M9ORWeCgWRdoxLYG84aUsR1jfsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMSNrPoHY99MfE5bkr9z41vUqkMmhchBX+wnA2f2QJv24oMyOysYxXRO9k+ysasuc
	 P/1gOM0qV1K9Vzpkdv92bRRWFbD31rJPowmqhF6dQ1PeBdKiaj3+mMairABmpr20wS
	 TxvUHEmV566B01LG0vGC9SbyZIfSdg7DZ4QYDyu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0157/1611] RDMA/mlx5: Fix devx subscribe-event unwind NULL dereference
Date: Tue, 21 Jul 2026 17:04:33 +0200
Message-ID: <20260721152518.412842463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 8b506417ad2fbe..dfeffbacea2249 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1899,6 +1899,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
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
@@ -2146,10 +2157,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 
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
@@ -2164,9 +2182,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 		}
 
 		event_sub->cookie = cookie;
-		event_sub->ev_file = ev_file;
-		/* May be needed upon cleanup the devx object/subscription */
-		event_sub->xa_key_level1 = key_level1;
 		event_sub->xa_key_level2 = obj_id;
 		INIT_LIST_HEAD(&event_sub->obj_list);
 	}
@@ -2211,10 +2226,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
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



