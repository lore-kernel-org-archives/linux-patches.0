Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B709F154AF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE3AC433C8;
	Wed, 20 Sep 2023 11:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210374;
	bh=vFtHKZYZKp2qv19verSgpzuGLumJwQ+FQfTd3XWrw4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTE45BtCzwm83kCzDCNykwDOnSPJuNqwejBaNusjS6gU7nwgmgNI0oT9pz4NsXOAA
	 bVm/rw4rRr1TktSeCBSPJctRu6uzZqlPphc/5aim4a206Td3iIn4C9ObXyIOSellMZ
	 g457UX/5RvvWOQiRn0ni3Ze1m9hbwFEaFIaQrZH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2676771ed06a6df166ad@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 053/211] wifi: cfg80211: reject auth/assoc to AP with our address
Date: Wed, 20 Sep 2023 13:28:17 +0200
Message-ID: <20230920112847.424004208@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5d4e04bf3a0f098bd9033de3a5291810fa14c7a6 ]

If the AP uses our own address as its MLD address or BSSID, then
clearly something's wrong. Reject such connections so we don't
try and fail later.

Reported-by: syzbot+2676771ed06a6df166ad@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index ac059cefbeb39..775cac4d61006 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -281,6 +281,11 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	    ether_addr_equal(req->bss->bssid, wdev->u.client.connected_addr))
 		return -EALREADY;
 
+	if (ether_addr_equal(req->bss->bssid, dev->dev_addr) ||
+	    (req->link_id >= 0 &&
+	     ether_addr_equal(req->ap_mld_addr, dev->dev_addr)))
+		return -EINVAL;
+
 	return rdev_auth(rdev, dev, req);
 }
 
@@ -335,6 +340,9 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			if (req->links[i].bss == req->links[j].bss)
 				return -EINVAL;
 		}
+
+		if (ether_addr_equal(req->links[i].bss->bssid, dev->dev_addr))
+			return -EINVAL;
 	}
 
 	if (wdev->connected &&
@@ -342,6 +350,11 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	     !ether_addr_equal(wdev->u.client.connected_addr, req->prev_bssid)))
 		return -EALREADY;
 
+	if ((req->bss && ether_addr_equal(req->bss->bssid, dev->dev_addr)) ||
+	    (req->link_id >= 0 &&
+	     ether_addr_equal(req->ap_mld_addr, dev->dev_addr)))
+		return -EINVAL;
+
 	cfg80211_oper_and_ht_capa(&req->ht_capa_mask,
 				  rdev->wiphy.ht_capa_mod_mask);
 	cfg80211_oper_and_vht_capa(&req->vht_capa_mask,
-- 
2.40.1



