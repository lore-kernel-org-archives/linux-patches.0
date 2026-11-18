Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031811;
	b=0VWsIyVjl65yljR718PYGm/E75WoqAupt5yevbWKHfTUmO7YcOgIj265CqjY0NjN7fw8
	 MwoKAIqzekyOhHLK9OwNX35W/DAlLNR1yeSYJN8hQYmOeBBJQEvNXj1nnega6cJPU/1Yw
	 CnRPahFekXXeNLuoi9uFqAvMDrp9Eedyirx1VQ86S9BcB8en2IS3HjvZnvlurCJfGaqMl
	 un8zH4U5h+kB2WGxPkD4/B2VwP2UJ5KXWlsyelX4MRFwY0/BWueHIVeGePpKQYeu4194V
	 92ywlN5KPzGy9mkpz/VifbiKRQNEBewC5IlTQOB8zaDy0LDbDDNsnaFsVQsMG9xsPkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUuMaIgDBYyEBdffS4FzyTKcSjf9fT/GzxlM+G2PrAc=;
	b=KLMGUmBGynwwuigRDblPfGJBj5dNMeucoKez+blDTloD8jAQvabFQ8jb8jI6BRKn+ZLk
	 DzZO+ROeOYieGh5cc8BTGuUkHqSZSjHDk6PP1dJBqAgu5oGyOmqEeDocAgzcgjiYtyBWO
	 UQ3lLKsPuSYe7rtQ8PUsM5t/PvsF5O1+/IaBKfJNIqS5LCl3ONgmvQridiBl3dJ+Hb37o
	 bYBNlgM1EM5q9Hn2kxINcpFea4yYxTI22CC7PxbQRRLUEIDtGfxQTrSZSJUmPib6Vtz5d
	 v3q/+rUmYjp0/to8tbOybWccwOl0kX3aydG6mccerP1zBGIKRwZqlPf8P+3BE31MoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NWem4fxf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6A606A32A;
	Wed, 18 Nov 2026 19:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NWem4fxf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CE21F000C5;
	Wed, 18 Nov 2026 19:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031811;
	bh=VUuMaIgDBYyEBdffS4FzyTKcSjf9fT/GzxlM+G2PrAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWem4fxfrMG8pN3tdWYsQUW2C8j1ZmTO00RGjTiOANtWMfwN7vxiQzSXIZR7TUAaW
	 TPFTkIie4SyQSTGjNwdOvGy2oTg3kxgIWSAj2cTCeyqXNiLYWN11kvZMOr7kAG2wuT
	 IwJwsS5XFG9nN/0b4IgE/tVqUPmVqrwWuYw/PUtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1188/1756] wifi: cfg80211: track SSID regardless of country data
Date: Wed, 18 Nov 2026 15:55:15 +0100
Message-ID: <20261118150057.186806063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 577f690ce5dc641d9d8646d15bb8e99ff4a8280e ]

If the country data cannot be found, the function exits
and then doesn't track the SSID. Move the SSID tracking
up to fix that.

Fixes: c38c70185101 ("wifi: cfg80211: Set SSID if it is not already set")
Link: https://patch.msgid.link/20261013151258.7fbca481c328.I7beb03fb4309698bdcfade57c6804573f96eeb18@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 059b01bdb630b..0044fba0fb58a 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -873,6 +873,25 @@ void __cfg80211_connect_result(struct net_device *dev,
 
 	cfg80211_upload_connect_keys(wdev);
 
+	if (!wdev->u.client.ssid_len) {
+		rcu_read_lock();
+		for_each_valid_link(cr, link) {
+			u32 ssid_len;
+
+			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
+						      WLAN_EID_SSID);
+
+			if (!ssid || !ssid->datalen)
+				continue;
+
+			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
+			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
+			wdev->u.client.ssid_len = ssid_len;
+			break;
+		}
+		rcu_read_unlock();
+	}
+
 	rcu_read_lock();
 	for_each_valid_link(cr, link) {
 		country_elem =
@@ -898,25 +917,6 @@ void __cfg80211_connect_result(struct net_device *dev,
 				   country_data, country_datalen);
 	kfree(country_data);
 
-	if (!wdev->u.client.ssid_len) {
-		rcu_read_lock();
-		for_each_valid_link(cr, link) {
-			u32 ssid_len;
-
-			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
-						      WLAN_EID_SSID);
-
-			if (!ssid || !ssid->datalen)
-				continue;
-
-			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
-			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid_len;
-			break;
-		}
-		rcu_read_unlock();
-	}
-
 	return;
 out:
 	for_each_valid_link(cr, link)
-- 
2.53.0



