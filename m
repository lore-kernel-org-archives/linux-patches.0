Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E6019D065;
	Wed, 30 Jul 2025 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868462; cv=none; b=u35c49e25EFvm+nzQExBXHxIKvyrIwRn7HPU/iM03RnjwHdZsU+nvYAMvBX9DbmAPakK6y3qi/gnuI2jOGZHNPw/25qYkTJ7+u4OfPCwFzyN6tShZfymTDqvnOQWqxtZI8rkf2LuerzHuVlDqUoWhduIe/6Cgf9dC9Qk2/XHWeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868462; c=relaxed/simple;
	bh=PLVBEcTKDkoubU5HfTLxa/3TFWMcZMc0/WBmS6jgxpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z73IoShe78ABnO9Loxd4VP7hpMy67WEGvRiLKTpSWHJV2WMbu38YGHauTHNpwWOEMNB/c2F8nERopkjqCRFmDzr1QQAHeXceOXXs6shNiNwJIoSnTUcdEq+87s8dUUygaSrCZAXOFIZxNOI9koJY7VOCTFz3HAhg+j1ZFp90ceQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhOrs/h5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhOrs/h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD4EC4CEE7;
	Wed, 30 Jul 2025 09:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868462;
	bh=PLVBEcTKDkoubU5HfTLxa/3TFWMcZMc0/WBmS6jgxpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhOrs/h5TiyOKAb3FWTjLWHzv1T3m88YGdkDI2LTtfKajra1vR54PCpHID+L4XUKb
	 lF806CShmZoWDkI5rKU6SuoqBSlWOedIYkqMd+bE4casMkPjS/oju0ROrULO+Nytdj
	 c08doMhxwwhuT9LyP0Pp54wirE7orXcz+sTkKEd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 71/76] mptcp: plug races between subflow fail and subflow creation
Date: Wed, 30 Jul 2025 11:36:04 +0200
Message-ID: <20250730093229.618535899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Paolo Abeni <pabeni@redhat.com>

commit def5b7b2643ebba696fc60ddf675dca13f073486 upstream.

We have races similar to the one addressed by the previous patch between
subflow failing and additional subflow creation. They are just harder to
trigger.

The solution is similar. Use a separate flag to track the condition
'socket state prevent any additional subflow creation' protected by the
fallback lock.

The socket fallback makes such flag true, and also receiving or sending
an MP_FAIL option.

The field 'allow_infinite_fallback' is now always touched under the
relevant lock, we can drop the ONCE annotation on write.

