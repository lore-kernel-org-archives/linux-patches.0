Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9808744AB9E;
	Tue, 21 Jul 2026 21:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669990; cv=none; b=FkKD8LatBGJDRaewnrZ5AE5ZDEHfBhSp9DK+J1L+77wZLTYELkxb7vU7G5wRJz9mLBqg36rjGLs4Getg41F5pnzlYW/ckeHhnFziD9X/dq0YOBdRPRT3dSuq1N2A212Sc0kWIrIPtwA69TjUnkmXYu8ZxYxbOjMXiC8boxkKcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669990; c=relaxed/simple;
	bh=q8oZss0tppDBNaLnWuxmoNxblEALFVETr1cBlsIIsls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4BfzjPytc6lBPim53AME1M8YWBgmuhVO8VUI9m/LlhNr1DvuKwUSIw62C47mRPrfwsjm46DtSPkmhOdIS6xh6XrJpjRlLk2IviRV4I+UW01gxMULHOxyS2N4MXLXdgwgwn6iaIdVRRfpbbysDorzVV7dVyFyRDERJ+AFkAPu2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTbcgUFF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTbcgUFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051041F000E9;
	Tue, 21 Jul 2026 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669989;
	bh=vYDWQXYtgrYsrbG1nJbGVV3/RsnDjjd9tengez0Y8AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTbcgUFFDHryEGYBsOYP6f/yqnQ7lpqc8pswQ3yB78TK8beKfPf7XlqXv9xdOcoJg
	 ewt2pwesXg6wB+QjeVlY2JvW0JR9AKgQINK7mTzYCgImfbTe4XYCcjvQ+zrFSVjmYu
	 9zh5mwhWD3PkD5cwRL220RkkEszUufyGJ/meJFNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0764/1067] batman-adv: dat: acquire ARP hw source only after skb realloc
Date: Tue, 21 Jul 2026 17:22:45 +0200
Message-ID: <20260721152441.659403042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


