Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00568427F91;
	Sat, 12 Sep 2026 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212304; cv=none; b=H87E6S9gUR5lZesT+Fh73jDVfaEWgdJ5w+t4dM5IIyGTIe+bwKiJaMctkgbgPvuOvng8QU9HPwgZeDs/xiAeetimq6mpvxi7XdVrj5TJ8aq5LkfxUWii7MpOSuYah/cIdLq9j16bAiDVLzLko4fY1+n6CK/YmYZcGwedH84O494=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212304; c=relaxed/simple;
	bh=p4/lcChOvF10J6Jdq0g6PjsVFvpgmNFgU8JsRfg9oro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE2ERX6Wmk01Iu0seHVE7pp4OhDxTaL/5fSyW/RlolF2s4AjGkiBrriidjqghYV8xZqbQOtuet0S9gTdq2i3RbLcDDu3hDu48Xqc1DOaAc30DEklbK34XMdUtcqeKWaAHKrKszDGcIIuUdfHMUM00lYkP/1Nt52KAFO2B+IQmvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsU1cX3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsU1cX3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE621F000FF;
	Sat, 12 Sep 2026 11:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212302;
	bh=/BUyoXAsx6hB2zUovWsOWeg1kmYG9k0wIihVcne7EVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsU1cX3KhfEMjQcVorfn2LXgFkskdb+X7/GHpeV7Osf5WgpBXJjiJ2FTXlql1iv1n
	 QrF0APKfc450JMBJ6QkQG8SPtKJwpNrJL5FPD7McA/S/pAqcFIDeloU+qsruhVNupT
	 M9Lww0jUs2ypTLOSPH44TIXmc3E19g6JqwvbjMTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1408/1518] net/rds: use wq_has_sleeper() in rds_cong_map_updated()
Date: Sat, 12 Sep 2026 08:59:37 +0200
Message-ID: <20260912065655.399090084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit d4f484661961636eb90d287050959e613795f73a ]

rds_cong_map_updated() runs after a peer's congestion map has been
rewritten (by rds_tcp_cong_recv() and rds_ib_cong_recv(), or the
clear-all in the loopback and IB send-completion paths).  It bumps
rds_cong_generation and then checks waitqueue_active() on
map->m_waitq and on rds_poll_waitq to decide whether anyone needs
waking.  atomic_inc() carries no ordering and waitqueue_active() is a
plain load, so nothing orders the map and generation stores before
the wait queue reads.  The waiters do the mirror image: rds_cong_wait()
adds itself to m_waitq and then tests the port bit, and rds_poll()
registers on rds_poll_waitq and then reads the generation.  That is
the store-buffering pattern described above waitqueue_active() in
include/linux/wait.h - the updater can observe an empty wait queue
while the waiter still observes the port as congested, and no wake-up
is issued.

rds_cong_wait() is an interruptible sleep with no timeout, so a
sender blocked on a congested port stays blocked until the next
congestion update from that peer arrives or a signal is delivered.
A poll() waiter misses the map-updated notification the same way.

Use wq_has_sleeper(), which is waitqueue_active() preceded by the
required full barrier, as rds_tcp_state_change() already does for
the same pattern.

Fixes: 922cb17a5c81 ("RDS: Congestion-handling code")
Signed-off-by: Allison Henderson <achender@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260822052647.88318-1-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/cong.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/cong.c b/net/rds/cong.c
index 8b689ebbd5b52..c85af56e42e73 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -256,9 +256,9 @@ void rds_cong_map_updated(struct rds_cong_map *map, uint64_t portmask)
 	  map, &map->m_addr);
 	rds_stats_inc(s_cong_update_received);
 	atomic_inc(&rds_cong_generation);
-	if (waitqueue_active(&map->m_waitq))
+	if (wq_has_sleeper(&map->m_waitq))
 		wake_up(&map->m_waitq);
-	if (waitqueue_active(&rds_poll_waitq))
+	if (wq_has_sleeper(&rds_poll_waitq))
 		wake_up_all(&rds_poll_waitq);
 
 	if (portmask && !list_empty(&rds_cong_monitor)) {
-- 
2.53.0



