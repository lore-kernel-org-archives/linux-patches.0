Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5742F1FDF;
	Mon, 17 Aug 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979171; cv=none; b=iAeepdlJZqAvDuLwyPETVbtZaTee1r4VQrJS4WGkIzBIg0L9oLw1xZxh5QgIbADNQfS3pN+6w9L6AiDt50OOVskV63ySLDDWLpBD1LL/sjzgSUNchd2dXuGoC40LTbitVRDmsJ3dCXRmjCUIlmgOMS4wv9VYcc/IOv30nH/g5gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979171; c=relaxed/simple;
	bh=mEEfz692p3P5iOH42OtxKuJVVgSmB7ZClHzCWiaeF4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucsMIln7b2jO7jrxUMzW+DeDXGYAFK8I6NBUqii1r4QPJgQbx+NIoF7lvk+lv8rWZvnYiu6aDg7MvhfU+zVCAlBQfAQ7L4kKzlC8+4n1gS8d12WlL1sg7hizqtT/ty2CI+DdqrBfsiUdWd0VQe8zTp+HzXds7gQhCzU7NKHosPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rxs3bjyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rxs3bjyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961C01F000E9;
	Mon, 17 Aug 2026 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979170;
	bh=5I2CFaJi4kaX99t/++uCYGOkVw2DlTf2tm2Bzi8bLWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rxs3bjyybpqjLcExPnrwLPrRhic4xhrHeYUmWLqWE6cN00Z3YNbUQLq+lvwa2XJ74
	 osoipD9mU+5Nyod/doBv6C0bJcvm0U3VFDWwe6t8GEPqsihHN6ORlnypB5z/ObFHqH
	 TVu1PlkixrL2i1+MNeQwkB1lMNKn95zZJMD9LKTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pope <andrew.pope@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/609] wifi: mac80211: recalculate TIM when a station enters power save
Date: Mon, 17 Aug 2026 15:27:09 +0200
Message-ID: <20260817132548.372792343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a6636e9f5c087a..1fbccdb37166a6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1590,6 +1590,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.53.0



