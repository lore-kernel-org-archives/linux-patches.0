Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15086763F6;
	Wed, 21 Feb 2024 13:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521594; cv=none; b=MO8q561DU+GkGp0kNpxJ122W08WxSCHbRRZuNeTd3Upl6zPvd3KN5QWFxrStilagGiSbUEcwu+DEOH08bpyP0nCjJCtwRVr+Gnt7Plxj2fz4VultRlCVOydUnMqh1vhd/7ufLj2bWKYPztdZP6LgXfZcqidgbsoWkFtaZbieSkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521594; c=relaxed/simple;
	bh=LbFv/9KabQfjhDV5YKlwmWtzfbB85+f/a2TFZCMq5jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g42an0zlG11adNPA1Bu4L/yBshl7/VHYGhx+G9cwGnqzbYcg0Nj9JTdCdxzrsFu+ZL3e+AZ6pUIHOVwAy8QNNeKl2j3s5/rAsv6Ht/sqXPtVdTLJjQfzJC692ZL/PEw4a5tEmAaJ9+lUV/VGTVpVMC1lpxCnZiTo1aPT+6WqD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woBLoTeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woBLoTeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847A4C43390;
	Wed, 21 Feb 2024 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521593;
	bh=LbFv/9KabQfjhDV5YKlwmWtzfbB85+f/a2TFZCMq5jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woBLoTeBBtlzDHtt+18UfU+3YdJkwSuWeoVsm9sj3yi+UW7aVFw+bO7SvJk9sJGrj
	 1mHBdR5DFOopebFbjv7ZPSy6CKr6u+iEKXhV+GeY6TNDiXjkJajLFa8OLLsBa+hfBu
	 1YiHHYAiIsrLT8HX5aGskwmtDL6TLtcYMvdT7+40=
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
Subject: [PATCH 4.19 153/202] rxrpc: Fix response to PING RESPONSE ACKs to a dead call
Date: Wed, 21 Feb 2024 14:07:34 +0100
Message-ID: <20240221125936.634735812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 04213afd7710..84a70d7d0285 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -45,6 +45,14 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 
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



