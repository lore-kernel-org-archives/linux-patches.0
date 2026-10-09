Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B993D9DCE;
	Fri,  9 Oct 2026 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556637; cv=none; b=hsMMbN66vQx++pW0ze7UeQuP/g+eUbujY6mBtX3p2w6SnDsUc060wYMM8xklketfUGcs4j3z1Mk0aX3HCtra3ARktlGod71JpHiTvqRHQoqXl60xJwZQpO+ESl9D1odTnRJTsCxIgrwOYiEZsZ+JdoIGax5Sj08nw2Tu+d7VipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556637; c=relaxed/simple;
	bh=MKMmzddF5vmAUPAnBwq+8BaO1HpmDLnH2LmZWeU+XDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiM9gtHCJPr8moAYGNJ9Dlnp1KUqmD9QTBZd+Kd8OZUfOK1/qvW7AAzC/FHTAO94g79l55V/m2vBAKwZiddeZljjZiYcrpMjJAfKx7lx9vWFW7vgGj7W7UPq+MJfztxGuD4FAy72gNJHpugWD1YY4hh9Ib58vrf4lIQN51WohOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0k1fUd1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0k1fUd1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE11F000FF;
	Fri,  9 Oct 2026 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556636;
	bh=VFGKo3xKT42oZdycJZ8D9Obh6pvrdPUVG/nZvBpeXKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0k1fUd1+XMC/fBNfAyMGTdj73Eo6tRfzEFQerDuxKRKFnBqn7wzuh7/7dNnDe6TVx
	 FL9hltjdnIW2rmpXuTSF5kB8rNBZyPaBMJTtSWK76I+R6Xv2SIllTJfMYOQjampENF
	 pXFS1zpL9VfXxEaUBrLdXMHGE6Qgcyd5DawRtB1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	stable@kernel.org
Subject: [PATCH 6.18 267/403] wifi: mac80211: shut down RX BA session timer on teardown
Date: Fri,  9 Oct 2026 16:10:28 +0200
Message-ID: <20261009140958.423479077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit e588e83e5c7a0f6d7a77dbbb58927c8c8cfd598e upstream.

Tearing down an RX BA session can leave the session timer queued on a
freed tid_rx. Later timer-wheel processing and the timer callback itself
then run against freed memory.

An RX BAR handler can dereference tid_rx under RCU before teardown
unpublishes it and stay in its read-side critical section while teardown
deletes the session timer. The stale handler can then rearm the timer
after timer_delete_sync() returns and before the RCU callback frees
tid_rx.

Use timer_shutdown_sync() so rearm attempts become ineffective once
teardown starts. Keep reorder_timer unchanged: teardown marks the session
removed under reorder_lock and its release path checks that state before
rearming. session_timer has no equivalent guard because
ieee80211_rx_h_ctrl() rearms it before taking reorder_lock.

Fixes: a87f736d942c ("mac80211: use RCU for RX aggregation")
Cc: stable@kernel.org # 5.15+
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/agg-rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -103,7 +103,7 @@ void __ieee80211_stop_rx_ba_session(stru
 	if (!tid_rx)
 		return;
 
-	timer_delete_sync(&tid_rx->session_timer);
+	timer_shutdown_sync(&tid_rx->session_timer);
 
 	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
 	spin_lock_bh(&tid_rx->reorder_lock);


