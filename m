Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063581;
	b=CKKmHmc/8jkcth5cXu8CCx6XAvhVIv3JYV4zdO8Ldhzb+oIPBnHEaHFxgPjhkzLUel//
	 MegXo777eZqeFu+3xNJtciAz3noSphtBCI/VO+aWDfIv+G68eVANG7N4r8z1PzZcp+bdJ
	 tEHEHHNQyGrN3g5vybqkddrBAtOaTqDsa0dKe6jSoJXO5g2xMZRpiC0vQ92wtYpj6Dr6B
	 4N79praSS5iqLr2yYBsEYkX64XDOaGKJ1LGtKDFj/2OXbjOIg2q5a2uRqUh3xfHq66ldE
	 C3JV5l84JagINXZWxWimq5EMaDhhxCNEnMyEB7YXJdiHigpIEHbGuYGdrQOMr5/nMmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1mzpw8eW0wiHBczVfFNGI37r4URLUDeL46xU9IYgmGg=;
	b=q0HinLOEl9G0FX4tfrALMXd4Kfq6RSE2JIUUVocko/2beDkqNSo9n8uItYDRdoBjVHS9
	 kEe517YJf3+5KFlwx812AiRf0ySFdJaCGopbG9wnii6ytvB+foQuqVqRZQsqSoMjRCizm
	 +DfKMA1NOhDUTJ6DyvzxvE7aefNrCGeYrOYRNtUHOadGsJzcUEqSw1fmvpLdIynygVKoI
	 cFPBTZGTAvJOlRdeMTSadpHjudlT4jbTBnUuARpYA0cpIeTPU7Aktx2bjnLnAslHxS5x8
	 KxChAiYLYEjPJ3Rjv/U8q2d4AMWoeUXCc9ZY2p60BM8aBixudIJ69suwl9RPpElspQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c35WJfwV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0EF60A263F;
	Sat,  7 Nov 2026 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c35WJfwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB51F008A3;
	Sat,  7 Nov 2026 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063580;
	bh=1mzpw8eW0wiHBczVfFNGI37r4URLUDeL46xU9IYgmGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c35WJfwVGMWJb4KdPq8vBNMP1gNKR7Wb5Cxh6UfyDSafa9P9zY+hHBWEG9UAdcJqL
	 GexYD+zEIBYoCt0Ekywa8zrdKPo3dmpmNw1tXwKBeHSlQfFOibRVwMFiTw3f1HszpR
	 ziP9qlJXc9XDm4oSJJQtAVnVh4pCqzHhneGsY2kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 709/869] tipc: fix broadcast sender hang on last acker departure
Date: Sat,  7 Nov 2026 08:56:31 -0500
Message-ID: <20261107134916.936850316@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit f4377bf85887f57b59abb5479f7660a81ffe4449 ]

TIPC group broadcast senders are blocked while a replicast still has
outstanding member acks: tipc_group_bc_cong() returns true as long as
grp->bc_ackers is non-zero, and clears *grp->open, which is what
tipc_poll() uses to report EPOLLOUT (via tsk->group_is_open).

When the last outstanding acker departs before acking,
tipc_group_delete_member() decrements grp->bc_ackers to zero but
never restores *grp->open.  As a result poll(EPOLLOUT) never fires
again.  A writer blocked in sendmsg() is only released if some other
wakeup happens after the deletion: with TIPC_GROUP_MEMBER_EVTS the
leave event delivery calls sk_data_ready() and wakes it, but without
member events nothing does and it sleeps indefinitely, since the
default send timeout is MAX_SCHEDULE_TIMEOUT.

