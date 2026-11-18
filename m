Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040936;
	b=yzCVEp1qJTW7HzqbLxTF92MS4n4p9JrbgM7DTWM8pVthb1eG0LmPofTqgugMFkd4yW3s
	 0xJms8piad8aVJuY/i3adLsGNAzPFK/9Q9df0xIWFIf5y44sy8MD3os1rdRLoCRLra0Ke
	 lZGE8YUs7XxnT44vjsZnwp1ev2HcWueFizx1B0334vkiCoqdHXblXU3cTOTJEfqaKFpq8
	 w+po0q9Q+mkEFpkT3th3cERXeckPOmig0r+gLriYNL8myoS/sKPPDIODhl8j8vNDEiv5O
	 JIMwcX5SUujhg6R/tfXo/it2dTmbvujMKIlHcidNLNV/+6dYwJCrTQRg41wDHhOlmLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZANA/VO2hOlMNg2/TBIrbqiHSbkl1vXwLbdB9LW1WQ=;
	b=DQ8av2gx1VO3+W9iBwvIRv0LbAe+SLAOvJSqbo7faNYQArZgrb8UZWhzKkGXQEitarIW
	 rCUTOLmnJcjqFiYPlQlJ/a/32MpmPc06hQsFJipUV0iWYVZuALtEIU0KoO/pyZSRVp1k3
	 9eJoBuSPsEYbmwPCxEyOCUpA6QG+j3qRTob0w2OTxuJqJqdkt2sRKDZB2ZNDGUk2zcXXi
	 AbxEGL2pl9UiZWXWxh8mgFouwz4WIViFbxEd5L/h56rcdasuYVRO9M7ogYziyxpZPM7Bm
	 6yMwO5VNZ6vKyokS1vS/wOu60EZGppg9sJOZfaU3mnlN5p7BbTuT9sPZdOdz/wjbC2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wB0pFVtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACC1606A336;
	Wed, 18 Nov 2026 22:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wB0pFVtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50C81F000C4;
	Wed, 18 Nov 2026 22:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040936;
	bh=OZANA/VO2hOlMNg2/TBIrbqiHSbkl1vXwLbdB9LW1WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wB0pFVtSgidxnEm0ILbEskMdB0Ea/T/PDEdfmEwJWKNl86pfRXRtz0dPrvqn7gbMo
	 2ReVfhH7ryRMv1Y6tcHe4Vq/xy8ZODkxhBge2L0mpHuiwMmmqTJj0zQaVEmuYNKo+N
	 ZgyzyCvM6ryzQCDzbLJ207MU0vJ20p3N+drcNEF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2627/3318] inet: implement lockless IP_MULTICAST_TTL
Date: Wed, 18 Nov 2026 15:54:09 +0100
Message-ID: <20261118150439.909004515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c9746e6a19c24b2d9a74d6657daee3b39fdc1bec ]

inet->mc_ttl can be read locklessly.

Implement proper lockless reads and writes to inet->mc_ttl

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 852c08d6a991 ("ipv4: reserve one IP ID per segment for UDP GSO packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c            |  2 +-
 net/ipv4/ip_sockglue.c          | 31 ++++++++++++++++---------------
 net/netfilter/ipvs/ip_vs_sync.c |  2 +-
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c8f966d8c77f9..6b29d1caa9223 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1452,7 +1452,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	if (cork->ttl != 0)
 		ttl = cork->ttl;
 	else if (rt->rt_type == RTN_MULTICAST)
-		ttl = inet->mc_ttl;
+		ttl = READ_ONCE(inet->mc_ttl);
 	else
 		ttl = ip_select_ttl(inet, &rt->dst);
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 1a6952921e07b..86ea9cee33af5 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1039,6 +1039,17 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 
 		WRITE_ONCE(inet->min_ttl, val);
 		return 0;
+	case IP_MULTICAST_TTL:
+		if (sk->sk_type == SOCK_STREAM)
+			return -EINVAL;
+		if (optlen < 1)
+			return -EINVAL;
+		if (val == -1)
+			val = 1;
+		if (val < 0 || val > 255)
+			return -EINVAL;
+		WRITE_ONCE(inet->mc_ttl, val);
+		return 0;
 	}
 
 	err = 0;
@@ -1101,17 +1112,6 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 		inet->pmtudisc = val;
 		break;
-	case IP_MULTICAST_TTL:
-		if (sk->sk_type == SOCK_STREAM)
-			goto e_inval;
-		if (optlen < 1)
-			goto e_inval;
-		if (val == -1)
-			val = 1;
-		if (val < 0 || val > 255)
-			goto e_inval;
-		inet->mc_ttl = val;
-		break;
 	case IP_UNICAST_IF:
 	{
 		struct net_device *dev = NULL;
@@ -1594,6 +1594,9 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_MINTTL:
 		val = READ_ONCE(inet->min_ttl);
 		goto copyval;
+	case IP_MULTICAST_TTL:
+		val = READ_ONCE(inet->mc_ttl);
+		goto copyval;
 	}
 
 	if (needs_rtnl)
@@ -1651,9 +1654,6 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 		}
 		break;
 	}
-	case IP_MULTICAST_TTL:
-		val = inet->mc_ttl;
-		break;
 	case IP_UNICAST_IF:
 		val = (__force int)htonl((__u32) inet->uc_index);
 		break;
@@ -1720,7 +1720,8 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 			put_cmsg(&msg, SOL_IP, IP_PKTINFO, sizeof(info), &info);
 		}
 		if (inet_test_bit(TTL, sk)) {
-			int hlim = inet->mc_ttl;
+			int hlim = READ_ONCE(inet->mc_ttl);
+
 			put_cmsg(&msg, SOL_IP, IP_TTL, sizeof(hlim), &hlim);
 		}
 		if (inet_test_bit(TOS, sk)) {
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 60428e15659ac..5a626841b07a3 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1340,7 +1340,7 @@ static void set_mcast_ttl(struct sock *sk, u_char ttl)
 
 	/* setsockopt(sock, SOL_IP, IP_MULTICAST_TTL, &ttl, sizeof(ttl)); */
 	lock_sock(sk);
-	inet->mc_ttl = ttl;
+	WRITE_ONCE(inet->mc_ttl, ttl);
 #ifdef CONFIG_IP_VS_IPV6
 	if (sk->sk_family == AF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
-- 
2.53.0



