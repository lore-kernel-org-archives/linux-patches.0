Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF87D413;
	Wed, 21 Feb 2024 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524889; cv=none; b=f2XHR6h5I1R8lSn7LWgsJ70X9elDUNZlEUqfoSj62hm8MJ09v8DFlzNZaz0U86FI199vX4+TYQfkIMOB03MyRTHXxf8VsEooaXGHolJy2qhHXikDi1e9oSHgg4EOlSqdOkidcJ6IXlC/QsLOh8J5e0UdYD9hfw1YhtaOQKwRweI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524889; c=relaxed/simple;
	bh=hfXj2/oJcOgrEYNl6JYcljpCYM3TXfD+/AUk5uecdck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7dx8fDAz17lxIkZJ0gX+NtjoniuNSWSMzDv8C9kBiSlDrfQ+ckcozIdpCgK2PrwrKg0Q93FCNIgZA9TakjazES8MG8axsJNj+N4LerY1GUhvejvlMry1ypynkdeL2MVdadEKyIH6aTexYuxl33M4+ZBNADh7bE5C3kAOPUrKsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5exqYeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5exqYeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5827BC433C7;
	Wed, 21 Feb 2024 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524888;
	bh=hfXj2/oJcOgrEYNl6JYcljpCYM3TXfD+/AUk5uecdck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5exqYeusMXU7QaBoNp3DfcHjStU+eMZaOFE0eUEa8HmnW5En4QyU0PDPwEjvtMla
	 sT9NBObeI0v/5tt48zclC6Jf+RzkCJCvNYKDPERg3no+rG+7Xlz/TWdx8TGcqxU3dI
	 FNzFgwrui//i76Y4y9sF5ZZR/o/qBssPfY/LrwYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 340/379] wifi: mac80211: reload info pointer in ieee80211_tx_dequeue()
Date: Wed, 21 Feb 2024 14:08:39 +0100
Message-ID: <20240221130005.047654680@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3721,6 +3721,7 @@ begin:
 			goto begin;
 
 		skb = __skb_dequeue(&tx.skbs);
+		info = IEEE80211_SKB_CB(skb);
 
 		if (!skb_queue_empty(&tx.skbs)) {
 			spin_lock_bh(&fq->lock);
@@ -3765,7 +3766,7 @@ begin:
 	}
 
 encap_out:
-	IEEE80211_SKB_CB(skb)->control.vif = vif;
+	info->control.vif = vif;
 
 	if (vif &&
 	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {


