Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E103545DF7D;
	Tue, 21 Jul 2026 22:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672459; cv=none; b=ItfxJypAoZYKE7WthptJSXVVIPrjD9A6seQ4W2TKNJOJaqLJNMlaPXtxnhFn9LNVrLqGi7wyU5mAIlEJzg+LvQYff7eLxhwy2dRzC8CtNTBimApWqBSWP1o6PcRxxgh44ZbNtvzqtDSBl/c4eiTZNSWTrw4GHLrMpx40uh7evMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672459; c=relaxed/simple;
	bh=SWcBDbE3gl3nM3Lhb5Tc3EHZZGM8ObI6lrOcFKHnaJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+71is4uoSlviP4LNfg85Jy/qpRKLfnkDRsuZG6WwlLaO0vd9vgFvRhhyuWmcWz14Zxf1ourte5g9J4/e443AsEYNCLRAcg/l77GwVq5PqpNZs/I9sqgsQ7u19UuZr/ndz1QzJ2Dr7AirODHs06oae6SAcVYkfHKBCX9voa71OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiosvhnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiosvhnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0194E1F00A3A;
	Tue, 21 Jul 2026 22:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672457;
	bh=p3ERcZKYePKeubIxaUKnt34J1duoRGfekE+5KoNYjZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiosvhnfeuf/6tzrbb0pK7sEVXzLxbinbkPWdw8bnWBn4zC6dyMRPVuzR2DypeWlO
	 2xWHSL1wb1/v/UjW4HgV+1m5Rox9V3u13/Jb4YASP2jW6tMt375H1T0ZHDENBrZBtm
	 el/YVc3prlVTm7vqwJ3NBBbsSln8y9DoZY1TzVJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 589/843] batman-adv: dat: acquire ARP hw source only after skb realloc
Date: Tue, 21 Jul 2026 17:23:44 +0200
Message-ID: <20260721152419.300496904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 48067b2ae4504500a7093d9e1e16b42e70330480 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: b61ec31c8575 ("batman-adv: Snoop DHCPACKs for DAT")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -1758,6 +1758,7 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	struct ethhdr *ethhdr;
 	__be32 ip_src, yiaddr;
 	unsigned short vid;
+	int hdr_size_tmp;
 	__be16 proto;
 	u8 *hw_src;
 
@@ -1774,8 +1775,10 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	if (!batadv_dat_check_dhcp_ack(skb, proto, &ip_src, chaddr, &yiaddr))
 		return;
 
+	hdr_size_tmp = hdr_size;
+	vid = batadv_dat_get_vid(skb, &hdr_size_tmp);
+	ethhdr = (struct ethhdr *)(skb->data + hdr_size);
 	hw_src = ethhdr->h_source;
-	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	batadv_dat_entry_add(bat_priv, yiaddr, chaddr, vid);
 	batadv_dat_entry_add(bat_priv, ip_src, hw_src, vid);


