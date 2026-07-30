Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077A135C68A;
	Thu, 30 Jul 2026 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421887; cv=none; b=CDXTSuRSW6Yz0kFm+J7N+bCZ95EdRBVG7HRP1v36Pah1MwerUizePb7w0Mpq8kPUws4gjezeIv248MiIVBHLTzpztCxtLg6klQc4f+l8ceX9ur6sh3R4FqEFaajWQ4FTgXnQ1/Mzx85eKrKs/PTtWZrWpilFBPLho2M25yn1fHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421887; c=relaxed/simple;
	bh=d67LG/QdBl0dV6IzHMXH9OofBBHNDugTyKnD4kThuTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+v6uyn4fsJQD6fY8EuMaOhNwGY0TMMDANfFhV5SLoYkffePFodByA5VYAf1UNZP0q1HnHW5ZT/ekaHf3OuJXnZNPK66Be6AtY3rMicOVEWK4MmEPfAhhPvPqmM36IOvsFnBkxUuisb7g1TInekLaiSjduzVd1Kaxps+RE7oNks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctaYDvk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctaYDvk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7F81F000E9;
	Thu, 30 Jul 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421885;
	bh=msBHB40o5CDCICyDO+qb3LJHhavuJ2t4k0k4h8cwtE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctaYDvk9V+A8J+mpT/nCOsm+H0KMv4a9PrAErLooZWXQDfoT0X2T4yyoNAhhWgDFq
	 j6Z7VhjYqJYheN9RlzUCP4g6ra+eB+QRKKxZt39/9WKxvhEyD564US/gSwMPd3cIcA
	 L89j1yPpAUtt9MAmqWUsj7T50kRffGusAGPsXxH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pope <andrew.pope@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 252/744] wifi: mac80211: recalculate TIM when a station enters power save
Date: Thu, 30 Jul 2026 16:08:45 +0200
Message-ID: <20260730141449.649169987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe583636d326eb..7372025831c5dc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1717,6 +1717,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.53.0



