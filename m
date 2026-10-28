Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211348;
	b=DCjDYYT22QNPZ7hkIslcuWZhnVfQKZY052e2SUeCngqtTOZDZsQ2Uev06pSGk99HVm8/
	 0nS1oUPLFgvqZHVS3l50aVaee58GyYkmo50L8BHKm1FgYz2Ut6ByT9rJdvRclSxYEIcV5
	 Gxz/QPnVZ+xYRdmAQJbGjo/lAfgpLMoOIcTLbGpCJj5YRoT0HCGpKlnbsX9sBu0dKa5oB
	 a+qCJB0idV0ytBtc4lBosvsGnKbqBCbJkNjMjghH7kaKqzWZmrJy30OPOQTq7i2tnOABs
	 Rae1TQriDUXKoa4QCdKFuHvVcmb/Pkbr98UQyjIes+QlkzDBEbK16NpPoxcG8/13L6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SBiZRhHpQ2Sl7RvkA2uFf6la47aPcg+WnIL6pbFV4cA=;
	b=aV5XHa3jPoITJ3/0/RGexcZeRoHS8lhNRHBZkEM+XfVu8oD0hpdXJvLk1h1IZ2DuQ6Rn
	 0h+N3z2jzsXKm/zmZljNXv/NUMZ1xQPPmOD8Nt6gsY5e4zkcxV0Tn9ZzOK9iJ5InBwec4
	 w4CO7jvxL9nHTtyRlOV/qHBqHU5/3kJA8xRmqDEPSVZTq8CiYcG8L7iZAv12suRr4cP3X
	 d3WySw+urCN+Emfl544Qaota91XUqketgFL7nzd+FpxGvzyVrDCr5PbSU8gHGIF/H/cxL
	 DAaLAAEegskDxODLbaI+k6utPDH8Sd5ae9bi55tUsjo/fcBbj04t5uSIaFw1tJEvwgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojoC48CJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA794606A33B;
	Wed, 28 Oct 2026 18:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojoC48CJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E651F01825;
	Wed, 28 Oct 2026 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211347;
	bh=SBiZRhHpQ2Sl7RvkA2uFf6la47aPcg+WnIL6pbFV4cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojoC48CJ6sfDxXi2EsZIH8hvPjtIfYTdMljafb4S6xjQeol0gTe1lEBeRmeBzIqc+
	 8GnS8LRd6zH4Ct88hnVegIyoczWkeI5d4Fs9lHQpvWGicMa6ulHrCjDGUgaNTffWpP
	 AxLPWm6hh+MtmvMiQLqc00lvgrhrKnitPTOJIODw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 319/571] wifi: mac80211: shut down RX BA session timer on teardown
Date: Wed, 28 Oct 2026 17:57:46 +0100
Message-ID: <20261028170015.569948741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the timer replacement to the existing del_timer_sync() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 0d2bab9d351c6..f6a7eb7181c8c 100644
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



