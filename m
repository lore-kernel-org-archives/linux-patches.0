Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04D044AB7F;
	Tue, 21 Jul 2026 21:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669127; cv=none; b=nXfEh4R8X1wOB0PLy9mBd3Eeuf1BXvR69S7zGulTz89wvyEZDIfBh1psFyI4V9Ec9jkrEt/XgJbWYZ02ltXKFIAfU8mPKbLe7Jm437Vw+ckagJdeAsJjs45PwXpMyFPDCcHOat/t61mPdKQ7oRL+VfvSAXmQ8eM1ZBQrUjKJerM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669127; c=relaxed/simple;
	bh=TYbTa3w8huKXLCEfUhBShptViDwGcB7ZUJfoF6GNlm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg448ouV1b5dBoRIrQW6t4Sy3YexszqEfQTFJ5jPrGTJsqGBJnYuE3B9jLIT5jlIrDnhZp8wEJBakbd9r97ocqc60zrRDdhawV1ZA4+T42kveTCruntv4J4f3r98ye0ZNcifJWOvkQERuglW7qe0kmTu14m1kNwW0HYHWDtc/Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8SOqBCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8SOqBCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428F91F000E9;
	Tue, 21 Jul 2026 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669126;
	bh=JaceFURkNkwL92Efx+oLutQF/spZs45Ws5ZGjWHyKRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8SOqBCjWQx8cft/OVlQhtsJfk45t4HeejS/6Y/Gb66Lq4PyMWrG5Lg9FiqP7/kV5
	 wd+YjGkkrOCFvsd5crl5N7iFoP37iRkUsWkCZXWuI9nw2wSRBqieqx1/RZNMyZbxp3
	 D7IUIh3vNPhLR4tId+6v1SSFb8i/riIanph9oFtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0438/1067] tipc: prevent snt_unacked underflow on CONN_ACK
Date: Tue, 21 Jul 2026 17:17:19 +0200
Message-ID: <20260721152434.414561395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d828ae769fd67..c981bca5af5947 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1366,6 +1366,9 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
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



