Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863CE4E50CF;
	Wed, 30 Sep 2026 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783938; cv=none; b=Ai+wl71BqjxDz5HX5cviDDwlveLlqKH0ZFAJMY8BwUYv2QV1zod6T8kwoWs1N27DWFeRIAhIY97/8OLR/zg4LAVcqy4DHsQh+vD0ZFAXgnTi0Yf0Y/iwDrkdzLMMSA/z6yCduOiiv2AoiMbQME8WSWCug5ftKvB4X5WIQ9Zqfb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783938; c=relaxed/simple;
	bh=x9Mwp1rPTHYTSmhAyKDJJjlCYPnBv92BI+/J9RGCYdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhN9neNE4U7MG4Ui8wPASgVQh2aqefVAYUv6BQlkxJXb9+Ee91vAaX3X/FytjsNmTzFmDtCX/cGiLR99LhZiv6nMdpB4RwzvKF+TChQ91h4MKdjZ0RMhw5OrlynLXbG3qe8MVin1OFxbyYW+BICBGV4911bwBMrTgzm1aaHhxiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+dJPR2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+dJPR2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3AD1F00899;
	Wed, 30 Sep 2026 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783932;
	bh=x6hg+CagVMqWFh/eLnxyuEU+bwVDgTSim4qAfNgqz0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+dJPR2z7QEFUQzwMIOWKB+w1I3eq/6AZT7tIL4aaXU6kdRwQM1J2FfNkS0lY1Ozn
	 PpVX1YC9dBzcvXEVxZ4NT3oe2X+y1d+QuXCuoGbiujXBnuaRZC1ePY5CvPYgCK2rKK
	 oB1XG/NBVM5RIs545/4Egij2kQc2b+nEhVHFDiz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 546/595] rculist: add list_splice_rcu() for private lists
Date: Wed, 30 Sep 2026 17:27:19 +0200
Message-ID: <20260930152359.457888046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index f8633d37e3581..5be4dd041f987 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -213,6 +213,35 @@ static inline void list_replace_rcu(struct list_head *old,
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



