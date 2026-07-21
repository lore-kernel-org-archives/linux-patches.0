Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7039A7FD;
	Tue, 21 Jul 2026 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658583; cv=none; b=o8dd9SP+LkyNY2gWLrPmCRlNl1NxhuLbQY4FEIzaNPe/HtpDPwVKRUOllt61jWUzBmXSUorTNc8x/2wF3Pw1U7f74eR/CnOsZX9SCzRS4W0fGN1rDrkVyhgBranJepy5jM4i3YjHGDJN7/yggplem6QebnhZmjRFQoaAyNlqDYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658583; c=relaxed/simple;
	bh=FfmPg263g9bwJaE5ZtcZKB1IXQiWES4ppwS+rwBzzto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMBRLzcnQoE9HN9JYMYyZTH9nx9LwUgwbPD0+A5It+TWEmme87eSq7uHFdnO6K5ojYFSh4FR9YzzuKLUNrR8KXqblrpgTgGRC5jA1xJ0uIXXZjxhzeReo4tMkBSUntAW+D8577KexLwETZNX4SdIKqakQhy0GjcbYn06S1XJx8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQ66RyK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQ66RyK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FCA1F000E9;
	Tue, 21 Jul 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658582;
	bh=l0xZN4sbkaE7WXVztj91Cq/xqPoYd41zxuAtOSw+5Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQ66RyK5B1oMj7EvyLR2fetH3kqG9bFhhO88vGDXBgkazS/nW9O0hDX5pp/xSf9ds
	 7byV5dVAjfTpBl+uH7ySTYgIDBugy3x5m8kGaRcb0D56B1HAk0Ara0emqG6q3hntj3
	 Lux6P6yHm6g/ugjZYWPNthKcjk4wj0+ro6clSjVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1197/1611] batman-adv: dat: acquire ARP hw source only after skb realloc
Date: Tue, 21 Jul 2026 17:21:53 +0200
Message-ID: <20260721152542.354974601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1747,6 +1747,7 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	struct ethhdr *ethhdr;
 	__be32 ip_src, yiaddr;
 	unsigned short vid;
+	int hdr_size_tmp;
 	__be16 proto;
 	u8 *hw_src;
 
@@ -1763,8 +1764,10 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	if (!batadv_dat_check_dhcp_ack(skb, proto, &ip_src, chaddr, &yiaddr))
 		return;
 
+	hdr_size_tmp = hdr_size;
+	vid = batadv_dat_get_vid(skb, &hdr_size_tmp);
+	ethhdr = (struct ethhdr *)(skb->data + hdr_size);
 	hw_src = ethhdr->h_source;
-	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	batadv_dat_entry_add(bat_priv, yiaddr, chaddr, vid);
 	batadv_dat_entry_add(bat_priv, ip_src, hw_src, vid);


