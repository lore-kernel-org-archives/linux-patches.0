Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6A83B8BBB;
	Sat, 17 Oct 2026 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259128; cv=none; b=b5+s5f/D+gXCm11OJe9u3z40m+6b1m2i9F4VnExx4+l4oPst4AzwhjPV+ixMKs7HVcRcHK0+VqjZQPDtZ7m+8Ezul8BVrcLkk2Shwx7NCtKnQrEp/bQfu6E1KBTnKcbxMjNlQJIVKAfmBK34piz/tmit4qt7jMjsimRtolsydjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259128; c=relaxed/simple;
	bh=GlAFg73bfsBgoVQ2gSjKceJVXELxOmYlyy1X84Enw2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5rTe5BUEF2Hp41j+onDTIo6j/T/bSYE8di7mE5sFT94stpRbH6jjpuR6MnKxgbx7smd+SoROdTg32MlEufq3zymbSb4ixOxftu+TCFsgSgnMDVxpA+13tCvONO7aMt0MSO9ubUphNuGidLnuvj617vQrd8cGHxmfPMQvMzMwtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dONa4b78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dONa4b78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAED1F000C4;
	Sat, 17 Oct 2026 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259127;
	bh=K4nViVMEt/+j1qpS3GSFYMK60moZecmm37GqFs1e++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dONa4b78VgMxwt0jvn0TrcCQRI6uLFEXOuJc6q7Lk3lKoTkqFFvzRzbyxh85tGUYn
	 +Y01CtKtfEycFOOgLpBb838B0Tpw5+qOp5EFfy12dEh02xSplEPYutZAX9U39Zg3Kw
	 arDnETeh663b1hTD9zOv7IpcDolXwT/0BIte8sZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1112/1674] wifi: ieee80211: validate MLE common info length
Date: Sat, 17 Oct 2026 17:56:24 +0200
Message-ID: <20261017160459.669892210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 38e3e81b880fb..8b73e37c604d9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4945,7 +4945,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	const struct ieee80211_multi_link_elem *mle = (const void *)data;
 	u8 fixed = sizeof(*mle);
 	u8 common = 0;
-	bool check_common_len = false;
+	u8 common_len;
 	u16 control;
 
 	if (!data || len < fixed)
@@ -4956,7 +4956,6 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 	switch (u16_get_bits(control, IEEE80211_ML_CONTROL_TYPE)) {
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
 		common += sizeof(struct ieee80211_mle_basic_common_info);
-		check_common_len = true;
 		if (control & IEEE80211_MLC_BASIC_PRES_LINK_ID)
 			common += 1;
 		if (control & IEEE80211_MLC_BASIC_PRES_BSS_PARAM_CH_CNT)
@@ -4974,15 +4973,14 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
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
@@ -4995,11 +4993,9 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
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



