Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DFB69962;
	Wed, 21 Feb 2024 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525543; cv=none; b=UPie/mgBHMUzz+N0cY74s6Y3RC1oAqoOFGxfxmHO3zLyR3MQyeHmmrzRoeXyxUnHJhhHRhN8JeSCPbeyxKt1baZreA0qabNyZW+bg5mcUahWwstEtCItJFd6qWv55I3M36CDV4+UrSL+oy+SlmOx7qk9bh+vOoarXfh//hUB+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525543; c=relaxed/simple;
	bh=33xWNptVJ7lwM3jsP+vAg6yNHkSj/oR/I0le7WdhQMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=And/38eaZOom2tHLy6r7jFeiXKfZxGQsq6xarLN5LPwBvxMRFuo1EYEq4uBGVA6PWC6yeNLsPZODiQGt2NzQw0hMF5JARU+Qh0/GRKzrzCW2jo8aMGO4IieZZkxSQov8ra1xTolMZN5sVW5ddkG85Y3Y6jHYOnk8660L7kwfRoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0XP+69z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0XP+69z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44782C433F1;
	Wed, 21 Feb 2024 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525543;
	bh=33xWNptVJ7lwM3jsP+vAg6yNHkSj/oR/I0le7WdhQMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0XP+69zK1tZwXmaU6QBv5zwNEMHFaBQvTksthnhTDI7bo2LbSKI6sMlKxPRKJ/+x
	 VEns7UKJPJX0H1hyX+tfuB9G6u3p240sVzU6MScOyp5YL+riCPIuYlhOGhzMT7XpY2
	 naDn4Obaj7fYaDxsOrFa9gA9JXWUqV5hBCPXBdc8=
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
Subject: [PATCH 5.4 188/267] rxrpc: Fix response to PING RESPONSE ACKs to a dead call
Date: Wed, 21 Feb 2024 14:08:49 +0100
Message-ID: <20240221125946.033678471@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b5864683f200..49669055ee9d 100644
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



