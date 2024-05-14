Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0135476026;
	Tue, 14 May 2024 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683639; cv=none; b=snNYbM8fi0P7XDRSUneZCowOGURAFTJ1x+SsjmUDV+ABP+fsAkTvjvn98RfqSTxbJkDa1ZsH/D47Gxjz/0ZgzYcpvpWxLz8fUKeUNF+c6GY7oZPfXtpiQ1nxTb5bnkCI50imk6ldTzSeYtPUffFSq4/Rn3CQGfdWs5J3y56qLhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683639; c=relaxed/simple;
	bh=QmcQ5ApsL+i9u6LsFJtq1I00FTJh3bZ5nN8YfB19oaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZyWndLFqPGCDX/NEaSzPy7x/TAsCj+jP7jlPxjW/+intpkQP5+72t4bCf2/1jE3akwo/AUL+98rkvXw22wYAy0RKnTYDicIL2w5a2DiGYvjn6LPqZwv8pozPUhofI2qUAN1WlYUHtLgxg0yh11BwCoHB8VfZHSLJWcJdV1nRSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWOUwlMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWOUwlMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB03C2BD10;
	Tue, 14 May 2024 10:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683638;
	bh=QmcQ5ApsL+i9u6LsFJtq1I00FTJh3bZ5nN8YfB19oaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWOUwlMOGYZYfRW9fiVZiXdu4dS6O5w81WipwzDF4+vRIoOpQS9JvrpN8BqGCjXcx
	 iCx90ZgAlJ3Yad9Ff59GTCSVYl8IzCyNwHYxMdHbQKBdDjMthwyKOIA7C4mdFB3pJ6
	 SssJRL1/07rl3FPPlRhRiNXizQke7rhfq0jxPht4=
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
Subject: [PATCH 6.8 217/336] rxrpc: Fix congestion control algorithm
Date: Tue, 14 May 2024 12:17:01 +0200
Message-ID: <20240514101046.805714948@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 7818aae1be8e0..4301dd20b4eaa 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -692,7 +692,7 @@ struct rxrpc_call {
 	 * packets) rather than bytes.
 	 */
 #define RXRPC_TX_SMSS		RXRPC_JUMBO_DATALEN
-#define RXRPC_MIN_CWND		(RXRPC_TX_SMSS > 2190 ? 2 : RXRPC_TX_SMSS > 1095 ? 3 : 4)
+#define RXRPC_MIN_CWND		4
 	u8			cong_cwnd;	/* Congestion window size */
 	u8			cong_extra;	/* Extra to send for congestion management */
 	u8			cong_ssthresh;	/* Slow-start threshold */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 9fc9a6c3f6858..3847b14af7f3c 100644
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



