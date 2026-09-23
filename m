Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70F5369D7A;
	Wed, 23 Sep 2026 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172965; cv=none; b=n9KsBGbqCeAl+Woc0vqWkrfN6lKzsJfaKVXGJ+Qxh6aBwdlOgG64cZDvYfvx2iIk8+go+3tgaeblH49/CdMEstamkRhwVR3S+NWRT2g47cvPiBw43+TUqQAkhiMsgc7CFPlw1qXRUNFxn6kOwaKWId/rRnvX618+LIRWrIJ+FEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172965; c=relaxed/simple;
	bh=8XYWqzPbc5kNPqUZYT7fMU7GJ47D6MGgROSGx7NsU9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og1aOFuj3/UxpcpElr6QtxgqKWw2MFfUHDg1hlX6vrPDcH+aNFXsiGq4LFLvsai898zelfKQIOawjLVs/tO4rir0MfqxsZjjsJb8rNIWW1Ftad5KqZ/xgtBHk9qtBtvp82Sr9c9w7gI1WERPbWlIFoEZXhnrDjn4mtwwNh+9Qgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwrnemHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwrnemHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AC61F000FF;
	Wed, 23 Sep 2026 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172963;
	bh=J4/RSTpCgaol4I3NkNd0V2waQcXZbyVORirCDkrMMI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwrnemHRmxYghD5raKf59HAWU2AxBZ7PZXCWErbzmV6wsOB4pxfNH+SyQXsdJs/Cz
	 4bi/05qBmcWqRXYJ62Qe7TSpytolJ8RWT/ehH0wg5WUmkbXpvzGIAc8B1NWTYtc7OL
	 IWvDk+Bt1nxgwPr//UW2fyQEXVZ0AWZDFXqp77kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e55106f8389651870be0@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 084/438] wifi: mac80211: require a peer station for TDLS setup confirm
Date: Wed, 23 Sep 2026 16:01:45 +0200
Message-ID: <20260923140646.959393494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5f2f89795dc99..9e721d3735e7e 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1281,6 +1281,24 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
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
@@ -1289,7 +1307,6 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		 */
 		drv_mgd_protect_tdls_discover(sdata->local, sdata, link_id);
 		fallthrough;
-	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		/* no special handling */
 		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
-- 
2.53.0



