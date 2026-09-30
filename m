Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D285172D4;
	Wed, 30 Sep 2026 18:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792507; cv=none; b=sPyouJhGULKD6dNaaoOkLrNE6hsAADHXiHo1/4MO9zTL2P83rWDOdsi6Um+yIf8cGFTkwLwNFLAyS7XPcPKFWpwcElXcBiZp9fvfDg+4kP9mwF+IX7O0ixH6B2OjHf6w/tdJZLMfRt0ix8sonzWCFlEWyIySbTTjo1JlbMcIM5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792507; c=relaxed/simple;
	bh=EP/3B4r/RO4NaDh1bsnIGW3rCHohl4I4osd+wYmjKHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuRi+5EMPWTHo3yrofSxJBCxj8RpOKpLi4Oca6IsX9mZ+QdymR7V93kwxgkEnfTzOwRB/2BsbBeOBwaI1v1oHVVJZSLTYMZi3FP1AOH9fKdyAD50gUGJuRrhOVC5+DEk+P/eVRTnKxkYL391GCRCt0Im0XQK0s4ly0q2W7lIxg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFHrKgrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFHrKgrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1141F000FF;
	Wed, 30 Sep 2026 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792505;
	bh=RteQ/z6vlNxwZ/o1nv1osKwnuy7YCkus6hr6A4uh254=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFHrKgrCOHRbV0m2sIE1fyoZBX2znv4grIx9+doAaKb+up+hLIxCvjkrPGZFrR50F
	 s9wdwz+RB0PhLKnnpCB24FqLwA6DRdj3SUGkzze9VoGIDoIzIk/ouJcuZGSQ/GrQS9
	 BmJqcxf811qjxt+Dati6GWUmpbaXAPwsz6c+R7N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 679/752] rculist: add list_splice_rcu() for private lists
Date: Wed, 30 Sep 2026 17:29:09 +0200
Message-ID: <20260930152412.938745339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f902877b635551513729bdf9a8d1422c4aab7741 ]

This patch adds a helper function, list_splice_rcu(), to safely splice
a private (non-RCU-protected) list into an RCU-protected list.

The function ensures that only the pointer visible to RCU readers
(prev->next) is updated using rcu_assign_pointer(), while the rest of
the list manipulations are performed with regular assignments, as the
source list is private and not visible to concurrent RCU readers.

This is useful for moving elements from a private list into a global
RCU-protected list, ensuring safe publication for RCU readers.
Subsystems with some sort of batching mechanism from userspace can
benefit from this new function.

The function __list_splice_rcu() has been added for clarity and to
follow the same pattern as in the existing list_splice*() interfaces,
where there is a check to ensure that the list to splice is not
empty. Note that __list_splice_rcu() has no documentation for this
reason.

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rculist.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index d29740be4833e..ad37c0584c23b 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -204,6 +204,35 @@ static inline void list_replace_rcu(struct list_head *old,
 	old->prev = LIST_POISON2;
 }
 
+static inline void __list_splice_rcu(struct list_head *list,
+				     struct list_head *prev,
+				     struct list_head *next)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+
+	last->next = next;
+	first->prev = prev;
+	next->prev = last;
+	rcu_assign_pointer(list_next_rcu(prev), first);
+}
+
+/**
+ * list_splice_rcu - splice a non-RCU list into an RCU-protected list,
+ *                   designed for stacks.
+ * @list:	the non RCU-protected list to splice
+ * @head:	the place in the existing RCU-protected list to splice
+ *
+ * The list pointed to by @head can be RCU-read traversed concurrently with
+ * this function.
+ */
+static inline void list_splice_rcu(struct list_head *list,
+				   struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_rcu(list, head, head->next);
+}
+
 /**
  * __list_splice_init_rcu - join an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
-- 
2.53.0



