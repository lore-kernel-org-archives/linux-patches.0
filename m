Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D519F43A;
	Thu,  3 Jul 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554252; cv=none; b=uoxr6MXVXvKhNGlBmvRyG6SLmQ/FwNq67Lbc/NXqWb6Yy6BE3VCSQJ4kr3j1bZ28Y3YlTaqRfWfbizEkFMbvD1XNv2WZJON0BUhq9lciDrNltKdMFLilVeSB6iTUOiGjCS758G2n2h9m60crDfpeSSpXHROdhgmgAlIJZIfhakw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554252; c=relaxed/simple;
	bh=6BIweqKezPx4x7XgeEqJfwbWt0x2XFtYFBX17rl09QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqbIvGqxlbMvGIkeFkNpDDrqIv+1WQyKE6vIB1TXLlDUmq48s3/PxY/Rq0JolcQYKk94Wh8tuHbIk5llG8OQ2BtLud77QOCbGlzfHscjTr4+QQyYgV7BstAWGS9qIVx7qKLLoFOd40Eb8jWmOgM0acP7P3erxwLEaR2vNNEpLoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZzClF3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZzClF3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAEFC4CEE3;
	Thu,  3 Jul 2025 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554252;
	bh=6BIweqKezPx4x7XgeEqJfwbWt0x2XFtYFBX17rl09QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZzClF3Ku5mgnF9SqrUvGvUtryzptfDOuWtj++Ex2gwVTYptB80wQv6fHzvdbmPmA
	 rz4I3LD2wBTtx0Lk9M2C3XPREIpH3p4wAZ9gKjNbPsPejSQZqj0e1BtzWAa5jr2yNm
	 mfqaUIi9Ak1TK/OWFjAsGrl1AfEzCWCheNAuiEEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/218] wifi: mac80211: Add link iteration macro for link data
Date: Thu,  3 Jul 2025 16:40:47 +0200
Message-ID: <20250703143959.895753859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Muna Sinada <muna.sinada@oss.qualcomm.com>

[ Upstream commit f61c7b3d442bef91dd432d468d08f72eadcc3209 ]

Currently before iterating through valid links we are utilizing
open-coding when checking if vif valid_links is a non-zero value.

Add new macro, for_each_link_data(), which iterates through link_id
and checks if it is set on vif valid_links. If it is a valid link then
access link data for that link id.

Signed-off-by: Muna Sinada <muna.sinada@oss.qualcomm.com>
Link: https://patch.msgid.link/20250325213125.1509362-2-muna.sinada@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d87c3ca0f8f1 ("wifi: mac80211: finish link init before RCU publish")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bfe0514efca37..41e69e066b386 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1209,6 +1209,15 @@ struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 	if ((_link = wiphy_dereference((local)->hw.wiphy,		\
 				       ___sdata->link[___link_id])))
 
+#define for_each_link_data(sdata, __link)					\
+	struct ieee80211_sub_if_data *__sdata = sdata;				\
+	for (int __link_id = 0;							\
+	     __link_id < ARRAY_SIZE((__sdata)->link); __link_id++)		\
+		if ((!(__sdata)->vif.valid_links ||				\
+		     (__sdata)->vif.valid_links & BIT(__link_id)) &&		\
+		    ((__link) = sdata_dereference((__sdata)->link[__link_id],	\
+						  (__sdata))))
+
 static inline int
 ieee80211_get_mbssid_beacon_len(struct cfg80211_mbssid_elems *elems,
 				struct cfg80211_rnr_elems *rnr_elems,
-- 
2.39.5