Fixes: 478d770008b0 ("mptcp: send out MP_FAIL when data checksum fails")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250714-net-mptcp-fallback-races-v1-2-391aff963322@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in subflow.c, because commit f1f26512a9bf ("mptcp: use plain
  bool instead of custom binary enum") and commit 46a5d3abedbe
  ("mptcp: fix typos in comments") are not in this version. Both are
  causing conflicts in the context, and the same modifications can still
  be applied. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c       |    8 +++++++-
 net/mptcp/protocol.c |   11 ++++++-----
 net/mptcp/protocol.h |    7 +++++--
 net/mptcp/subflow.c  |   19 ++++++++++++++-----
 4 files changed, 32 insertions(+), 13 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -304,8 +304,14 @@ void mptcp_pm_mp_fail_received(struct so
 
 	pr_debug("fail_seq=%llu\n", fail_seq);
 
-	if (!READ_ONCE(msk->allow_infinite_fallback))
+	/* After accepting the fail, we can't create any other subflows */
+	spin_lock_bh(&msk->fallback_lock);
+	if (!msk->allow_infinite_fallback) {
+		spin_unlock_bh(&msk->fallback_lock);
 		return;
+	}
+	msk->allow_subflows = false;
+	spin_unlock_bh(&msk->fallback_lock);
 
 	if (!subflow->fail_tout) {
 		pr_debug("send MP_FAIL response and infinite map\n");
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -875,7 +875,7 @@ void mptcp_data_ready(struct sock *sk, s
 static void mptcp_subflow_joined(struct mptcp_sock *msk, struct sock *ssk)
 {
 	mptcp_subflow_ctx(ssk)->map_seq = READ_ONCE(msk->ack_seq);
-	WRITE_ONCE(msk->allow_infinite_fallback, false);
+	msk->allow_infinite_fallback = false;
 	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
 }
 
@@ -887,7 +887,7 @@ static bool __mptcp_finish_join(struct m
 		return false;
 
 	spin_lock_bh(&msk->fallback_lock);
-	if (__mptcp_check_fallback(msk)) {
+	if (!msk->allow_subflows) {
 		spin_unlock_bh(&msk->fallback_lock);
 		return false;
 	}
@@ -2688,7 +2688,7 @@ static void __mptcp_retrans(struct sock
 				len = max(copied, len);
 				tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 					 info.size_goal);
-				WRITE_ONCE(msk->allow_infinite_fallback, false);
+				msk->allow_infinite_fallback = false;
 			}
 			spin_unlock_bh(&msk->fallback_lock);
 
@@ -2819,7 +2819,8 @@ static void __mptcp_init_sock(struct soc
 	WRITE_ONCE(msk->first, NULL);
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
-	WRITE_ONCE(msk->allow_infinite_fallback, true);
+	msk->allow_infinite_fallback = true;
+	msk->allow_subflows = true;
 	msk->recovery = false;
 	msk->subflow_id = 1;
 
@@ -3624,7 +3625,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	/* active subflow, already present inside the conn_list */
 	if (!list_empty(&subflow->node)) {
 		spin_lock_bh(&msk->fallback_lock);
-		if (__mptcp_check_fallback(msk)) {
+		if (!msk->allow_subflows) {
 			spin_unlock_bh(&msk->fallback_lock);
 			return false;
 		}
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -330,13 +330,15 @@ struct mptcp_sock {
 		u64	rtt_us; /* last maximum rtt of subflows */
 	} rcvq_space;
 	u8		scaling_ratio;
+	bool		allow_subflows;
 
 	u32		subflow_id;
 	u32		setsockopt_seq;
 	char		ca_name[TCP_CA_NAME_MAX];
 
-	spinlock_t	fallback_lock;	/* protects fallback and
-					 * allow_infinite_fallback
+	spinlock_t	fallback_lock;	/* protects fallback,
+					 * allow_infinite_fallback and
+					 * allow_join
 					 */
 };
 
@@ -1113,6 +1115,7 @@ static inline bool __mptcp_try_fallback(
 		return false;
 	}
 
+	msk->allow_subflows = false;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 	spin_unlock_bh(&msk->fallback_lock);
 	return true;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1257,20 +1257,29 @@ static void subflow_sched_work_if_closed
 		mptcp_schedule_work(sk);
 }
 
-static void mptcp_subflow_fail(struct mptcp_sock *msk, struct sock *ssk)
+static bool mptcp_subflow_fail(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	unsigned long fail_tout;
 
+	/* we are really failing, prevent any later subflow join */
+	spin_lock_bh(&msk->fallback_lock);
+	if (!msk->allow_infinite_fallback) {
+		spin_unlock_bh(&msk->fallback_lock);
+		return false;
+	}
+	msk->allow_subflows = false;
+	spin_unlock_bh(&msk->fallback_lock);
+
 	/* greceful failure can happen only on the MPC subflow */
 	if (WARN_ON_ONCE(ssk != READ_ONCE(msk->first)))
-		return;
+		return false;
 
 	/* since the close timeout take precedence on the fail one,
 	 * no need to start the latter when the first is already set
 	 */
 	if (sock_flag((struct sock *)msk, SOCK_DEAD))
-		return;
+		return true;
 
 	/* we don't need extreme accuracy here, use a zero fail_tout as special
 	 * value meaning no fail timeout at all;
@@ -1282,6 +1291,7 @@ static void mptcp_subflow_fail(struct mp
 	tcp_send_ack(ssk);
 
 	mptcp_reset_tout_timer(msk, subflow->fail_tout);
+	return true;
 }
 
 static bool subflow_check_data_avail(struct sock *ssk)
@@ -1342,12 +1352,11 @@ fallback:
 		    (subflow->mp_join || subflow->valid_csum_seen)) {
 			subflow->send_mp_fail = 1;
 
-			if (!READ_ONCE(msk->allow_infinite_fallback)) {
+			if (!mptcp_subflow_fail(msk, ssk)) {
 				subflow->reset_transient = 0;
 				subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
 				goto reset;
 			}
-			mptcp_subflow_fail(msk, ssk);
 			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
 			return true;
 		}


