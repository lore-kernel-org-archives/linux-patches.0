Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0C23BB690;
	Sat, 17 Oct 2026 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257615; cv=none; b=DLHoSKJyVivFAOUpAOZd3j4IEtZPvgHtOd8prv/wLzWFvTQqw8hnSG+4BWPdY96MJidRM1V//0tMolmKKA0nW3Mo4siec2nHhHeQjThPSTw3rmYIAGnfMaBlyhN/UEDRmBvR5U9g+CmfSbj1fN1Zf8kdzT2WQ3HJtrycEVztgSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257615; c=relaxed/simple;
	bh=8uwubsJ9tRSZUUND/43wqjU2xtAT111DW89+fn53AJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfp5ZHFWNIE4CJynNIqyjaFD1s2A9qc8XG6tq/0QcNCb2xORH3Fr/RZdOt/fzEiAZDH031y+hRyksa408sE8SNq3HjHPFYT7FMAnq5E3Ds+quQ72ARFdCX87dLalyAYRS1aXEhR1nkCNd2nxpJF4gbgLKNcEPCdq8Ghp39vbPho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSU2xP04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSU2xP04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9E51F000C4;
	Sat, 17 Oct 2026 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257613;
	bh=Fv7RF8lSpOcoTbA09pvgCUpV5iVp6r1uinxTDWhId88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSU2xP045NQFFRIij1c33OBiVzOsd+iG9kcxL+GdMDDb4ZXhZQZfFU2HGJbshgizF
	 e8gq3abs/2MsgeGgXfRT62omLzZmG9ExEJuRs6JUWCkXw4OSU3pz6C27R30OB3LM18
	 5myNbqVawsHDj99d8SQhhk1ZAAA4UB+4zKjBF/ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0573/1674] llist: add interface to check if a node is on a list.
Date: Sat, 17 Oct 2026 17:47:25 +0200
Message-ID: <20261017160445.800920159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit d6b3358a2813bb14791259a2227d9af1e7019ca0 ]

With list.h lists, it is easy to test if a node is on a list, providing
it was initialised and that it is removed with list_del_init().

This patch provides similar functionality for llist.h lists.

 init_llist_node()
marks a node as being not-on-any-list be setting the ->next pointer to
the node itself.
 llist_on_list()
tests if the node is on any list.
 llist_del_first_init()
remove the first element from a llist, and marks it as being off-list.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/llist.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 85bda2d02d65b..dcb91e3bac1cc 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -73,6 +73,33 @@ static inline void init_llist_head(struct llist_head *list)
 	list->first = NULL;
 }
 
+/**
+ * init_llist_node - initialize lock-less list node
+ * @node:	the node to be initialised
+ *
+ * In cases where there is a need to test if a node is on
+ * a list or not, this initialises the node to clearly
+ * not be on any list.
+ */
+static inline void init_llist_node(struct llist_node *node)
+{
+	node->next = node;
+}
+
+/**
+ * llist_on_list - test if a lock-list list node is on a list
+ * @node:	the node to test
+ *
+ * When a node is on a list the ->next pointer will be NULL or
+ * some other node.  It can never point to itself.  We use that
+ * in init_llist_node() to record that a node is not on any list,
+ * and here to test whether it is on any list.
+ */
+static inline bool llist_on_list(const struct llist_node *node)
+{
+	return node->next != node;
+}
+
 /**
  * llist_entry - get the struct of this entry
  * @ptr:	the &struct llist_node pointer.
@@ -249,6 +276,21 @@ static inline struct llist_node *__llist_del_all(struct llist_head *head)
 
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
+/**
+ * llist_del_first_init - delete first entry from lock-list and mark is as being off-list
+ * @head:	the head of lock-less list to delete from.
+ *
+ * This behave the same as llist_del_first() except that llist_init_node() is called
+ * on the returned node so that llist_on_list() will report false for the node.
+ */
+static inline struct llist_node *llist_del_first_init(struct llist_head *head)
+{
+	struct llist_node *n = llist_del_first(head);
+
+	if (n)
+		init_llist_node(n);
+	return n;
+}
 struct llist_node *llist_reverse_order(struct llist_node *head);
 
 #endif /* LLIST_H */
-- 
2.53.0



