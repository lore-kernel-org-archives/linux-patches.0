Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7AF3D3002;
	Wed, 30 Sep 2026 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795968; cv=none; b=JzFdm6iJwdkdV8VT277FqH99+wyefxjpfAfXBFVq2gBFGoKnzHbyUHVXiAf//s134TnkHbNMaJ24Q/5RRetcQCQD8fZ4lG1P+gDslsMv2EDUWYPyiPzd4MadaGpdl49JRe0zb9X9twlzm7ybblLK1O8GiC+ZKlYIVzALOR+8EP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795968; c=relaxed/simple;
	bh=ysbeOOeOfepOz5SVaC6baC5hvyCA36G/CQNBAVQfMFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVHT8fuUo12pC2u2pCp91q+IenMU8lnZj7SVuDTzal4p33hAKAYbTLTWdGrJreJXSX5cR9vEjrEGH3MbW0SXhvX56udRLkki+wiTlfBBgTr+CxBfe1+8CVyghIZrni2tUrgDdPW7gD6rmhDlS0AGSmWDEw1MxAKz+ZmL88aJRxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCyYyZD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCyYyZD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3421F00898;
	Wed, 30 Sep 2026 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795967;
	bh=3/Vs0CrzhnDRDBjpbLtsGo3Hmx44OgFgrTxNDvQriOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCyYyZD82t717ZueiDD43DWMQS8mSuc3TY7rEcOCe7a86ynkoqDnP0ftwrrd+1APp
	 uWBdfsKmeJRDAehdKZM3Y9fl22ANml+xQHTZdG2XZMCCKKitFT3rdKXw8A+OGYM0Tz
	 HWbJB4IEInqJwrh4xAGoJmI1/2ME1sj2Q0/TSjyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+878ddc3962f792e9af59@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0746/1193] wifi: cfg80211: check IP header size in cfg80211_classify8021d()
Date: Wed, 30 Sep 2026 17:23:50 +0200
Message-ID: <20260930152450.824965716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 48b2c5c628b09cf36cbeca53e0432fc2a7518be7 ]

A frame that looks like IP can be transmitted, but be too short, so
the DS field is read incorrectly:

  BUG: KMSAN: uninit-value in cfg80211_classify8021d+0x99d/0x12b0 net/wireless/util.c:1027
   cfg80211_classify8021d+0x99d/0x12b0 net/wireless/util.c:1027
   ieee80211_select_queue+0x37a/0x9e0 net/mac80211/wme.c:180
   __ieee80211_subif_start_xmit+0x60f/0x1d90 net/mac80211/tx.c:4304
   ieee80211_subif_start_xmit+0xa8/0x6d0 net/mac80211/tx.c:4538
   ...
   packet_sendmsg+0x9173/0xa2a0 net/packet/af_packet.c:3108

Use skb_header_pointer() like the MPLS case.

Assisted-by: LLM
Fixes: e31a16d6f64e ("wireless: move some utility functions from mac80211 to cfg80211")
Reported-by: syzbot+878ddc3962f792e9af59@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=878ddc3962f792e9af59
Link: https://patch.msgid.link/20260904165614.5e61a4c80b92.I37d68d3f406cb3b90b32e6943418d66070b65197@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 640ec502e82d2..40788274d4a77 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -995,12 +995,30 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 	}
 
 	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
+	case htons(ETH_P_IP): {
+		const struct iphdr *iph;
+		struct iphdr _iph;
+
+		iph = skb_header_pointer(skb, sizeof(struct ethhdr),
+					 sizeof(*iph), &_iph);
+		if (!iph)
+			return 0;
+
+		dscp = ipv4_get_dsfield(iph) & 0xfc;
 		break;
-	case htons(ETH_P_IPV6):
-		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) & 0xfc;
+	}
+	case htons(ETH_P_IPV6): {
+		const struct ipv6hdr *ip6h;
+		struct ipv6hdr _ip6h;
+
+		ip6h = skb_header_pointer(skb, sizeof(struct ethhdr),
+					  sizeof(*ip6h), &_ip6h);
+		if (!ip6h)
+			return 0;
+
+		dscp = ipv6_get_dsfield(ip6h) & 0xfc;
 		break;
+	}
 	case htons(ETH_P_MPLS_UC):
 	case htons(ETH_P_MPLS_MC): {
 		struct mpls_label mpls_tmp, *mpls;
-- 
2.53.0



