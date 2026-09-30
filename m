Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE8540B0FA;
	Wed, 30 Sep 2026 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796950; cv=none; b=IMLzNOeEeJsucsqzIbPTephwbkQt+VrvK5Kso0eJafU0pVSIO61DsloafYbQ+Ymb9V/zab2EQlDEaN3w5J+lHay7/WsUY5nU0kES4m29NeIJbUqBoh1UEMttntaWPwEXKU62jUru2zfSDRaeByMyQPy8xz0Nh+0zza8wPee2Slo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796950; c=relaxed/simple;
	bh=gH1Y1S29yonQKGp6p6KoEeaG/jPQwxC7B52gfuo07xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9s33m1fBnADHnBhl7FHy+fxse8Ez0LJdW2HncHIxvG342Pon4DHDA0GW34YQAmPQFIbSjjqRodS+Q7qL63hwXJVqJScfbH7aqWhVTyCctzODGXNZ3iAs808q/crP+hDRuII66ZLHnElsS1M2ec4bupXBTf7YGAJT2IRHBuwuWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNNvdCM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNNvdCM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBE91F000FF;
	Wed, 30 Sep 2026 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796949;
	bh=6nDwyWp/GozGUeHCZqtAv++noqZ58htmTv8pxlTJGVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNNvdCM79p0JYqZJtb7dZ6d2u7uvsdfUzeQFNypMJM82WMP4jVlD8lFwQjgKVmabk
	 4uDkUec4cH+VFBTzAoOv9c9cFCLkXlU11tedVV8kDkvDiHIqM+rvqT8qdl2EHsoKsJ
	 rHNsH3HHl3oaT8pgPMzs829AN3GIblz9at5skJ+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Burton <jamesburton@meta.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1092/1193] tipc: reject invalid and unexpected GRP_ACK_MSG to prevent bc_ackers underflow
Date: Wed, 30 Sep 2026 17:29:36 +0200
Message-ID: <20260930152458.495085817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


