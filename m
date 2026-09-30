Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35D03DCDA4;
	Wed, 30 Sep 2026 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796903; cv=none; b=muwm7Un+iZk0EgwYRS/MEbO93D8drJH2C1J3f0w8X0Hl5YwYTSWvHiLOwI5E42sfG2/azmROUtNG1K7vDD79li76USy8XMXSOZnfXHcZK1yBoWnZbWfC7BRPrdW/yWiYez1E97+8eMRHmcpDfQK6QgUVzL5/2aCGkchQbxVXUBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796903; c=relaxed/simple;
	bh=zMoUZCvEb1kgevSm1yqnjuO9zxfIq5cSNv3qKzADp+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9xOUHjES1RZaGuTxX8pLyZI8hlRQ9pNJsE+xONou+gkfQbdD1m3GJfOBxAViZSSAcs+mNs4IpYhBl3zIGlRUwIy3BDX1MRjn3SPrDkuF18JT+mClI/sBAmpfGn3UPx1MVJDUJ837lTQeSLaq7gQmfQbksqhpxNjD8/1DLyWCYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/W9B5tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/W9B5tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4827A1F000FF;
	Wed, 30 Sep 2026 19:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796901;
	bh=21y97hiJcL0padBRx+jnPMsQ0kiwrDoP/rL5pflmZok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/W9B5tcCGkAIMpU1lwYlB1IFAVoa2dN7064EzRteknUVwPthEeg5zBgynbutmlVt
	 k08CfspqAIErC1Thw+EaTGOozVEqL7aFsuKZLeSQqQqSM+iJsTPnW6VD8BW747kWZB
	 HkWx1s/2BteUV34m2SgtzwOrLQDwY5LNUn7A8W9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1076/1193] tipc: Fix a data race on mon->peer_cnt in mon_timeout()
Date: Wed, 30 Sep 2026 17:29:20 +0200
Message-ID: <20260930152458.133514362@linuxfoundation.org>
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
index ddc3e4e5e18d7..76606813c3052 100644
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



