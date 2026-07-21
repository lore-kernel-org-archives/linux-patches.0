Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BD946C4AC;
	Tue, 21 Jul 2026 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655283; cv=none; b=PPuhbUrYKuFs92Ad6ayGYP+oMHvQ942qoVAraDEHOfotiy7rCihWI5T44VeB3Wsnbh2T+FdS+I1OnAtE8+Ue4ql8+FxjFaCWyPu+F4ooQfptOcOeFWmqZ4kNyrwKiKqdPHN+fkTmoTEevVr8sjm0VdxnDVCTCznZkLeJu2ROltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655283; c=relaxed/simple;
	bh=MwvDJIhI9sJ0pcgAdidY5CDHzB57uNgS/S7VDeIE06o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtTLPeueOaclzDT6ES46tDzmFugPrrHmRJDuT5S6Og4dw4uEZtgBs0s6sdb5dcq72Iy++Z6GbIMsNa+W01OwIkTQ8Z+2bQE/GVPKmSa1xzGMXPQjXTDL+XkzGMMkQI+chIjdPrXRwj1I6j61l65sekICz6ydqgFuyt1S2r68jGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIkqtxLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIkqtxLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AB51F000E9;
	Tue, 21 Jul 2026 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655282;
	bh=EAUXa25PxcfE84qHGiTAAPVIVTW+zmU8DOBqi0p45eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIkqtxLOJBNnf4RzqYPqlm/pitp3M/a1aGzzP/kU2z5x0YZye+j4syE6T/ZaEq4Bb
	 6iK2jT+zg5WW1ZO/9/DzdRo0PRrJoUq9KhP7lcmiyVsh3p4lsoDi5BMFfkmjw4jpsf
	 J/ZVNNr1q5r7Zwiz7mDyPFbTiGdIDnWDP+cIIj7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.1 2023/2077] wifi: ieee80211: validate MLE common info length
Date: Tue, 21 Jul 2026 17:28:16 +0200
Message-ID: <20260721152640.414983753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 293baeae9b2434a3e432629d7720b5603db2d77e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ieee80211-eht.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -844,7 +844,7 @@ static inline bool ieee80211_mle_size_ok
 	const struct ieee80211_multi_link_elem *mle = (const void *)data;
 	u8 fixed = sizeof(*mle);
 	u8 common = 0;
-	bool check_common_len = false;
+	u8 common_len;
 	u16 control;
 
 	if (!data || len < fixed)
@@ -855,7 +855,6 @@ static inline bool ieee80211_mle_size_ok
 	switch (u16_get_bits(control, IEEE80211_ML_CONTROL_TYPE)) {
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
 		common += sizeof(struct ieee80211_mle_basic_common_info);
-		check_common_len = true;
 		if (control & IEEE80211_MLC_BASIC_PRES_LINK_ID)
 			common += 1;
 		if (control & IEEE80211_MLC_BASIC_PRES_BSS_PARAM_CH_CNT)
@@ -875,9 +874,9 @@ static inline bool ieee80211_mle_size_ok
 		common += sizeof(struct ieee80211_mle_preq_common_info);
 		if (control & IEEE80211_MLC_PREQ_PRES_MLD_ID)
 			common += 1;
-		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_RECONF:
+		common += 1;
 		if (control & IEEE80211_MLC_RECONF_PRES_MLD_MAC_ADDR)
 			common += ETH_ALEN;
 		if (control & IEEE80211_MLC_RECONF_PRES_EML_CAPA)
@@ -889,7 +888,6 @@ static inline bool ieee80211_mle_size_ok
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_TDLS:
 		common += sizeof(struct ieee80211_mle_tdls_common_info);
-		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
 		common = ETH_ALEN + 1;
@@ -902,11 +900,9 @@ static inline bool ieee80211_mle_size_ok
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


