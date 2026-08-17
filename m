Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EE941D227;
	Mon, 17 Aug 2026 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976912; cv=none; b=Os7cjPXsbCWS1Z+BaHM/V9qldmD1UUnPMyuguj07isMTCZgZZDbTT/rj8N4qOQEsnjGa0ue0eO6kDpgUnIu/xzqvy+rUWPhsffyt15wMejJavCGRpfyro12u+rqVdDQeIgQVbZ/PL4pd48h3fcTfaXUNsLw5EZDi3ElMJck+Z5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976912; c=relaxed/simple;
	bh=nzBSHSmd3or91MMe9tlCA7dF3XIii57RKMNOrCATtI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9w0JZh0esyRrwAWEg1kXALcKzwkpPEaC1aamldT+eURpRVVA7LEu0rC0YLmJV92659VcMe8eBEHnYOS3trZ28uFF3qzsuUsq4+9NmslZy+qdoecEGOn5RiU2exPRPAL4Gpuf31SEZZyw6XM+r1otw5Rwscd5DtWAGJoK6D1L/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJAUU/ms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJAUU/ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC48C1F00A3D;
	Mon, 17 Aug 2026 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976911;
	bh=CM1IceG+etn2nPRwlMaplcmZhabHxntRecGhQ+X1ECM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJAUU/ms6YVXlbSk1Fcp0Tjnaw56TTuArqbiejhfQ3FNHcnOdMujuTvMxJRMZW80i
	 54M4smWYQIut1xb89gzIYYAGwg45DYb/dhOQG1zlezQFbzNqQ/beWQM4g3k9b8F6wT
	 BanDahU9FbEWfWElchR7wwtSAjLWfnmI/pLMmmEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pope <andrew.pope@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/456] wifi: mac80211: recalculate TIM when a station enters power save
Date: Mon, 17 Aug 2026 15:28:18 +0200
Message-ID: <20260817132544.319856498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 15933e9abc9b9e..dda1ee11f8a8cb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1591,6 +1591,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.53.0



