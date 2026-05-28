Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE23619A288;
	Thu, 28 May 2026 20:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999974; cv=none; b=UJowVE1bK1Lvbx6ToRWcVt08hDtHJfZgdQNfkDql/qrlmJ+eJ+IHJt9UZTrJYrcXwZI1XMgwiK/wVxuF+3sO0Xc6oNAloM5IjBVWOeUY0SKdoZemRh9AmbaeJLd6I9gYjp19fb7pvID6tI8fsWql9hry8FtWbxgnpfBqzUKgzXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999974; c=relaxed/simple;
	bh=e9Jd6lTqp56ea9q8wNyLVsInld3IfK9v1SXCOK1fLIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCgVdfYjW54TvjXP4tYBrnlSmKzHIVFNw5uTfqenNKAIgoV8Aqp8g5mmOt50nUrg7zn7nIkiEYn3aYKEuy+z4IQT6qKnvIuocMnGyY7lXDGd/UV7eGX2XA7Fd9FiBAhullE6uj10JeYbiplg+NTLbJ2vPGO8MjytcHN3W9gJegU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBDU+fIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBDU+fIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D301F000E9;
	Thu, 28 May 2026 20:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999973;
	bh=On62PtwMVViC4YNRZI7i+Hsbdems+9xrfs//CYX5J9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBDU+fIf+JkterGvKVPNvXOLiaxc0FeJjXIWlGZQz0E0lGXjdBvgCZThLpu8nmHMW
	 1mKV+uuxt3YdI57pOPIDwq8d7V7y/QhwbCb26dRLqBxVi70NX/eALsx3ZlK9IMBaXz
	 Y6JBXbAc5DtnWIEmBlHstlPd8rAi0mIhzTLkCrJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 257/377] net: shaper: flip the polarity of the valid flag
Date: Thu, 28 May 2026 21:48:15 +0200
Message-ID: <20260528194645.812480364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7cee43fcb0c3f71441d2faaa8c2202b6a88b6bef ]

The usual way of inserting entries which are not yet fully ready
into XArray is to have a VALID flag. The shaper code has a NOT_VALID
flag. Since XArray code does not let us create entries with marks
already set - the creation of entries is currently not atomic.

Flip the polarity of the VALID flag. This closes the tiny race
in net_shaper_pre_insert() of entries being created without
the NOT_VALID flag.

Fixes: 93954b40f6a4 ("net-shapers: implement NL set and delete operations")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-2-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index e41a82241230d..64c9d6cf6756c 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -275,11 +275,13 @@ static void net_shaper_default_parent(const struct net_shaper_handle *handle,
 	parent->id = 0;
 }
 
-/*
- * MARK_0 is already in use due to XA_FLAGS_ALLOC, can't reuse such flag as
- * it's cleared by xa_store().
+/* MARK_0 is already in use due to XA_FLAGS_ALLOC. The VALID mark is set on
+ * an entry only after the device-side configuration has completed
+ * successfully (see net_shaper_commit()). Lookups and dumps must filter on
+ * this mark to avoid exposing tentative entries inserted by
+ * net_shaper_pre_insert() while the driver call is still in flight.
  */
-#define NET_SHAPER_NOT_VALID XA_MARK_1
+#define NET_SHAPER_VALID	XA_MARK_1
 
 static struct net_shaper *
 net_shaper_lookup(struct net_shaper_binding *binding,
@@ -289,8 +291,8 @@ net_shaper_lookup(struct net_shaper_binding *binding,
 	struct net_shaper_hierarchy *hierarchy;
 
 	hierarchy = net_shaper_hierarchy_rcu(binding);
-	if (!hierarchy || xa_get_mark(&hierarchy->shapers, index,
-				      NET_SHAPER_NOT_VALID))
+	if (!hierarchy || !xa_get_mark(&hierarchy->shapers, index,
+				       NET_SHAPER_VALID))
 		return NULL;
 
 	return xa_load(&hierarchy->shapers, index);
@@ -370,13 +372,10 @@ static int net_shaper_pre_insert(struct net_shaper_binding *binding,
 		goto free_id;
 	}
 
-	/* Mark 'tentative' shaper inside the hierarchy container.
-	 * xa_set_mark is a no-op if the previous store fails.
+	/* Insert as 'tentative' (no VALID mark). The mark will be set by
+	 * net_shaper_commit() once the driver-side configuration succeeds.
 	 */
-	xa_lock(&hierarchy->shapers);
-	prev = __xa_store(&hierarchy->shapers, index, cur, GFP_KERNEL);
-	__xa_set_mark(&hierarchy->shapers, index, NET_SHAPER_NOT_VALID);
-	xa_unlock(&hierarchy->shapers);
+	prev = xa_store(&hierarchy->shapers, index, cur, GFP_KERNEL);
 	if (xa_err(prev)) {
 		NL_SET_ERR_MSG(extack, "Can't insert shaper into device store");
 		kfree_rcu(cur, rcu);
@@ -413,8 +412,7 @@ static void net_shaper_commit(struct net_shaper_binding *binding,
 		/* Successful update: drop the tentative mark
 		 * and update the hierarchy container.
 		 */
-		__xa_clear_mark(&hierarchy->shapers, index,
-				NET_SHAPER_NOT_VALID);
+		__xa_set_mark(&hierarchy->shapers, index, NET_SHAPER_VALID);
 		*cur = shapers[i];
 	}
 	xa_unlock(&hierarchy->shapers);
@@ -431,8 +429,9 @@ static void net_shaper_rollback(struct net_shaper_binding *binding)
 		return;
 
 	xa_lock(&hierarchy->shapers);
-	xa_for_each_marked(&hierarchy->shapers, index, cur,
-			   NET_SHAPER_NOT_VALID) {
+	xa_for_each(&hierarchy->shapers, index, cur) {
+		if (xa_get_mark(&hierarchy->shapers, index, NET_SHAPER_VALID))
+			continue;
 		__xa_erase(&hierarchy->shapers, index);
 		kfree(cur);
 	}
@@ -836,7 +835,8 @@ int net_shaper_nl_get_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 
 	for (; (shaper = xa_find(&hierarchy->shapers, &ctx->start_index,
-				 U32_MAX, XA_PRESENT)); ctx->start_index++) {
+				 U32_MAX, NET_SHAPER_VALID));
+	     ctx->start_index++) {
 		ret = net_shaper_fill_one(skb, binding, shaper, info);
 		if (ret)
 			break;
-- 
2.53.0



