Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E257C09A;
	Wed, 21 Feb 2024 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524494; cv=none; b=T10NSbKfRCoPS3N1cdDFtDM62tym4n3/rnkaa0P1gsC0LEqBlZz4/RpSHZcL59dBipb8o1iuA1MoiQpVV7BT4YRKt97rRui1UzQSSpnlO1nEX7+sRSMVVGKzzpF8kv0tY7e/vVg1FgMcBLwtsN9o4gvobVg0aVRC32msSIn/7m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524494; c=relaxed/simple;
	bh=6eei+uUJy2Tp4+TFQTQWvmwR6IaUAIXfqY9YUkVEhNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btmET4HB87RBg+FSFka1mO8EunKKSAGvlINWeFVdU0bXortcg4OE7fq02xbecWS50Th5Y1EcXnFIUnyigdX9JpYHwVgeKYJLXxYE2rnarbCS7unZtsw6aweSK+6Ch30B49tQ00DoYKWN0wklDf8LWQdWwS4iDHa+foN4ER8w6AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jLgyvKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jLgyvKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBABFC433C7;
	Wed, 21 Feb 2024 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524494;
	bh=6eei+uUJy2Tp4+TFQTQWvmwR6IaUAIXfqY9YUkVEhNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jLgyvKm5Cxni5qaJhriP8Rr33Znl39sqlLKOX/g72SqffCgZBCRrohhJk4+4wd6a
	 e+g/bBOP2YAsAOy/Pu6uyQ90UdaCdaLqG+bOySyQ0orjX9e3UNHQnoAwgzgT51TgLi
	 RK656Z9SKECy+IZwGFn1lr2gV3mS/qHL3HGojGiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/379] rxrpc: Fix response to PING RESPONSE ACKs to a dead call
Date: Wed, 21 Feb 2024 14:07:21 +0100
Message-ID: <20240221130002.665266294@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6f769f22822aa4124b556339781b04d810f0e038 ]

Stop rxrpc from sending a DUP ACK in response to a PING RESPONSE ACK on a
dead call.  We may have initiated the ping but the call may have beaten the
response to completion.

Fixes: 18bfeba50dfd ("rxrpc: Perform terminal call ACK/ABORT retransmission from conn processor")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_event.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index aff184145ffa..9081e8429584 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -41,6 +41,14 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 
 	_enter("%d", conn->debug_id);
 
+	if (sp && sp->hdr.type == RXRPC_PACKET_TYPE_ACK) {
+		if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
+				  &pkt.ack, sizeof(pkt.ack)) < 0)
+			return;
+		if (pkt.ack.reason == RXRPC_ACK_PING_RESPONSE)
+			return;
+	}
+
 	chan = &conn->channels[channel];
 
 	/* If the last call got moved on whilst we were waiting to run, just
-- 
2.43.0



