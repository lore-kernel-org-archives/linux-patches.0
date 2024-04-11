Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD641F5FA;
	Thu, 11 Apr 2024 10:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830140; cv=none; b=SE6cq6vGGXgae17cmYOhaVX8F9sG5lsEYWAMb4h3wEdX1FtcIv/bHfECk+y9ieGsZx1zK1GcUc6kqz0V8312n4Hhdm2Wk5EJ0hg58zU0pboO/6bVCRFsdmCvDR5wc01GoSmrzI8wDL/lwbrCCg2qDjPI6buZmqCZu7erqJA66VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830140; c=relaxed/simple;
	bh=TZAbMvpeIk+5DPea3GwoTmfqojOP/aWh5oRdf7R91G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXnb+5HNWFzRIqCvq3WL4HlsMcGCLdoJ9Mmr1IB7aqEBEwDS+lZC/OZKWOSqFO3/tQx0m9BVKpHJmv8nnGSKUEO9+uVqvIfwo4xITJJGh/KQ5UovpPSFGBQ+Hu6ELE0Z247puIi2bYdNY7nAo1hwUlA8m2jcK3DZCuzw/tC+t3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/5QBrRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/5QBrRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD97C433F1;
	Thu, 11 Apr 2024 10:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830140;
	bh=TZAbMvpeIk+5DPea3GwoTmfqojOP/aWh5oRdf7R91G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/5QBrRbjhQv7uQ3NjXoj0xT94WMXkzhzTMG4CVoFBeBOVGPptjDzso265TXFtDL8
	 1iQGEKE7Byv4i+QOJNgroMspSRKPl02Eq7Zj19wVE60cPUsdvV8PToa+sK8uHnjMt8
	 Mr6azHNKhkIhnFM/PPNe0P61mMQhidlJTUUUu4M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d050d437fe47d479d210@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/143] wifi: cfg80211: check A-MSDU format more carefully
Date: Thu, 11 Apr 2024 11:55:15 +0200
Message-ID: <20240411095422.333183925@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9ad7974856926129f190ffbe3beea78460b3b7cc ]

If it looks like there's another subframe in the A-MSDU
but the header isn't fully there, we can end up reading
data out of bounds, only to discard later. Make this a
bit more careful and check if the subframe header can
even be present.

Reported-by: syzbot+d050d437fe47d479d210@syzkaller.appspotmail.com
Link: https://msgid.link/20240226203405.a731e2c95e38.I82ce7d8c0cc8970ce29d0a39fdc07f1ffc425be4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index d1ce3bee27973..b9d15f369378b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -791,15 +791,19 @@ ieee80211_amsdu_subframe_length(void *field, u8 mesh_flags, u8 hdr_type)
 
 bool ieee80211_is_valid_amsdu(struct sk_buff *skb, u8 mesh_hdr)
 {
-	int offset = 0, remaining, subframe_len, padding;
+	int offset = 0, subframe_len, padding;
 
 	for (offset = 0; offset < skb->len; offset += subframe_len + padding) {
+		int remaining = skb->len - offset;
 		struct {
 		    __be16 len;
 		    u8 mesh_flags;
 		} hdr;
 		u16 len;
 
+		if (sizeof(hdr) > remaining)
+			return false;
+
 		if (skb_copy_bits(skb, offset + 2 * ETH_ALEN, &hdr, sizeof(hdr)) < 0)
 			return false;
 
@@ -807,7 +811,6 @@ bool ieee80211_is_valid_amsdu(struct sk_buff *skb, u8 mesh_hdr)
 						      mesh_hdr);
 		subframe_len = sizeof(struct ethhdr) + len;
 		padding = (4 - subframe_len) & 0x3;
-		remaining = skb->len - offset;
 
 		if (subframe_len > remaining)
 			return false;
@@ -825,7 +828,7 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 {
 	unsigned int hlen = ALIGN(extra_headroom, 4);
 	struct sk_buff *frame = NULL;
-	int offset = 0, remaining;
+	int offset = 0;
 	struct {
 		struct ethhdr eth;
 		uint8_t flags;
@@ -839,10 +842,14 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		copy_len = sizeof(hdr);
 
 	while (!last) {
+		int remaining = skb->len - offset;
 		unsigned int subframe_len;
 		int len, mesh_len = 0;
 		u8 padding;
 
+		if (copy_len > remaining)
+			goto purge;
+
 		skb_copy_bits(skb, offset, &hdr, copy_len);
 		if (iftype == NL80211_IFTYPE_MESH_POINT)
 			mesh_len = __ieee80211_get_mesh_hdrlen(hdr.flags);
@@ -852,7 +859,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		padding = (4 - subframe_len) & 0x3;
 
 		/* the last MSDU has no padding */
-		remaining = skb->len - offset;
 		if (subframe_len > remaining)
 			goto purge;
 		/* mitigate A-MSDU aggregation injection attacks */
-- 
2.43.0



