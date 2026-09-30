Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF534F4D08;
	Wed, 30 Sep 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783244; cv=none; b=g9d/qDpvBUbMwVk7WxRdJbQMcYnmUyruQxX2TW+QK8GwCoHIYcCty0XGOENlndVmRbY/3VRNBB1PBsXN3QA5pijS0SeATnu64SeytMjiX4bbtmULBmUqtdvzItpHmK/HaD98VltudIjUTcaQTkC02Qlgq0jcD/8EZC9V1mdjcgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783244; c=relaxed/simple;
	bh=eZvidB89b2TvRKCuzkwqGZvn/3ka+N2uKJNsBS4HT4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5tIMFTDYMEGBQrv0rBxHYQvN1W6bX1ODbJUG5DVYSGlaHl7M6h4iQ80sSfsoyEInHgSHY+jFohEv0l7wK3esmjIouO76zFQw/NSqnoSK9mOg1Bm+7SsrmHR9by5ao0Gb3kVgZt3PWF/enQdjPQnIJA4pVQSlB3NkHBFe4q+S1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+v/FmAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+v/FmAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6687F1F00893;
	Wed, 30 Sep 2026 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783239;
	bh=BAKfGMRIVfrZvG2SHG+dYLl8/SN3n5yIMwalQNef+rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+v/FmAFwOVLlWWYdML64V63fsIJxnXS4wdsndo0+0XLBHP3o7xxKPbO1E6xFld6f
	 ONtiyz1w8nkWCrt4cWWKbmANMF0BbeeCYnFTcO9Bi6A8AzcV2BfpLygJPCvtNByZ99
	 QbOQUFilLInFmSwwNPYThIBnkK9b5dw3uuyJ18u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyang Ge <xinyang@anthropic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 329/595] mptcp: avoid unneeded actions on subflow reset
Date: Wed, 30 Sep 2026 17:23:42 +0200
Message-ID: <20260930152354.761633385@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 2b0f561f21b27c40c91ea4975268a06092bd7e9c upstream.

Once in a blue moon, the mptcp receive path can recursively call
mptcp_data_ready() via state change under unlucky error conditions, and
then try to hold the data lock again.

Break the recursion loop explicitly checking for the exceptional
condition.

Add a new flag instead of using an existing one like 'closing', to exit
early in subflow_state_change(), and explicitly flush the RX queue at
reset time.

This avoids unneeded processing to check for available data -- calling
get_mapping_status() and more on a dying subflow -- but also in error
reporting and worker scheduling.

Note that we must consume the currently peeked skb before invoking
mptcp_dss_corruption to avoid consuming it again after the eventual
reset has freed it.

Fixes: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
Cc: stable@vger.kernel.org
Reported-by: Xinyang Ge <xinyang@anthropic.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260917-net-mptcp-misc-fixes-7-3-rc4-v2-1-0cf5c72667c8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Note: conflict in protocol.c, because commit e0ca4057e0ec ("mptcp:
  micro-optimize __mptcp_move_skb()") is not in this version, and is
  part of a consequent rx path refactor. The conflict is in the context,
  and is easy to resolve, "done = true" can be moved along without
  consequences. Also, the context is slightly different because there is
  no DEBUG_NET_WARN_ON_ONCE in this version, see the backport commit
  12c1676d598e ("mptcp: handle consistently DSS corruption").
  Also a conflict in protocol.h, because __unused is at a different
  number. Decrement the one from this version and add the new flag
  above. The context is also a bit different with data_avail being an
  enum, but that's without consequences here.
  Also a conflict in subflow.c, because commit 71154bbe4942 ("mptcp:
  fallback earlier on simult connection") was not needed in this
  version, and cause conflicts in the context, but that's without
  consequences here. Also, a conflict in the context, because commit
  81c1d0290160 ("mptcp: consolidate fallback and non fallback state
  machine") was not needed in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 +++---
 net/mptcp/protocol.h |    3 ++-
 net/mptcp/subflow.c  |   11 +++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -581,11 +581,11 @@ static bool __mptcp_move_skbs_from_subfl
 			if (unlikely(map_remaining < len))
 				mptcp_dss_corruption(msk, ssk);
 		} else {
-			if (unlikely(!fin))
-				mptcp_dss_corruption(msk, ssk);
-
 			sk_eat_skb(ssk, skb);
 			done = true;
+
+			if (unlikely(!fin))
+				mptcp_dss_corruption(msk, ssk);
 		}
 
 		WRITE_ONCE(tp->copied_seq, seq);
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -314,7 +314,8 @@ struct mptcp_subflow_context {
 		mpc_map : 1,
 		backup : 1,
 		rx_eof : 1,
-		can_ack : 1;	    /* only after processing the remote a key */
+		can_ack : 1,	    /* only after processing the remote a key */
+		resetting : 1;	    /* subflow is resetting */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -282,6 +282,10 @@ void mptcp_subflow_reset(struct sock *ss
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
+	subflow->resetting = 1;
+
+	/* No need to delay the actual close for to-be discarded data. */
+	__skb_queue_purge(&ssk->sk_receive_queue);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
@@ -1302,6 +1306,13 @@ static void subflow_state_change(struct
 
 	__subflow_state_change(sk);
 
+	/* Rx queue processing is unneeded, error reporting will take place at
+	 * __mptcp_close_ssk() time and subflow reset can't happen in case of
+	 * fallback: subflow_sched_work_if_closed() would be a no-op.
+	 */
+	if (subflow->resetting)
+		return;
+
 	if (subflow_simultaneous_connect(sk)) {
 		mptcp_do_fallback(sk);
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);


