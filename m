Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622355;
	b=IolAye/heJSDn2DyXF6Z+IPSdsRxA+gkkRQ4fJpk0DlNaiUj9umJwurwcJMJTvhDT7h/
	 omepXikKhD5xhEgm3vM/m6DLnd/hPmvMeUekoHpqru34+1f5jYaIbs1Rv8YJTfOh+UEB9
	 xWcizZNbVSZl6FBptfXBsQWwah+EjD1ugprbg1t924rKIcIqxA43UteNPcgZrL3x8jYVO
	 28C5KrGsDYB4pe1VXFBbjgIJNdYYTZNnTtQ3Azql3zD+0BhIvthzcxIRD7+R9zc3FVMw1
	 ErzXzV/tasw+K4dV0tM9hfRcF5Ov72CLcke+E+/sbfbar0JmhCiQFPC8szz9YLd7dfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E7NMrlUP1MDTXd5RduopPcisfaMIJoksTTxC1MnlZio=;
	b=2uV4F5YQidRT4KnXX2NdnzC3s63q7aIi/6vv64V+Q+20ulfDJxVonCrKY7Dz29ORwmdE
	 WTDkRiRfPZv0eJp5S/0pZHSFrM3O94xGtuc81k1zW6pOZ2lqFZtKdY85ZaYaChcitexu+
	 Kc64OrQ7psPwqwP72FoDKCRDJr++ZAecJ7yWmegYvSq7SRkGvXOvxMZSY2TP57d5kQQec
	 Kt5v8EkH9//V4kZ/8Bf2GSMPZNFsFQTI0a8/4M30pp0IFs1/Vb1uEBz1CwXFOpswaOmgJ
	 3qKUJjpCMySsJ9ZjqnMENOxiOy5xgvK1FqR5OoA6Sm+JYkX+iYw/I7LiuRRqaa+6mSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j4/FUm08";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B814606A323;
	Wed, 25 Nov 2026 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4/FUm08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C61F000D3;
	Wed, 25 Nov 2026 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622354;
	bh=E7NMrlUP1MDTXd5RduopPcisfaMIJoksTTxC1MnlZio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4/FUm08oPkHT7p7rFqgoKXaxMX2ReqYaX2QXpYJDySjIYFFTS8Sfro08e7+IoN1d
	 ACy6DrDwWTLHG+li6qXI+Vw8SB3kzCAvYZ6v6aKh9+n7zR+kZRzAWHbhxt+vIfMcbO
	 yxW1aSSrMr/2vqXNCPiqSXDSPKifsYll6in6jRHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/990] sit: charge ip_tunnel_prl_entry allocations to memcg
Date: Wed, 25 Nov 2026 15:31:19 +0100
Message-ID: <20261125143834.090915515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 40a2b90f5190fcc7b083809fa93f2799abefeeb1 ]

ipip6_tunnel_add_prl() allocates struct ip_tunnel_prl_entry for each
potential router entry added via SIOCADDPRL.
An unprivileged user with CAP_NET_ADMIN in a user namespace can add
an unbounded number of entries, consuming uncharged kernel memory.

Commit 1b51d8271973 ("memcg: ipv6/sit: account and don't WARN on
ip_tunnel_prl structs allocation") added accounting to the temporary
buffer in ipip6_tunnel_get_prl(), but missed the entry allocations
in ipip6_tunnel_add_prl().

Use GFP_KERNEL_ACCOUNT when allocating struct ip_tunnel_prl_entry.

Fixes: 1b51d8271973 ("memcg: ipv6/sit: account and don't WARN on ip_tunnel_prl structs allocation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260907075846.2913645-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Replaced kzalloc_obj(struct ip_tunnel_prl_entry, GFP_KERNEL_ACCOUNT) with kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL_ACCOUNT) because this tree's sit.c lacks the kzalloc_obj conversion. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 590b54e9b947d..d7d166cd54f88 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -394,7 +394,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a, int chg)
 		goto out;
 	}
 
-	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL);
+	p = kzalloc(sizeof(struct ip_tunnel_prl_entry), GFP_KERNEL_ACCOUNT);
 	if (!p) {
 		err = -ENOBUFS;
 		goto out;
-- 
2.53.0



