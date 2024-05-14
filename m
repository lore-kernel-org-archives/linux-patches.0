Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855CE6CDC9;
	Tue, 14 May 2024 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685519; cv=none; b=TbA3rxzbijUyRBeHgd36ZOJmdoR1uRvdho0MBdz5sCE3tjiKip4Bs25z1SUDEvaCg43WHFoz8cFij9UkE3RemRbejgI/MKBpQNyfTOa5zP2Jz9hOp+sTimL2dEicSVHcaUtQ1IndmZ4Hc0yg5kngHvIDJyYXAtvdP+Myo5QgkJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685519; c=relaxed/simple;
	bh=al7Sk76qkvhvJw4iG2MPeiCIHkXp4XuRokw49HsDQUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toxyvB4zMEyleySdynjRN335QpQqLR/LkAvi1KXlSChIT8sqP33q1tLMzswaxDEDD0hIIPn06m2Crl7RB1+GDWn2V7LtminbWl8MJTjznHYCsClLanVhcdTt8JHeey/bQ6IavbYaTJkSfblfBNvnm8Emzjd2B/7ewxqemWtiA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AT+yK2g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT+yK2g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8390C4AF09;
	Tue, 14 May 2024 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685519;
	bh=al7Sk76qkvhvJw4iG2MPeiCIHkXp4XuRokw49HsDQUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT+yK2g6iy/CLBagg3nx/yBw90Usio8vzdkYhsKRd4sZEmquUFkkqTcY/QeOH29cZ
	 fThLQaD4p1nfNkZikfdC8A3Io0DUBxA47dfaJHpGsB9qiUrvXciYegjA6I6Id5hbhx
	 WE21l8pXtKb1x47OiVA8GGkNzORIREJBJru6f/7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Simon Wilkinson <sxw@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Jeffrey Altman <jaltman@auristor.commailto:jaltman@auristor.com>
Subject: [PATCH 6.6 195/301] rxrpc: Fix congestion control algorithm
Date: Tue, 14 May 2024 12:17:46 +0200
Message-ID: <20240514101039.617287185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit ba4e103848d3a2a28a0445e39f4a9564187efe54 ]

Make the following fixes to the congestion control algorithm:

 (1) Don't vary the cwnd starting value by the size of RXRPC_TX_SMSS since
     that's currently held constant - set to the size of a jumbo subpacket
     payload so that we can create jumbo packets on the fly.  The current
     code invariably picks 3 as the starting value.

     Further, the starting cwnd needs to be an even number because we ack
     every other packet, so set it to 4.

 (2) Don't cut ssthresh when we see an ACK come from the peer with a
     receive window (rwind) less than ssthresh.  ssthresh keeps track of
     characteristics of the connection whereas rwind may be reduced by the
     peer for any reason - and may be reduced to 0.

Fixes: 1fc4fa2ac93d ("rxrpc: Fix congestion management")
Fixes: 0851115090a3 ("rxrpc: Reduce ssthresh to peer's receive window")
Signed-off-by: David Howells <dhowells@redhat.com>
Suggested-by: Simon Wilkinson <sxw@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Reviewed-by: Jeffrey Altman <jaltman@auristor.com <mailto:jaltman@auristor.com>>
Link: https://lore.kernel.org/r/20240503150749.1001323-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h | 2 +-
 net/rxrpc/call_object.c | 7 +------
 net/rxrpc/input.c       | 3 ---
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index bda3f6690b321..d431376bb120a 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -688,7 +688,7 @@ struct rxrpc_call {
 	 * packets) rather than bytes.
 	 */
 #define RXRPC_TX_SMSS		RXRPC_JUMBO_DATALEN
-#define RXRPC_MIN_CWND		(RXRPC_TX_SMSS > 2190 ? 2 : RXRPC_TX_SMSS > 1095 ? 3 : 4)
+#define RXRPC_MIN_CWND		4
 	u8			cong_cwnd;	/* Congestion window size */
 	u8			cong_extra;	/* Extra to send for congestion management */
 	u8			cong_ssthresh;	/* Slow-start threshold */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 0a50341d920af..29385908099ef 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -175,12 +175,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->rx_winsize = rxrpc_rx_window_size;
 	call->tx_winsize = 16;
 
-	if (RXRPC_TX_SMSS > 2190)
-		call->cong_cwnd = 2;
-	else if (RXRPC_TX_SMSS > 1095)
-		call->cong_cwnd = 3;
-	else
-		call->cong_cwnd = 4;
+	call->cong_cwnd = RXRPC_MIN_CWND;
 	call->cong_ssthresh = RXRPC_TX_MAX_WINDOW;
 
 	call->rxnet = rxnet;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 718ffd184ddb6..f7304e06aadca 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -688,9 +688,6 @@ static void rxrpc_input_ack_trailer(struct rxrpc_call *call, struct sk_buff *skb
 		call->tx_winsize = rwind;
 	}
 
-	if (call->cong_ssthresh > rwind)
-		call->cong_ssthresh = rwind;
-
 	mtu = min(ntohl(trailer->maxMTU), ntohl(trailer->ifMTU));
 
 	peer = call->peer;
-- 
2.43.0



