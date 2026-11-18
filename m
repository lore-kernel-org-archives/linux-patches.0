Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026160;
	b=hQBzm0fdk5bDmIyDDLWcdVpPLLQFDkyjW1SX1OZZP9YB/j7y3GwiZKyXJxq78pE32iz0
	 DeGptuISN1uxJIZny7RHDAFVAgt6V0GbuRY8Vv2A6ux9MwpjXRU+jOF5pklUE3MVcI3Vg
	 JA3wrm3CbjqipViLFPgfQfYA4fXnAGmOwKgvLVhgv2NVHFvikqoGv09fC07/vs7mDN6fb
	 bY+VgQ9U/g4hYT4+3x3BYz9DKkb61pPcy9p5UJs7aiyHJmzXYUr+367i9D7IPOSODf5Fi
	 qKVQjwgKCk+kUWat/EHJSYloYZDdpG8yttbJ2GfeUnewVNBX4vvtt2RB3QIyjwdY6ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hpshe8EeTNRsRCjnDL+nTZvnje4YQZHsxsMFJH/JHUw=;
	b=r79ZXI3lJq2L17qoFQeJzE3k5wC8rrmS5meA63mTDIIEvbWiVin2F0xKHa6MFxvE24wM
	 x04wun4Up6zFftgKBMCXcvz07uwwo1rw6KgiQz7+xDSwCqvVdQgjDR2GER0V14SUUynX/
	 TGKbJbjSqynqFdpP3mkvlteg3EeROL6CXzMwHfWE/uVKA1F0InLSVzJRsz1XbJoAXYjRk
	 Czam6OT29YwW3XrTQ46Q87d+hmXARkvKIGj+bI/mR9XNBOvd6N1XK+6MaUx0k5v01MPrf
	 +txXdjJrsC1O6mWW0Nt0JajjJl7FjbeOVOrpNxcHqRFrma6gCBCtt6Yq99mOrBiNpng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkNky0JO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5AE606A31C;
	Wed, 18 Nov 2026 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkNky0JO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCEE1F000C5;
	Wed, 18 Nov 2026 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026160;
	bh=Hpshe8EeTNRsRCjnDL+nTZvnje4YQZHsxsMFJH/JHUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkNky0JOP0pldpJLLaZEX15UpU2icp5CfVrsgRvsi3eeiA6j3jWqO+09Tpwd5yn2B
	 HXgKM9CPfC4YMlnavAMZt0hqnhEeaqwHiyLwTKgXfgQ1yEZdQaHV87Kye2+NbHleko
	 8trogwgqCjQoUF8m7U3oggbG+JM1hCeF61GJKk9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1295/2151] wifi: mac80211: fix mbssid/rnr allocation in beacon data
Date: Wed, 18 Nov 2026 15:50:30 +0100
Message-ID: <20261118150209.291066660@linuxfoundation.org>
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

[ Upstream commit baf0d4feed2f0fed8e045f948534a4bd43ae464e ]

These structs are placed after the tail, but that can make
them unaligned. Change the order so the structs are after
one another, and then followed by the head/tail/elements.

Assisted-by: LLM
Fixes: 2b3171c6fe0a ("mac80211: MBSSID beacon handling in AP mode")
Link: https://patch.msgid.link/20261005224950.2f554b2c7c10.Ie961eb6b1435f956446e052936258758b966c67f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 53 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c154d9c0169aa..25bb1fed9b606 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1326,6 +1326,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
 	int size, err;
+	u8 *pos;
 	u64 _changed = BSS_CHANGED_BEACON;
 	struct ieee80211_bss_conf *link_conf = link->conf;
 
@@ -1353,20 +1354,16 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
-		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (params->rnr_ies) {
-			rnr = params->rnr_ies;
-			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
-		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
-							mbssid->cnt);
+		rnr = params->rnr_ies;
 	} else if (old && old->mbssid_ies) {
 		mbssid = old->mbssid_ies;
+		rnr = old->rnr_ies;
+	}
+
+	if (mbssid) {
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old->rnr_ies) {
-			rnr = old->rnr_ies;
+		if (rnr)
 			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
 	}
@@ -1378,26 +1375,38 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	/* start filling the new info now */
 
 	/*
-	 * pointers go into the block we allocated,
-	 * memory is | beacon_data | head | tail | mbssid_ies | rnr_ies
+	 * pointers go into the block we allocated, the order in memory is
+	 *  - struct beacon_data
+	 *  - struct mbssid_ies (including variable array)
+	 *  - struct rnr_ies (including variable array)
+	 *  - beacon head
+	 *  - beacon tail
+	 *  - mbssid/rnr elements
+	 * so that the structs (which contain pointers) are all aligned
 	 */
-	new->head = ((u8 *) new) + sizeof(*new);
-	new->tail = new->head + new_head_len;
-	new->head_len = new_head_len;
-	new->tail_len = new_tail_len;
-	/* copy in optional mbssid_ies */
+	pos = (u8 *)(new + 1);
 	if (mbssid) {
-		u8 *pos = new->tail + new->tail_len;
-
 		new->mbssid_ies = (void *)pos;
 		pos += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		pos += ieee80211_copy_mbssid_beacon(pos, new->mbssid_ies,
-						    mbssid);
 		if (rnr) {
 			new->rnr_ies = (void *)pos;
 			pos += struct_size(new->rnr_ies, elem, rnr->cnt);
-			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
 		}
+	}
+
+	new->head = pos;
+	new->head_len = new_head_len;
+	pos += new_head_len;
+	new->tail = pos;
+	new->tail_len = new_tail_len;
+	pos += new_tail_len;
+
+	/* copy in optional mbssid_ies */
+	if (mbssid) {
+		pos += ieee80211_copy_mbssid_beacon(pos, new->mbssid_ies,
+						    mbssid);
+		if (rnr)
+			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
 		/* update bssid_indicator */
 		if (new->mbssid_ies->cnt && new->mbssid_ies->elem[0].len > 2)
 			link_conf->bssid_indicator =
-- 
2.53.0



