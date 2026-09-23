Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89843391832;
	Wed, 23 Sep 2026 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174238; cv=none; b=BW0Lxbu+xFCTeozvVtmdXhxH+d6CWcaLkfUeCmcTJuoXTnOHriDzY4pHytQ1I+ER3+o+db7xXUC16SlHrX5Srtrv0hRyl7fPmEFKot2ZJKycwnS4P7/lftZ59+EQHlL2cCLKI0wCL/c9dFGDDDjY/bhOipsb5rFaCFZnuAe4PRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174238; c=relaxed/simple;
	bh=LH/QhVWeGIBDiRyV0f4HeonyCOjWaRtIpjlvTxftoOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6yY/J0H8rE2OLvyQqWTt21n1A8P7NM8/LeM/mOwZv4oalVHlgwshXE28KoaoSF3cpvjjUSe3mn4DtZaYQYPTK8vfCq4mb7odHl4Pw6onJcNxSV6IiWJ6KXNdF7U7pMyDoz9/wXcjkt/mSr7atYKIoaOzDziaQ/rCj/YjPcIF44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzjrMTnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzjrMTnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9793A1F00893;
	Wed, 23 Sep 2026 14:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174237;
	bh=6BZmSdwsXF9nWTfUkdjFw79E9WtdtzOXSVpkkiKJ3F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzjrMTnDYSto0fs/hRDpC67h+eLNKdoz/Q0I8wRXI55K2jbDyHbNroeeD8UHJ91oR
	 jTDVxDqMfjHMcKcxOBxAdoh8g7XGYIK2vPAGfThihGZF3e+rUvJtkj7UlV2QMeua7a
	 CkwNc5kTdLiK0A6ZDfLLSBRcubHleQ2Hz1yakgMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+878ddc3962f792e9af59@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/398] wifi: cfg80211: check IP header size in cfg80211_classify8021d()
Date: Wed, 23 Sep 2026 16:02:06 +0200
Message-ID: <20260923140644.768993776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3a60dfca77236..0254cd5f89f15 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -962,12 +962,30 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
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



