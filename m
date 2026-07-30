Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBF43839B2;
	Thu, 30 Jul 2026 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425821; cv=none; b=Rvl3WIaMZ8laPf92a0+3/k97Pr86HueJMnK/frDoQ+gH2mLdhHTPZoR+EDBlmK1hE54aj5Jf1WfCMS+FsO3LnnmOmOa72J1+Gyt554sP16yaNrXz1cCm0VYpn4uXCBoLXyR73XHyUOz1avjKB37Et3NAxozQX/KcEzHNfzyrQes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425821; c=relaxed/simple;
	bh=GjRTh+6Lg60mAJjPOqanuBCICf3l990RMpIlsQQQKF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKwYLb8GYjIZG5v9r4poyejHhfnr80IArqnzUG8+N1T45Ru1kUv7gICFhlYB9+2/mwdzG6RP5+GBvPrQxBkFIy+MsihIVGpl6ozyGMFTsoPVgaNmbIT2gKrW+9iDK+rMSVwtPGpzsd1qWHBMkCjaS/vS46Cmk+45DdS4z9DNz3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e451zkgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e451zkgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149E41F000E9;
	Thu, 30 Jul 2026 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425820;
	bh=iYr3xgEYPxAz7unwyZjJ4U/LNcr1TB4zIX/HaUjfe90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e451zkgjSyFV+tP+uPE89CaNV7pJ0oqVclytFHnkrDVSB/rUz34Dr/hHLsOt524Ft
	 p54vhJkuFBBZsls66pYSWquyMvuyc2NGOV9NgNlYnf8xjSd8sSN8zxH+K51Ow6Bkzt
	 Y0ppcJLQUVbf32gg9SHDxCmg9G6E4kafyOsWFLt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pope <andrew.pope@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/602] wifi: mac80211: recalculate TIM when a station enters power save
Date: Thu, 30 Jul 2026 16:09:38 +0200
Message-ID: <20260730141439.870313972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 59070283839277..7e3bcd709c579b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1595,6 +1595,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.53.0



