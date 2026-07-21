Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ED446EF60;
	Tue, 21 Jul 2026 19:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663598; cv=none; b=fKC15aWCsi7IYCLBiviPRbCX2Yb1CwG45duIChUzUaG+yZv2PxKuFtvyJfUqn72bMNad1CGK7X3WatRsvzKtuyA4fxAC30dMFYwV4jCaELVIS8R+2fwf/4SBkmCDixEE/nUhSyxmdPSgAA0RfsEnHWyQUbH7SyV1INnR3X+ygi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663598; c=relaxed/simple;
	bh=F2jPucXL3CW/yJicYIVZLVYyjwvPgYdyzP4KR1jem40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnAS3k/deOb1qZq8/mracBznEBk+xM4uE8s/gIJcqe/Q/TiD6EJhicbXdK8T870+3xPSLbg4fAdOUmwqk7fwr2LqkQtdl6kWpqPE0yWosPoSeTuzmQoEq+VUoSai7GfuAwddXasdz1D5oKCNt61AJBo7x81GYD2PTsTF1Uc009M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLuVjcu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLuVjcu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F441F000E9;
	Tue, 21 Jul 2026 19:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663597;
	bh=5AvswsWvgFSXXr8PQW6aujjkptz0LI2b2BB8Hdcl03o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLuVjcu+VfnCQPtpsKy9CMThmVVBZAKB1WWLgrNYiZb10JScmWEhZNukDxSTieh3w
	 3t0HtTLE0D+pb60g+2BcKh8eTZ9R6j39gtxAQPVDfWTpwmx4E1BHKutlMMwkts8WkU
	 4hYGd9IW3owkBPBbT8mKgMK1n5yW5juhPKBn8FZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0884/1276] batman-adv: dat: acquire ARP hw source only after skb realloc
Date: Tue, 21 Jul 2026 17:22:07 +0200
Message-ID: <20260721152505.833019860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1757,6 +1757,7 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	struct ethhdr *ethhdr;
 	__be32 ip_src, yiaddr;
 	unsigned short vid;
+	int hdr_size_tmp;
 	__be16 proto;
 	u8 *hw_src;
 
@@ -1773,8 +1774,10 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	if (!batadv_dat_check_dhcp_ack(skb, proto, &ip_src, chaddr, &yiaddr))
 		return;
 
+	hdr_size_tmp = hdr_size;
+	vid = batadv_dat_get_vid(skb, &hdr_size_tmp);
+	ethhdr = (struct ethhdr *)(skb->data + hdr_size);
 	hw_src = ethhdr->h_source;
-	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	batadv_dat_entry_add(bat_priv, yiaddr, chaddr, vid);
 	batadv_dat_entry_add(bat_priv, ip_src, hw_src, vid);


