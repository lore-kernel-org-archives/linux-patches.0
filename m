Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A15446846;
	Thu, 30 Jul 2026 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427403; cv=none; b=X6tCae9e47+zFGQfB6Lu9Bfmw7KLSVXK+t9AEHirBlHwSdUNwyD9hVIWcSNjs84DM4+g/pO7UgJjkcf58cV2KV8dK43fUJG1fbgx7vj0upPx+LmW2ZmR2JSk7aOJhEcACfaRD/fn76hxAcNZ3x/vcQe2DrY4ydiOHMgyAMljOsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427403; c=relaxed/simple;
	bh=d6evx16odu67aBns1zECj8wurjVUC7R9p8z00GpvBr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbhLKIbq7whXU22jlxMney4Ds0TMlbGhC93qD3rlSc+oYNVgTLkVRY0hLoZ9nWv3Jre0gYgXtnRXgozABykOZOhOlniYHHajxou2F1AgQL2p4L/TZIPfmGMr7QnimHgE8ZhOA4d89o8iUDlRvJwmK0cbHHPApGz9z5bobhWgFEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJMtz3QQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJMtz3QQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224E81F00A3A;
	Thu, 30 Jul 2026 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427402;
	bh=TxMaAfFCut9+DUb7BcGFF6c6owlQgQpcZdGRemvdlJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJMtz3QQuqJ/1BMJqWx1ej72sn8+VslhE3fZUogTrvMhI5yFM371yQXAqpSDC/pfe
	 kRnNOgZkL4+dCEyN+ZTOLHtUL+Q9/MhFbaNcu860N8mT2sqMjcSVoFVL3cgIupCsuf
	 aQmRBu3B3Hrm2hX8gMG12Y3NdALabHISs6xPoho4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pope <andrew.pope@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/484] wifi: mac80211: recalculate TIM when a station enters power save
Date: Thu, 30 Jul 2026 16:10:55 +0200
Message-ID: <20260730141426.898301094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Andrew Pope <andrew.pope@morsemicro.com>

[ Upstream commit a007a384c9eb17610f53a53e2f59944c31f1565a ]

When an AP buffers frames for a station on its per-station TXQs and the
station subsequently enters power save, sta_ps_start() records the
buffered TIDs in txq_buffered_tids but does not update the TIM. The
station's TIM bit is only ever set when a further frame is buffered
while the station is already asleep
(ieee80211_tx_h_unicast_ps_buf() -> sta_info_recalc_tim()).

If no further downlink frame arrives for that station the beacon
TIM never advertises the buffered traffic. A station relying on the
TIM then remains in doze indefinitely on top of a non-empty queue. Its
TXQs were removed from the scheduler's active list at PS entry, nothing
pages it, and the flow deadlocks until an unrelated event wakes the
station.

Recalculate the TIM at the end of sta_ps_start(), so traffic
already buffered at PS entry is advertised immediately.
sta_info_recalc_tim() already consults txq_buffered_tids, which is
updated above, and is safe in this context (it is already called
from equivalent paths such as the tx handlers and
ieee80211_handle_filtered_frame()).

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Signed-off-by: Andrew Pope <andrew.pope@morsemicro.com>
Link: https://patch.msgid.link/20260717011751.79524-1-andrew.pope@morsemicro.com
[add wifi: subject prefix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a716a055bff9a4..b0f975dbdde0da 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1568,6 +1568,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.53.0



