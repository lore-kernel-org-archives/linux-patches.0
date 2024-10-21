Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095D1F9A80;
	Mon, 21 Oct 2024 10:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507873; cv=none; b=UA/bdOVSSgDMAXJBiPpdqvQdFZaMuQ5ejsGoI72NR0u9tL8cN+sgbnHxJ+GHN/n/s6vFcmy78YIinnTNrlQWkuEmFB7m4+kG5chAEmucz8lFyjsgazlnNOo//ws1jIDRAlgahTxpAQmBxWjaj/1BhyARD0kWzNpXhV4/zqpAyas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507873; c=relaxed/simple;
	bh=7dYKpQZhV/cWmKGC9JP8OvMxdVKa/FM0rLF7OKJg0+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3OykOfuo3ENgBEf0gXL7rWCcti1BtumlneA3nmn9qxItq3CEvUg0zuN5dmA8GwYEgQIgKoovtHus2lTFlwEne/OsffjyqK7ztLJLBrGjzAkxH6++1wmhHoIezWLo5eKeeI1Uu+oOIYtGS9GNYpQxJy37HiYVsuG66spVainAwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1X/Sbjji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1X/Sbjji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AA8C4CEE7;
	Mon, 21 Oct 2024 10:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507873;
	bh=7dYKpQZhV/cWmKGC9JP8OvMxdVKa/FM0rLF7OKJg0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1X/SbjjiiQgUubFT8mwebPKrFrSuFAdPLsm3GbA9s6Wv4c8u7K69BnbAC5Frc2UEX
	 FbUx/5cSbN4PY8cLFig+OTsNcwA21k3atcSHyQiAcmPk5JWedWYvvRRZYoScFXO56D
	 CzErCRmF+AkSu5Gwzm8cbJsDdz4fhaLfv4F6vZBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.10 47/52] mptcp: track and update contiguous data status
Date: Mon, 21 Oct 2024 12:26:08 +0200
Message-ID: <20241021102243.468326394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 0530020a7c8f2204e784f0dbdc882bbd961fdbde upstream.

This patch adds a new member allow_infinite_fallback in mptcp_sock,
which is initialized to 'true' when the connection begins and is set
to 'false' on any retransmit or successful MP_JOIN. Only do infinite
mapping fallback if there is a single subflow AND there have been no
retransmissions AND there have never been any MP_JOINs.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
[ Conflicts in protocol.c, because commit 3e5014909b56 ("mptcp: cleanup
  MPJ subflow list handling") is not in this version. This commit is
  linked to a new feature, changing the context around. The new line
  can still be added at the same place.
  Conflicts in protocol.h, because commit 4f6e14bd19d6 ("mptcp: support
  TCP_CORK and TCP_NODELAY") is not in this version. This commit is
  linked to a new feature, changing the context around. The new line can
  still be added at the same place.
  Conflicts in subflow.c, because commit 0348c690ed37 ("mptcp: add the
  fallback check") is not in this version. This commit is linked to a
  new feature, changing the context around. The new line can still be
  added at the same place.
  Extra conflicts in v5.10, because the context has been changed. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 +++++-
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1810,9 +1810,11 @@ static void mptcp_worker(struct work_str
 		if (!mptcp_ext_cache_refill(msk))
 			break;
 	}
-	if (copied)
+	if (copied) {
 		tcp_push(ssk, msg.msg_flags, mss_now, tcp_sk(ssk)->nonagle,
 			 size_goal);
+		WRITE_ONCE(msk->allow_infinite_fallback, false);
+	}
 
 	dfrag->data_seq = orig_write_seq;
 	dfrag->offset = orig_offset;
@@ -1845,6 +1847,7 @@ static int __mptcp_init_sock(struct sock
 
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
+	WRITE_ONCE(msk->allow_infinite_fallback, true);
 
 	mptcp_pm_data_init(msk);
 
@@ -2543,6 +2546,7 @@ bool mptcp_finish_join(struct sock *sk)
 	if (parent_sock && !sk->sk_socket)
 		mptcp_sock_graft(sk, parent_sock);
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
+	WRITE_ONCE(msk->allow_infinite_fallback, false);
 	return true;
 }
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -213,6 +213,7 @@ struct mptcp_sock {
 	bool		rcv_data_fin;
 	bool		snd_data_fin_enable;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
+	bool		allow_infinite_fallback;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1179,6 +1179,7 @@ int __mptcp_subflow_connect(struct sock
 	list_add_tail(&subflow->node, &msk->join_list);
 	spin_unlock_bh(&msk->join_list_lock);
 
+	WRITE_ONCE(msk->allow_infinite_fallback, false);
 	return err;
 
 failed:


