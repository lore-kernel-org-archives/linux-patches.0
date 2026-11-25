Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620087;
	b=4uP6p9FJY2znBid5NYvq1w0Ws0cPa5cdXr15AURLGa+/1CAHuCWS3qILAOwpknodLIxC
	 FLUrKnjj7pohAxttEaGWVO5zTMP1ejv/xbghelNGUFPk4LDr6pNLd9siBV8L2VTJMKyte
	 +BwTb32wG8q4Tuu7v9qa1/SuKFDxw56/HdWr0tfhAz2CJ7T1eZxT+lnBWNIFFw9bDYwiI
	 bbGa02WOtbkKRQU1lfAjTlUbiQ9wKcNvo+ETFRTUVhKZWC2ZKMI8GM2Zk/vUkn7nwKg1L
	 RmTpiXR/RmTIpVzWjX4KZUBkWx2hYQPuycBAhAx2SgR4wbNfaPfxfGSl7aRjdljtzyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z2L3TIxIYwNfFTlqEtMKLaXtNyLpbQ6iokn0wbz9yck=;
	b=VWgpQCKmS3S3gPureNglsMS5kqYVrfmVZqFyF2AFhdOSc2mtfIXJmU4WW3UbyjHtrFJN
	 Zui3lmfIoJojPJNwsL+i6RZ8KVDkhSEJJ3a6mcV2uSomN4WlWCyisr3XpqJxSXQTcedJt
	 REIDcoyIutaIUk86jl7jUh28EEZaQYpLhuU27Nj2mPoXXvManRiOANNF2pjGYY4dnO27c
	 KguVYJyr5/WkNhXanoY0tPWMJlCIvQ8h1z7dMRO7JRi514+r+cBI2lQBPj8gLAy21VBGP
	 ic7lGvA9A82Ccsormb+ZRRzhwu1vowB4OoCtytYge3un1bG0BsUXYRq4dIugV6k2LUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9a1ktq3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47DB606A31E;
	Wed, 25 Nov 2026 15:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9a1ktq3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BEB1F000C6;
	Wed, 25 Nov 2026 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620086;
	bh=z2L3TIxIYwNfFTlqEtMKLaXtNyLpbQ6iokn0wbz9yck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9a1ktq3y7ZBSDQ0/0VImnlG1bRNaAV3kjfzT1GGZC4j1WEKsc8DNpfM2lPXlUkr/
	 ncVOVESUkUZdnQilgATFk91QGVHiDgfJ0NLfGOIbyPdwn2i1/CIPpjcOTZhI5tsK2U
	 gQdDcct4LyZ/WNEZNaaqKWph8JbsbA7lWtfYLlkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0805/1005] wifi: mac80211: fix use-after-free on TTLM disconnect
Date: Wed, 25 Nov 2026 15:35:43 +0100
Message-ID: <20261125143840.589757262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7849,15 +7849,15 @@ static void ieee80211_tid_to_link_map_wo
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
@@ -7875,14 +7875,14 @@ static void ieee80211_process_adv_ttlm(s
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
@@ -7894,7 +7894,7 @@ static void ieee80211_process_adv_ttlm(s
 
 		if (res) {
 			__ieee80211_disconnect(sdata);
-			return;
+			return false;
 		}
 
 		if (ttlm_info.switch_time) {
@@ -7919,7 +7919,7 @@ static void ieee80211_process_adv_ttlm(s
 			 * switch the AP will continue to announce it anyway.
 			 */
 			if (delay > IEEE80211_ADV_TTLM_ST_UNDERFLOW)
-				return;
+				return true;
 
 			delay_usec = ieee80211_tu_to_usec(delay);
 
@@ -7938,9 +7938,11 @@ static void ieee80211_process_adv_ttlm(s
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
@@ -8463,8 +8465,9 @@ static void ieee80211_rx_mgmt_beacon(str
 					       elems->cisco_dtpc_elem);
 
 	ieee80211_ml_reconfiguration(sdata, elems);
-	ieee80211_process_adv_ttlm(sdata, elems,
-				      le64_to_cpu(mgmt->u.beacon.timestamp));
+	if (!ieee80211_process_adv_ttlm(sdata, elems,
+					le64_to_cpu(mgmt->u.beacon.timestamp)))
+		goto free;
 
 apply:
 	ieee80211_link_info_change_notify(sdata, link, changed);


