Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5AD13FD86;
	Wed, 19 Feb 2025 09:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956237; cv=none; b=NoftqVFjfztdzC9J+8SW/3PGiXtQycT7bFAfc6rR9wgVsfowum4akIZyULWYT5RvRs9ccf9Be+FmrDaG6FvsBIOrZxRfa2W61WUsMmDqdNJXfy8uiJIwSoGckKrVJ3dGfDBb4s7Zj/TGutl9zMd+n0UqGS39bFlZs8kbw7tJJSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956237; c=relaxed/simple;
	bh=jvRTYeLlUCosTMUpyf31btvwNiZRS5+m4ffiZIrrexg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtuEPruB6ow8BPsZ81ZC/wyY0S1Z3D6Pm00j/JKEb7DrR/bj5nYfe2hgdGhHmi3P2Wj3JFpfAXbhK/n+vo7jV4qI3nsK1gHxT5U9f3/Eq72UvhEX3HkYN4kxpDjtPA+f8HkbPsyvrOy8SjB4dZht8uUFd09a4v9y0ClIDou7PiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBFHpDhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBFHpDhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AAFC4CED1;
	Wed, 19 Feb 2025 09:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956237;
	bh=jvRTYeLlUCosTMUpyf31btvwNiZRS5+m4ffiZIrrexg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBFHpDhFw9EOASON9XZFwztr/d+vHubiqOgAkZp4Uv30TKV1RF9WtjT0tVR/WKIsS
	 JY77kSgOKOQp9yKpvB92DsRDUh1ptiptuo/EjZgz4s6eqMpaItwTUEwSZSimtrhz/S
	 qjxomlNOz9huRHJB3TPpVx7Kv37H8yuQhDmT+Jq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/578] wifi: mac80211: Fix common size calculation for ML element
Date: Wed, 19 Feb 2025 09:21:24 +0100
Message-ID: <20250219082656.106541932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 160230bb1a9ce..8e00918b15b49 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4571,28 +4571,24 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
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
@@ -4645,8 +4641,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, u8 len)
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



