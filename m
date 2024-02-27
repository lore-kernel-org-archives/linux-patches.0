Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CA213B2B3;
	Tue, 27 Feb 2024 13:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041934; cv=none; b=mg2pZrDg5/EpHroSCxzzEDa3CldaRfGsrIl3vEOi1Z6knvGGoynG5lhbTIWBqTlkmJ8hvy/O1LnBZa99BcIsxaDsPQFZPHoRQ1v/zfbAUqmiU+EVM0H9VQBI55lnaAnZpLvdbhvg16Uwh10lKgAy3+6u2hIZQQ41KQs9ugw3384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041934; c=relaxed/simple;
	bh=Fqil5A+EI7yCrZAdPM3VemzC8yzOVhEOfAw2tUnzg6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckAMSN7LnmyLDjNVt7mOFZc523UaRZCuFKXpWtamr1qqN1ZXb9Bew9VrYzigcUG45if43n8QzZ4vV35fy/pwzYCdP/d4WfigX5IHf3j6CRN76BmHn09BgGDk0RNKgIkNATwhC+cUjBpz1/glxGyu/zQvt+rCw5mRAdVNr9M6HZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGTiIGJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGTiIGJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC444C433B1;
	Tue, 27 Feb 2024 13:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041934;
	bh=Fqil5A+EI7yCrZAdPM3VemzC8yzOVhEOfAw2tUnzg6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGTiIGJphBARQU7albwWKM1oKuxl0h6GHTR6ifpia2L8znrHWHLe9o1SmSxm4Ee/h
	 rBXRpSFGy4XrPea4zzE57EBmdGewvXvb34QtM3QLiaczgYqVE9qKrcSjccvA8vgyPw
	 C4bB1uTsx7CmvAq7Aq6V0dpA3F5eAy9t5JoGb5+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/299] mptcp: add CurrEstab MIB counter support
Date: Tue, 27 Feb 2024 14:23:51 +0100
Message-ID: <20240227131629.730581433@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@linux.dev>

[ Upstream commit d9cd27b8cd191133e287e5de107f971136abe8a2 ]

Add a new MIB counter named MPTCP_MIB_CURRESTAB to count current
established MPTCP connections, similar to TCP_MIB_CURRESTAB. This is
useful to quickly list the number of MPTCP connections without having to
iterate over all of them.

This patch adds a new helper function mptcp_set_state(): if the state
switches from or to ESTABLISHED state, this newly added counter is
incremented. This helper is going to be used in the following patch.

Similar to MPTCP_INC_STATS(), a new helper called MPTCP_DEC_STATS() is
also needed to decrement a MIB counter.

Signed-off-by: Geliang Tang <geliang.tang@linux.dev>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e4a0fa47e816 ("mptcp: corner case locking for rx path fields initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/mib.c      |  1 +
 net/mptcp/mib.h      |  8 ++++++++
 net/mptcp/protocol.c | 18 ++++++++++++++++++
 net/mptcp/protocol.h |  1 +
 4 files changed, 28 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index a0990c365a2ea..c30405e768337 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -66,6 +66,7 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("RcvWndShared", MPTCP_MIB_RCVWNDSHARED),
 	SNMP_MIB_ITEM("RcvWndConflictUpdate", MPTCP_MIB_RCVWNDCONFLICTUPDATE),
 	SNMP_MIB_ITEM("RcvWndConflict", MPTCP_MIB_RCVWNDCONFLICT),
+	SNMP_MIB_ITEM("MPCurrEstab", MPTCP_MIB_CURRESTAB),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index cae71d9472529..dd7fd1f246b5f 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -65,6 +65,7 @@ enum linux_mptcp_mib_field {
 					 * conflict with another subflow while updating msk rcv wnd
 					 */
 	MPTCP_MIB_RCVWNDCONFLICT,	/* Conflict with while updating msk rcv wnd */
+	MPTCP_MIB_CURRESTAB,		/* Current established MPTCP connections */
 	__MPTCP_MIB_MAX
 };
 
@@ -95,4 +96,11 @@ static inline void __MPTCP_INC_STATS(struct net *net,
 		__SNMP_INC_STATS(net->mib.mptcp_statistics, field);
 }
 
+static inline void MPTCP_DEC_STATS(struct net *net,
+				   enum linux_mptcp_mib_field field)
+{
+	if (likely(net->mib.mptcp_statistics))
+		SNMP_DEC_STATS(net->mib.mptcp_statistics, field);
+}
+
 bool mptcp_mib_alloc(struct net *net);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9d4d5dbdbb53b..7765514451ded 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2877,6 +2877,24 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 	release_sock(ssk);
 }
 
+void mptcp_set_state(struct sock *sk, int state)
+{
+	int oldstate = sk->sk_state;
+
+	switch (state) {
+	case TCP_ESTABLISHED:
+		if (oldstate != TCP_ESTABLISHED)
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_CURRESTAB);
+		break;
+
+	default:
+		if (oldstate == TCP_ESTABLISHED)
+			MPTCP_DEC_STATS(sock_net(sk), MPTCP_MIB_CURRESTAB);
+	}
+
+	inet_sk_state_store(sk, state);
+}
+
 static const unsigned char new_state[16] = {
 	/* current state:     new state:      action:	*/
 	[0 /* (Invalid) */] = TCP_CLOSE,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 094d3fd47a92f..01778ffa86be1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -642,6 +642,7 @@ bool __mptcp_close(struct sock *sk, long timeout);
 void mptcp_cancel_work(struct sock *sk);
 void __mptcp_unaccepted_force_close(struct sock *sk);
 void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
+void mptcp_set_state(struct sock *sk, int state);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 			   const struct mptcp_addr_info *b, bool use_port);
-- 
2.43.0



