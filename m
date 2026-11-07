Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063256;
	b=r7rXdiczOmHcbjPqQWHA7z0FWYrcI80HLlIFbsASgvUGM4s3OKqKuLw37g/scDBPEqSx
	 8EfsabqhkdMuZ/0HfnxPFEO3tRpjh7IRI6b6vgplPVwcWK+KzEx96q2kR4z/UtvS8+gMp
	 b6r+U6EXLSX2BfdJnShC0fBmYkJIstbmRY9y1l1q+bMO8akmsq2TrGnpIw912Imu3uiod
	 2vRJMajT3RtRzBz2CC3A2IEYIkNCyk3Y8j/b+Q4KuG/qRpJyfVvpkR5gYZHUUWhbBipJB
	 dCNv5dV/Sr3UPgNVT+LgtbX71/eK8erRF5b/jVYdHzWeUlZ3D/xq6RwXeeaUmG5F4hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5NnPTVh63WwASQcwhOkrfj7Bd93P0TZZ0qPFOs6kBE8=;
	b=RqhqchZoSwq00+GEWFxub1GWjtNoaxHSAUNA7mCNFdJW/DNXgfiPeffG7apc5CwjZHlg
	 e7XBdr8PyI4XRkxiFNAGRuDGh14657xSWH3SnLNXMLdYUvol9r+RlzWCRO6lXj4FqzbL0
	 EOffwnL282b2ojDMBeA24HY923UM3pAHJn9KOWs7cSX5jlypuRa0+jEHfOsmfG0XzPO8c
	 R43txj/M6MxDE6G70AXgCbBS+gp3CcZ3JuA6KOWTmD+WQybWX+yCy+YEqzJ4O+VfwvyFd
	 +nPmamOb2XSTe2v1iZd/uz6HB+OxAgSDNGeCB6PPPC9+Bh1/F+3jwmHjMERlAHjO7vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7kra6MJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F34D606A32E;
	Sat,  7 Nov 2026 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7kra6MJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF001F0089F;
	Sat,  7 Nov 2026 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063256;
	bh=5NnPTVh63WwASQcwhOkrfj7Bd93P0TZZ0qPFOs6kBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7kra6MJz1UurHUlUfVUdWFmIgFFu3aglbHnaw96vBzjGY2sdeRZfcmP7URDp1ruw
	 HqLhVHO0+iZYz53RzNZTsMfcFn5virlzaSMjsP0TokwXIhZN91g5CG2uEyuSXKG8LC
	 h3UVYwVysGfbDr5Ntr9UjRW9j20LatOwcDOBq+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Harshbarger <handyhandyman.adam@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	I Hsin Cheng <richard120310@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/869] lib/plist: fix plist_requeue() corrupting order in the last bucket
Date: Sat,  7 Nov 2026 08:52:19 -0500
Message-ID: <20261107134909.187242452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Harshbarger <handyhandyman.adam@gmail.com>

[ Upstream commit 43c91b1522435429a63d175f5a953e6f727a4f88 ]

plist_requeue() is meant to move a node to the end of its own priority
run.  When the node heads the *last* priority bucket it is instead placed
at the head of the whole list, leaving the plist unsorted:

  built:      A(prio 0) B(prio 1) C(prio 1)
  requeue(B): B(prio 1) A(prio 0) C(prio 1)
  expected:   A(prio 0) C(prio 1) B(prio 1)

prio_list is a *headless* circular ring of the nodes that lead each
priority bucket.  The shortcut added by commit 95d4b3450ebe ("lib/plist.c:
add shortcut for plist_requeue()") takes

	iter = list_entry(iter->prio_list.next, struct plist_node,
			  prio_list);
	node_next = &iter->node_list;

which from the last bucket wraps round to the *first* bucket, so node_next
ends up pointing at the head of the list rather than at its end.  The
plist_for_each_continue() loop immediately below it computes the correct
answer (&head->node_list) for that case.

With any bucket after it the shortcut is correct, which is why this went
unnoticed: the benchmark in that commit measured elapsed time and never
checked the resulting order.

Keep the shortcut -- it is a real win -- but exclude the case where iter's
bucket is the last one, which is exactly when its ring successor is the
first bucket again.

Reachable from mm/swapfile.c, which rotates swap_avail_heads[] with
plist_requeue().  It takes three or more swap devices: at least two
distinct priorities, so that a later bucket exists for the ring to wrap
round from, and two or more devices sharing the lowest priority, so that
plist_requeue() does not return early.  One device per priority returns
early at the node->prio != iter->prio test.  A single priority is also
safe, but for a different reason worth stating: with one bucket no node is
ever linked onto prio_list at all -- plist_add() skips it for the first
node and for every node whose predecessor shares its priority -- so
list_empty(&iter->prio_list) holds and the shortcut is never entered.

Tested by driving three implementations -- the pre-95d4b3450ebe code,
current mainline, and this patch -- through 1,084,492 identical random
add/del/requeue operations over 24 nodes and 1..5 distinct priorities,
comparing the resulting node_list node for node after every operation:

  variant             differs from pre-95d4b3450ebe  left list unsorted
  pre-95d4b3450ebe    -- (reference)                                  0
  mainline                                  289,297             276,660
  this patch                                      0                   0

Link: https://lore.kernel.org/20260903222456.1881786-1-handyhandyman.adam@gmail.com
Fixes: 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()")
Signed-off-by: Adam Harshbarger <handyhandyman.adam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Assisted-by: Claude:claude-opus-5
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/plist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/plist.c b/lib/plist.c
index 330febb4bd7d7..1e9cb0e35af7f 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -174,8 +174,15 @@ void plist_requeue(struct plist_node *node, struct plist_head *head)
 	/*
 	 * After plist_del(), iter is the replacement of the node.  If the node
 	 * was on prio_list, take shortcut to find node_next instead of looping.
+	 *
+	 * prio_list is a headless ring, so from the LAST bucket ->next wraps
+	 * round to the first one; in that case node_next is the list head.
 	 */
 	if (!list_empty(&iter->prio_list)) {
+		struct plist_node *first = plist_first(head);
+
+		if (iter->prio_list.next == &first->prio_list)
+			goto queue;
 		iter = list_entry(iter->prio_list.next, struct plist_node,
 				  prio_list);
 		node_next = &iter->node_list;
-- 
2.53.0



