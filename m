Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623325;
	b=og/hpWu83umh5TnGEOZFp0dVHvOxwBCPMIrBpIaqUdNmIbZjZ7CjIkdqAy8DnRL0rX75
	 DtpYsFN/9GPvywqN6k8paBsmFaEX8Fpj+4+U7X13QpaesCfyhaTbsuaIW8CxMTt8+Ykzh
	 WokmE1Fiztp+y8alnOzByTy+MO5/8LBSGiBjXMOpSXy3RXzdDM+jVdAmRQdhLojAxP/IA
	 rrDAnl4nqgxJ64z8Tm6L5TYkzBfJ6i05vMDkwbEGnxFosmD6Tn7proNkag1lYpUOnkBae
	 sS/AUmmW3X+QBSAH+MZLBrn1YqdkdZszpY/74q/hDAmHFVAvWdFA1aaGtTvtmhbzBnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gHHvgQg/hB2srbst7861bNdof+fKvEnrmewM/eRtm28=;
	b=u4bXx4dhiBeZPZFKKEslbZfFpMHMFHi7dyWOEzVUxAw3vxgKdpgHyMlIygt2GijvDVOA
	 TUcAxHnxJ69nL9ZohLoo6kFKjjdR9PbJalRY0Km+7oJwy/HChrUeTPZyPdsE7KJp/Sn8G
	 u44FKz3jwUsHp70le1ATRLc7wJIFZHIOgha3vLqaSMv6kLD9abDn6JrO/kJ2EumHgHBpu
	 iJU8amd79AMv26yqw3VjDkKyVAqhHWv4KOHqJZtlBPNEFirscHGbAfGS3aQ8g4QaVl1ZH
	 pvQWOsYYoimNuGhbIKEtBDL4J9nTOjTK4GAh8bkXicqeDuJO7Gpcl5BlBUE+ouy5kPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWeDy3oH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5AE606A336;
	Wed, 25 Nov 2026 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWeDy3oH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C711F000C4;
	Wed, 25 Nov 2026 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623325;
	bh=gHHvgQg/hB2srbst7861bNdof+fKvEnrmewM/eRtm28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWeDy3oHLoJy4JY0CulkFOsuwLX/EP1DmL2A0WHxJwVckrQi1JFDwoV+zycbZn2QI
	 rQyTtUAKnNI50J8EhogIkQLZM/FWzyKK+7m/P5n/yYmhmA8cMAGK1yqrC3IBkzv4Gt
	 2wWyIGcJkXc/z75MOrqBwyt/dwerJqUDfqhzZvFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 821/990] wifi: mac80211: fix use-after-free on TTLM disconnect
Date: Wed, 25 Nov 2026 15:36:28 +0100
Message-ID: <20261125143841.270460730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4af2b71495a3f12196cbea1c9a502c62ada867be upstream.

If ieee80211_process_adv_ttlm() disconnects, and some other
changes were also detected in the beacon, the link update
to the driver is still done, leading to use-after-free. Fix
this by returning, like other functions, whether or not the
update was accepted by the function.

Cc: stable@vger.kernel.org
Fixes: 702e80470a33 ("wifi: mac80211: support handling of advertised TID-to-link mapping")
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20261102220313.3cf5e709417b.I339967c7e614057253aa68c005d9ae220577f99a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7127,15 +7127,15 @@ static void ieee80211_tid_to_link_map_wo
 	sdata->u.mgd.ttlm_info.switch_time = 0;
 }
 
-static void ieee80211_process_adv_ttlm(struct ieee80211_sub_if_data *sdata,
-					  struct ieee802_11_elems *elems,
-					  u64 beacon_ts)
+static bool ieee80211_process_adv_ttlm(struct ieee80211_sub_if_data *sdata,
+				       struct ieee802_11_elems *elems,
+				       u64 beacon_ts)
 {
 	u8 i;
 	int ret;
 
 	if (!ieee80211_vif_is_mld(&sdata->vif))
-		return;
+		return true;
 
 	if (!elems->ttlm_num) {
 		if (sdata->u.mgd.ttlm_info.switch_time) {
@@ -7153,14 +7153,14 @@ static void ieee80211_process_adv_ttlm(s
 						      0);
 			if (ret) {
 				sdata_info(sdata, "Failed setting valid/dormant links\n");
-				return;
+				return true;
 			}
 			ieee80211_vif_cfg_change_notify(sdata,
 							BSS_CHANGED_MLD_VALID_LINKS);
 		}
 		memset(&sdata->u.mgd.ttlm_info, 0,
 		       sizeof(sdata->u.mgd.ttlm_info));
-		return;
+		return true;
 	}
 
 	for (i = 0; i < elems->ttlm_num; i++) {
@@ -7172,7 +7172,7 @@ static void ieee80211_process_adv_ttlm(s
 
 		if (res) {
 			__ieee80211_disconnect(sdata);
-			return;
+			return false;
 		}
 
 		if (ttlm_info.switch_time) {
@@ -7197,7 +7197,7 @@ static void ieee80211_process_adv_ttlm(s
 			 * switch the AP will continue to announce it anyway.
 			 */
 			if (delay > IEEE80211_ADV_TTLM_ST_UNDERFLOW)
-				return;
+				return true;
 
 			delay_usec = ieee80211_tu_to_usec(delay);
 
@@ -7216,9 +7216,11 @@ static void ieee80211_process_adv_ttlm(s
 			wiphy_hrtimer_work_queue(sdata->local->hw.wiphy,
 						 &sdata->u.mgd.ttlm_work,
 						 us_to_ktime(delay_usec));
-			return;
+			return true;
 		}
 	}
+
+	return true;
 }
 
 static void
@@ -7738,8 +7740,9 @@ static void ieee80211_rx_mgmt_beacon(str
 					       elems->cisco_dtpc_elem);
 
 	ieee80211_ml_reconfiguration(sdata, elems);
-	ieee80211_process_adv_ttlm(sdata, elems,
-				      le64_to_cpu(mgmt->u.beacon.timestamp));
+	if (!ieee80211_process_adv_ttlm(sdata, elems,
+					le64_to_cpu(mgmt->u.beacon.timestamp)))
+		goto free;
 
 apply:
 	ieee80211_link_info_change_notify(sdata, link, changed);


