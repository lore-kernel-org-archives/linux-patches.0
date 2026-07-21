Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6536F42DFEA;
	Tue, 21 Jul 2026 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670006; cv=none; b=O1FdR1YARF56P8QUKOJ4a+7hC82Av4GUNuFZmMpK+H8H9D7BBGMref2IyUeWb8AGEjDVhQpwRdTeuCRrhwE+jLKGGFQLwMxWbhqPdigJtqZIJNaaBtLlpDj9TlDf49P1bJWh7DV2PWazIXiBlD68I1UCNhPLRRlUDLMEie+5S0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670006; c=relaxed/simple;
	bh=xpBh8I/oKhsvGUZmUIdiKLWbWj2jMa427cL3OoNUVcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov18YTKCHbYK1wCdFe2F1pi0LLNvr8co/tetNzVcIsC/9oUiyCcjNmd3a6qhqaZzthJsgmYkWxm+EbiAFAGzjjdVcZMfJ7iS2ST6ELh6wnGR+O/tO17+bJuEhiTD878yfFLiz/YXEW3hodIZgJO7igcmpvGQeVhDn6p3xEFzbGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdBVlM4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdBVlM4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C481F1F00A3A;
	Tue, 21 Jul 2026 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670005;
	bh=w/GnP9k9SihHSCQdCOXKl5L/1EGpcVOJpiJO6b4MYzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdBVlM4/L6uXnerDSMx15HMOx1xKJ//R92GYqE+1JG5vAZEx38Yp+3TslC/FYGXJd
	 vHDx6yYGnSKZ1AeqI0sOl/pwP+HxrqZCp1qVisOk0W4FFLqMwiHjC5AM9YmXAn3y0W
	 f4gNRcE9cMly2fGBpjsJpSkt5u1MuWjaUvI0LX/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0769/1067] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:22:50 +0200
Message-ID: <20260721152441.774811482@linuxfoundation.org>
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
@@ -375,7 +375,7 @@ void batadv_skb_set_priority(struct sk_b
 
 	switch (ethhdr->h_proto) {
 	case htons(ETH_P_8021Q):
-		vhdr = skb_header_pointer(skb, offset + sizeof(*vhdr),
+		vhdr = skb_header_pointer(skb, offset,
 					  sizeof(*vhdr), &vhdr_tmp);
 		if (!vhdr)
 			return;


