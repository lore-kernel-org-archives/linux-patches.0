Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C18443AAC;
	Tue, 21 Jul 2026 22:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672355; cv=none; b=Pyv7epwzqRXOVDScB96G703Hd1/gd3dGP7lwVA8xz2EimjPy37G6YwkbdpABdUB2OGeA1hVVnBfbdvDJwWIhMjczBxIYqpAK6+TxgEjyF4gBIMDuMtsC3QuCPcpZucTGpa3mGCFtAe8AWuRk8U9dCvlCZyAqygC2AEysX5rh4io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672355; c=relaxed/simple;
	bh=DgdNAT4gXIi9ZwEXy0R5CRZ1RG0XzDJSa0QEnfnfJb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iqekseno9qktARzdle1Hr0s4PxpHJYG22KQ9zqVqDfC00yUFyoIIZ9w08DJaURei3Jl6rwDfItxTgGOVPotlFtp5tplMyePawi6F0hmx0dg5QUtqtosggaPidWJ6H5Apqx/zbjQcrALevmS9QXDN8NTDQ1sIqxRa/JAfC+iSbqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDBZOh4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDBZOh4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DCA1F000E9;
	Tue, 21 Jul 2026 22:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672354;
	bh=cPqcNqDOEjuIQ4BPS/dtJuRsxFJCAeXdw6fgb9ccAWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDBZOh4o0/Xgo52NazgvU+234glPwOVL9BZEA+YKXEpHEBtKwoEauo/2lAf2IlYNf
	 ZsaxOOjJaUFd9hzY2S89x3d5cB9dzg8BWiQlNM2TqTPlE8cm7PNSpiI0ejZ71Rj5+i
	 msIiwff3n8rKISrR2QxPjZrYolEajUWcFMt3PdFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 594/843] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:23:49 +0200
Message-ID: <20260721152419.412517041@linuxfoundation.org>
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


