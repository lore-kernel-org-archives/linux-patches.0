Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDE23BD64D;
	Fri,  9 Oct 2026 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556058; cv=none; b=iCOf5gPeQtGUhTaimopP06rQa9+qyYONeGJejeEZkQKjv3vH7GgfCdyJAgPIAMn82ySpuVdRRdehJ1T2D4TGreYgsSE9g6kvgyW919EaVbf5yAPgE3vqu5X2DV2F8khqAIz27t/VCDKxxVRErCgeOnVHR6sfJ6DFziniN318WgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556058; c=relaxed/simple;
	bh=//r/MKuNSsRY9dT3/vvvkmzs2D74Mq5U4JBSQQ3IKTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0hsPYJ/taP0dSGQdE4N/rL6dgiwvxcvbC7IUPMX9jkH/VlgkAdPiUQQzpREpbOOqeKcMij7C0/j0OCK4eKscRahOCxl38bFcTNFHzO3RaAo7W40X9Iq3llS5dA53NtUpN1KzDjd2hSEc3BYLxKBt79z9Y1cFIR8n1ldL6wpLlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/ED4x98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/ED4x98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECB91F000FF;
	Fri,  9 Oct 2026 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556057;
	bh=lozPcoKH/gcyVMiqKqZqSR2fK4bI948J9hFogHqS1A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/ED4x986UgicLfkEPO1bA69z5AbFvKbmsIDbgeGAk7iRQvSjAFSOldNqNIO/nP1O
	 /0+NJAjUPDE5kXdYfLR7RO9AsBI2A31o7BVq+zslh21OEITa79UFtF3Xsozn11ccdG
	 EeZm+XdmIlmd9KywPOyvWnuAPDHmyNBI6FeCcYNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	syzbot+610e40369bc02181bad0@syzkaller.appspotmail.com,
	syzbot+878643e0580bc580f883@syzkaller.appspotmail.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Francis Perron <francis@akrites.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 114/428] wifi: mac80211: fix slab-out-of-bounds read in ieee80211_monitor_select_queue()
Date: Fri,  9 Oct 2026 16:07:31 +0200
Message-ID: <20261009140948.704261634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit 6f63e919fe1e335b8abcb3a28bfd4804a98d875a ]

ieee80211_monitor_select_queue() validates the skb length using skb->len
before dereferencing pointers into skb->data to access the 802.11 header.
However, skb->len includes data in both the linear head buffer and
non-linear fragments/pages. When AF_PACKET sends a packet large enough to
become non-linear, the 802.11 header at skb->data + len_rthdr may extend
past the linear head buffer even though skb->len appears sufficient.

This leads to a slab-out-of-bounds read when accessing hdr->frame_control,
as the kernel reads beyond the allocated skb head buffer:

  BUG: KASAN: slab-out-of-bounds in ieee80211_monitor_select_queue+0x1ed/0x220

syzbot has hit the same issues.

Fix this by checking skb_headlen(skb) (which gives the length of the
linear data region) instead of skb->len before dereferencing skb->data
pointers. This ensures the required bytes are actually present in the
linear portion of the skb.

Apply the same fix to ieee80211_validate_radiotap_len() which has the
same class of bug: it uses skb->len to validate accesses to skb->data,
and to the corresponding checks in ieee80211_monitor_start_xmit(): for
drivers advertising NETIF_F_SG the skb is not linearized before
ndo_start_xmit, so the 802.11 header can be read past the linear
buffer there as well.

Fixes: cf0277e714a0 ("mac80211: fix skb buffering issue")
Fixes: 9b8a74e3482f ("[MAC80211]: Improve sanity checks on injected packets")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: syzbot+610e40369bc02181bad0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=610e40369bc02181bad0
Reported-by: syzbot+878643e0580bc580f883@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=878643e0580bc580f883
Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Reviewed-by: Francis Perron <francis@akrites.dev>
Link: https://patch.msgid.link/20260925024408.32143-1-cenzhang@linux.microsoft.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c |  4 ++--
 net/mac80211/tx.c    | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 889c32fd8de19..88942317fec8e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -998,8 +998,8 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
-	if (skb->len < len_rthdr + 2 ||
-	    skb->len < len_rthdr + ieee80211_hdrlen(hdr->frame_control))
+	if (skb_headlen(skb) < len_rthdr + 2 ||
+	    skb_headlen(skb) < len_rthdr + ieee80211_hdrlen(hdr->frame_control))
 		return 0; /* doesn't matter, frame will be dropped */
 
 	return ieee80211_select_queue_80211(sdata, skb, hdr);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 77e7d5a17abe0..8e274e9f1874e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2082,7 +2082,7 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 		(struct ieee80211_radiotap_header *)skb->data;
 
 	/* check for not even having the fixed radiotap header part */
-	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
+	if (unlikely(skb_headlen(skb) < sizeof(struct ieee80211_radiotap_header)))
 		return false; /* too short to be possibly valid */
 
 	/* is it a header version we can trust to find length from? */
@@ -2090,7 +2090,7 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 		return false; /* only version 0 is supported */
 
 	/* does the skb contain enough to deliver on the alleged length? */
-	if (unlikely(skb->len < ieee80211_get_radiotap_len(skb->data)))
+	if (unlikely(skb_headlen(skb) < ieee80211_get_radiotap_len(skb->data)))
 		return false; /* skb too short for claimed rt header extent */
 
 	return true;
@@ -2379,13 +2379,13 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	skb_set_network_header(skb, len_rthdr);
 	skb_set_transport_header(skb, len_rthdr);
 
-	if (skb->len < len_rthdr + 2)
+	if (skb_headlen(skb) < len_rthdr + 2)
 		goto fail;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if (skb->len < len_rthdr + hdrlen)
+	if (skb_headlen(skb) < len_rthdr + hdrlen)
 		goto fail;
 
 	/*
@@ -2393,7 +2393,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * carrying a rfc1042 header
 	 */
 	if (ieee80211_is_data(hdr->frame_control) &&
-	    skb->len >= len_rthdr + hdrlen + sizeof(rfc1042_header) + 2) {
+	    skb_headlen(skb) >= len_rthdr + hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *payload = (u8 *)hdr + hdrlen;
 
 		if (ether_addr_equal(payload, rfc1042_header))
-- 
2.53.0



