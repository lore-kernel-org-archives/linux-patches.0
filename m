Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5336A44C8C;
	Tue, 27 Aug 2024 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770198; cv=none; b=TtRzRXn1OSXFozmek1xG2qXYIg5Z61Indiage6GsuUGzNhdYpgyKgOsruAy6L/EsjAHncJyo7AYlkvzsnRG157Upzc5gXDJHiJLnccqegn+DorjX6KClBlkT0altek96DCUI2Fma51FzWoQMAmjhuA2YpKP55B6MqWjRcKB8svE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770198; c=relaxed/simple;
	bh=yeUd57RHLgAHOGJBe0L604qJm8wW3U2iUw81g32w6dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq/ciCVIl52EGQ/ej6t0laBe7/h4/r8vytdPV4h1aD1WJbzdwm8DK/IWSiGUxVeMLDg2X8uwr3ZGi0LoKKi0kTB5fjoQ3mcVM3UBhSyOD3fBbmffiTedpUPytkjXJRYVcVuJVJww6Ry4dtDzbarqE5ZfOhYkzO3cEdf9h7LQvtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vc1YjiRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vc1YjiRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E24C4DDEA;
	Tue, 27 Aug 2024 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770197;
	bh=yeUd57RHLgAHOGJBe0L604qJm8wW3U2iUw81g32w6dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vc1YjiRG/V/Vp7FF2JXyJBfoWO+TCjH/CPTUxXM++Hfq0xP67dj2GXs1u2xrP53qe
	 bkri66G19wqMKn5un1LAedEsMRDCU3LNt4Ad2PDrW4WeSbkzxfZJX8BeVQNRyFd5xI
	 kw2oBR16o3rgOw2fKM7wO7GNYZ1dBrUZ0QkyJw3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/341] wifi: mac80211: flush STA queues on unauthorization
Date: Tue, 27 Aug 2024 16:35:56 +0200
Message-ID: <20240827143848.172666021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit 06d6af4e1223339bb597b02fa8ad3f979ddb5511 ]

When the station is marked as no longer authorized, we shouldn't
transmit to it any longer, but in particular we shouldn't be able
to transmit to it after removing keys, which might lead to frames
being sent out unencrypted depending on the exact hardware offload
mechanism. Thus, instead of flushing only on station destruction,
which covers only some cases, always flush on unauthorization.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230928172905.d47f528829e7.I96903652c7ee0c5c66891f8b2364383da8e45a1f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 42ba51a9700f2..5d71e8d084c45 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1284,6 +1284,8 @@ static int _sta_info_move_state(struct sta_info *sta,
 				enum ieee80211_sta_state new_state,
 				bool recalc)
 {
+	struct ieee80211_local *local = sta->local;
+
 	might_sleep();
 
 	if (sta->sta_state == new_state)
@@ -1359,6 +1361,24 @@ static int _sta_info_move_state(struct sta_info *sta,
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 			ieee80211_vif_dec_num_mcast(sta->sdata);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+
+			/*
+			 * If we have encryption offload, flush (station) queues
+			 * (after ensuring concurrent TX completed) so we won't
+			 * transmit anything later unencrypted if/when keys are
+			 * also removed, which might otherwise happen depending
+			 * on how the hardware offload works.
+			 */
+			if (local->ops->set_key) {
+				synchronize_net();
+				if (local->ops->flush_sta)
+					drv_flush_sta(local, sta->sdata, sta);
+				else
+					ieee80211_flush_queues(local,
+							       sta->sdata,
+							       false);
+			}
+
 			ieee80211_clear_fast_xmit(sta);
 			ieee80211_clear_fast_rx(sta);
 		}
@@ -1424,18 +1444,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 		WARN_ON_ONCE(ret);
 	}
 
-	/* Flush queues before removing keys, as that might remove them
-	 * from hardware, and then depending on the offload method, any
-	 * frames sitting on hardware queues might be sent out without
-	 * any encryption at all.
-	 */
-	if (local->ops->set_key) {
-		if (local->ops->flush_sta)
-			drv_flush_sta(local, sta->sdata, sta);
-		else
-			ieee80211_flush_queues(local, sta->sdata, false);
-	}
-
 	/* now keys can no longer be reached */
 	ieee80211_free_sta_keys(local, sta);
 
-- 
2.43.0



