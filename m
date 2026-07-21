Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E6F42DFEC;
	Tue, 21 Jul 2026 22:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671705; cv=none; b=FjFkOVXPsk1L79q31MuZbcYNPZxb233je8Ne7horCIYzQgWfsoy1e23L5JRo3WD0V22VD0BgyxOxOoupTlKn6+Ws95nB3YDLMf8Izv3CXcrhMktQRvnECGefyjOZX7wybRlMH94Fa59xOqxi25EbHYk5uMwWrjUSce0nPeXeI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671705; c=relaxed/simple;
	bh=xkhapEAFQ2y4FBM3frpTDDlG5n4fu8Ml9Cy5/P5g2Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCeUZHEvCCoKflHFp3msskyOUHrZ4GNYY1iRwQ4xl8YRGVeOrmt9xp38xJ58kfubj11iw8EWZnXxS2Vxj+qC1zF8Sq/Ccuj1gGbd1sr++0Cow7ZSPJsQKhohKMHXspv99bA0WschZ05cEPZD9JGlhdBGozCMBT9qaPsG4KhNk+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+yzhMRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+yzhMRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BCA1F00A3D;
	Tue, 21 Jul 2026 22:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671704;
	bh=D15ZjDHUh+AFFIeABKtPRXETnGUmOJo2H1fFzdFjJAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+yzhMRzSNfeWBxl9hThUirMbbZfpcacpiZVxm5ZVPMeUQprIxuw0iN1JUvZEehzW
	 nQt4ZFE0ydDsC6eRR1zfO3Vzm9zb0IoI5qHxhF+WzGztsUcqBHqrL7NiuUqEPQkwtr
	 6iCWw15aDTc6fsYZrOU8RH7NaHeqJNlkVSvASvqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/843] tipc: prevent snt_unacked underflow on CONN_ACK
Date: Tue, 21 Jul 2026 17:19:41 +0200
Message-ID: <20260721152413.813896733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eccb97b530b71d..d7110b2738a570 100644
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



