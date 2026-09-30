Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE3D51357D;
	Wed, 30 Sep 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786609; cv=none; b=W9z//9h0kx2D9/PEJ838E1x4M2eWUHoYVWLpVV0gXKHBKvWvITkponKFnaMf7BLbbZ74eTcmisIH6b4RLQ5ksr6WGh96Ug5ogtlduQ2922bW7nYErOwGPdKnV82A3WKxGHUMVwJO94+/W71Vrx68KHxz9OQ6L4ZfAhrHS9t2Al0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786609; c=relaxed/simple;
	bh=XsC1NlziM1Y0+N6X95JEVatFqvecxZf9PMavJLcsstg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR5ZGv5XxXlIVI110/vQIpRfz3ud7Ig0Zt8fJ9gOZ8wB6DMlEfsMuDoZRY4k/CIhepyR766RPfHPoDYnpyYOIGx9AgNHLsUVm12hrkGBZVvxWH3Hc1ZLoF+tOhVKfXaUHae38DAr0XTtNEmc3vDhFNztHwLZipxb9faSCmvf7oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HygJ15Dx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HygJ15Dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BFC1F000FF;
	Wed, 30 Sep 2026 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786608;
	bh=7BgCwzMlXi8XTqP2akOjAyN30zp7vfIudpwNV5R5mHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HygJ15DxAULxI8+jXNzxyVVGyg/qEe99Brc5cSIFpuIbFh5j45MqxPkzeCJUG3ojB
	 LpuA2VpHjq6DWYQPeoAbfthtLJQKIc1/uF7KHeP43J20NYd+U2DmEtWxXchQTXcvcV
	 jtveFPMczerrfZOpGpw4o1m4xh4f4ytZXY9cLMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 920/982] rculist: add list_splice_rcu() for private lists
Date: Wed, 30 Sep 2026 17:27:36 +0200
Message-ID: <20260930152436.502540914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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



