Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DC5361640;
	Thu, 20 Aug 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238208; cv=none; b=qB8lN3L0JuvlOvkVow/iotaACCKPzs8QTQ3xBgz42bkA29KVaeP+3PP7Xyk+GcAMWeMLTd0qHICYfSteX28R9EVZLNa5pw6wAwu7Yrfs4mnnjYipau80HySPPUI6Ph0mCU7ZO5tgGu8FNLyWEQ5ovmkQcJz1FG7i4b3r1Ec5Ld0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238208; c=relaxed/simple;
	bh=eJhPEDKCV4l2h+bxST32TtMjoZow/wiBGmRj9RGzDKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnWruQSEh7eF1xC82v7EWdpFcQ3iw3ry8CWg/ZGHVuAEUKGDpIGkSGrSlGjKZU3k+my21iqb4303stfu22CgQ/LwJoSmt3jfrnEZMRbJHg/I66YLe3lzUAMBVa76AFYin30NjXn/6QE2Ubo8IgHFC4c1itSu91n0/tWwC1O0BL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHM2s6RI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHM2s6RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ACC1F000E9;
	Thu, 20 Aug 2026 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238207;
	bh=ozxvIkpaP+wMFXv0g9EX4+1PISp3vII6qopf/JVvS0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHM2s6RIWeAFo+rhmZO0734WkRDdZ8NLUfE+P+2s5Gk9DVhIuczZ9TikMwLVlsYIr
	 yu8nlxMyWGmxh3vlYYI4cTALAal9qyzKziJEv9U9n9lnTiA1v3Vif5xe0LSwM7lncj
	 Qw1ZN4LDQiSc5EsAMZxKxlZpvOeOxs+HdCNOE42g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 069/228] ftrace: Protect direct_functions in update_ftrace_direct_del
Date: Thu, 20 Aug 2026 16:53:31 +0200
Message-ID: <20260820145246.558582755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

commit f26e5fa75fccd54bb95793c6519d405cf83233b2 upstream.

Fix accessing the __rcu pointer direct_functions with RCU protection.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260730150411.88667-3-leon.hwang@linux.dev
Fixes: 8d2c1233f371 ("ftrace: Add update_ftrace_direct_del function")
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6489,6 +6489,7 @@ int update_ftrace_direct_del(struct ftra
 	struct ftrace_hash *new_direct_functions;
 	struct ftrace_hash *new_filter_hash = NULL;
 	struct ftrace_hash *old_filter_hash;
+	struct ftrace_hash *direct_hash;
 	struct ftrace_func_entry *entry;
 	struct ftrace_func_entry *del;
 	unsigned long size;
@@ -6500,11 +6501,13 @@ int update_ftrace_direct_del(struct ftra
 		return -EINVAL;
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EINVAL;
-	if (direct_functions == EMPTY_HASH)
-		return -EINVAL;
 
 	mutex_lock(&direct_mutex);
 
+	direct_hash = rcu_dereference_protected(direct_functions, lockdep_is_held(&direct_mutex));
+	if (direct_hash == EMPTY_HASH)
+		goto out_unlock;
+
 	old_filter_hash = ops->func_hash ? ops->func_hash->filter_hash : NULL;
 
 	if (!hash_count(old_filter_hash))
@@ -6514,7 +6517,7 @@ int update_ftrace_direct_del(struct ftra
 	size = 1 << hash->size_bits;
 	for (int i = 0; i < size; i++) {
 		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
-			del = __ftrace_lookup_ip(direct_functions, entry->ip);
+			del = __ftrace_lookup_ip(direct_hash, entry->ip);
 			if (!del || del->direct != entry->direct)
 				goto out_unlock;
 		}
@@ -6525,7 +6528,7 @@ int update_ftrace_direct_del(struct ftra
 	if (!new_filter_hash)
 		goto out_unlock;
 
-	new_direct_functions = hash_sub(direct_functions, hash);
+	new_direct_functions = hash_sub(direct_hash, hash);
 	if (!new_direct_functions)
 		goto out_unlock;
 
@@ -6552,7 +6555,7 @@ int update_ftrace_direct_del(struct ftra
 		/* free the new_direct_functions */
 		old_direct_functions = new_direct_functions;
 	} else {
-		old_direct_functions = direct_functions;
+		old_direct_functions = direct_hash;
 		rcu_assign_pointer(direct_functions, new_direct_functions);
 	}
 