Commit 99cc2a62e07a ("tipc: reject invalid and unexpected
GRP_ACK_MSG to prevent bc_ackers underflow") already calls this out
in its changelog as a pre-existing issue.

Restore the open state exactly on the 1->0 transition in the delete
path, mirroring the GRP_ACK_MSG completion path, and invoke
sk->sk_write_space() from tipc_sk_filter_rcv() when the group just
became writable again.

Also make the ack accounting precise.  The delete path used to test
less(m->bc_acked, grp->bc_snd_nxt - 1), which also matches members
that were never counted for the current replicast (JOINING/LEAVING
members keep a stale bc_acked), and the GRP_ACK_MSG handler accepted
an ack from any member whose bc_acked differed from the expected
value.  Either could zero bc_ackers on behalf of a member that owes
nothing and silently void an ack still owed by a real acker.  Track
whether a member owes an ack for the current replicast in a new
per-member bc_pending flag, set when the member is counted and
cleared when its ack arrives, and use it both to accept an ack and
to decide on deletion.  bc_acked has no remaining user and is
removed.  Suggested by Tung Quang Nguyen.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: 2f487712b893 ("tipc: guarantee that group broadcast doesn't bypass group unicast")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20261019115859.3471295-1-bsdhenrymartin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/group.c  | 19 ++++++++++---------
 net/tipc/socket.c | 12 +++++++++++-
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/tipc/group.c b/net/tipc/group.c
index 0da7b27133949..a9ce1c7018b6c 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -74,7 +74,7 @@ struct tipc_member {
 	u16 window;
 	u16 bc_rcv_nxt;
 	u16 bc_syncpt;
-	u16 bc_acked;
+	bool bc_pending;
 };
 
 struct tipc_group {
@@ -316,7 +316,6 @@ static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
 	m->node = node;
 	m->port = port;
 	m->instance = instance;
-	m->bc_acked = grp->bc_snd_nxt - 1;
 	ret = tipc_group_add_to_tree(grp, m);
 	if (ret < 0) {
 		kfree(m);
@@ -340,9 +339,12 @@ static void tipc_group_delete_member(struct tipc_group *grp,
 	rb_erase(&m->tree_node, &grp->members);
 	grp->member_cnt--;
 
-	/* Check if we were waiting for replicast ack from this member */
-	if (grp->bc_ackers && less(m->bc_acked, grp->bc_snd_nxt - 1))
-		grp->bc_ackers--;
+	/* If this member owed an ack for the current replicast and it
+	 * was the last one, restore the open state so blocked broadcast
+	 * senders can proceed.
+	 */
+	if (grp->bc_ackers && m->bc_pending && !--grp->bc_ackers)
+		*grp->open = true;
 
 	list_del_init(&m->list);
 	list_del_init(&m->small_win);
@@ -394,7 +396,6 @@ void tipc_group_update_member(struct tipc_member *m, int len)
 
 void tipc_group_update_bc_members(struct tipc_group *grp, int len, bool ack)
 {
-	u16 prev = grp->bc_snd_nxt - 1;
 	struct tipc_member *m;
 	struct rb_node *n;
 	u16 ackers = 0;
@@ -403,8 +404,8 @@ void tipc_group_update_bc_members(struct tipc_group *grp, int len, bool ack)
 		m = container_of(n, struct tipc_member, tree_node);
 		if (tipc_group_is_receiver(m)) {
 			tipc_group_update_member(m, len);
-			m->bc_acked = prev;
 			ackers++;
+			m->bc_pending = ack;
 		}
 	}
 
@@ -800,9 +801,9 @@ void tipc_group_proto_rcv(struct tipc_group *grp, bool *usr_wakeup,
 		if (!m || !grp->bc_ackers)
 			return;
 		acked = msg_grp_bc_acked(hdr);
-		if (acked != grp->bc_snd_nxt || m->bc_acked == acked)
+		if (acked != grp->bc_snd_nxt || !m->bc_pending)
 			return;
-		m->bc_acked = acked;
+		m->bc_pending = false;
 		if (--grp->bc_ackers)
 			return;
 		list_del_init(&m->small_win);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index af14b50933f5c..4780264a8a491 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2355,8 +2355,18 @@ static void tipc_sk_filter_rcv(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(!msg_isdata(hdr)))
 		tipc_sk_proto_rcv(sk, &inputq, xmitq);
 
-	if (unlikely(grp))
+	if (unlikely(grp)) {
+		bool was_open = tsk->group_is_open;
+
 		tipc_group_filter_msg(grp, &inputq, xmitq);
+		/* A departing member may have held the last outstanding
+		 * replicast ack, which can restore the open state inside
+		 * tipc_group_filter_msg(); wake up senders blocked in
+		 * poll()/write() if the group just became writable.
+		 */
+		if (!was_open && tsk->group_is_open)
+			sk->sk_write_space(sk);
+	}
 
 	if (unlikely(!grp) && mtyp == TIPC_MCAST_MSG)
 		tipc_mcast_filter_msg(net, &tsk->mc_method.deferredq, &inputq);
-- 
2.53.0



