Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA1F4EDCAC;
	Fri,  9 Oct 2026 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557273; cv=none; b=eXjgg2/8oa5kSKTQsHvO5oeyqkNaszWE4Iy2nLW+x5bFBshjSUwIvBrx5+nPUp+btuZRCLuM8Ljb4YSSjUz8JGXrtfAnMyWWRDdt9ZjK5lEHZYwDsnn2YytckKlJKw0NHXB+E5cgwnEIDsOiITg2T8xIcAFb2wQxO5Q6NmErmWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557273; c=relaxed/simple;
	bh=33l+vr2vidCOwgt+ABVxGnUcIHpz4jAYD3mtnILqTSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMoYA6yxpKGCVtTrd4qYZkWU/WKdZn4kcuH8bElhHiOKmJ8vMQNXWG6QK+ePGGyfu5j0sFhPfJIEtjtIFgtk2XDPFovPW+LrApu2gMe0y0gHxPuFVZ7trhyIJd3kgwiS7VT8cal7X2TLPLDDEw35Y96ggeFcHKMX4RoRtuLLANs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppB4dOaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppB4dOaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072561F000FF;
	Fri,  9 Oct 2026 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557272;
	bh=JCutGjow6mbtD6T96LpgXZSoDP7WKDh38Oycx/E9Agg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppB4dOaH/Upzr2o7NlrWKmkAGcDZto8QKdav1aWRIeeOtZkUCF267sQzaZMi1tZWR
	 IpT0Ugkbh0Cldx9BMQGuCoFh4m1u26wJgiDhjuXxpjCt68gwmfE8Iy/fWDMpP45c+t
	 YNdB859OM9CwPOCgerTRA1+0mGNAo5DSiioKiDVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	stable@kernel.org
Subject: [PATCH 7.2 329/428] wifi: mac80211: shut down RX BA session timer on teardown
Date: Fri,  9 Oct 2026 16:11:06 +0200
Message-ID: <20261009140953.364667815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,7 +102,7 @@ void __ieee80211_stop_rx_ba_session(stru
 	if (!tid_rx)
 		return;
 
-	timer_delete_sync(&tid_rx->session_timer);
+	timer_shutdown_sync(&tid_rx->session_timer);
 
 	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
 	spin_lock_bh(&tid_rx->reorder_lock);


