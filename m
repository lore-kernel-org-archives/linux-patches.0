Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C12D9488;
	Thu, 15 Jan 2026 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498884; cv=none; b=KeTYAx01d2ivTjutLmlquhcjDNu5KwP7chQxQEzoCfcgIzgFtL5zUS2J/ddlUJIzk1BMC976EU322pTU20eeXsCu+oTOKT/y+6R1jq1t33HGn+COONeHlfRkta7blqTGfbuRhQuzslrEyxF7CQI+lD+9DQzeXOukmyczZmpXFZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498884; c=relaxed/simple;
	bh=QVAUldekalroaQj58t3sHnFkPihy//ONfRjSTckjXu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmrEyCfUNXUKnbBlhUoxjGCwGKJpQx3VEP10HbyFAsSwyI8XPuxu08zC8tR0CjLpcInQv2Iyq/86DzS+8r6icCf6qOF+o16meDd+OIWc6dtjLxEiQ0Nvdj7atbAIVfg31EVFSD+qgO20Kow+FW2C9teVRgpNiYr9Ua/NhLhj0iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSfZaXSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSfZaXSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA07C116D0;
	Thu, 15 Jan 2026 17:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498884;
	bh=QVAUldekalroaQj58t3sHnFkPihy//ONfRjSTckjXu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSfZaXSObMyJdx7b33usSJe2FfRn8qsvuHb9t9caR2BzrFAhnSc/6skcWrZDUOgIN
	 B1RxbBCDxWjSP7Of7EL2BEkH2LdkawSuikBaP6PbXMriNhwImhJrMfp+BULXuBriuv
	 XnId1soxq9ryLQzEpprKPpvhjixtVZHgAuOwJrQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/451] rculist: Add hlist_nulls_replace_rcu() and hlist_nulls_replace_init_rcu()
Date: Thu, 15 Jan 2026 17:43:54 +0100
Message-ID: <20260115164232.091169829@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 9c4609225ec1cb551006d6a03c7c4ad8cb5584c0 ]

Add two functions to atomically replace RCU-protected hlist_nulls entries.

Keep using WRITE_ONCE() to assign values to ->next and ->pprev, as
mentioned in the patch below:
commit efd04f8a8b45 ("rcu: Use WRITE_ONCE() for assignments to ->next for
rculist_nulls")
commit 860c8802ace1 ("rcu: Use WRITE_ONCE() for assignments to ->pprev for
hlist_nulls")

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20251015020236.431822-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1532ed0d0753 ("inet: Avoid ehash lookup race in inet_ehash_insert()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rculist_nulls.h | 59 +++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index ff3e94779e73c..c3efa06bd1fe7 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -52,6 +52,13 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 #define hlist_nulls_next_rcu(node) \
 	(*((struct hlist_nulls_node __rcu __force **)&(node)->next))
 
+/**
+ * hlist_nulls_pprev_rcu - returns the dereferenced pprev of @node.
+ * @node: element of the list.
+ */
+#define hlist_nulls_pprev_rcu(node) \
+	(*((struct hlist_nulls_node __rcu __force **)(node)->pprev))
+
 /**
  * hlist_nulls_del_rcu - deletes entry from hash list without re-initialization
  * @n: the element to delete from the hash list.
@@ -152,6 +159,58 @@ static inline void hlist_nulls_add_fake(struct hlist_nulls_node *n)
 	n->next = (struct hlist_nulls_node *)NULLS_MARKER(NULL);
 }
 
+/**
+ * hlist_nulls_replace_rcu - replace an old entry by a new one
+ * @old: the element to be replaced
+ * @new: the new element to insert
+ *
+ * Description:
+ * Replace the old entry with the new one in a RCU-protected hlist_nulls, while
+ * permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary (such as holding
+ * appropriate locks) to avoid racing with another list-mutation primitive, such
+ * as hlist_nulls_add_head_rcu() or hlist_nulls_del_rcu(), running on this same
+ * list.  However, it is perfectly legal to run concurrently with the _rcu
+ * list-traversal primitives, such as hlist_nulls_for_each_entry_rcu().
+ */
+static inline void hlist_nulls_replace_rcu(struct hlist_nulls_node *old,
+					   struct hlist_nulls_node *new)
+{
+	struct hlist_nulls_node *next = old->next;
+
+	WRITE_ONCE(new->next, next);
+	WRITE_ONCE(new->pprev, old->pprev);
+	rcu_assign_pointer(hlist_nulls_pprev_rcu(new), new);
+	if (!is_a_nulls(next))
+		WRITE_ONCE(next->pprev, &new->next);
+}
+
+/**
+ * hlist_nulls_replace_init_rcu - replace an old entry by a new one and
+ * initialize the old
+ * @old: the element to be replaced
+ * @new: the new element to insert
+ *
+ * Description:
+ * Replace the old entry with the new one in a RCU-protected hlist_nulls, while
+ * permitting racing traversals, and reinitialize the old entry.
+ *
+ * Note: @old must be hashed.
+ *
+ * The caller must take whatever precautions are necessary (such as holding
+ * appropriate locks) to avoid racing with another list-mutation primitive, such
+ * as hlist_nulls_add_head_rcu() or hlist_nulls_del_rcu(), running on this same
+ * list. However, it is perfectly legal to run concurrently with the _rcu
+ * list-traversal primitives, such as hlist_nulls_for_each_entry_rcu().
+ */
+static inline void hlist_nulls_replace_init_rcu(struct hlist_nulls_node *old,
+						struct hlist_nulls_node *new)
+{
+	hlist_nulls_replace_rcu(old, new);
+	WRITE_ONCE(old->pprev, NULL);
+}
+
 /**
  * hlist_nulls_for_each_entry_rcu - iterate over rcu list of given type
  * @tpos:	the type * to use as a loop cursor.
-- 
2.51.0



