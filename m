Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427B53DC4D8;
	Wed, 30 Sep 2026 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796135; cv=none; b=baRck0Q22UysH068gAf/Fx8smio3pUtYxsTa2gFZAsJSpJ57HVl15t5pm/cgnwdW7B7xbk0daPZSppLE0GDTql3bApnqpOeHJAUAnATtGV2f+atwClkT/DvBw9L//fn3zYUbCR7gwr96yv/CvAn66CqVUC17Cl2n353Ti4qN/Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796135; c=relaxed/simple;
	bh=ZnF9kgffNVI1RB2y7RNJpFeDYBXZi2AFjuVGp4V6YXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa53aFALy7alyJp2w9rrFDvqtCFX9ogpXSxzqwgZWifPAoiViNg+v1lRurL49tCo4/fbIgefLzKITRa7Mx0P0GQd4+wcRp6DxWlg3LQnZdTaXzHNGQcZq30fcy52nUrjbBNZE7OkRqMDdA16cpZduntZvHr9kfl1CCgioV+7Nq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W732j+IG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W732j+IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8581F000FF;
	Wed, 30 Sep 2026 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796134;
	bh=cB1CGj782BIFpVUifRbzapifHU3XVxh7mDlkwAy1XOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W732j+IGc7mzbU6xrWTaHwGcN3sk2DP9I/5s49W7clNyivi57NkP/SG+76fZwFRyr
	 XfMfzhav3MLrwIFi29aZBQ/A5JAdG9w36nzTpOI0sNT0mEz1nHKXEUKH8Sk76CBC1h
	 TNtVZJ/nUA4xfrvkaqISNsj9dyOEcqTUeKU8LS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e55106f8389651870be0@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0761/1193] wifi: mac80211: require a peer station for TDLS setup confirm
Date: Wed, 30 Sep 2026 17:24:05 +0200
Message-ID: <20260930152451.164192321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 038e1d126304fd25d507fd4e671232df57bd1799 ]

It's nonsense for the setup confirm to go to station that
doesn't even exist, and it hits a warning when building
the frame:

  WARN_ON_ONCE(!sta || !ap_sta)

Only accept WLAN_TDLS_SETUP_CONFIRM when the station is
already there as a TDLS station. Need to copy the call
to ieee80211_tdls_prep_mgmt_packet() since the existing
WLAN_TDLS_DISCOVERY_REQUEST already falls through to it.

Assisted-by: LLM
Fixes: 6f7eaa47e1de ("mac80211: add TDLS QoS param IE on setup-confirm")
Reported-by: syzbot+e55106f8389651870be0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e55106f8389651870be0
Link: https://patch.msgid.link/20260908122838.201719-15-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c3622f779d120..38cbfced6ae34 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1316,6 +1316,24 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 						   peer_capability, initiator,
 						   extra_ies, extra_ies_len);
 		break;
+	case WLAN_TDLS_SETUP_CONFIRM: {
+		struct sta_info *sta;
+
+		sta = sta_info_get(sdata, peer);
+		if (!sta || !sta->sta.tdls) {
+			ret = -ENOLINK;
+			break;
+		}
+
+		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
+						      link_id, action_code,
+						      dialog_token,
+						      status_code,
+						      peer_capability,
+						      initiator, extra_ies,
+						      extra_ies_len, 0, NULL);
+		break;
+	}
 	case WLAN_TDLS_DISCOVERY_REQUEST:
 		/*
 		 * Protect the discovery so we can hear the TDLS discovery
@@ -1324,7 +1342,6 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		 */
 		drv_mgd_protect_tdls_discover(sdata->local, sdata);
 		fallthrough;
-	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		/* no special handling */
 		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
-- 
2.53.0



