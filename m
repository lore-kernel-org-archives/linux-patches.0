Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510E7339870;
	Mon, 13 Apr 2026 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099705; cv=none; b=MFLOl0XlADcPWYvZf+PptZhFrWA3cM2amNB6RQKMv2CBFEtOtUwHwz5TdKGqoLxaeilfIGNTd6DgpLWcZ3yuEGv9chihraa7mjJhG5ZRuGa7SmWaaGC2gPil4dRSrtlaoXupe6mcyl0Ew8HPWe7CqzenmTQZAELRisheJWCOynw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099705; c=relaxed/simple;
	bh=qIULiA+l2kezeIIURFp40r5prabimM6NdS2JlLBJOso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqdt2i54QsYIZrnGp/arNiAkpIkhOJUE05RTt8B7XpFtAj8m220D2kZ+OQsuF97G2fk3H1WqVPkaeZDgFnTq0UDSMOuj3rZth+9/r8nX4j94TmQvGXYAeOZxUry/SFKtt5bJz9WOMjVhJ0mQRlULI9psYtCDvmgI83OSEVTUVQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5+otxMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5+otxMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BAFC2BCB6;
	Mon, 13 Apr 2026 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099704;
	bh=qIULiA+l2kezeIIURFp40r5prabimM6NdS2JlLBJOso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5+otxMQYQGKAb8oGYvR67TWa04zkCbvzBB5xvqQb0M5bBcl9uXjj6vl85rQQnbIL
	 XOA84a+xy/ydBWekWYV/r5wvp0i1yxWE2s1/lo3v+c7r8f9w/BaBbdWpHa0HZqwd54
	 hPgf5MCygxxpU9PAJBA7Da+hYZeV99/G1ovkxChE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 442/491] tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG
Date: Mon, 13 Apr 2026 18:01:27 +0200
Message-ID: <20260413155835.576526398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -745,6 +745,7 @@ void tipc_group_proto_rcv(struct tipc_gr
 	u32 port = msg_origport(hdr);
 	struct tipc_member *m, *pm;
 	u16 remitted, in_flight;
+	u16 acked;
 
 	if (!grp)
 		return;
@@ -797,7 +798,10 @@ void tipc_group_proto_rcv(struct tipc_gr
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


