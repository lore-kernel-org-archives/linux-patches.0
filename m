Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129DA5F54E;
	Tue, 13 Feb 2024 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845402; cv=none; b=ea+96l1/Mh6gteJP+ucK8TG8yC7u2BuukvllpK2Jzu19jrwNOk4a0MgK4mLudewVkeWULQRO4v7T/WlXNy1YctpDXqqO15d8+SjEjJVmMztBX5Ig49tkb6pIeTgFKCNrWkWRkYwUKczSidbOB1LoQU2/Ng/R+Ry61NMt6vWIhYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845402; c=relaxed/simple;
	bh=SbEqPa68EIJjlYQogjH0w3T47E8q0RH3pjibl2SvH+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TddmYDzNkFHTVV9OC8+YqWUL15+mUHnyMZFPUF5zZQNE+xpvEeRtk4wE/nKIAF+jKl978vCvBcUTMEkqxShj3+PA5W8f9Si/U2ze42hWnanRr+a1eD9uHb6qPtxjbVxknxcinAjIw1Y3vRtrVScbw6vtk4V9+a6kqsm51+g/N8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jrJaaAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jrJaaAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD9FC433C7;
	Tue, 13 Feb 2024 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845401;
	bh=SbEqPa68EIJjlYQogjH0w3T47E8q0RH3pjibl2SvH+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jrJaaAKuupLpbBi4kKuiwmdn1960jg6tE2Xkevq1JN2xqn2DWeCtJgrDBEHcyp+o
	 iM8n/jEmGaG4aJQk4iiSxF3Jkfw5kMOUpGaWbN06x7qdsLPMnOOiSwY/9qfkVStb7b
	 opfJW5E10MyTsKlLAj1HHSyLuiUfvngwoWGBj6pg=
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
Subject: [PATCH 6.6 067/121] rxrpc: Fix response to PING RESPONSE ACKs to a dead call
Date: Tue, 13 Feb 2024 18:21:16 +0100
Message-ID: <20240213171854.950890125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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
index ec5eae60ab0c..1f251d758cb9 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -95,6 +95,14 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 
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



