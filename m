Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C95443318;
	Thu, 30 Jul 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423971; cv=none; b=SgeHz+BIq8JmovzHiPKdjYHLdLMIIttm8rPl7NixBPwYxQGaQA1H96DHiVCDEA4ixx79qeFqmbbla2QCQeFMnOcHm1Z/+UNBruS6AlIxPHDbjEouQ7NhQtwBYXebbNoj6h5Q6LFBv2Tb08Z0wAH1Mw8YcQH5Jh7rb3ZRDCvqc7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423971; c=relaxed/simple;
	bh=lo7GXxpOUHUzGEOGZvrWn+Gw1wHmLdB+/z9MzpBuDq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edmRfVuCpr0xBitniCCDgEC/phC+adqv4C6cfqhDrMJl0ft+Zh2IXNnNBbptswyams03uv5rJC+JDVwBOhzkaEcq9B+ln9Qz/NDaRwblBYULkZYBoGhwuis08bYr8J/kGoHlAUdoswgmanprlcJo3xk3NA8BHp3lctFPXGRDpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRpipHNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRpipHNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282E11F000E9;
	Thu, 30 Jul 2026 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423970;
	bh=cNPih+lOe/qTvNU3Kc1Rf79rAq4gjhkYiykQnpzAO2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRpipHNfs50UixLSLXami+r+UWpO400W5mPE5KTjjRH6plW4L5+0cwbDVrr+4fW7Y
	 CcYzwDzYPCMpxVeppZMIYV17YvDg5Cemgg57XQ4Hv/1jPnm1mPhCepURQcMsLBv7d9
	 RZ+llF3J8h+/j2IByvKCoufTqcWYjxedf+ABsD0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pope <andrew.pope@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/675] wifi: mac80211: recalculate TIM when a station enters power save
Date: Thu, 30 Jul 2026 16:09:21 +0200
Message-ID: <20260730141450.047059000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 0a986607e65922..13b7432d732f87 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1612,6 +1612,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.53.0



