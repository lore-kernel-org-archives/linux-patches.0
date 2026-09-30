Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5284B511E9F;
	Wed, 30 Sep 2026 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786578; cv=none; b=olIUiVQzapFtt8cBTkGZbgUj1+h1aUNgBzCKLJ/GjXMn3Dl3v8Y/YHnYWs7QQulIXiAFVWFaVOPFAdSlcdKO7kEsmHFch9MQvr9+OrMptgKXt6y1WE5miQC/wo1gFBxZpxbyPyTRQrvvQWmOZO+mGdqVuupT7b6TQHcoMgwRlYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786578; c=relaxed/simple;
	bh=jK46oPZeF2gH3nZumJgPvMDKs9vqqADuyNWIZmFDtB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfG7WrPnhINCsTbyNSURmQRyE5Vp+IeySO0j0PTCwBqG/suZppEdnzb9IBmAnMAydi0VUVtaJhI69R8HgBN4SgWOx1lLqclzABZwL9SXuyJEuB1ebxCrSZ2r8XveASD5DySHvRejpBUdAjL+H+MCSUkeQLRF4Lsdg/9SW7wVJ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAYtr+E7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAYtr+E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0C1F000FF;
	Wed, 30 Sep 2026 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786577;
	bh=gmWgRJ3maFI8KLyMLDAxvafXAshgYmCWChQp3M3VeUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAYtr+E7mZrjW6yJv3MeUyilwLwBjHmn9KvlcaZ3ovGMDA8naL7QLYhBGQwVUwAzW
	 ABaqzqsF318PT/H8yavKurYDxA699Cp8eqSynaPfEoZZ9dYV1gfdy6DY2iVskENCL1
	 5B7qxPenL0m1QLMNTO4pt9hjutf+cYwP6SuPBlIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 910/982] tipc: Fix a data race on mon->peer_cnt in mon_timeout()
Date: Wed, 30 Sep 2026 17:27:26 +0200
Message-ID: <20260930152436.286698212@linuxfoundation.org>
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

From: Ginger Li <ginger.jzllee@gmail.com>

[ Upstream commit 8e1937fed6738460554ec123c64839e2445e7d53 ]

mon_timeout() evaluates dom_size(mon->peer_cnt) before it takes mon->lock,
while mon->peer_cnt is updated under that lock by tipc_mon_add_peer() and
tipc_mon_remove_peer().  The value can therefore be stale, and the decision
whether the local domain has to be recomputed can be based on an outdated
member count.

Read mon->peer_cnt inside the write_lock_bh(&mon->lock) protected region.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260922080909.21123-1-ginger.jzllee@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 23efd35adaa35..e96dcdaa93894 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -632,9 +632,10 @@ static void mon_timeout(struct timer_list *t)
 {
 	struct tipc_monitor *mon = from_timer(mon, t, timer);
 	struct tipc_peer *self;
-	int best_member_cnt = dom_size(mon->peer_cnt) - 1;
+	int best_member_cnt;
 
 	write_lock_bh(&mon->lock);
+	best_member_cnt = dom_size(mon->peer_cnt) - 1;
 	self = mon->self;
 	if (self && (best_member_cnt != self->applied)) {
 		mon_update_local_domain(mon);
-- 
2.53.0



