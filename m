Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C22B4E1AD;
	Tue, 23 Jan 2024 01:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975087; cv=none; b=FAWq1fkH1C3Tc/2dNoXqRcr8kfCNH1DPDHQcGQBZzKHxs+1w6Jc0LpmTFfaQGL7Si/DLCqTYOgXU35Q740tXaYn+S1ZmXRGihIVvcSTCncKxHYRQeEaDInH6FHtPCXB5kZa81RRS17Ixn9VZDjb20Ia07rnIPjsEZoO3LhT2ob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975087; c=relaxed/simple;
	bh=iVY1TzcuO4Cyuf0UOnawI7Amn1utTnfZG4w20lJDqCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBoTpsZnyJVKTyfNEuxqm7g3u8KUm9Z9XB2DUOw06JnxwXbd2SRKyTNT13wH3nepmHhJcsykd8sRX+Md9BXzogVrWI/SVYywppUfUqEQ5BsGuLI6fNnElymGsqplKTrCEiySmUU/IWBU1tWPYXkksoFzz/BgFuMKRcykP677Cps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C614+0v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C614+0v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40936C433F1;
	Tue, 23 Jan 2024 01:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975087;
	bh=iVY1TzcuO4Cyuf0UOnawI7Amn1utTnfZG4w20lJDqCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C614+0v3WSdV1nrICY3FRvadL3bhw/qo/lsiDveM32KwtnaBbQ11vizxJdz3/CoUY
	 Lgpy9tNGW8kSG5Eawe7iJQ1i0PhzQSrcVpaK7lMfusXfi87t2Dpk3NcoBnA4e6XhEp
	 14apqUhpu2ha35ZylztS60vTvlaYvuioBIZ6wNI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/583] rxrpc: Fix skbuff cleanup of calls recvmsg_queue and rx_oos_queue
Date: Mon, 22 Jan 2024 15:54:30 -0800
Message-ID: <20240122235818.703132870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

[ Upstream commit 4fc68c4c1a114ba597b4f3b082f04622dfa0e0f6 ]

Fix rxrpc_cleanup_ring() to use rxrpc_purge_queue() rather than
skb_queue_purge() so that the count of outstanding skbuffs is correctly
updated when a failed call is cleaned up.

Without this rmmod may hang waiting for rxrpc_n_rx_skbs to become zero.

Fixes: 5d7edbc9231e ("rxrpc: Get rid of the Rx ring")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 773eecd1e979..f10b37c14772 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -545,8 +545,8 @@ void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
  */
 static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 {
-	skb_queue_purge(&call->recvmsg_queue);
-	skb_queue_purge(&call->rx_oos_queue);
+	rxrpc_purge_queue(&call->recvmsg_queue);
+	rxrpc_purge_queue(&call->rx_oos_queue);
 }
 
 /*
-- 
2.43.0



