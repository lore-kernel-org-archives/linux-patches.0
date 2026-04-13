Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF8E29ACD7;
	Mon, 13 Apr 2026 16:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096715; cv=none; b=QqbYgvZNUwU67rLlCt5aasaKuz2sFhy47A4NlrjCmo0dPvokuXFp3Dj6uptD6jFjw++3k9Sy1yVUaCyckciyU6CONjGe+gIq4eIUu9a1fuTNWbzoCCGka0viSPifhjs/LSZ3WfmqwPVekm5wGDerwz+0NIPWFib89cx40wYuBDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096715; c=relaxed/simple;
	bh=fRnwI/9b1HM5um2MyfdaMxOavExNNmK1mI8PaQtluLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+/A8wa3Z9HdizlrTaN/KkYYZvZd8nl3sfyli+dRgh7EF0r6MSIimVDVuYl+tWN+2W8yrmaYpJf24Y8FKosI/Xb/Zk8DZQ8Qvv4z0rU58r35w9zDBW3K8cUzAYZQ5p7MZWBIYrWMBPnvh1dv5LcjGZm/h8YMl+cYZzsbtj7Ib0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orXJ+eQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orXJ+eQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96F7C2BCAF;
	Mon, 13 Apr 2026 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096715;
	bh=fRnwI/9b1HM5um2MyfdaMxOavExNNmK1mI8PaQtluLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orXJ+eQJAvYu/ISYnbImSkAoVfZzmdQwPZ8uiBGm5HZDMWCFI9C9H4izKDGGOo3B3
	 wqsdgsxPlO3q1UNVwMBZ/24WHaTQFbGSJBijuubAvHstJcGggEiZAsk0Y9PNEOfdDG
	 wJyfGe5TXUhOZ0qYMTLQ1obszE0Z+sXtOU8PzgdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 34/70] tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG
Date: Mon, 13 Apr 2026 18:00:29 +0200
Message-ID: <20260413155729.458274334@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleh Konko <security@1seal.org>

commit 48a5fe38772b6f039522469ee6131a67838221a8 upstream.

The GRP_ACK_MSG handler in tipc_group_proto_rcv() currently decrements
bc_ackers on every inbound group ACK, even when the same member has
already acknowledged the current broadcast round.

Because bc_ackers is a u16, a duplicate ACK received after the last
legitimate ACK wraps the counter to 65535. Once wrapped,
tipc_group_bc_cong() keeps reporting congestion and later group
broadcasts on the affected socket stay blocked until the group is
recreated.

Fix this by ignoring duplicate or stale ACKs before touching bc_acked or
bc_ackers. This makes repeated GRP_ACK_MSG handling idempotent and
prevents the underflow path.

Fixes: 2f487712b893 ("tipc: guarantee that group broadcast doesn't bypass group unicast")
Cc: stable@vger.kernel.org
Signed-off-by: Oleh Konko <security@1seal.org>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/41a4833f368641218e444fdcff822039.security@1seal.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/group.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -746,6 +746,7 @@ void tipc_group_proto_rcv(struct tipc_gr
 	u32 port = msg_origport(hdr);
 	struct tipc_member *m, *pm;
 	u16 remitted, in_flight;
+	u16 acked;
 
 	if (!grp)
 		return;
@@ -798,7 +799,10 @@ void tipc_group_proto_rcv(struct tipc_gr
 	case GRP_ACK_MSG:
 		if (!m)
 			return;
-		m->bc_acked = msg_grp_bc_acked(hdr);
+		acked = msg_grp_bc_acked(hdr);
+		if (less_eq(acked, m->bc_acked))
+			return;
+		m->bc_acked = acked;
 		if (--grp->bc_ackers)
 			return;
 		list_del_init(&m->small_win);


