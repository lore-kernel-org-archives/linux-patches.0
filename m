Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B309C151CCC;
	Tue, 20 Feb 2024 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465154; cv=none; b=CipeiKOL00zOMtIViJDTNIoyuqYun20ZqNs9Mtce23i54/mFBdZ/7jDrVoDbKejdoKDdvSWiUvIAlD4nQqp9LgwNDBHSh+N2+MegSbR3TOCFTsYeoWgG1tjSmYjJPkEg4K67VwcKnNJc6D4ifSL2wv0S5PWsPBhjDun6hTASZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465154; c=relaxed/simple;
	bh=H5h437pAjYZaJmXkBgXsk8DRuz+/XWGavXaL2uNB9dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=An6DzCcl5FASitWJZtrbS67LVxOdQfCjDpOAmwUvXHAdbehUfm+S09+6DgxQIgncqdMmn9bGGytQP1UPzEnoy5brxBn7iWb5pIaLE7PU53V9KKFqDYwS5+ymRmkK6LWzPbn3WcLt9LznzZb4CgGfm86bZTmcwq5zqp9LkNtvDLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMWJ5Fre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMWJ5Fre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BF4C433F1;
	Tue, 20 Feb 2024 21:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465154;
	bh=H5h437pAjYZaJmXkBgXsk8DRuz+/XWGavXaL2uNB9dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMWJ5Fre8BgkUeKW17eqaJ0EgbXh9fPDaIoc8LHwfS/WuQJ47CEtrgePNi8icEtZr
	 8X+ZOfZvOlmwTYR0MvPuhewjFRyR9OPn9SZPcU83g9aT7fJ9S3kqTqCG65OsE9yehc
	 PjYNpXkBicOhcj4XALNksUoaHiwHcooeieW+kmvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 252/309] wifi: mac80211: reload info pointer in ieee80211_tx_dequeue()
Date: Tue, 20 Feb 2024 21:56:51 +0100
Message-ID: <20240220205641.052020987@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3927,6 +3927,7 @@ begin:
 			goto begin;
 
 		skb = __skb_dequeue(&tx.skbs);
+		info = IEEE80211_SKB_CB(skb);
 
 		if (!skb_queue_empty(&tx.skbs)) {
 			spin_lock_bh(&fq->lock);
@@ -3971,7 +3972,7 @@ begin:
 	}
 
 encap_out:
-	IEEE80211_SKB_CB(skb)->control.vif = vif;
+	info->control.vif = vif;
 
 	if (tx.sta &&
 	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {


