Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C94C60273;
	Tue, 13 Feb 2024 17:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845765; cv=none; b=uZ3tLLnyB0Qf852NUenuGKclms97qH4TOs68s1gSGwEKVVEPd0i44Qa0hNK55nT0mpj4W25RvGLsbT7qPz+uwTs9b7WW+gj3C9yjc5ue32WRybxTaJ6tKaIrO0Zyc5jt0vYcP97tOCErdYG8uIkotzn22KjIDlIUDZ7iPVun/Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845765; c=relaxed/simple;
	bh=GFTqCrtgzadH0GryzepExGZARR4yzwP16wqP48qw7vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUA3fv+DxKfbzyzAYdchYrvHh6baT4IdTOURCILmvW50s3fkk96nR7GA1n6FtekOfPKGfrQmh6AScsBj+QLsJkj0bm4KSAf4epB6GIg8mNWmZb8UVcNEftR9nV8yeCjSgfHyfVd9lSu+n1HcwMsrqtpshYWVljnr5XrECB1KlnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJuNDY2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJuNDY2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF606C433C7;
	Tue, 13 Feb 2024 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845765;
	bh=GFTqCrtgzadH0GryzepExGZARR4yzwP16wqP48qw7vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJuNDY2VHQ2heAGgA4RIWAtSk5VDmAVs5gmLwuvnTeu1s0VzahEC3Obu9oV14ilB2
	 DgLL3EV8BPr1AeMCb1ctGCrOVj7JHD9fJaMQhIa65ZAfX+v3wyba3u5eFo1Nn1yxkh
	 oMpopQ9XP7MI0TnJ3fXlFKpim07nPKt3RS+Y8g6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coldolt <andypalmadi@gmail.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 024/124] wifi: cfg80211: detect stuck ECSA element in probe resp
Date: Tue, 13 Feb 2024 18:20:46 +0100
Message-ID: <20240213171854.436586611@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

[ Upstream commit 177fbbcb4ed6b306c1626a277fac3fb1c495a4c7 ]

We recently added some validation that we don't try to
connect to an AP that is currently in a channel switch
process, since that might want the channel to be quiet
or we might not be able to connect in time to hear the
switching in a beacon. This was in commit c09c4f31998b
("wifi: mac80211: don't connect to an AP while it's in
a CSA process").

However, we promptly got a report that this caused new
connection failures, and it turns out that the AP that
we now cannot connect to is permanently advertising an
extended channel switch announcement, even with quiet.
The AP in question was an Asus RT-AC53, with firmware
3.0.0.4.380_10760-g21a5898.

As a first step, attempt to detect that we're dealing
with such a situation, so mac80211 can use this later.

Reported-by: coldolt <andypalmadi@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAJvGw+DQhBk_mHXeu6RTOds5iramMW2FbMB01VbKRA4YbHHDTA@mail.gmail.com/
Fixes: c09c4f31998b ("wifi: mac80211: don't connect to an AP while it's in a CSA process")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240129131413.246972c8775e.Ibf834d7f52f9951a353b6872383da710a7358338@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h |  4 +++
 net/wireless/scan.c    | 59 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4ecfb06c413d..8f2c48761833 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2865,6 +2865,8 @@ struct cfg80211_bss_ies {
  *	own the beacon_ies, but they're just pointers to the ones from the
  *	@hidden_beacon_bss struct)
  * @proberesp_ies: the information elements from the last Probe Response frame
+ * @proberesp_ecsa_stuck: ECSA element is stuck in the Probe Response frame,
+ *	cannot rely on it having valid data
  * @hidden_beacon_bss: in case this BSS struct represents a probe response from
  *	a BSS that hides the SSID in its beacon, this points to the BSS struct
  *	that holds the beacon data. @beacon_ies is still valid, of course, and
@@ -2900,6 +2902,8 @@ struct cfg80211_bss {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 
+	u8 proberesp_ecsa_stuck:1;
+
 	u8 bssid_index;
 	u8 max_bssid_indicator;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f819ca3891fc..3f49f5c69916 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1725,6 +1725,61 @@ static void cfg80211_update_hidden_bsses(struct cfg80211_internal_bss *known,
 	}
 }
 
+static void cfg80211_check_stuck_ecsa(struct cfg80211_registered_device *rdev,
+				      struct cfg80211_internal_bss *known,
+				      const struct cfg80211_bss_ies *old)
+{
+	const struct ieee80211_ext_chansw_ie *ecsa;
+	const struct element *elem_new, *elem_old;
+	const struct cfg80211_bss_ies *new, *bcn;
+
+	if (known->pub.proberesp_ecsa_stuck)
+		return;
+
+	new = rcu_dereference_protected(known->pub.proberesp_ies,
+					lockdep_is_held(&rdev->bss_lock));
+	if (WARN_ON(!new))
+		return;
+
+	if (new->tsf - old->tsf < USEC_PER_SEC)
+		return;
+
+	elem_old = cfg80211_find_elem(WLAN_EID_EXT_CHANSWITCH_ANN,
+				      old->data, old->len);
+	if (!elem_old)
+		return;
+
+	elem_new = cfg80211_find_elem(WLAN_EID_EXT_CHANSWITCH_ANN,
+				      new->data, new->len);
+	if (!elem_new)
+		return;
+
+	bcn = rcu_dereference_protected(known->pub.beacon_ies,
+					lockdep_is_held(&rdev->bss_lock));
+	if (bcn &&
+	    cfg80211_find_elem(WLAN_EID_EXT_CHANSWITCH_ANN,
+			       bcn->data, bcn->len))
+		return;
+
+	if (elem_new->datalen != elem_old->datalen)
+		return;
+	if (elem_new->datalen < sizeof(struct ieee80211_ext_chansw_ie))
+		return;
+	if (memcmp(elem_new->data, elem_old->data, elem_new->datalen))
+		return;
+
+	ecsa = (void *)elem_new->data;
+
+	if (!ecsa->mode)
+		return;
+
+	if (ecsa->new_ch_num !=
+	    ieee80211_frequency_to_channel(known->pub.channel->center_freq))
+		return;
+
+	known->pub.proberesp_ecsa_stuck = 1;
+}
+
 static bool
 cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			  struct cfg80211_internal_bss *known,
@@ -1744,8 +1799,10 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 		/* Override possible earlier Beacon frame IEs */
 		rcu_assign_pointer(known->pub.ies,
 				   new->pub.proberesp_ies);
-		if (old)
+		if (old) {
+			cfg80211_check_stuck_ecsa(rdev, known, old);
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+		}
 	}
 
 	if (rcu_access_pointer(new->pub.beacon_ies)) {
-- 
2.43.0



