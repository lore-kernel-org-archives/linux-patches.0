Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D94E324C;
	Wed, 30 Sep 2026 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786774; cv=none; b=YrvFYRtlEbCqtbZ8cwnGliAiSotG6ByqEflkFEPzfWuyLPfc1y7rxLSKP0zDxQW5c3Z+kXCmsCs4yrto1Uti06zX2s/loKLxOasHAedEnNyUF/n0+XbOAehFinA5e7yVX0AyCa3sT2Sdnpn9WWzl6gIV3bX1qASrYUhz5F1wTu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786774; c=relaxed/simple;
	bh=h1SZMIY29VHki1T+UcAvK96OhYlST2s4osHmJEwIQIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdOJG7hbyRZTn3e3MbhCi5wT/jekKbeRU/cV3iNZmKwyoP92vh4uxiKmlmkoQ+5f8gp0pCOo8KyjTOlEUT4H5F6eleImOqszaF+HmgsXvtdp3ZRB962h6NvSpBf+InjOyhn3vGP4SuM45xXs+JqoMFPV4LuT9oQ/c4+VmTzguso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3DDezKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3DDezKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0631F000FF;
	Wed, 30 Sep 2026 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786772;
	bh=i4mWavE9hcSwxQ4DGwOW0eZPeCkr4psOFf85S22kqkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3DDezKtODFwAE/S6EICbhtwXScuTHEiNIuvYMI456DD3bKc+zym407lOREMhu63K
	 ESWaIE98n8zbN2EXmhaa3r1HlbFd/x96ImzH+GsH+IMROxY3JRoBJIWi0541Dhc3lO
	 cpjMJ0iF4ju9zd4YYBBtECieLeCzyowPN2gQ+xio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Burton <jamesburton@meta.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 925/982] tipc: reject invalid and unexpected GRP_ACK_MSG to prevent bc_ackers underflow
Date: Wed, 30 Sep 2026 17:27:41 +0200
Message-ID: <20260930152436.609735805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 99cc2a62e07a44a22254d7beca9ef1f8ad886d0d upstream.

Commit 48a5fe38772b ("tipc: fix bc_ackers underflow on duplicate
GRP_ACK_MSG") rejected duplicate/stale ACKs in tipc_group_proto_rcv()
by returning early when less_eq(acked, m->bc_acked).

However, that check remains incomplete in two ways:

1. When grp->bc_ackers is zero (e.g. on a quiet group, when replicast
   ACKs were not requested, or after all expected members have already
   acknowledged), an unexpected GRP_ACK_MSG with acked > m->bc_acked
   passes less_eq() and unconditionally decrements grp->bc_ackers.
   Because bc_ackers is a u16, this wraps to 65535, causing
   tipc_group_bc_cong() to permanently report congestion and blocking
   all future group broadcasts on the socket.

2. During an active broadcast round (grp->bc_ackers > 0), the sender
   transmits packet S and advances grp->bc_snd_nxt to S + 1. Receivers
   increment their expected counter to S + 1 upon consuming packet S,
   so the only valid ACK value for the current round is strictly
   acked == grp->bc_snd_nxt.

   However, tipc_group_update_bc_members() initializes each member's
   m->bc_acked to prev = grp->bc_snd_nxt - 1 (S - 1 before increment).
   This leaves a 2-sequence gap (S - 1 to S + 1) in sequence space.
   An incoming ACK is therefore neither rejected as duplicate nor
   prevented from decrementing grp->bc_ackers if an unexpected or stale
   value (such as S) is received. A member sending acked = S followed
   by acked = S + 1 could decrement grp->bc_ackers twice in the same
   round, prematurely clearing bc_ackers or underflowing it.

Fix this by:
- Dropping GRP_ACK_MSG immediately if grp->bc_ackers is zero.
- Requiring acked == grp->bc_snd_nxt and rejecting duplicates where
  m->bc_acked == acked. Because replicast broadcast rounds are strictly
  sequential, only grp->bc_snd_nxt can be acknowledged, and each member
  can acknowledge at most once per round.

Note that a related pre-existing issue in tipc_group_delete_member()
(where grp->bc_ackers decrementing to zero upon member departure does
not restore *grp->open or trigger a socket wakeup) will be addressed
in a separate patch.

Fixes: 48a5fe38772b ("tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG")
Fixes: 2f487712b893 ("tipc: guarantee that group broadcast doesn't bypass group unicast")
Reported-by: James Burton <jamesburton@meta.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260913044233.193927-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/group.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -797,10 +797,10 @@ void tipc_group_proto_rcv(struct tipc_gr
 		tipc_group_open(m, usr_wakeup);
 		return;
 	case GRP_ACK_MSG:
-		if (!m)
+		if (!m || !grp->bc_ackers)
 			return;
 		acked = msg_grp_bc_acked(hdr);
-		if (less_eq(acked, m->bc_acked))
+		if (acked != grp->bc_snd_nxt || m->bc_acked == acked)
 			return;
 		m->bc_acked = acked;
 		if (--grp->bc_ackers)


