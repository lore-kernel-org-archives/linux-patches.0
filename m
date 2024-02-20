Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF12614C585;
	Tue, 20 Feb 2024 21:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463207; cv=none; b=adDxZJZiIgtmAM6m1ZOHfPg3OZJ2xlVr3hU49ip/lC91wnOoc3NDpLHvfOTSQEqLrfZUprhbQOBYVpgxdwu+fqw9JhdkKtCHh6MTb+P7VHXnidsgvBmSIyJdqD/hy1HkRYsNt+gLNOwdw8mocn7S7dnGehxClIYTvLk6yAEbq1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463207; c=relaxed/simple;
	bh=/kqtGka2hw2dES3tYyWmGm7xy8DIQ/a4aRKEwtN3t2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD7zoZBgeBuVV0wEUOaOQpQnSY+/tJ+KD9r1bF1NCcM1dTLijwGlu6nCtZ2VWp2Jd17z1p4mQ/a5d3Fw+St3DiQoJ+OMfzfpYmztbLhCOYTJXXh7qb0QZRjm2kq4zZiR3agJz7HJC/AkkIylx2oxcYBOys0j3v7Oc8oH8NW8gw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vk3zcfsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vk3zcfsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F37C433C7;
	Tue, 20 Feb 2024 21:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463207;
	bh=/kqtGka2hw2dES3tYyWmGm7xy8DIQ/a4aRKEwtN3t2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vk3zcfsM1eEDE2DP77LiJQlyS21wOWmFx19dnnWqI3JveXbKqw8xwQAs7h8HP0Oj6
	 jDvNUSqpNNFnCbabD+8bpWUFDy+ZmAyq6BC64d2dD66O3Lr7thjWUm6JP9UXSQuCtD
	 3kw33IrhVJlLXs0z93HD2GAf/Wm/ovQn6+pm5XhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 141/197] wifi: mac80211: reload info pointer in ieee80211_tx_dequeue()
Date: Tue, 20 Feb 2024 21:51:40 +0100
Message-ID: <20240220204845.288233005@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johannes Berg <johannes.berg@intel.com>

commit c98d8836b817d11fdff4ca7749cbbe04ff7f0c64 upstream.

This pointer can change here since the SKB can change, so we
actually later open-coded IEEE80211_SKB_CB() again. Reload
the pointer where needed, so the monitor-mode case using it
gets fixed, and then use info-> later as well.

Cc: stable@vger.kernel.org
Fixes: 531682159092 ("mac80211: fix VLAN handling with TXQs")
Link: https://msgid.link/20240131164910.b54c28d583bc.I29450cec84ea6773cff5d9c16ff92b836c331471@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018-2022 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  *
  * Transmit and frame generation functions.
  */
@@ -3838,6 +3838,7 @@ begin:
 			goto begin;
 
 		skb = __skb_dequeue(&tx.skbs);
+		info = IEEE80211_SKB_CB(skb);
 
 		if (!skb_queue_empty(&tx.skbs)) {
 			spin_lock_bh(&fq->lock);
@@ -3882,7 +3883,7 @@ begin:
 	}
 
 encap_out:
-	IEEE80211_SKB_CB(skb)->control.vif = vif;
+	info->control.vif = vif;
 
 	if (tx.sta &&
 	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {


