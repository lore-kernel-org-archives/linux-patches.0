Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019343;
	b=X+7dXI0T8LpoeoYwrT+iUSeVRB1qbF6YFQRvwE/4NkjV0zOuP3WRyFzi/7Yzx+KpFWNM
	 sAavcc3TC7pX5T+8dJ/Y9cg79OqeW4I3iph7X5Um+q/6dQckbuQyyKkfpPnUuLpXvEf6z
	 Q6be9v1FRmT6P2r2YyNgsjkfHtrwUbiOq6yh7zttVtzMmoGXfriU4Ew5Jd0/gpNkYJo7k
	 +P34uLJssgH7Lci6Ohg5efbnBAwt5ERUr9BZWPf1+zN+CKNvSzQyxka09TabGFu7fezrk
	 owZn8KeCkNrr3Sj4wMpZYZTWcWU4Qc03Hm+8CcXVzkANcdwpG0hiu4jHfnoHbbEtPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D1zPn5wB8IrSNyvbO5kK2H7CLUESwRzh+Uw3eTs+B2E=;
	b=enwlEIvPSERYAs9Abjx6LX0KX7LAATSIYmUrxhhIX5YFpkdVc+uWQTCOI8bGrRvszqvz
	 MmU+J8apGs6s3rHaGxNUuC3L1DduYE9vogVnAv8wLY5FwJupadVfCkRZxrFsV4bNbwt0b
	 nTxd33Ovz5ZjPLbQ2SftLGbcvFFkkFkUGL8nNvhtVuqXM2EYtbek+ZrfYd4F82cts0lcA
	 MCpMZzVqULYNhsQlhJYvsuQ+Au1Kj1luvO8+7gPHygmT+MbLzgyT8tkMuZkbt4NjzK7ry
	 jyRPQU5mEz5MdJzUWEROYHoaLOjrpY0W6YEIHfAIf2ubPOEu2ElOXpHx9Du6Q2Z4Vpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlWTQVoq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3119606A335;
	Wed, 18 Nov 2026 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlWTQVoq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A671F000C4;
	Wed, 18 Nov 2026 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019343;
	bh=D1zPn5wB8IrSNyvbO5kK2H7CLUESwRzh+Uw3eTs+B2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlWTQVoq3+ETp/I8V++ARMKJAVgB2bWUae6HdtNH3fPJ6oOdesdXha8i9kNDZ+Ahr
	 SG2kxU3eiYa5qLVMBNGM6q0UICZB5EmFj4U8mTAnQa9MiZv9xgXAgxWxfvKHyPuYJQ
	 JCfs4lSagMw7uj5tjiQxPw/wrPds0Q5I0WDCwZ9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1561/2651] wifi: mac80211: fix mbssid/rnr allocation in beacon data
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118150344.151776842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bfdfc018a185d..7cbd3a3c2ebdf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1477,6 +1477,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
 	int size, err;
+	u8 *pos;
 	u64 _changed = BSS_CHANGED_BEACON;
 	struct ieee80211_bss_conf *link_conf = link->conf;
 
@@ -1504,20 +1505,16 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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
@@ -1529,26 +1526,38 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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



