Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F621714B7;
	Tue,  8 Jul 2025 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992373; cv=none; b=L/6b5sAFg3WYlIEp2zDqnpviBwv2S8IMW775oUTgvWGLkOBOzXDZlhRHud55h2LYUEXh5U4hKFFdKd/5EgTFKVPziaZJS9aa0QasIMc+S6RQnvvUsdeJ4bQ5S2hQZtDhYuH6ndy4hb+vmjSSL70D07xEdQTedS/5Js39WMOJoVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992373; c=relaxed/simple;
	bh=K4xboaidBIw/7YghyETmqYFJkaPA77dxSvUFC4yK+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBgvWCBxwYh4BT0Vj0i3uDlTeYsprRZjOCnynWr1IrhlpoBeQawDWJk0hIgPUpFwU0B7ZA5NpnMnH1Ot33D4nBg/Zpp/Zy6yHSn48NMdL1DmHfG3MKeL10acOdIBiunDxHsRQA6rA06DeJ0IDUQPjq/bpP2rNNZ/mU8H0F7I/fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJX3XQiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJX3XQiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37E5C4CEF0;
	Tue,  8 Jul 2025 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992373;
	bh=K4xboaidBIw/7YghyETmqYFJkaPA77dxSvUFC4yK+VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJX3XQiUix6FJf1D/WLOPb4jcnoFrtnEk+8IjBELzlqIj0Fsg8uiuX1J2GwsDjz2c
	 kE6gqYOSEhaCHbDQ7JNjb2HO6JT9AVio72lAc4/QtEO949tu0lYw2fLSBcJ+YeyvkT
	 d8ilXcmPbtAYx4DpJwSwt0UNEyMXVSG7hIGW0zsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/132] wifi: mac80211: Add link iteration macro for link data
Date: Tue,  8 Jul 2025 18:23:00 +0200
Message-ID: <20250708162232.668470907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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
index 04c876d78d3bf..44aad3394084b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1186,6 +1186,15 @@ ieee80211_vif_get_shift(struct ieee80211_vif *vif)
 	return shift;
 }
 
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



