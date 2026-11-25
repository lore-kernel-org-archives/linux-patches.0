Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625077;
	b=E+zz29NBUIYdN/2IHzSS4wxrzSNIIN4iOEajzBiL4pnUKhZgHNAVGK9llSCUGZjYQ3Op
	 f/8jFGJZhPmmLm+Gm5y8hR1kYeGyBEMppECfmiHCBYX1711p4oxkDKUKdhLzK9GFTga1R
	 jHBXILp02M+qwUv+TZbpI+zodCuG1Hcipkp+9NqxKWyT3hstAYWzw9dMBa3jw6buYijZr
	 WjeR3uwJyaPruzUTNy4yU1eUlPElyuBWjIYKhMXIOTg++n3v1kuF62rOAvPiNuLxZefV3
	 2k0CiV5/W0ZI8rV5TwdgfTi9MEpvHSjMsR6A0hwpE9jp6m2/e5iYjueVR6u1WC9VMCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82/i3/+y9+7B9totqN+4qfOEbMAt7j01vgY6hKGoNMA=;
	b=ZyEWxgFsQqnRnmQhIwGSWAWAMt2R9k4GoUipYc5v+jNXrhEtKgOnvjUxKkU0hQvZSwMf
	 7pgsq7H4jCCgOPJa9awalNd89bb6wKmAnrDWzJPtUYP5kuQHHBjlGh1flNaO/Cv+WnAMg
	 X+amtWu6Tfiqw7QKFR5rPyjrn2+eR+GvLUNW0sIgr4eG7UTOClMdSEcl1PVO9wYQKnRaw
	 Spw3mxYfb01TMnTPXeYodjWn6zrelQswN/BQltKa+9fdpWJ5/gFKaBsfVYYxFwREQ77yo
	 MAAhpGwe+Cw3+NTPItk/eaAD5jCXQ3U732/bH/iuM9VNLAV4fZHp0UOZ164WYa2kASA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bh2WOaD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F12606A31E;
	Wed, 25 Nov 2026 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bh2WOaD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EE91F000C4;
	Wed, 25 Nov 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625077;
	bh=82/i3/+y9+7B9totqN+4qfOEbMAt7j01vgY6hKGoNMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bh2WOaD439vOPV3iPT3dGqUJvdsKBCaN+8+TOH/OJc9Td4197oZZsCPZ62WfF8BWI
	 8vx1OCoiJYnwd0zecNvNj8gfWFpjhHlZ0BUovVssaa5fTT14lml64TkO9/pXodPnfR
	 w+blgGfgprJ3YVy2Jt5jePN3OSb0SerYIOt1n04k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/816] sit: charge ip_tunnel_prl_entry allocations to memcg
Date: Wed, 25 Nov 2026 15:32:26 +0100
Message-ID: <20261125143858.412172309@linuxfoundation.org>
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
[ sashal: Changed GFP_KERNEL to GFP_KERNEL_ACCOUNT on the existing kzalloc() call, since the kzalloc_obj() helper used by the upstream patch doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index eb42d3075e77d..c1617f3e09d91 100644
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



