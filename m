Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041242;
	b=N5R10ATS5vbYrPhV3o9U67wxjUHc0fqWpgtUsTQbP/HJUMu7VhM94/Wu2/PdpE1IHb9S
	 HiqoFXRFJEN3zRNeXKDS0AZ9rt/k7lEONaIPUqYl8LNTO7PKX5j7MxNktjDuDOLUYaRBJ
	 RUhJ6FpyglI1OhnkEmBi86NwGvlHYy+75jS9lvKPKJDOAcfvkZOH7R6HSJHQ136A5lnzW
	 T1qNOpdFrVeGQwnpbXtRpGK7wIedypRbNx1ed2SSuS/CaxVkanIAdprRNOkvEXPucQXEv
	 QVlqhdF+2IZS6RC8mS1JwsyIJnd8Uoe0fY3yBRAekCw8yBqfTG0zmSLosZeoqFFk8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+PaVYxGaDs1BY2c9x97Do5heFdPdxyYA3E5fBeTzO0w=;
	b=s6tbhhlU0CbGdbcMGe8zSkFy/wacYDeRfLqYweUKakn2tXJtvkWfhrioM4f659B7vUdv
	 2gHH2kIs367lWiB/3SmSj0+06FPwh/JGxBFqoxflPdn3SOmXJXl6e1rYDaC+wQj6i86N6
	 AUe500zMOTmInkU8HMlwb7Xcsnd3QR0MebzoAGHvn03gfeDVbTVg6j0KDDqtMUYCJ5D3k
	 OSeTsttP9fNKIk4Yi9R88PGVTkFA17B7Hfa7uhTvopbhgrNGM+LTsmm6hSYuiW6Tqaiki
	 itTeCNnoaU/B0U3OxZMssD5gGxD0afL/LjO/8TCgKGZn4990ueXARWgxeCFImtaDAoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFBrQFU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C124606A320;
	Wed, 18 Nov 2026 22:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFBrQFU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623C61F000C4;
	Wed, 18 Nov 2026 22:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041241;
	bh=+PaVYxGaDs1BY2c9x97Do5heFdPdxyYA3E5fBeTzO0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFBrQFU6ttG6rDtujr1+ZS/5N2INpcKwz1fQ4caEgpyA3cXzLvrm1UEXbgb44Obvv
	 FWfYz3lRQvJYv87DBGDmCebs1L8JkrGp9C/Y9lgHS24gESKn5emmHSech1DZvSi5jg
	 rz3es8KmrCnFdCcBI8f4nfEiyTZurLUTGI15hzhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2716/3318] wifi: mac80211: fix mbssid/rnr allocation in beacon data
Date: Wed, 18 Nov 2026 15:55:38 +0100
Message-ID: <20261118150442.344125536@linuxfoundation.org>
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
index a6f53af5a8f09..ae477600b9f53 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1127,6 +1127,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
 	int size, err;
+	u8 *pos;
 	u64 _changed = BSS_CHANGED_BEACON;
 	struct ieee80211_bss_conf *link_conf = link->conf;
 
@@ -1154,20 +1155,16 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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
@@ -1179,26 +1176,38 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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
 		link_conf->bssid_indicator =
 			ilog2(__roundup_pow_of_two(mbssid->cnt + 1));
-- 
2.53.0



