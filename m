Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39F64D4888;
	Wed, 30 Sep 2026 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785800; cv=none; b=m9cxjRHoSSocfWXitxucbDA+hrXtASbNTQS9mE4SaX7gGeLCo/KG226WGJ8FXuYW+zPYZmKSF51IOiFZSbCGLISg73eZ2lPxWX/aK4AHOLKrWH3zJWpmBTTb7sq15GKLecIWF0/uqcGAS9ONHCRnWGrKUWZ8aGXwLLZHB7X1jBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785800; c=relaxed/simple;
	bh=s3Z/2I08h+Fwj6m3naqNWfZ5w2JDGXxfuSkZMIjnXIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3qbRY91Z1GC8xLK4jGGALUHmDwH+JX12/wiAjQPFL9xL0q1lQML3hu7+Ewr2tYo6Yc6nVfUfck18VGYO9NVCd1ulW/7bUYmhpqz12LQ/IB8ewEYMuQe2zXRh0SV1d56VmaHx7cqZbHvg3rjqlXLo8iZDHIyQfTw0tmS3gsar3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jboefEKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jboefEKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4671F000FF;
	Wed, 30 Sep 2026 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785798;
	bh=Z5cC0Y0ACmHmRNyikNdTI3uePg8ZGi7j0A/mJQhf0Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jboefEKHU3qJRQfr1qo/6+no6HEzfCG2Zp4opQWtij+2MEzO5BgUmUd64qhADXrNR
	 zbBpfHyfbz4u0iYixyDw8RctMYW8fw1zZFBHsjmHHlauoO4gWbVs78heMDI/vzrDdp
	 D9NeDzb7c+nbXQuwjuGGl7zlMCkejzNa3U9/GLOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e55106f8389651870be0@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 634/982] wifi: mac80211: require a peer station for TDLS setup confirm
Date: Wed, 30 Sep 2026 17:22:50 +0200
Message-ID: <20260930152430.388485178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 708e7fb1b218a..b25aed68dc8a8 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1232,6 +1232,24 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
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
@@ -1240,7 +1258,6 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		 */
 		drv_mgd_protect_tdls_discover(sdata->local, sdata);
 		fallthrough;
-	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		/* no special handling */
 		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
-- 
2.53.0



