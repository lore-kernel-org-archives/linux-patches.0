Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D2313E22;
	Wed,  3 Dec 2025 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776757; cv=none; b=k3zvYon3u6qODwM4bI7iLxfM7U6F8Mu+EME/hwHdx7koc+W2zoueyDm7jbquGrMtL9pr9Xdu0WMO6ou0OBA9BN2r9XxxD8xx8Cy4+PattLEbjNIMUtY7WhZcPWEfZRAVf1fKI2aS/4hsF69wV4i6bl3w8KJqZLjLFXDbid9v4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776757; c=relaxed/simple;
	bh=ZXCbuR2X4rMn9s0EL+T4Ru1Yf8u7vm8oO+s0O7KxcyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwoFr3DtcHiG1ZKVCrAKlSjIRjFrZMGafkWk9OjJi2BFmYFL4hgBaIAiBzyCUJF5RNbYQWsmhbhzlyWd3G7oi1hpZ+T/XMPmrvQ78PkV+CnEM/AHmLfu2LAFp1RC1yQ5Dl2eEK9Lf6snzxMZW6GJmlrrtc/KI0Fr9AyzOTt9x1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKfxv/r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKfxv/r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34081C4CEF5;
	Wed,  3 Dec 2025 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776757;
	bh=ZXCbuR2X4rMn9s0EL+T4Ru1Yf8u7vm8oO+s0O7KxcyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKfxv/r/AW3hORU0k1XXnb9635iSvWFeo3W2PSfhUv7p2aTLZt7aB5chHeryGO9NO
	 /OBilIGMqwR57sJM1TcAar+XCE3sQozxtQ3QBdQRNsavmETpMIzrliDVyl2Lvadk9I
	 0xnU+ggufzj3icOoYrfMhvWVtXhshb8Me0npztco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/300] mptcp: introduce mptcp_schedule_work
Date: Wed,  3 Dec 2025 16:27:30 +0100
Message-ID: <20251203152409.745076866@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

[ Upstream commit ba8f48f7a4d79352b764ace585b5f602ef940be0 ]

remove some of code duplications an allow preventing
rescheduling on close.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 035bca3f017e ("mptcp: fix race condition in mptcp_schedule_work()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c       |    3 +--
 net/mptcp/protocol.c |   36 ++++++++++++++++++++++--------------
 net/mptcp/protocol.h |    1 +
 3 files changed, 24 insertions(+), 16 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -89,8 +89,7 @@ static bool mptcp_pm_schedule_work(struc
 		return false;
 
 	msk->pm.status |= BIT(new_status);
-	if (schedule_work(&msk->work))
-		sock_hold((struct sock *)msk);
+	mptcp_schedule_work((struct sock *)msk);
 	return true;
 }
 
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -641,9 +641,8 @@ static bool move_skbs_to_msk(struct mptc
 		 * this is not a good place to change state. Let the workqueue
 		 * do it.
 		 */
-		if (mptcp_pending_data_fin(sk, NULL) &&
-		    schedule_work(&msk->work))
-			sock_hold(sk);
+		if (mptcp_pending_data_fin(sk, NULL))
+			mptcp_schedule_work(sk);
 	}
 
 	spin_unlock_bh(&sk->sk_lock.slock);
@@ -715,23 +714,32 @@ static void mptcp_reset_timer(struct soc
 	sk_reset_timer(sk, &icsk->icsk_retransmit_timer, jiffies + tout);
 }
 
+bool mptcp_schedule_work(struct sock *sk)
+{
+	if (inet_sk_state_load(sk) != TCP_CLOSE &&
+	    schedule_work(&mptcp_sk(sk)->work)) {
+		/* each subflow already holds a reference to the sk, and the
+		 * workqueue is invoked by a subflow, so sk can't go away here.
+		 */
+		sock_hold(sk);
+		return true;
+	}
+	return false;
+}
+
 void mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
 
 	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
-	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)) &&
-	    schedule_work(&mptcp_sk(sk)->work))
-		sock_hold(sk);
+	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
+		mptcp_schedule_work(sk);
 }
 
 void mptcp_subflow_eof(struct sock *sk)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	if (!test_and_set_bit(MPTCP_WORK_EOF, &msk->flags) &&
-	    schedule_work(&msk->work))
-		sock_hold(sk);
+	if (!test_and_set_bit(MPTCP_WORK_EOF, &mptcp_sk(sk)->flags))
+		mptcp_schedule_work(sk);
 }
 
 static void mptcp_check_for_eof(struct mptcp_sock *msk)
@@ -1643,8 +1651,7 @@ static void mptcp_retransmit_handler(str
 		mptcp_stop_timer(sk);
 	} else {
 		set_bit(MPTCP_WORK_RTX, &msk->flags);
-		if (schedule_work(&msk->work))
-			sock_hold(sk);
+		mptcp_schedule_work(sk);
 	}
 }
 
@@ -2503,7 +2510,8 @@ static void mptcp_release_cb(struct sock
 		struct sock *ssk;
 
 		ssk = mptcp_subflow_recv_lookup(msk);
-		if (!ssk || !schedule_work(&msk->work))
+		if (!ssk || sk->sk_state == TCP_CLOSE ||
+		    !schedule_work(&msk->work))
 			__sock_put(sk);
 	}
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -410,6 +410,7 @@ static inline bool mptcp_is_fully_establ
 void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
+bool mptcp_schedule_work(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);


