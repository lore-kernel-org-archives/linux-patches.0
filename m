Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625582;
	b=srxVrsXrRz1E0suhBti8k04wEjd43plJYvVGQbkiFmdYg3aHIxVHLLYYaMl8HzLNGT6t
	 oJIX2zOfCXuHSHhIiKAvp3grE8es8YOsrasslFHHUVFPz7aFQeBOFRPwzJmtuWH5rIjkn
	 EQ7RP1QMw82UUKISUUSgGp6roXR6nDr3wBACmOYG1Vpc0CCjulDzN0pH10hVsbzlpECyR
	 mmcz/j8Pg1+q57HRZ2hWhdfbiJS9RY+n1PklJpOR0Jfytd3VNMt4JZru6jzTXgfaEs+5q
	 6Qu1z4q12TRIx/0NajVASF4n+8IPvTKOlpQuJhiq77IN9u9dl3DQ6HHKEleKRnbDJSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=566JYJybhzQ471zKtXGElIqAq4yqHEXLA53Mp6Swp2s=;
	b=phjDpi4bmNUcXkOLv02VGEK2FtdVu7nE1WpdlFVTGh0WLPu/fPRsd7+ccrdoAwM/uyX2
	 jdw+GTs4yjI9vFAavYsUKaB5h/WjPw3/Nrp8nH04EFe/mAZyufRNteSKmXLKAZZkyXp0E
	 IXFvyuZVRfNMiBk/6yjk6RAQNtr9T8fjPu/zZeyjpNllwo2xDikyrs7Iwt2/i24QCC0Nv
	 TStTJDIaC2kZjUg5JdLce/27DT5JugO8WfzZuItRhwrjiUNoUtepHiQtSgC8vsbLiwzxT
	 5a7E8aep8ZnFsNdJA/WRmPYCKC7q9PYBFpa1Y+lXWxIpFJmyJ1dUX/vUMY3bXHJq+vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ac7EO/lb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289B0606A32D;
	Wed, 25 Nov 2026 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ac7EO/lb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E7D1F008B2;
	Wed, 25 Nov 2026 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625582;
	bh=566JYJybhzQ471zKtXGElIqAq4yqHEXLA53Mp6Swp2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ac7EO/lbV6mN62ngSIAps8xmz7Dw88f6SYBENRW6qWKFOAjLcY9W6/pVtk4fU7ts3
	 Ed8otS33DqNML0s4oWmjhQQARoPFF7PrR5ly5aY+O81sB0e5AGcuzEgdC/PknLDthb
	 JCHM6zNip4ORNpSlde7zXKUS/JAQq3fTozdcOxTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 519/816] netfilter: flowtable: reset transport header after nf_flow_encap_pop()
Date: Wed, 25 Nov 2026 15:34:27 +0100
Message-ID: <20261125143901.199499639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 08f7882637f2db5b98f521498eeaf94770383a6e ]

nf_flow_encap_pop() pulls vlan/pppoe or ip tunnel headers and resets the
network header, but leaves the transport header pointing into the removed
outer header. Reset the transport header to the inner L4 header, otherwise
later consumers (e.g. GSO segmentation) parse a bogus header.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ sashal: Adapted the IPv6 hunk context to this tree's two-argument nf_flow_encap_pop(skb, tuplehash) call instead of the three-argument form with ctx. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1855ee828421f..91c82d513bbc0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -418,6 +418,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	nf_flow_encap_pop(skb, tuplehash);
 	thoff -= ctx->offset;
+	skb_set_transport_header(skb, thoff);
 
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
@@ -700,6 +701,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
+	skb_set_transport_header(skb, sizeof(*ip6h));
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
-- 
2.53.0



