Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF56C347BC6;
	Tue, 21 Jul 2026 22:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674224; cv=none; b=GbjbGtwJ+5yXMVm1tUu56Ds9dHgateIpSQ/0nuTO1OXIz6PwtAYNq+DDkB8NQdSmrxZorqUwhYNfc1ZmK9Z3DpyvgsNaD7T08rGkhFcI0C/L1gzyn1kUiG6siGgvGoYD3OhhzG2V56Ja0HUFnBVF+mJLxmfHqPG8+klji3CL05g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674224; c=relaxed/simple;
	bh=lpGS8cPnUVuB0BaW3JJb8Qiyw3/9zwJ19slCPBdcfNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKTRw/svp2gUYGH8Ue3BR2s3evyHrUhIBxKxENZ36dhPPiXlkmCpPDZo35+Kwo/Oa1STBk6Lr3blENXdgLIHiFpfEmmVX/gOk9MjWOjkpPxHlTAeEaIFqp97k53/TTsS7B87fakQGG7Oy5TZz/Hu9807Xu0KaThQHKxdwAfBkfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOmTajR3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOmTajR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4E91F000E9;
	Tue, 21 Jul 2026 22:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674223;
	bh=L0c4i1iVmJFmnnHpahVBoJO8HjeWCho+8tPo2Mz0xGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOmTajR39YQUSj5l20OEDByHEbw8ikHu0OWQlMP9pDZoDvl9wsGj3nlOGd+OJbs7u
	 YXvLSAysG9UNpGp8c2kG0aT24I2r/CwbGLqUs5QX4QdKEaai4ZyMPcUUHLk6kZYZTP
	 SOEkoYsVClKa26HkQLUReTTRsFikacH6HasK2ySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 461/699] batman-adv: dat: acquire ARP hw source only after skb realloc
Date: Tue, 21 Jul 2026 17:23:40 +0200
Message-ID: <20260721152406.097067647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -1819,6 +1819,7 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	struct ethhdr *ethhdr;
 	__be32 ip_src, yiaddr;
 	unsigned short vid;
+	int hdr_size_tmp;
 	__be16 proto;
 	u8 *hw_src;
 
@@ -1835,8 +1836,10 @@ void batadv_dat_snoop_incoming_dhcp_ack(
 	if (!batadv_dat_check_dhcp_ack(skb, proto, &ip_src, chaddr, &yiaddr))
 		return;
 
+	hdr_size_tmp = hdr_size;
+	vid = batadv_dat_get_vid(skb, &hdr_size_tmp);
+	ethhdr = (struct ethhdr *)(skb->data + hdr_size);
 	hw_src = ethhdr->h_source;
-	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	batadv_dat_entry_add(bat_priv, yiaddr, chaddr, vid);
 	batadv_dat_entry_add(bat_priv, ip_src, hw_src, vid);


