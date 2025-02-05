Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D82BF510;
	Wed,  5 Feb 2025 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764040; cv=none; b=J4f6OUwaM87jDXcHjlCh0nA93wYG6AUXvbF8Vrd0lL7d94hm3yZOu/i6s33OSJZCS7wZICm+VQtYj/dkvEaNyxEQvr1nIs6i1cdT8zLIhi8UCtNXvFg5qbF+HMaPiIO7w/OrSJTTvntwrNEgAn1VSYdfpw70fx+c7Go+BlUmQis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764040; c=relaxed/simple;
	bh=ZRWxGg3Uh36JnEFgOYM+WzubxLDiAd4H5LhZBxbgS4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odIHn+9WGPzJcS1mgL1X9D1HLT1VPyNmyvuBD9+smLgbw8NHH8rxK9XHUdan0hFjqM1AJxyxZ51Y0lpwM79Q/GxEHXWd5v68L5xEoxoiyRQnZk7pQSocdq3SmoSjQF3VAxi93w7daXBHOjRVkcdionKtB47ADgpY8DLr1npzZiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nijIgOpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nijIgOpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8197C4CED1;
	Wed,  5 Feb 2025 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764040;
	bh=ZRWxGg3Uh36JnEFgOYM+WzubxLDiAd4H5LhZBxbgS4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nijIgOpt49oh6lkABvUDUx//ekdrKkh2GIWU1Ms20ZTOKRVdBpVfG//QFnAgr92TM
	 Z8yCLknpLO8u8wrGdlFogHwbwAxK0rJbK/2W19o9SXmzsGC4tKI3j3m3stTA8llEoE
	 m8Mh8LefgGD3GqYHj81nS9XmbnUEIUm5qxXGuurc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/393] wifi: mac80211: Fix common size calculation for ML element
Date: Wed,  5 Feb 2025 14:40:30 +0100
Message-ID: <20250205134424.541663751@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f1e5a16d7b2c..0ff10007eb1a5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4826,28 +4826,24 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
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
@@ -4989,8 +4985,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
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



