Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945C52F260C;
	Thu, 28 May 2026 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998837; cv=none; b=UCiswU30aO7eHv5RWD5j7EXp346R7T56K4VOH7qm5dgvIGQbjnnq/lWBfS9tyo24xRs9dpksMJ5zOCDmI1vSw0PmL3Tcot1YQc65f/opLx383YB2MDx4TLd5Y5Pl13IWDsAMjwAfT1+60cFUJpdqiVISmKj7XRZV5opXrlxjiqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998837; c=relaxed/simple;
	bh=7aTyQ0enZIiRcN55XQGtEY98ONvf2pvGcwGc5M2nAAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4/RRHoGkQgi19+EeZrd6vg6syriEjc3eKDcKTj0NT2wWBaVOYL6WU5eguwNdeSYmxb6SL/GSiWDGtD2X3fmRSA+qCR+iuIjsiMLoOmplTjdplAK0gmQKvFxC7xBKEhCWjvnvHKQQVu1qHIR0D+vsayKVULxp6HZ4+RScVrERCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfG1r5f3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfG1r5f3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26401F000E9;
	Thu, 28 May 2026 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998836;
	bh=2ILk5P239ZyiHNVD6pp5VM38cBfP2GEhU/RFiPiM+hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfG1r5f3rUyZIXXjZHymD2Zravezak3ws8nUH3RTo4L6mNUJ3lGhS3CRXDz7I1UXc
	 6F9CqL/tLCVLNrvadIr7tE6cxrVAGGn0Gaszu867BtH1w4r2/TFcSkTneEuNlNAw+z
	 n7l5t46L2XJTrl+T59UfcCLC9lmi7imiQEkJCbXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 279/461] net: shaper: flip the polarity of the valid flag
Date: Thu, 28 May 2026 21:46:48 +0200
Message-ID: <20260528194655.265311137@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 1069fa4eb9f60..d2b8f1f951b19 100644
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



