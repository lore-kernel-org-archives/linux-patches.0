Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A033DA7C0;
	Tue, 16 Jun 2026 18:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635137; cv=none; b=kUnQWyp9woCQPwh+EadXYzP52IEjsaCrsn/9wG2CvugZi2josB1erioi/SGcJRjEzI9qLQeODQlq6E8p04S9c3Eg/GVsBD+vetb8A+nBvAOLbUp5wEyaB4wYzxrWnghRowdFwv1F0y/0Wz8HxPO8xA1RJcXYlxp4upvf9XzfQkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635137; c=relaxed/simple;
	bh=VMMIjoscUoRAImBxNuWcYBifIj7XuBtXaK3qTUrHgGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFHn0lGmuGC2mjWB2WVY6UaPbb8uBeZin4jh3IsQZcRgVUD7WWarlgxAtZaLcM1Hc/fLrryAQLvfs+gVL5x0oGzV8WtqTv/oixO8xgQwKeeclwUNN5AZ4+zfqPeHxj0FU/clOmYO5zqXxWy8WMweVyXqZm7LRYucz5REoN2RWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oULkDfNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oULkDfNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA61F000E9;
	Tue, 16 Jun 2026 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635136;
	bh=0BTnAfr0SCTmtF45UEkyz6Lqy0JI+/a8tFmvlMmRpkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oULkDfNCA25upom3nmLQnd0OGi1/2nlV2OFtxTvy1ua3g9jMxSqlDosRXVKRKbeQG
	 UnvjcLUThCcnrC4l3W8xHF7wLd31kdRxVD3bQvPYpEzWxrTiS22LUJKGirLER5KGrZ
	 6Iz+gV07+G2ZdI75nCS5PoS9ES0YZ/AI/XXXE0Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 396/411] batman-adv: tp_meter: fix tp_num leak on kmalloc failure
Date: Tue, 16 Jun 2026 20:30:34 +0530
Message-ID: <20260616145122.254659376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit ce425dd05d0fe7594930a0fb103634f35ac47bb6 upstream.

When batadv_tp_start() or batadv_tp_init_recv() fail to allocate a new
tp_vars object, the previously incremented bat_priv->tp_num counter is
never decremented. This causes tp_num to drift upward on each allocation
failure. Since only BATADV_TP_MAX_NUM sessions can be started and the count
is never reduced for these failed allocations, it causes to an exhaustion
of throughput meter sessions. In worst case, no new throughput meter
session can be started until the mesh interface is removed.

The error handling must decrement tp_num releasing the lock and aborting
the creation of an throughput meter session

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -991,6 +991,7 @@ void batadv_tp_start(struct batadv_priv
 
 	tp_vars = kmalloc(sizeof(*tp_vars), GFP_ATOMIC);
 	if (!tp_vars) {
+		atomic_dec(&bat_priv->tp_num);
 		spin_unlock_bh(&bat_priv->tp_list_lock);
 		batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 			   "Meter: %s cannot allocate list elements\n",
@@ -1367,8 +1368,10 @@ batadv_tp_init_recv(struct batadv_priv *
 	}
 
 	tp_vars = kmalloc(sizeof(*tp_vars), GFP_ATOMIC);
-	if (!tp_vars)
+	if (!tp_vars) {
+		atomic_dec(&bat_priv->tp_num);
 		goto out_unlock;
+	}
 
 	ether_addr_copy(tp_vars->other_end, icmp->orig);
 	tp_vars->role = BATADV_TP_RECEIVER;


