Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3401C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42079C433EF;
	Mon, 20 Mar 2023 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325369;
	bh=H96fpcwqJceqRaitYxcT5Jbq/71e4nWY0B1FohBm9rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHBFhwQRALh0Iki9zS3dZ3btl4YnKdQ+2rinkxMgJF7Ouslspht7jiCxFHODZVE+7
	 hALAlKqIyAhy2AK9ncW/8HUuIx2EJQh8r7pdG4Oq11Bn9owwzuxXzAS8J1M4HTaBto
	 Oy9o73G3hvSJNDqTdXeP1EwjMCs+rPXhe18qaPoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 036/211] wifi: cfg80211: fix MLO connection ownership
Date: Mon, 20 Mar 2023 15:52:51 +0100
Message-Id: <20230320145514.756007627@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 96c069508377547f913e7265a80fffe9355de592 ]

When disconnecting from an MLO connection we need the AP
MLD address, not an arbitrary BSSID. Fix the code to do
that.

Fixes: 9ecff10e82a5 ("wifi: nl80211: refactor BSS lookup in nl80211_associate()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230301115906.4c1b3b18980e.I008f070c7f3b8e8bde9278101ef9e40706a82902@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 326c6e50e9db5..e34491e63133d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10700,8 +10700,7 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 
 static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device *rdev,
 					      const u8 *ssid, int ssid_len,
-					      struct nlattr **attrs,
-					      const u8 **bssid_out)
+					      struct nlattr **attrs)
 {
 	struct ieee80211_channel *chan;
 	struct cfg80211_bss *bss;
@@ -10728,7 +10727,6 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 	if (!bss)
 		return ERR_PTR(-ENOENT);
 
-	*bssid_out = bssid;
 	return bss;
 }
 
@@ -10738,7 +10736,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct cfg80211_assoc_request req = {};
 	struct nlattr **attrs = NULL;
-	const u8 *bssid, *ssid;
+	const u8 *ap_addr, *ssid;
 	unsigned int link_id;
 	int err, ssid_len;
 
@@ -10875,6 +10873,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 
 		req.ap_mld_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+		ap_addr = req.ap_mld_addr;
 
 		attrs = kzalloc(attrsize, GFP_KERNEL);
 		if (!attrs)
@@ -10900,8 +10899,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 				goto free;
 			}
 			req.links[link_id].bss =
-				nl80211_assoc_bss(rdev, ssid, ssid_len, attrs,
-						  &bssid);
+				nl80211_assoc_bss(rdev, ssid, ssid_len, attrs);
 			if (IS_ERR(req.links[link_id].bss)) {
 				err = PTR_ERR(req.links[link_id].bss);
 				req.links[link_id].bss = NULL;
@@ -10952,10 +10950,10 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		if (req.link_id >= 0)
 			return -EINVAL;
 
-		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs,
-					    &bssid);
+		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs);
 		if (IS_ERR(req.bss))
 			return PTR_ERR(req.bss);
+		ap_addr = req.bss->bssid;
 	}
 
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
@@ -10968,7 +10966,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 			dev->ieee80211_ptr->conn_owner_nlportid =
 				info->snd_portid;
 			memcpy(dev->ieee80211_ptr->disconnect_bssid,
-			       bssid, ETH_ALEN);
+			       ap_addr, ETH_ALEN);
 		}
 
 		wdev_unlock(dev->ieee80211_ptr);
-- 
2.39.2



