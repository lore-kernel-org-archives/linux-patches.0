Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD6B335083;
	Fri,  9 Jan 2026 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961558; cv=none; b=IzZg+iOaScFg0cYcDxzbAc+Xd8fOY+z2rjeGClwo5R4ay3fz9go3dgToZpTUVgZgSEV0hdvTkNfFF13UwNA7QN/5RCsumc4Tn8HYlA2ul+y81qhA/cTIkqeuiaAw5XQgNdkrOwcfDgG8IbxtYwLSmi6ZtkbCN6HkAg+34hZcWiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961558; c=relaxed/simple;
	bh=fia2vh/U99ocVBujFVnSBBobEVyd204DDvArwzfWFbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alppu+T2fQumFejEoXBZM2SSX4bXcq6VrwZIzpxtlP2fceM7Y9ZSuhV3vD/Is4HzRSXWSeTkzrfAGxrvs9R0k3tj/WTkH1XBmFkOKRpWg59E5UKpWNxe4g7hPLF3SWQ7RQWJQetJLf5quuSWzKIC/y264YQQPFBV24wXSYxjsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jczg/wj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jczg/wj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5797C4CEF1;
	Fri,  9 Jan 2026 12:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961558;
	bh=fia2vh/U99ocVBujFVnSBBobEVyd204DDvArwzfWFbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jczg/wj4fvLNjFTLOzTfVOeO+0nQXZ05dHDnWsx3XC6ThmFpHXJAmdQaYCBLnPqz7
	 upacSatl1qhN30c0ccp/ZgHpCdjcOw9XRh0IZJtLhmgk6SpelsxscDNGxYNZEW9UkV
	 n7wmG4LO1LU8L/8qYdNk0Q3vRiC0z7btJby25fn0=
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
Subject: [PATCH 6.1 056/634] rculist: Add hlist_nulls_replace_rcu() and hlist_nulls_replace_init_rcu()
Date: Fri,  9 Jan 2026 12:35:34 +0100
Message-ID: <20260109112119.553081207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index d8afdb8784c1c..c89dd30fa3dff 100644
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



