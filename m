Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026610;
	b=hBcQIl7Hb3mj2p+06T1Hc++XHZ8YDf21zm5+RVwoq9UZiVZxAiewRwGvsWlr5lMwwEMf
	 wnaAqOsmFpUMI9/mBohAl5l80Crs0j1SBV6/4+/W3yIsCMRn0eqHWC2uzUv76AoyBS92Y
	 k1w9OQY9Tcbro6jGP1dgVP8f2YxcAzd4TZUrniGy5ZAUCHzQRNAK17bFyeZhtu0ycpwre
	 SZbjKM4yM4pLk2rpp/ZcG8zfov8IKJF1Qft+ituzWZKPRtHZIpNL20JWJPfxjgjsCDwhI
	 tArSrGyQ25DAJD4bQWwxhCpk4mNi9RJt8JwMdbwAEB9PbZ6tsbK9zTlPRzpfgI8wfhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6BNeXuDqVv+AoszSUSGYLLWI6t5EfP2HHacjbEERrzs=;
	b=ZjqlRK7CcIIRKO1OLEkWW4hx7puTj2u8lc27t348/+FQzFQgV3TP8l4k54yh0eE9Wfsn
	 x0VBTtxUfvZtk49uxqMMlLRu6EWEGt9vBrDrVJPddep+b70Im6xUeQv+0wjwBYiqxE90M
	 WJBiifz4oG+oEO7f3Oe6tXowU9O8N31g4nUprta05DPDhch3D/IkUcHuq+TyBemI9Tv9v
	 CnbTpxFWZPHY8V5vfBV7UkCGIlUSaiD97T06V0hxbVb8EC3bmLuYJ/ifGP/je+NKmNoa4
	 ZchPq+Asvob819FtDllS5RVuZtziRVbzQesygVQiW/iCw/2N1pb40o+Dl7J+iLZc3xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wxHQwmkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FD2606A320;
	Wed, 18 Nov 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wxHQwmkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2601F000C4;
	Wed, 18 Nov 2026 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026609;
	bh=6BNeXuDqVv+AoszSUSGYLLWI6t5EfP2HHacjbEERrzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxHQwmkdct8LOB8pCjofE9vKs92aaoTiyM+0EEvIPcNvWaj+FY+hJOJxyVVrTZe9P
	 XtxfDZLC8AZ2ZSeq3/5l35cQK3+rvfsaFhWWIfxa1R74wdZcaNNsqScnwpvGapNuzg
	 SBh19inU/7m91bYpd/L1tCpRRCYln5GYuMtjrycg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1495/2151] wifi: cfg80211: track SSID regardless of country data
Date: Wed, 18 Nov 2026 15:53:50 +0100
Message-ID: <20261118150216.333466035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 72166b70ee679..e379af2f7b6ac 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -872,6 +872,25 @@ void __cfg80211_connect_result(struct net_device *dev,
 
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
@@ -897,25 +916,6 @@ void __cfg80211_connect_result(struct net_device *dev,
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



