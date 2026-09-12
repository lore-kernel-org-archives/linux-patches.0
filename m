Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25638F649;
	Sat, 12 Sep 2026 19:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242914; cv=none; b=aZKWVLoIWGJHtBZehd14qu9uZnlck7ncvIRH+nj4CABinYFj7n2N4GYc4/k1ID1fJWV0radrSwuApAe07hVl7ul5qmDqDIkKBosUgaV3GUzwO845t1XMaci1rYbJScnFUM2YfmjNHFL88lWEhi9CcHayxCoe3ov90xwOabAWSBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242914; c=relaxed/simple;
	bh=Vcb4vbYiHb6lHy4rYNMwJj1BtIFJ9vx+GhdQrkRc+Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1mngd9Ajk6wtROubJiDWqvp6u00yNvBi/7fLNZhZA6PRdBYLaf79aWUEC+HmNfRjUN4AGhSsl+VJDBq+/fRl8CuJdY8N86WeABJaL3/lQuAi2Ag5S4VQuqAzJryHxeVd8h50TUwJ3sCUgVUVwWSm/m2QvUnQS8XJdxXMoeUvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IFsufi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IFsufi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76FB1F000FF;
	Sat, 12 Sep 2026 19:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242913;
	bh=AAifw+xmmdUjQbBw9Dza2cBb72jPqEKfQbhsPVUZ4xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IFsufi1lHEqYBvoBxnv4ToKyKO6ilNxWvLRfNvUTiuCpo2KC87XivDItAqe2wdDI
	 oMJr7iQAelIiCKV+s6WFW4M55toy/tI7H1gpZBWV+WHnoxpByckMMa9xG+bkXGTgxQ
	 evVyQQLBKHs98H/+ID5D00Wfg1dsdWFZ45KbHpLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Borgers <borgers@mi.fu-berlin.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 572/798] mac80211: add ieee80211_is_tx_data helper function
Date: Sat, 12 Sep 2026 09:03:20 +0200
Message-ID: <20260912065530.238569913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Borgers <borgers@mi.fu-berlin.de>

[ Upstream commit cff7b5ca25353bef5909e357a9912f3d44b32af5 ]

Add a helper function that checks if a frame is a data frame. Frames
with hardware encapsulation enabled are data frames.

Signed-off-by: Philipp Borgers <borgers@mi.fu-berlin.de>
Link: https://lore.kernel.org/r/20210519122019.92359-2-borgers@mi.fu-berlin.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: fd2bf5e71810 ("wifi: mac80211: skip unused probe response countdown offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 70ee982f08d9d..52cf4f770ab60 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6709,4 +6709,22 @@ struct sk_buff *ieee80211_get_fils_discovery_tmpl(struct ieee80211_hw *hw,
 struct sk_buff *
 ieee80211_get_unsol_bcast_probe_resp_tmpl(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif);
+
+/**
+ * ieee80211_is_tx_data - check if frame is a data frame
+ *
+ * The function is used to check if a frame is a data frame. Frames with
+ * hardware encapsulation enabled are data frames.
+ *
+ * @skb: the frame to be transmitted.
+ */
+static inline bool ieee80211_is_tx_data(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *) skb->data;
+
+	return info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP ||
+	       ieee80211_is_data(hdr->frame_control);
+}
+
 #endif /* MAC80211_H */
-- 
2.53.0



