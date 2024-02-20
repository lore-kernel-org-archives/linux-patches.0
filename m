Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38152612D7;
	Tue, 20 Feb 2024 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463966; cv=none; b=YxPkrdHzUnf5MAYDL/OFohqlKm2UYc74Bz/WZzNOH1oQutSw16RM24nM5uwzrZIujyhurBDwsr+OKJp8XEDMRc2AIPcwcuDx+asHKQOKm35guAqQOFM6j/uZO38jS9zlPA4rAwhg/9rqVDPVx+rb0+DPQ3I/CEvDVSlWQrzwvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463966; c=relaxed/simple;
	bh=3sZ85q8uZBvXkGez5ACT1nIXyyCsawPi7+XBwLbv98I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgFBRAUNbfGFxrjipWMZ2H7nMVHVXjTsQgwkjcX7SJ1WvFDAWqPeJV0gpm5rxL6sTu2vb3qhimC3+CUmE/Gg4zuU4qYlKI56cXegB833oU2EAZ+MPiEBvIVc8BJeTNIqLt10X32YZyMNL1mmjMSeTslkMoVmnCd+HMENz/Cyk/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VV3k3Mba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VV3k3Mba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49884C433C7;
	Tue, 20 Feb 2024 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463965;
	bh=3sZ85q8uZBvXkGez5ACT1nIXyyCsawPi7+XBwLbv98I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VV3k3MbaxNvqXEfQtbROONrFuvb/+bHNLelgpKXEjXi85amFUd0LPgEAc57B2yluH
	 LDU3qcWDQcEbijV1EZiXTJXayBu9EZR6l7tnVISAIAV9WE4KnQLgO+s7deBR34QscA
	 k7IZYjcTTzb+VbB+B6mXA5m1saU4ouSlb67HfGFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 208/331] wifi: mac80211: reload info pointer in ieee80211_tx_dequeue()
Date: Tue, 20 Feb 2024 21:55:24 +0100
Message-ID: <20240220205644.232049330@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3913,6 +3913,7 @@ begin:
 			goto begin;
 
 		skb = __skb_dequeue(&tx.skbs);
+		info = IEEE80211_SKB_CB(skb);
 
 		if (!skb_queue_empty(&tx.skbs)) {
 			spin_lock_bh(&fq->lock);
@@ -3957,7 +3958,7 @@ begin:
 	}
 
 encap_out:
-	IEEE80211_SKB_CB(skb)->control.vif = vif;
+	info->control.vif = vif;
 
 	if (tx.sta &&
 	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {


