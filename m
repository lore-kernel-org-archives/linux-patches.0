Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4DE12CDA5;
	Sun,  7 Jun 2026 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829955; cv=none; b=FnIP5avRy87J3J7k2r7OeyaaBoHQMC9O5pR+MnLiKN14rfvnqx/yoU9vnRUGGRtB3tcikMvjGCwX2USAw8ewG2j5fn7jxTLpYAG6L+OyAprk8rKxWfZXJrux7gV2+GBqQBS7bWxC8VoG2lMJMRpUOiVOO4Lr2FFgATjLF3iCqCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829955; c=relaxed/simple;
	bh=TXcTwm7sHGppeF9QKrpsbJV7DzMniGuoN2hQmm82bfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/tkT97bZiCFkS6y9LUO3Kk8PG/xq4hdrEaTnCMqnBzrlh4bNpVRwJUNdHikwMUAag7PCrdfN93+4guZe24Ssz0jaaC90Q7Q8a1/Yy6iMHfJPcWEuCXp9sGZH7iEczB/i5Y2ecm18e4Tx3dQo3GJmctO814YKiE4P+FlQDSXRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JslXi4Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JslXi4Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18591F00893;
	Sun,  7 Jun 2026 10:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829954;
	bh=HtbauBaSCFsNTmOA4vzu6hEV0p7tmLM9Ho/moACh6rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JslXi4IiEhxnlozD/tuYt9fmPI185SJtWC4LEcHPAE1zNFEnhGLjXMwqDqIHkKgnW
	 yxOpHZDDlpopJEb2jHHPqNA7zeI0Tonwc3bFYbr3PiTnmcsBOWI4HtF++8UHfyaVQb
	 D1snBRROLLd9Rfvwz06bkklifaPvp2+R7fjjA5ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 295/315] mptcp: do not drop partial packets
Date: Sun,  7 Jun 2026 12:01:22 +0200
Message-ID: <20260607095738.430568169@linuxfoundation.org>
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

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

[ Upstream commit 50c2d91c5dfa0e465826ec1f8dbad9cdc254bd85 ]

When a packet arrives with map_seq < ack_seq < end_seq, the beginning
of the packet has already been acknowledged but the end contains new
data. Currently the entire packet is dropped as "old data," forcing
the sender to retransmit.

Instead, skip the already-acked bytes by adjusting the skb offset and
enqueue only the new portion. Update bytes_received and ack_seq to
reflect the new data consumed.

A previous attempt at this fix has been sent by Paolo Abeni [1], but had
issues [2]: it also added a zero-window check and changed rcv_wnd_sent
initialization, which caused test regressions. This version addresses
only the partial packet handling without modifying receive window
accounting.

Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue.")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/c9b426a4e163aa3c4fe8b80c79f1a610f47ae7d8.1763075056.git.pabeni@redhat.com [1]
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/600 [2]
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
[pabeni@redhat.com: update map]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260515-net-mptcp-misc-fixes-7-1-rc4-v2-1-701e96419f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -395,12 +395,26 @@ static bool __mptcp_move_skb(struct sock
 		return false;
 	}
 
-	/* old data, keep it simple and drop the whole pkt, sender
-	 * will retransmit as needed, if needed.
+	/* Completely old data? */
+	if (!after64(MPTCP_SKB_CB(skb)->end_seq, msk->ack_seq)) {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
+		mptcp_drop(sk, skb);
+		return false;
+	}
+
+	/* Partial packet: map_seq < ack_seq < end_seq.
+	 * Skip the already-acked bytes and enqueue the new data.
 	 */
-	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
-	mptcp_drop(sk, skb);
-	return false;
+	copy_len = MPTCP_SKB_CB(skb)->end_seq - msk->ack_seq;
+	MPTCP_SKB_CB(skb)->offset += msk->ack_seq - MPTCP_SKB_CB(skb)->map_seq;
+	MPTCP_SKB_CB(skb)->map_seq += msk->ack_seq -
+				      MPTCP_SKB_CB(skb)->map_seq;
+	msk->bytes_received += copy_len;
+	WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
+
+	skb_set_owner_r(skb, sk);
+	__skb_queue_tail(&sk->sk_receive_queue, skb);
+	return true;
 }
 
 static void mptcp_stop_rtx_timer(struct sock *sk)


