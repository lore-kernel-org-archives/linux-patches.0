Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D8344239B;
	Fri,  7 Aug 2026 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114632; cv=none; b=Yy09ttmDVCIi6cFhu7vXnDlWRW1tE1Grxp8dvHj1ZglZnIoltMrhpEaDnvyoZUaTsseVReO5S/adApQgVtb5uqrd3uu4Q9lL7NXoJ3Qn9bKu61Rt0K8Ez4VIhWWvJCXHRNxiLCcJAyDMsrho2WYck8VQwzSb1pN1qXKHeMA1VaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114632; c=relaxed/simple;
	bh=rsOnejBQSdGH5fsuyA1V2rPZ6pYsyNHKlh/rzjne/AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW0cAmUBd9VMMSW1icBskC+SXHh3h2+koICzeQeNGY/0uXa/70uJXis2QQLyd/sfDSqMapuRAE5Zuk8KJdDmjOV5HkFMYbBpZuyqFQ0RST57D0Gbl0CgV1QH99/s7f94EMwQaektOjvM+qbhA3dYJm188c2AaFgtMe4/gMUqCPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y4PzOc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y4PzOc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C72B1F00A3A;
	Fri,  7 Aug 2026 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114625;
	bh=XwDGOubuX4Sf6tbLSEt9Kv97cV//AUsxjU8PCJOSL44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0y4PzOc4LmCdf2Tsn89Hkuw4XquhkiJMEndZXxQ+m4du52NEKN3UGRWdAqyIaH9/i
	 Q1RsWZRtyJC7p8Xnzcf3OoperTstDhndC2ZmtUwThX2goZmIYNy8VC3+ntCCj/utLk
	 9giQiVo0aLEwMFrjI+4FOtMkRxwO8cRdtJqC/8ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Simon Wilkinson <sxw@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/337] rxrpc: Fix the calculation and use of RTO
Date: Fri,  7 Aug 2026 16:38:53 +0200
Message-ID: <20260807143425.695475885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5c0ceba23bb47085d6c9c53bff08a29634ee4e7e ]

Make the following changes to the calculation and use of RTO:

 (1) Fix rxrpc_resend() to use the backed-off RTO value obtained by calling
     rxrpc_get_rto_backoff() rather than extracting the value itself.
     Without this, it may retransmit packets too early.

 (2) The RTO value being similar to the RTT causes a lot of extraneous
     resends because the RTT doesn't end up taking account of clearing out
     of the receive queue on the server.  Worse, responses to PING-ACKs are
     made as fast as possible and so are less than the DATA-requested-ACK
     RTT and so skew the RTT down.

     Fix this by putting a lower bound on the RTO by adding 100ms to it and
     limiting the lower end to 200ms.

Fixes: c410bf01933e ("rxrpc: Fix the excessive initial retransmission timeout")
Fixes: 37473e416234 ("rxrpc: Clean up the resend algorithm")
Signed-off-by: David Howells <dhowells@redhat.com>
Suggested-by: Simon Wilkinson <sxw@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e4d2878369d5 ("rxrpc: Fix irq-disabled in local_bh_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_event.c |    3 ++-
 net/rxrpc/rtt.c        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -71,7 +71,8 @@ void rxrpc_resend(struct rxrpc_call *cal
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_txbuf *txb;
 	rxrpc_seq_t transmitted = call->tx_transmitted;
-	ktime_t next_resend = KTIME_MAX, rto = ns_to_ktime(call->peer->rto_us * NSEC_PER_USEC);
+	ktime_t next_resend = KTIME_MAX;
+	ktime_t rto = rxrpc_get_rto_backoff(call->peer, false);
 	ktime_t resend_at = KTIME_MAX, now, delay;
 	bool unacked = false, did_send = false;
 	unsigned int i;
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -27,7 +27,7 @@ static u32 __rxrpc_set_rto(const struct
 
 static u32 rxrpc_bound_rto(u32 rto)
 {
-	return min(rto, RXRPC_RTO_MAX);
+	return clamp(200000, rto + 100000, RXRPC_RTO_MAX);
 }
 
 /*


