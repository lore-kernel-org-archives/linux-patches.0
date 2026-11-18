Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041610;
	b=xYrr0jJSnVupentHTdtOlnR3JBPqcVK2JgP7ZiTzRy8Z+77Dw8mISYjmLKTs/50NVK7A
	 TP9qNnGdL18zuz0XsJtcDrJ5TZKuFxYTJBOUSVuCbrGhgHyVTtaX2+aetpBvaM6e5ipMj
	 v0gAj87a12hFOExcDYbhgcjsnRwJB7UuqoS880ONe+e99Fk8pgKoBHhfKXw04cD+ch0E/
	 0t2JylFlp3oI8BCwQhG0rB72LJ/+fCSRmS24/ISXQ+z1ycGQbP/V50d1RlIUQw1sBsT6q
	 rdTmNC1gfU44WDvW0oKO5DZYOkufmbTVp+EAHLd4gNqEMVjAKLolkSBzF64nJxu2bbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t0vSAX7JRk03sTHGjtT58TSxHEal0xlYwBX3q3ms6Qs=;
	b=hZKEPY68gFo+ih3oTPeZLXGr9zH07AfGJ2tsn7MjgbT8Yyt1YGqIS4KeeojveIJeopQx
	 dSHluxnoD8iW7/eS54fK0MZT+DFolymSr7aq0Gfc6vwNszZeFBpdWbahcyBIjrBtWDXc/
	 rZEc0jTon98YD+X58aZ4dnIsPO0H3dqlfQbKZ4t0j3ETCG93M5QmRNY+QKDBdXT8x3OaT
	 N6DYiCIs2+LgJCSAGxFIdJsD8qXU3JhS1EV64YKnO9vi+Q5YWMHHEexV+XtBTu8kF/N++
	 eTYO1HUh2rR0WHULzaykJQnXgvo6VSrnI1pxQWWOk2XLrYA52pRCWSuLKXRRNiCvlLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlZPCGjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D18606A325;
	Wed, 18 Nov 2026 22:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlZPCGjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139DB1F000C4;
	Wed, 18 Nov 2026 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041610;
	bh=t0vSAX7JRk03sTHGjtT58TSxHEal0xlYwBX3q3ms6Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlZPCGjX2MXquj7EWI1w++QcP4WzPCibypGsX5fgmlhDeFbBvem8uKIg4Txqix6Tm
	 8zf4ZhjEV/lzc1lGTnkXgOucOYzKVBviVsMpOj8AzxWCbUt4UOejVz6dnhCi+CNkU+
	 1lw2qUTLoq44C7+wXD4Kf6DxZvvgQ7cZ9U8SZQNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2848/3318] wifi: cfg80211: track SSID regardless of country data
Date: Wed, 18 Nov 2026 15:57:50 +0100
Message-ID: <20261118150446.045674206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eb0434783f9fb..2e56f61d28127 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -887,6 +887,25 @@ void __cfg80211_connect_result(struct net_device *dev,
 
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
@@ -912,25 +931,6 @@ void __cfg80211_connect_result(struct net_device *dev,
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



