Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D5746E005;
	Tue, 21 Jul 2026 19:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663611; cv=none; b=RS4RlcEglrlAwifpr9fMtnjMSSsbxJq6wvfLg7R7RXF1DO10xrhRBWWzzhIqEVyvFkp8yGQcaWxxRfgtWDPj5v//mZpwX8I2EVBfWaa5ycUg5gnPXZqquMqFn0s3lfjuJ9U+fHLwLxOveyPa3w1AuAtvBkBx9vg+zFZuzVHgJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663611; c=relaxed/simple;
	bh=UqkY8QqNTf1PLgtDf91d3n91wHfaQ57fcPoXhS1vBLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc0HFp+wHNgjoUVeADS9mTDPzT8qB/yRL+gMG1ir/zpZbiwVD1uAsmLjHhjGU4X1qQnh6b+K6PSlcV7TdGGcvbM9p8pU2FISGJrWTTKCiwsOiDh6cii6JvPC9/PdPWWdAhj7slHUMXJO3nidetaJZTQK2UbBTyWV/bxoFJOu5XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwGjK/ep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwGjK/ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286481F000E9;
	Tue, 21 Jul 2026 19:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663610;
	bh=ddpyBjnJ4BFr4gvwPdCXjLV5udE/KKrNBq5NSNgJTOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwGjK/epnhOuwAX6ikyaybE9p3csT0aNxsyvPxMAHO82FDKmTf2BpbF0j27MWjppq
	 KO4qCQZ7+3IiR/y29i4tG8R0DngIPSwLYL4P/K8Ga+qi2j8zk4DJFe4H2sdNpMMffP
	 HuYcEQLCs7pvxjLSuoD1wR81hYxyuOVPb+6A5I1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0889/1276] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:22:12 +0200
Message-ID: <20260721152505.940455671@linuxfoundation.org>
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
@@ -376,7 +376,7 @@ void batadv_skb_set_priority(struct sk_b
 
 	switch (ethhdr->h_proto) {
 	case htons(ETH_P_8021Q):
-		vhdr = skb_header_pointer(skb, offset + sizeof(*vhdr),
+		vhdr = skb_header_pointer(skb, offset,
 					  sizeof(*vhdr), &vhdr_tmp);
 		if (!vhdr)
 			return;


