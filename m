Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF812519E13;
	Wed, 30 Sep 2026 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792489; cv=none; b=SwUgdT2bDsv6gjBy7I9DabNmv4Uq1h8NiSrD7grUxhQZeBsQ1hyYwa89D5f3mDOZk33/RIoorsb/p/rkgHJXyhU4Tdd8VwJG5sWUMwqWa7jCR3qLD25WV+BHzEGbOjP6KgpqfrRhFlNNNfDH4Rq9lhhCIJ89RkqYLqfZXA6tu6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792489; c=relaxed/simple;
	bh=E0T7XoD2T5a1ScOjQ9kAxo9Ow7jP3vn9C/U5BRqU4c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnPfnG3Tjp7n4Qf/4eqJACjxmP18Eo9xqvbznl/FW9WCbiBzibSuK/TgCktVlRGqs6LVjswBLxFxl95oYSPNxXsSphvexFG3B7DC+mrw9N2N/47AkyOzlXvQX1xqqhxNXPRu3FDnXr+supchMPwPM2HqsfOQMOa/aOp9EGu00WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9ZKnQb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9ZKnQb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E521F000FF;
	Wed, 30 Sep 2026 18:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792488;
	bh=V0CmJRmkRH+XyuBC1wPPhycS4g00PW157JgUoSXG9v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9ZKnQb9sNa7DJp7kNZRUdZgu3HIN7gBeO7MlujIkRP39hJfE/kJi4h3IVO6DcmWh
	 /UVsKOJEhrUkh3J9+HvijNjubL/A6+QCArGz82AzKGYf4Ex5utnAw3E9IZAgCk4MSV
	 e1EXXtK74hHzksKcjtrBRmTNaF8xashWZH6TbWBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 673/752] tipc: Fix a data race on mon->peer_cnt in mon_timeout()
Date: Wed, 30 Sep 2026 17:29:03 +0200
Message-ID: <20260930152412.814761506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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



