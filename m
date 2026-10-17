Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B057D3AA4E8;
	Sat, 17 Oct 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256967; cv=none; b=WFepU2vUsSydWmMe+2ahwcL6BuN8V1vgf0PzA2PUMYvjhzZToi9W5Q70Bx9iMI1ySvZtIm9NvXbhLq3a/0Qb6uRIOPlViUh3igvp4vSTGz1yzqx467YAVhsS9cU5OsA33jOCbkgjGRkZXwOT0IhvpmcJNc7P9Ht84DkB2v3P58A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256967; c=relaxed/simple;
	bh=sD1+GjkPw6T3UgovOBWO4zl7aH0HG65pnZ+ZA5IJZ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rd7juR1EA+0iy2ubA6JHXPeo6ahlj/UnNmJ0Ml5g7EUJZHP4lPi61t6xbXj6jKw194cwtUn3dKewaF+c/bx9lwgTubuZVsYANnD3mollmjedkRWVW0uUg5NaQth1NxPSfbODQ2UklordvvFAxWY77d0ONI9vzYSkspX6sVPSnzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNIY/AsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNIY/AsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083941F000C4;
	Sat, 17 Oct 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256966;
	bh=D6+I8f76iUpEuSEu7+iiJYydK9UrUimGz3hy5tcuhmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNIY/AsPagRELx+OzMx5XsaZdsfQUgCYupu6AO1DJIrpSCcdlNXkh+qY4yQlqsBPi
	 UKdlvVKjg+7ZQvE4UnOwwlabW/bLD5Tubq2pcP0cwAVPYDtVNNFBzsvNeWG6MnNW+a
	 Lzut6c2y/i8tHVSTpXnfiZERMtRqAWbhesApn97E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 0409/1674] wifi: mac80211: shut down RX BA session timer on teardown
Date: Sat, 17 Oct 2026 17:44:41 +0200
Message-ID: <20261017160441.618591539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit e588e83e5c7a0f6d7a77dbbb58927c8c8cfd598e ]

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
[ sashal: adapted the timer replacement to target del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index c6fa532304500..32c1be3096b3d 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -103,7 +103,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	if (!tid_rx)
 		return;
 
-	del_timer_sync(&tid_rx->session_timer);
+	timer_shutdown_sync(&tid_rx->session_timer);
 
 	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
 	spin_lock_bh(&tid_rx->reorder_lock);
-- 
2.53.0



