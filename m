Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C0114389C;
	Wed, 19 Jun 2024 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802839; cv=none; b=Gt6XUjDdT/x4+gvMiW69lBL4KzNeP7SYSwTevJfoGpItI9R9bCGX2JgEFkCgdYYyLsDvN6RElfx01MvERlG5tmlO1JEjbPWJ3s1u2DVYrf6UwOTvEwOo0zcnW50zEMKktbZiP5Hb1amb87o608DSkIj9TSCRIdKUSEBByQBydRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802839; c=relaxed/simple;
	bh=vvG4dUTAlY4smpCdpjn9y1KPvmiP4KV6a6Xa/a6Ftlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD/P0qvKQZmCXyh/dcbkepXtiWU1FZnFbShIR5tRlgH2SHJtXa2/KKK8JbSSH6Pbg5D6eLS+g3ks48SRuQWou2/8cNjG9O82eMV9pec1YJ+guqI8UovIaHP0s+O6SlUoJP4vG+Wrs+132ywy2ognnR0CPToKWzVF7zCmAZScAy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbXR08Ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbXR08Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BF4C2BBFC;
	Wed, 19 Jun 2024 13:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802839;
	bh=vvG4dUTAlY4smpCdpjn9y1KPvmiP4KV6a6Xa/a6Ftlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbXR08AoYf+iQRPM8VuPzTLsoj0XEvrlxVL4NrUwO6XYAi0uOtwlcDWrM0LxgBlal
	 EVaiC315r5yzXfTwKf2pVQc44TPNK9W8VrE0e0srSNFW97SmvLl01RAPjIf5C54kxC
	 85AU8aHIUH2xXe66EOsF7b5nwogFKZm0h1bW4lDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 064/281] af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.
Date: Wed, 19 Jun 2024 14:53:43 +0200
Message-ID: <20240619125612.309354786@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 0aa3be7b3e1f8f997312cc4705f8165e02806f8f ]

While dumping AF_UNIX sockets via UNIX_DIAG, sk->sk_state is read
locklessly.

Let's use READ_ONCE() there.

Note that the result could be inconsistent if the socket is dumped
during the state change.  This is common for other SOCK_DIAG and
similar interfaces.

Fixes: c9da99e6475f ("unix_diag: Fixup RQLEN extension report")
Fixes: 2aac7a2cb0d9 ("unix_diag: Pending connections IDs NLA")
Fixes: 45a96b9be6ec ("unix_diag: Dumping all sockets core")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index ae39538c5042b..116cf508aea4a 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -65,7 +65,7 @@ static int sk_diag_dump_icons(struct sock *sk, struct sk_buff *nlskb)
 	u32 *buf;
 	int i;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		spin_lock(&sk->sk_receive_queue.lock);
 
 		attr = nla_reserve(nlskb, UNIX_DIAG_ICONS,
@@ -103,7 +103,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 {
 	struct unix_diag_rqlen rql;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
@@ -136,7 +136,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	rep = nlmsg_data(nlh);
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
-	rep->udiag_state = sk->sk_state;
+	rep->udiag_state = READ_ONCE(sk->sk_state);
 	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
@@ -215,7 +215,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		sk_for_each(sk, &net->unx.table.buckets[slot]) {
 			if (num < s_num)
 				goto next;
-			if (!(req->udiag_states & (1 << sk->sk_state)))
+			if (!(req->udiag_states & (1 << READ_ONCE(sk->sk_state))))
 				goto next;
 			if (sk_diag_dump(sk, skb, req, sk_user_ns(skb->sk),
 					 NETLINK_CB(cb->skb).portid,
-- 
2.43.0



