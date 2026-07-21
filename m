Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430D3B3C0A;
	Tue, 21 Jul 2026 20:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666126; cv=none; b=bIlTC4gTvWgu2w5iqkYh71ImFbasCFk8VJUGaghl7Z1dGQqjSBfnJyNbPvNnEw6MR4pQ+pPuKrZpq7fhtkYTZraq8Sc3dykUhq8io2vHx/p267UQbzsUK+hB0v50AGQC3LwQcunLbc8IMfWpxjwyBo6bWAYz0GfwEH4CgP6sLy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666126; c=relaxed/simple;
	bh=cP0oSLAcW7lV28CamqQ3iZa7+81DQ6L47dZ97stLMQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtgnKNmmyUDs6l2LJ3ll2MhrT5mqeC0Hgamec8gvX7vyj1/6sM3lRgLlTDh1JOl8xwDOu5aiC/ybsvaRVn+Nrz6j48JWAViTM2tGeBAbP7VFa3imhlGTmaPBus+O66k3jFggmAgAjMeFHItbYURGdhcV+z8rcX9vaoX6CNxSPRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0x1mEcjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0x1mEcjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E811F000E9;
	Tue, 21 Jul 2026 20:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666124;
	bh=T1k7oB+OQAgbE5RIoRYuaEbQCDqY45lXqENmNViT0h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0x1mEcjv6/HfD43UJbw3Awx+NtTa83GQ1kvUEc3hiotrJR078HSFpSw+Zkrub53Xh
	 35G9DfPsZf+4Ybau99mrfJWWIgN/Y1MulPYYK2IKh9omkyWhGSndPE3nyuOKMfvtTx
	 zubt+C6+pAv9s3IXp2c1LSidourhy6P0DiugY1vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0565/1266] tipc: prevent snt_unacked underflow on CONN_ACK
Date: Tue, 21 Jul 2026 17:16:42 +0200
Message-ID: <20260721152454.509296184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5931e56ef094e..31c6b61f0b0fd9 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1367,6 +1367,9 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
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



