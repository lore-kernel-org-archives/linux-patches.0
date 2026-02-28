Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA238F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302146; cv=none; b=XLds5bfvMgwhQ+N/OsWOLeBiWGccfpPGinWcBF7oUCF062IUvTgEeHQaFWrUOAH94eEq9bmYvXzCaZZ8ub5PzYdeAa5k/yONCXkGKpAmttR5UOKVdpDZsHZpcBrgajVnrtFnuARuYhPXDYARKGj6UrUJw+GZKrLByKkdkScbFpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302146; c=relaxed/simple;
	bh=X8YmMsjnliPiL2aAoOGAMrhclUzXsSpMJEhBscNyjYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHx3/hbjMb2a0HPtTXKWk8fck0+Vikb1CEbzdBNnU2/rF44a/AgU+uXG1Qpa6hCTcQPNMkbHXnB4vLkXFlmyFCB2bYci2Rx7HBDHPuVmADgvfx6jB1T97fERPs6mDND0bRb7cohz3niuVqyiTKY7xpT8hioN1HoRtJdZqVFUVd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9bN69Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9bN69Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0859C19423;
	Sat, 28 Feb 2026 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302146;
	bh=X8YmMsjnliPiL2aAoOGAMrhclUzXsSpMJEhBscNyjYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9bN69GcfqMTSItlSqPDBYQXYBr/CMR67WuxgaZoqW7qEgAK1LR7+qiUkNTaBlvlZ
	 2eLKjrrpiCWIXMP1/fMJUZdgqdTOqdL3P2L9K6Lchy3BAlUvo5wqnZS20yMrxnqhCe
	 pjwGHgKtgWAzs73GPwZB5soT5k6AJ2bNUjDqHh2tYpj4lqB+50w7xVC/5fr26Kaoyp
	 dbdIYsx3pSWyXarVJwb33VWnqRjQYJTvX9tX+c5/kuSK0IEYPV/znO9gNTwesz79KD
	 STIbPZGKi094KS1Z7esJfBcmYhZDZjQBeuPeq/rwKFLC+qNIenr9TqTfplxS+Sf4wL
	 ahtBOGKEpjGog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/283] mptcp: fix receive space timestamp initialization
Date: Sat, 28 Feb 2026 13:04:42 -0500
Message-ID: <20260228180709.1583486-140-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 70274765fef555af92a1532d5bd5450c691fca9d ]

MPTCP initialize the receive buffer stamp in mptcp_rcv_space_init(),
using the provided subflow stamp. Such helper is invoked in several
places; for passive sockets, space init happened at clone time.

In such scenario, MPTCP ends-up accesses the subflow stamp before
its initialization, leading to quite randomic timing for the first
receive buffer auto-tune event, as the timestamp for newly created
subflow is not refreshed there.

Fix the issue moving the stamp initialization out of the mentioned helper,
at the data transfer start, and always using a fresh timestamp.

Fixes: 013e3179dbd2 ("mptcp: fix rcv space initialization")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260203-net-next-mptcp-misc-feat-6-20-v1-2-31ec8bfc56d1@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 8 ++++----
 net/mptcp/protocol.h | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f3856856aa446..85ef9042873be 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2048,8 +2048,8 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 	msk->rcvq_space.copied += copied;
 
-	mstamp = div_u64(tcp_clock_ns(), NSEC_PER_USEC);
-	time = tcp_stamp_us_delta(mstamp, msk->rcvq_space.time);
+	mstamp = mptcp_stamp();
+	time = tcp_stamp_us_delta(mstamp, READ_ONCE(msk->rcvq_space.time));
 
 	rtt_us = msk->rcvq_space.rtt_us;
 	if (rtt_us && time < (rtt_us >> 3))
@@ -3451,6 +3451,7 @@ struct sock *mptcp_sk_clone_init(const struct sock *sk,
 	__mptcp_propagate_sndbuf(nsk, ssk);
 
 	mptcp_rcv_space_init(msk, ssk);
+	msk->rcvq_space.time = mptcp_stamp();
 
 	if (mp_opt->suboptions & OPTION_MPTCP_MPC_ACK)
 		__mptcp_subflow_fully_established(msk, subflow, mp_opt);
@@ -3468,8 +3469,6 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk)
 	msk->rcvq_space.copied = 0;
 	msk->rcvq_space.rtt_us = 0;
 
-	msk->rcvq_space.time = tp->tcp_mstamp;
-
 	/* initial rcv_space offering made to peer */
 	msk->rcvq_space.space = min_t(u32, tp->rcv_wnd,
 				      TCP_INIT_CWND * tp->advmss);
@@ -3688,6 +3687,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	 * accessing the field below
 	 */
 	WRITE_ONCE(msk->local_key, subflow->local_key);
+	WRITE_ONCE(msk->rcvq_space.time, mptcp_stamp());
 
 	mptcp_pm_new_connection(msk, ssk, 0);
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0fbc1f13bd2d4..58805fbf1f961 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -786,6 +786,11 @@ static inline bool mptcp_is_fully_established(struct sock *sk)
 	       READ_ONCE(mptcp_sk(sk)->fully_established);
 }
 
+static inline u64 mptcp_stamp(void)
+{
+	return div_u64(tcp_clock_ns(), NSEC_PER_USEC);
+}
+
 void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
-- 
2.51.0

