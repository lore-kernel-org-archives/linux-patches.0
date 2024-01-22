Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B32B372;
	Tue, 23 Jan 2024 00:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969464; cv=none; b=quublve2e6VOs+HEAKdfhJxK4h1gpsOy77kvieTZABJdIM2AqdaLTLn1CuF17fr+OYZXLqfe/l9cmYInziWM1r2ZHY2sBul145IDdx5RE/w2ww2YuRIkChT196rIkKBQh/Ezbz5LeF6Nzwt1mdlEpJzxwW8sVoeYVqWpVSiCFUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969464; c=relaxed/simple;
	bh=bSghpvZNq1T3rrpOYipet9T1woLnbL0GcCMSCBWTcXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYPvv02WZzc0M1Q3xqHiGp13zI3jWUiYfNSGPOeecH5S/uRB0ZsGQdcYAR1YmquSqjnNxqiHbnukRgxARhwMio8cT4W617CsZs6OjZkKomaYXdvfAvV/zDwUJzWZ2CKncfGTW69lbeuLhbDTyfG1tMwmetzW3Czx7nVw2VLJIgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfiR9spj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfiR9spj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD3EC433F1;
	Tue, 23 Jan 2024 00:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969464;
	bh=bSghpvZNq1T3rrpOYipet9T1woLnbL0GcCMSCBWTcXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfiR9spjTzHxxdoTeR0FvNE3EcmwgaO1wwbRrvv4UUGWLyyHjPgEUZPwmTxdfGx6T
	 MVNmoXTc657mmVatc3sxc8Yi+uV60hVyHH9MvR8wT0AAqNrFYYkBbQvZHfGBghUsjf
	 BEnAze1OtvkiiEOqX//1SclGKGrjw47s8KPeyzyU=
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
Subject: [PATCH 6.7 239/641] rxrpc: Fix skbuff cleanup of calls recvmsg_queue and rx_oos_queue
Date: Mon, 22 Jan 2024 15:52:23 -0800
Message-ID: <20240122235825.406423043@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



