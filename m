Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1251DAE2;
	Wed, 30 Sep 2026 18:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793227; cv=none; b=MF0EbqRTBEae0CpKTWdhU7DpnEFyfR8WKRldtpzSFJi+Dnds2MFx5ay3CPej8VK8kZ1SpW//a1dUpifKz4JRHytRGvfK86B5mqURUrECP01J+Vz3XgtFSyPnLF3q9oTbenE4wG0MVXvqm8WxGcKb02GZxxoOwof8xUyNv2Y5ztc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793227; c=relaxed/simple;
	bh=vEDNRVXZMHOKM0W0/j/vO7nTB0tR88AT7qbVOXpr7Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTt69OqCwrC8EtczS/Xj8cBCu1L2t741Pm2vPFNtlMh2lEccRMNIBIJw1fhhWoSMb+gPwX2C7RM0lpG+KjEom+QIzw0yY1S1aqnQxbH2Y8l96Toj8hCMAF5ijTLvuasrXzRyQ5P8A7v0NQFl1MkNiLY/qRc0hKDg2bDe6dQL75g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1glwVKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1glwVKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25941F000FF;
	Wed, 30 Sep 2026 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793226;
	bh=/Wwk7o72d04L1GTDe9FXaQI2LW6oXbULwagqEUvbnDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1glwVKvxownM2yoUyJbny7txFxa5Q02hms07ZN2tuWiEcpxkRqkRXdyTtEqLMAoZ
	 8KtpoKXCAZybtYEFNQncSoQj0JgbaWA5SjSwcOP9yJKYFJzAYcSDl3/sRV+fjCWZkp
	 yx72zSim1IsZOF4U0G9eIp0rEiDbwz/RHDm75Rgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/395] tipc: Fix a data race on mon->peer_cnt in mon_timeout()
Date: Wed, 30 Sep 2026 17:27:23 +0200
Message-ID: <20260930152344.578592294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 572b79bf76ce1..f47d0dba5e8fe 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -632,9 +632,10 @@ static void mon_timeout(struct timer_list *t)
 {
 	struct tipc_monitor *mon = timer_container_of(mon, t, timer);
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



