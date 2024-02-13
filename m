Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FC95FDD8;
	Tue, 13 Feb 2024 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845092; cv=none; b=F5FcZTam/dUki2WYV+/TKCjRsj8EIbymOyyueUD/1ZmBG5OMxqyehtVttXk5QzvUIsSQ1DDrVtlDjdOMoT2UNqiayBolVQw9GS3gP7ogQbVJCxM88eqxlGU3q3jcNWIO75lpIoTpbZbNH0milwMWHYFIobk7hP8UcLSseUL4zyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845092; c=relaxed/simple;
	bh=AEGq9F/uWwiLmYDtmOAKN1oZDSnAf46vP+JF6nBKhHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqiV7YD4BFAFJtrqz+KfBTppV8ilEa5DZQPPZVhCaof6wpfTb0HQ5tDUudbxCeGvTipDE3YCS//7dK2r9fQ5StZHJPctBzdqvDqbE31zhlPXXPoR2W0LonYF83xXmHDRhkgWW1RutiAKIhSXpEYaHl49LurCLZqenwyfjwAvCKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCKC+Qas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCKC+Qas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D647DC433C7;
	Tue, 13 Feb 2024 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845092;
	bh=AEGq9F/uWwiLmYDtmOAKN1oZDSnAf46vP+JF6nBKhHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCKC+QasxJw2PvF3KYszKa9ucObNK2evDMJsuIjhT5TwUhBeZmAuhOqLMF7TMHyXE
	 ZSkv4guKMEINZwn0yTsYuGlRxwMX4dG9nKBUK54ZiuIwJvdzbfWtBUKi07nccAgjgV
	 xOF/nmstZjqye0pOpZkSfkbr1BcXt7Bxe4pk8hV4=
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
Subject: [PATCH 6.1 27/64] rxrpc: Fix response to PING RESPONSE ACKs to a dead call
Date: Tue, 13 Feb 2024 18:21:13 +0100
Message-ID: <20240213171845.609427939@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aab069701398..5d91ef562ff7 100644
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



