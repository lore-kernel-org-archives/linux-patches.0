Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AE83242DF;
	Sun,  7 Jun 2026 10:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829924; cv=none; b=qUMjxJmnhQdIukbxpBGKbVpGS1RpNeDMa4MVRSvJZ5jXZDfTKPBPGjJ+jEWmRvbawB3L61Wku6NEaVJ2SM7YHDrPtVHQTEFit8mVCk7RUCSxkeV3EVbifebckfGfjOpQrzCNk03u71QyKimYjEX1b32a1zjbPUadh4qC71CWVs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829924; c=relaxed/simple;
	bh=2+6LrjtZUMVYckpD8em6/m/pB+uttGxMZmS08HdEit8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhWnp/1PERvt9TaO12H/8AeaEnKfycbWiSBiYcs3W5gGSTqyFbW1eKzAEVloh4rqwU16WhizYyiUYjTkfLL8o/gbMGaSrPv9M2iwddAkZEQg0Cpruteg06F2RLlVWHtDAFwg9nC5HuyonXYSZ0PIgSl41mav8e+tfsrj48m3oGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsxkqW7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsxkqW7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F43F1F00893;
	Sun,  7 Jun 2026 10:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829923;
	bh=aoeHEsC8SIiCPg1WA3C1RV51MFdqZ+81jzW0MxlFWbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsxkqW7YAXIpPGTMhbOOt7ynG780ef3QFYH/yrHwkNX/I9wzFkqYkKhyKvaZXWzt4
	 Mb2JyTjkJI2GaBf8tZ/h2HBAkNysBOysygSN+WdTKRZ3C7L3t6tP/F8Hh3lOqoBmv+
	 no077UeLT4KIEvCdbEJcsNcLZ61xcsnx4SxE3bdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/315] mptcp: handle first subflow closing consistently
Date: Sun,  7 Jun 2026 12:01:20 +0200
Message-ID: <20260607095738.358606998@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0eeb372deebce6c25b9afc09e35d6c75a744299a ]

Currently, as soon as the PM closes a subflow, the msk stops accepting
data from it, even if the TCP socket could be still formally open in the
incoming direction, with the notable exception of the first subflow.

The root cause of such behavior is that code currently piggy back two
separate semantic on the subflow->disposable bit: the subflow context
must be released and that the subflow must stop accepting incoming
data.

The first subflow is never disposed, so it also never stop accepting
incoming data. Use a separate bit to mark the latter status and set such
bit in __mptcp_close_ssk() for all subflows.

Beyond making per subflow behaviour more consistent this will also
simplify the next patch.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251121-net-next-mptcp-memcg-backlog-imp-v1-11-1f34b6c1e0b1@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 50c2d91c5dfa ("mptcp: do not drop partial packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   14 +++++++++-----
 net/mptcp/protocol.h |    3 ++-
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -854,10 +854,10 @@ void mptcp_data_ready(struct sock *sk, s
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 
 	/* The peer can send data while we are shutting down this
-	 * subflow at msk destruction time, but we must avoid enqueuing
+	 * subflow at subflow destruction time, but we must avoid enqueuing
 	 * more data to the msk receive queue
 	 */
-	if (unlikely(subflow->disposable))
+	if (unlikely(subflow->closing))
 		return;
 
 	mptcp_data_lock(sk);
@@ -2455,6 +2455,13 @@ static void __mptcp_close_ssk(struct soc
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool dispose_it, need_push = false;
 
+	/* Do not pass RX data to the msk, even if the subflow socket is not
+	 * going to be freed (i.e. even for the first subflow on graceful
+	 * subflow close.
+	 */
+	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
+	subflow->closing = 1;
+
 	/* If the first subflow moved to a close state before accept, e.g. due
 	 * to an incoming reset or listener shutdown, the subflow socket is
 	 * already deleted by inet_child_forget() and the mptcp socket can't
@@ -2465,7 +2472,6 @@ static void __mptcp_close_ssk(struct soc
 		/* ensure later check in mptcp_worker() will dispose the msk */
 		sock_set_flag(sk, SOCK_DEAD);
 		mptcp_set_close_tout(sk, tcp_jiffies32 - (mptcp_close_timeout(sk) + 1));
-		lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 		mptcp_subflow_drop_ctx(ssk);
 		goto out_release;
 	}
@@ -2474,8 +2480,6 @@ static void __mptcp_close_ssk(struct soc
 	if (dispose_it)
 		list_del(&subflow->node);
 
-	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
-
 	if (subflow->send_fastclose && ssk->sk_state != TCP_CLOSE)
 		tcp_set_state(ssk, TCP_CLOSE);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -537,12 +537,13 @@ struct mptcp_subflow_context {
 		send_infinite_map : 1,
 		remote_key_valid : 1,        /* received the peer key from */
 		disposable : 1,	    /* ctx can be free at ulp release time */
+		closing : 1,	    /* must not pass rx data to msk anymore */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
 		close_event_done : 1,       /* has done the post-closed part */
 		mpc_drop : 1,	    /* the MPC option has been dropped in a rtx */
-		__unused : 9;
+		__unused : 8;
 	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */


