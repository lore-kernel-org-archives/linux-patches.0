Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D28C3AA4F9;
	Tue, 21 Jul 2026 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673702; cv=none; b=rHT4kCX4lcNKdNup2jTqOOOeqAYqgnwrhOmOM3CaPn3JH5KM52/yjTpaAJmMAqR1sULgHFGI05u8baMVh7g86aU/tSEAsljtswAmfbjyxqSTkOY5NthBy1Uup+sS0EF7mXffJFs1J1D6p7CiuLWZPCTaMacSOY5/+WjOfcHtHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673702; c=relaxed/simple;
	bh=eEsAIWUFbbhynmMs1XLeqYcfBjZ9NgPwyvkz+AIOahA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qob1FJ1zbAutVsIfmTwAxy9Ck9RidKPv35J1jfLINJGc8D1UNAvXXAww+gAfH3fk349DiV9oOJTeO5Ojh9CnqPAbHFHa7CMDaAqzB++uPN7LM7HMBKMerNLxsgHd19P+5VxOfXudmRonmrwrRUU68Vz/tpUVtLe1uBzrvdsSr4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU9WmkY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU9WmkY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3261F000E9;
	Tue, 21 Jul 2026 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673701;
	bh=grw7jcTJh/kOIP5c9l01p2f3wXaXBxvWO2cvV/FmJnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CU9WmkY45LXaLngcYafRAlqOK4XPprPK72F9iCcSciFqnfgPK2lKq28iJbnQUTlBm
	 88yAuGQ6qi2ohgOJAjCa27JcUGJPoDm9Aoqxe/f7UHjYGxV0JISqXR/YJbidxtjvaD
	 v2dzfaonXXfiuGZ8uOJkyp+a6oMzyo1bbMwLfKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/699] tipc: prevent snt_unacked underflow on CONN_ACK
Date: Tue, 21 Jul 2026 17:20:19 +0200
Message-ID: <20260721152401.563863035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit ab3e10b44ba5411779aac7afd2477917dd77750f ]

tipc_sk_conn_proto_rcv() subtracts the peer-supplied connection ack count
from the unsigned 16-bit send counter snt_unacked without checking that it
does not exceed the number of messages actually outstanding:

	tsk->snt_unacked -= msg_conn_ack(hdr);

msg_conn_ack() is read straight from a received CONN_MANAGER/CONN_ACK
message. If the ack count is larger than snt_unacked, the subtraction
wraps to a near-maximum value, leaving tsk_conn_cong() permanently true
and starving the connection of further transmits.

Validate the ACK count at the start of the CONN_ACK block and drop the
message if it acknowledges more messages than are outstanding. A peer (or,
for a local connection, the connected peer socket) can otherwise wedge a
TIPC connection's send side by sending an oversized connection ack.

Fixes: 10724cc7bb78 ("tipc: redesign connection-level flow control")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260610124003.3831170-3-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 5adfd0d854a2b2..321f3317e3271c 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1354,6 +1354,9 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 			__skb_queue_tail(xmitq, skb);
 		return;
 	} else if (mtyp == CONN_ACK) {
+		if (tsk->snt_unacked < msg_conn_ack(hdr))
+			goto exit;
+
 		was_cong = tsk_conn_cong(tsk);
 		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
 		tsk->snt_unacked -= msg_conn_ack(hdr);
-- 
2.53.0



