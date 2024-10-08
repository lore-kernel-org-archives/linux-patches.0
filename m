Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B09192594;
	Tue,  8 Oct 2024 12:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391448; cv=none; b=J2+xf7rUWpeH9ffQYLrbM3F52o0fmgHdjfIIDi6zPt8flgX1q3EOMGkn2JEQZc5pG5eBJIRnE9XnD9iUTVzdjX6qLXFhtYcRoxZ841EObtsRfk394ClP4Q4iJnyDqjXaixya8K8Qyqn4fPjGYj/mKzMYuFJakFEmLX5/hl+ZXAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391448; c=relaxed/simple;
	bh=IqJrL8iOdYeyVbqLiHV1xu/QqUaG4D/10VszMmwwED0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds29Nrg50/X9BWJQ/V8pf+X+kZnho4wS8ihURk0yniWqmspwb5h743PGVP16kJnAmjSWMJlbru1f1BDei3NTJrmPxPVeNWrH6G3hQK4zbsbiDhDUWb7DG4df5zIgneuTuUwVfLnXoZXzfKdwO1HBS/Jf6cNiF5RPIzN68Tv4l00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsZbViod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsZbViod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77E3C4CEC7;
	Tue,  8 Oct 2024 12:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391448;
	bh=IqJrL8iOdYeyVbqLiHV1xu/QqUaG4D/10VszMmwwED0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsZbViodc003JRGC3oBu2FfYYRgfo4R0P/RbFzS2uRWueoLd48pkP0+nh+7wKm/Nx
	 SqlwZsUQ7Qy/ZgMFqNaG+nk/S1FcU8/Y85MqDG5Xiv4u/cqIc6KSA/fsdmiJMUHC7v
	 7AM/jRRHcb06J04XfVBD3+27OKShR+rlwIdu0eco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Chapman <jchapman@katalix.com>,
	Tom Parkin <tparkin@katalix.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 118/558] l2tp: use rcu list add/del when updating lists
Date: Tue,  8 Oct 2024 14:02:28 +0200
Message-ID: <20241008115707.010471839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Chapman <jchapman@katalix.com>

[ Upstream commit 89b768ec2dfefaeba5212de14fc71368e12d06ba ]

l2tp_v3_session_htable and tunnel->session_list are read by lockless
getters using RCU. Use rcu list variants when adding or removing list
items.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: Tom Parkin <tparkin@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index edff7afc06199..ee8133f77b64c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -394,12 +394,12 @@ static int l2tp_session_collision_add(struct l2tp_net *pn,
 
 	/* If existing session isn't already in the session hlist, add it. */
 	if (!hash_hashed(&session2->hlist))
-		hash_add(pn->l2tp_v3_session_htable, &session2->hlist,
-			 session2->hlist_key);
+		hash_add_rcu(pn->l2tp_v3_session_htable, &session2->hlist,
+			     session2->hlist_key);
 
 	/* Add new session to the hlist and collision list */
-	hash_add(pn->l2tp_v3_session_htable, &session1->hlist,
-		 session1->hlist_key);
+	hash_add_rcu(pn->l2tp_v3_session_htable, &session1->hlist,
+		     session1->hlist_key);
 	refcount_inc(&clist->ref_count);
 	l2tp_session_coll_list_add(clist, session1);
 
@@ -415,7 +415,7 @@ static void l2tp_session_collision_del(struct l2tp_net *pn,
 
 	lockdep_assert_held(&pn->l2tp_session_idr_lock);
 
-	hash_del(&session->hlist);
+	hash_del_rcu(&session->hlist);
 
 	if (clist) {
 		/* Remove session from its collision list. If there
@@ -490,7 +490,7 @@ int l2tp_session_register(struct l2tp_session *session,
 
 	l2tp_tunnel_inc_refcount(tunnel);
 	WRITE_ONCE(session->tunnel, tunnel);
-	list_add(&session->list, &tunnel->session_list);
+	list_add_rcu(&session->list, &tunnel->session_list);
 
 	if (tunnel->version == L2TP_HDR_VER_3) {
 		if (!other_session)
-- 
2.43.0



