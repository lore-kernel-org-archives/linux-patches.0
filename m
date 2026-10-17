Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147A6384CED;
	Sat, 17 Oct 2026 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254359; cv=none; b=SwSY59dFhhthHrDiwsDN1JKozbC30dbby5rrf972adQufw2Z3C/gPxPFUuN7FZkbWshslZkiCTEvdJMoUXYH1yY32HL7TWbl862RZTydOIJmPPp38x0amL9JkOg1Om44HFVKm/fTQIl/kUZyj9z4wmp9oaruLKlGbuGVP77wJTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254359; c=relaxed/simple;
	bh=0iCsCSdb9EWzkQwlTeMygUDE7cx4JwSSlhnZW75qwdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h36ccr29EZ45pO3UEseq7SU5OP7fr//LmoO0DvrrzMWkUd5Zp3WEwk0NgANyeoF5PwkDVLGwfFzpjOGXVy8ZNSAXohxQvYGrZlrKmC/bzW9lIMaSHRYn+4WKB1u2HwidYFfnqcuyO+3v0Jx2E4q0eop88rAO6DsYohjZ6Knp03M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L39vkkqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L39vkkqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A331F000C4;
	Sat, 17 Oct 2026 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254358;
	bh=yYgKwwA5dbHrRMTCZJnGFa9BuLlBaXCffUpPGSonanY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L39vkkqjSb8vyc3Ab5Fz39MikCYZe2Y0GT9D79fM6c73nob6h2HL48wJqlYBrHLKa
	 QIUlXslW6Jgf1mBj3BbC4q17kqLQBQSNzRzWoFfBmxILlSpwYnCMpzdjARBQMNa3sA
	 bFUbZjNQh52etVAHoXAUselSd8z0rdtkoYLOdAAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/869] wifi: ieee80211: validate MLE common info length
Date: Sat, 17 Oct 2026 17:54:19 +0200
Message-ID: <20261017160047.852225321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 293baeae9b2434a3e432629d7720b5603db2d77e ]

ieee80211_mle_common_size() uses the first common-info octet as the
common information length for all known MLE types. However,
ieee80211_mle_size_ok() only validates that octet for Basic, Probe
Request, and TDLS MLEs.

Reconfiguration MLEs also skipped the length octet when calculating the
minimum common size, and Priority Access MLEs skipped validation of the
advertised common information length.

Account for the Reconfiguration common-info length octet and validate
the advertised common information length for all known MLE types. Keep
unknown-type handling unchanged.

Fixes: 0f48b8b88aa9 ("wifi: ieee80211: add definitions for multi-link element")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260611173506.36838-2-enderaoelyther@gmail.com
[remove now misleading comment]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 85bf3ac6db570..59e7c0a81cee7 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -5348,7 +5348,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	const struct ieee80211_multi_link_elem *mle = (const void *)data;
 	u8 fixed = sizeof(*mle);
 	u8 common = 0;
-	bool check_common_len = false;
+	u8 common_len;
 	u16 control;
 
 	if (!data || len < fixed)
@@ -5359,7 +5359,6 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	switch (u16_get_bits(control, IEEE80211_ML_CONTROL_TYPE)) {
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
 		common += sizeof(struct ieee80211_mle_basic_common_info);
-		check_common_len = true;
 		if (control & IEEE80211_MLC_BASIC_PRES_LINK_ID)
 			common += 1;
 		if (control & IEEE80211_MLC_BASIC_PRES_BSS_PARAM_CH_CNT)
@@ -5377,15 +5376,14 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 		common += sizeof(struct ieee80211_mle_preq_common_info);
 		if (control & IEEE80211_MLC_PREQ_PRES_MLD_ID)
 			common += 1;
-		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_RECONF:
+		common += 1;
 		if (control & IEEE80211_MLC_RECONF_PRES_MLD_MAC_ADDR)
 			common += ETH_ALEN;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_TDLS:
 		common += sizeof(struct ieee80211_mle_tdls_common_info);
-		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
 		common = ETH_ALEN + 1;
@@ -5398,11 +5396,9 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	if (len < fixed + common)
 		return false;
 
-	if (!check_common_len)
-		return true;
+	common_len = mle->variable[0];
 
-	/* if present, common length is the first octet there */
-	return mle->variable[0] >= common;
+	return common_len >= common && common_len <= len - fixed;
 }
 
 /**
-- 
2.53.0



