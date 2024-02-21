Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C87A715;
	Wed, 21 Feb 2024 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523359; cv=none; b=u6soaJnrH8aHRKetfpQYZfPXXvcje6dvf2xuByhPGtZzyHUJK+bBmojh7Fmu4fdgSDIbdPXABbia58wv8Pkt/vlxkWDlj7GOBz+WQFwQs4RTADzYNAP4d3rf/k3q7duGO7wFMhtRlIlBTNLO2stvBB4O32VwQjXYre9h5ozYmP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523359; c=relaxed/simple;
	bh=EutInXz4LP9+lCK9w9kEhAEMgTbIIXBouew+7j85v+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9vrAp5atEg4Ok/ETQkh+Lsd3PN347C7TL1r503jaDd1BkCSQpttXAWlT0fQgkP6fVPnJI0Rskzj5ShCN1S7T6gxZtut7uRKl5unrWbs7RvdkJgbKuslcta6p2VqBrS+kuR/ZsBCTcHrK4HTz5ux6y4e/ewFcg2kx4dhevRp8mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEyGsaIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEyGsaIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5708C433C7;
	Wed, 21 Feb 2024 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523358;
	bh=EutInXz4LP9+lCK9w9kEhAEMgTbIIXBouew+7j85v+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEyGsaIsL8nQr2CoMrtzOJEIK4DBUNSa7sKu4r/FXTFEuYU7tpPxni6FC7QM6OjH+
	 zb7BJhnES4HPOr7Ii1D4BkwRlN71PWfUBTZXBzQRE+TWonhR0phRJl8PmiFVyUQC4L
	 0eO80h3WPHPvbGkUmu/ybkqCLdhIoc/gwRZHLKX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 412/476] wifi: mac80211: reload info pointer in ieee80211_tx_dequeue()
Date: Wed, 21 Feb 2024 14:07:43 +0100
Message-ID: <20240221130023.232413476@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3746,6 +3746,7 @@ begin:
 			goto begin;
 
 		skb = __skb_dequeue(&tx.skbs);
+		info = IEEE80211_SKB_CB(skb);
 
 		if (!skb_queue_empty(&tx.skbs)) {
 			spin_lock_bh(&fq->lock);
@@ -3790,7 +3791,7 @@ begin:
 	}
 
 encap_out:
-	IEEE80211_SKB_CB(skb)->control.vif = vif;
+	info->control.vif = vif;
 
 	if (vif &&
 	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {


