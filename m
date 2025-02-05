Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EAF15198D;
	Wed,  5 Feb 2025 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764857; cv=none; b=A6wcgfio2zKjL3phD7uVNJpVKl9tKXzlam8eEyQUGK9fdlpX6OeS98T6BPcbRHeIzPbwiEN4KmE4/Q0TkcLqvrpT0GFOz9zt0UW1+cunqkOJwZkbALQ9ueSYbJitxhL0Yos+XOQ1RCz+9yvZHi3xdaxN625FjRwpqHvkI1mmfYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764857; c=relaxed/simple;
	bh=pPbBeooxBQTyq+LzszIWA/qEvmTUOd35VwCFxbM9Ry0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNv+6MEalhW41Fd6AZLQZ4pGeUXDtehDMAeAl1RC1rBPqtJYJ/7XPcZj5lWffdz1TC/+R/Xfl5KRdB71J6nl1pRjfE3GpXMlypocqrvNfsIPavt5at6BxWzc5hZqMcokzIcN/uGNwQZqGdVfJ6k4JAp9sSRogGln1K5Ej9Rhyho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1VtKg5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1VtKg5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BCBC4CED1;
	Wed,  5 Feb 2025 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764857;
	bh=pPbBeooxBQTyq+LzszIWA/qEvmTUOd35VwCFxbM9Ry0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1VtKg5LyfgdFtsWFBtyPsDTBsAwvZOKrmu+l18zonVJoYB5C7ozlNE2C1cDz7bx0
	 HboXkRLDx+AzBDGIAcnQyILs9RmtpBFidhfgGAJbmQEi+xexGX+SqiHtSunLTWhAbO
	 UoWvyq3f0FZ70SULqxRmQ+F+f1J8KWL2pyMiw+b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/590] wifi: mac80211: Fix common size calculation for ML element
Date: Wed,  5 Feb 2025 14:38:39 +0100
Message-ID: <20250205134501.556782634@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 19aa842dcbb5860509b7e1b7745dbae0b791f6c4 ]

When the ML type is EPCS the control bitmap is reserved, the length
is always 7 and is captured by the 1st octet after the control.

Fixes: 0f48b8b88aa9 ("wifi: ieee80211: add definitions for multi-link element")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250102161730.5790376754a7.I381208cbb72b1be2a88239509294099e9337e254@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 456bca45ff052..3750e56bfcbb3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -5053,28 +5053,24 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 {
 	const struct ieee80211_multi_link_elem *mle = (const void *)data;
 	u16 control = le16_to_cpu(mle->control);
-	u8 common = 0;
 
 	switch (u16_get_bits(control, IEEE80211_ML_CONTROL_TYPE)) {
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
 	case IEEE80211_ML_CONTROL_TYPE_PREQ:
 	case IEEE80211_ML_CONTROL_TYPE_TDLS:
 	case IEEE80211_ML_CONTROL_TYPE_RECONF:
+	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
 		/*
 		 * The length is the first octet pointed by mle->variable so no
 		 * need to add anything
 		 */
 		break;
-	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
-		if (control & IEEE80211_MLC_PRIO_ACCESS_PRES_AP_MLD_MAC_ADDR)
-			common += ETH_ALEN;
-		return common;
 	default:
 		WARN_ON(1);
 		return 0;
 	}
 
-	return sizeof(*mle) + common + mle->variable[0];
+	return sizeof(*mle) + mle->variable[0];
 }
 
 /**
@@ -5312,8 +5308,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
-		if (control & IEEE80211_MLC_PRIO_ACCESS_PRES_AP_MLD_MAC_ADDR)
-			common += ETH_ALEN;
+		common = ETH_ALEN + 1;
 		break;
 	default:
 		/* we don't know this type */
-- 
2.39.5



