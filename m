Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA118801A;
	Tue, 30 Jul 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358661; cv=none; b=Vvbp5UTAjcIv1S03pW3UoaRnZO/OZ7GTf9sdmRaksm7psGCeDFW7VMOyHfnCcD+NEWgrLnK+Wk5s6SaKbghCZ85cdDPLiFwHwfujd135bmyMnYEEZ6L8pOO6irUP4BijLqi2W4eMYQCAuDNwZfvZRizDopsKiWauY0sd3eD8/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358661; c=relaxed/simple;
	bh=5KFz7BC5A5eghGGgmeLwh4kUwkszbGod5NwuZwhx3gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW/CiQzYkQ+mR/2szMvUMPr9G+qy46ld5DwZ5uHkScMYXdBjozOv4vjYNC6ynWom+t4hI/9Dza72jbyJdVjPEsolCK62u1Ip8ucHtu1wlVSaFjSoMDIvRbB6sYJqs9oPp5U58Luup0r1RJJ1+2ZBls/fSFCCA2VmpcCX41EteO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIVLkEIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIVLkEIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B3C32782;
	Tue, 30 Jul 2024 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358661;
	bh=5KFz7BC5A5eghGGgmeLwh4kUwkszbGod5NwuZwhx3gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIVLkEIJOekuotm8SJt3FsN5ShyxPcFkHaPuYg7u2s4GIHOh3Wnqnqoupuczgro+1
	 bYLQ/zAO7Yz94TFHCQIkJ3eR3nkd3iNmF/DXVe1XUEifSmDTN3cnjz9M5grL5TUPpv
	 SfyqmSHdG5nhg+vKogBiCQZNrRmrz0xKb6e3PoBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 411/440] ipv4: Fix incorrect source address in Record Route option
Date: Tue, 30 Jul 2024 17:50:44 +0200
Message-ID: <20240730151631.846418343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cc73bbab4b1fb8a4f53a24645871dafa5f81266a ]

The Record Route IP option records the addresses of the routers that
routed the packet. In the case of forwarded packets, the kernel performs
a route lookup via fib_lookup() and fills in the preferred source
address of the matched route.

The lookup is performed with the DS field of the forwarded packet, but
using the RT_TOS() macro which only masks one of the two ECN bits. If
the packet is ECT(0) or CE, the matched route might be different than
the route via which the packet was forwarded as the input path masks
both of the ECN bits, resulting in the wrong address being filled in the
Record Route option.

Fix by masking both of the ECN bits.

Fixes: 8e36360ae876 ("ipv4: Remove route key identity dependencies in ip_rt_get_source().")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20240718123407.434778-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index da193840fc007..fda88894d0205 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1275,7 +1275,7 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
 		struct flowi4 fl4 = {
 			.daddr = iph->daddr,
 			.saddr = iph->saddr,
-			.flowi4_tos = RT_TOS(iph->tos),
+			.flowi4_tos = iph->tos & IPTOS_RT_MASK,
 			.flowi4_oif = rt->dst.dev->ifindex,
 			.flowi4_iif = skb->dev->ifindex,
 			.flowi4_mark = skb->mark,
-- 
2.43.0



