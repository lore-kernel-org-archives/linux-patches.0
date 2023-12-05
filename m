Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4AD6FAF;
	Tue,  5 Dec 2023 03:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxjDDZTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C050AC433C8;
	Tue,  5 Dec 2023 03:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746660;
	bh=pyzOfYHgxIaiUNglYHa1hu0nv8OYQS6A1kNnOw7j9TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxjDDZTfqoAKV2tHQ41Jubsso0cN7F6giqM2gGhH7ehYSQWCS0WB497zmFDmL50TD
	 2q9Ig6Fou+kHXupEy3jOcBkyLqjt9a4dSIjfhOwd0he3Y2kQB4AFvounWafElBDH5w
	 klVFoLxE1AwZDG/5HB2GyGa2bFsN5+AcvlHSaWp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Demin <rockdrilla@gmail.com>,
	Koen Vandeputte <koen.vandeputte@citymesh.com>,
	=?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/134] wifi: mac80211: do not pass AP_VLAN vif pointer to drivers during flush
Date: Tue,  5 Dec 2023 12:15:56 +0900
Message-ID: <20231205031540.804407147@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oldřich Jedlička <oldium.pro@gmail.com>

[ Upstream commit 3e3a2b645c043f7e3e488d5011478cefb69bbe8b ]

This fixes WARN_ONs when using AP_VLANs after station removal. The flush
call passed AP_VLAN vif to driver, but because these vifs are virtual and
not registered with drivers, we need to translate to the correct AP vif
first.

Closes: https://github.com/openwrt/openwrt/issues/12420
Fixes: 0b75a1b1e42e ("wifi: mac80211: flush queues on STA removal")
Fixes: d00800a289c9 ("wifi: mac80211: add flush_sta method")
Tested-by: Konstantin Demin <rockdrilla@gmail.com>
Tested-by: Koen Vandeputte <koen.vandeputte@citymesh.com>
Signed-off-by: Oldřich Jedlička <oldium.pro@gmail.com>
Link: https://lore.kernel.org/r/20231104141333.3710-1-oldium.pro@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c4505593ba7a6..2bc2fbe58f944 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -23,7 +23,7 @@
 static inline struct ieee80211_sub_if_data *
 get_bss_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata && sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 				     u.ap);
 
@@ -638,10 +638,13 @@ static inline void drv_flush(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     u32 queues, bool drop)
 {
-	struct ieee80211_vif *vif = sdata ? &sdata->vif : NULL;
+	struct ieee80211_vif *vif;
 
 	might_sleep();
 
+	sdata = get_bss_sdata(sdata);
+	vif = sdata ? &sdata->vif : NULL;
+
 	if (sdata && !check_sdata_in_driver(sdata))
 		return;
 
@@ -657,6 +660,8 @@ static inline void drv_flush_sta(struct ieee80211_local *local,
 {
 	might_sleep();
 
+	sdata = get_bss_sdata(sdata);
+
 	if (sdata && !check_sdata_in_driver(sdata))
 		return;
 
-- 
2.42.0



