Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542FF395254;
	Tue, 21 Jul 2026 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658602; cv=none; b=aHc5O7VzrhRmLLjQahNRAwvsG5EAS6YWZSdGQpszkMhRjWiGDT3oNT9FgKCGF8OQhrtOzaFI65Ake5YhFWhZatYOKnhFK3BBsu92MRI8NcnQ6FaWnzYD0FepfjgQ/oVEljyvNty18LbisLqsubZ1QJ63WkvoHMnL0dFxeCu2chc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658602; c=relaxed/simple;
	bh=BVI7qYVlxJpGd8HX8jD3aks4g64ziBZEkbktN55T/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OT/gxRP2YcTnyxPp0Y1LljxG3wXa+/Yyy8aeSPIEp2xNiAGiNpXYW1YaBsyr/6qUpuKsViUMsQ8EBk1PM8STb4Kc6/Nv+gnbPKjNcxqfkcOZFNoSXR1QQAqRev3AwaSbJA6h/64DkJT3hHvWvtWHh2bmcbcjpgqsGzrd2Kh+O4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYz1UwTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYz1UwTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD96B1F000E9;
	Tue, 21 Jul 2026 18:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658601;
	bh=qHx1Lq3zX9+JuIjOWTj+kPWxvuvVnJXo+h8lU7a6oVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYz1UwTcU9YaXTJqJ4AizuFbz1fjC0NKVB7MrZMF/i8+N1z6XeC0aU/uB2khGJtqM
	 NctYPmDZmc4rqeHz9kqPLE95Q+zM68bRpAqb/Lazop6j+MINr6jkeUSukzW8kHbc2q
	 sRLkzw82R5N95tLAMfqggPjliTTPQefrkVgN0gco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1203/1611] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:21:59 +0200
Message-ID: <20260721152542.494200506@linuxfoundation.org>
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

commit fdb3be00ba4dafa313e699d6b5b90d13f22f3f25 upstream.

The batadv_skb_set_priority() receives an SKB with the inner ethernet
header at position "offset". When it tries to extract the IPv4 and IPv6
header, it needs to skip the ethernet header to get access to the IP
header.

But for VLAN header, it performs the access with the struct vlan_ethhdr.
This struct contains both both the ethernet header and the VLAN header. It
is therefore incorrect to skip over the whole vlan_ethhdr size to get
access to the vlan_ethhdr.

Cc: stable@vger.kernel.org
Fixes: c54f38c9aa22 ("batman-adv: set skb priority according to content")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -354,7 +354,7 @@ void batadv_skb_set_priority(struct sk_b
 
 	switch (ethhdr->h_proto) {
 	case htons(ETH_P_8021Q):
-		vhdr = skb_header_pointer(skb, offset + sizeof(*vhdr),
+		vhdr = skb_header_pointer(skb, offset,
 					  sizeof(*vhdr), &vhdr_tmp);
 		if (!vhdr)
 			return;


