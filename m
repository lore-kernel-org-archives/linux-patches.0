Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC9E1422CE;
	Thu, 11 Apr 2024 10:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831184; cv=none; b=VcEkAPI4EW0TodSZoIfu46QP9J24zafDQl1ivy0E1tHQzqBiOKKYE9+9w/f3MFbWkZFZzeW2BSXUGAHF7A3f7NgpN9l3sQuxuloymmw79yGcADoFxR/MKA2r4VPkCIwhwpQQB09OVZ4P4Ux6a6vl57H4nXv8Tt+IV0srm1qvgPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831184; c=relaxed/simple;
	bh=Zp8YSe+BksDnNrruqtcsayb/NeZJ9V66oiRTt4rs8zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5XVM18VlzSeH2Za4WRGZ8H/9zVzULLWmXZJXCuNZXfp6lFnAB7NoPQQDA1yorGq38DQh7KwET3mFFC0Z0jIpfrNRC7385bJbGtLGsBmnZyXIyDGuLV3Fo+nEiXKljlyerSKpsSxyzXmcDDqGQeWqEf8gtNGlOgKitxshS4XrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVXn1q2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVXn1q2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F46EC433F1;
	Thu, 11 Apr 2024 10:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831184;
	bh=Zp8YSe+BksDnNrruqtcsayb/NeZJ9V66oiRTt4rs8zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVXn1q2VImcE4PCJHIDcA19Rg4ibT6v+CcEqEF+W8u5/TsPbSjXDhfz2FnQNiAVSB
	 UFmuxuAabH0VC+K1+q2cTDM+L6hHGuaTmM90UrqJaBJVQ8ygsAL1O4vB4Br0nHFCBq
	 B2y8dzybui98qd+3sK3uZfViGmInfMdwQpeX0VA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d050d437fe47d479d210@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/114] wifi: cfg80211: check A-MSDU format more carefully
Date: Thu, 11 Apr 2024 11:56:04 +0200
Message-ID: <20240411095418.001969415@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1783ab9d57a31..9aa7bdce20b26 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -797,15 +797,19 @@ ieee80211_amsdu_subframe_length(void *field, u8 mesh_flags, u8 hdr_type)
 
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
 
@@ -813,7 +817,6 @@ bool ieee80211_is_valid_amsdu(struct sk_buff *skb, u8 mesh_hdr)
 						      mesh_hdr);
 		subframe_len = sizeof(struct ethhdr) + len;
 		padding = (4 - subframe_len) & 0x3;
-		remaining = skb->len - offset;
 
 		if (subframe_len > remaining)
 			return false;
@@ -831,7 +834,7 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 {
 	unsigned int hlen = ALIGN(extra_headroom, 4);
 	struct sk_buff *frame = NULL;
-	int offset = 0, remaining;
+	int offset = 0;
 	struct {
 		struct ethhdr eth;
 		uint8_t flags;
@@ -845,10 +848,14 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
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
@@ -858,7 +865,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		padding = (4 - subframe_len) & 0x3;
 
 		/* the last MSDU has no padding */
-		remaining = skb->len - offset;
 		if (subframe_len > remaining)
 			goto purge;
 		/* mitigate A-MSDU aggregation injection attacks */
-- 
2.43.0



