Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463CF296D1D;
	Mon, 12 May 2025 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072349; cv=none; b=TUjuP2IXLnRf8WrkKoIXyMoIz2zfmRqOI/ebYFs35+1qVBXMYj0Dd8Py6zl3SHZSeVP1icrphxO6wh8NC6A5JNLzgYfnMiS6VX8csC3lonUUVtU5dOXClJfEqxBw+GU8KyTDS870ZFoAkSzwRFdvPwzt25lXNiOwegGWJGoGPyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072349; c=relaxed/simple;
	bh=9/P0cZEtN5cqMFywYain1RMdj0QTGzjx9JTc31RZmgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnoqM2vw6xQ3zwiWRp93w7UYoYEj1QXrHNoEW0hVqknG31QRbnVtCj16lk9t9FFQcMtZ/bxOJ/wu9Bs++4v+8JURD5qFTZLSIz9YvW5m7X2NDj7zKTu+xiy080mGdtLrJUFT203W+k8hPcCgxY7HkWfrZhfE05t4voQ0ajrJhSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c2EmFo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c2EmFo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60093C4CEE7;
	Mon, 12 May 2025 17:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072348;
	bh=9/P0cZEtN5cqMFywYain1RMdj0QTGzjx9JTc31RZmgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1c2EmFo05Uh2oWJSl9A7R4cFRDviuetQsmeMBhu1gGjz5LgYfRcoHKk97+NB6RNaz
	 OjzulmeKI64gHDpZ2ki34pxeXM5Us+5SxLdTt9CjYopbTi5a7CTYn61c/Umax6GMg/
	 KK34qVbpNOEnSUlwuZLR5So1YUot0OFsFxkX/aFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/92] ipv4: Drop tos parameter from flowi4_update_output()
Date: Mon, 12 May 2025 19:44:48 +0200
Message-ID: <20250512172023.664723552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 3f06760c00f56c5fe6c7f3361c2cf64becee1174 ]

Callers of flowi4_update_output() never try to update ->flowi4_tos:

  * ip_route_connect() updates ->flowi4_tos with its own current
    value.

  * ip_route_newports() has two users: tcp_v4_connect() and
    dccp_v4_connect. Both initialise fl4 with ip_route_connect(), which
    in turn sets ->flowi4_tos with RT_TOS(inet_sk(sk)->tos) and
    ->flowi4_scope based on SOCK_LOCALROUTE.

    Then ip_route_newports() updates ->flowi4_tos with
    RT_CONN_FLAGS(sk), which is the same as RT_TOS(inet_sk(sk)->tos),
    unless SOCK_LOCALROUTE is set on the socket. In that case, the
    lowest order bit is set to 1, to eventually inform
    ip_route_output_key_hash() to restrict the scope to RT_SCOPE_LINK.
    This is equivalent to properly setting ->flowi4_scope as
    ip_route_connect() did.

  * ip_vs_xmit.c initialises ->flowi4_tos with memset(0), then calls
    flowi4_update_output() with tos=0.

  * sctp_v4_get_dst() uses the same RT_CONN_FLAGS_TOS() when
    initialising ->flowi4_tos and when calling flowi4_update_output().

In the end, ->flowi4_tos never changes. So let's just drop the tos
parameter. This will simplify the conversion of ->flowi4_tos from __u8
to dscp_t.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e34090d7214e ("ipvs: fix uninit-value for saddr in do_output_route4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow.h              | 3 +--
 include/net/route.h             | 6 ++----
 net/netfilter/ipvs/ip_vs_xmit.c | 4 ++--
 net/sctp/protocol.c             | 4 +---
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 079cc493fe67d..5a17fa6e016f8 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -115,11 +115,10 @@ static inline void flowi4_init_output(struct flowi4 *fl4, int oif,
 }
 
 /* Reset some input parameters after previous lookup */
-static inline void flowi4_update_output(struct flowi4 *fl4, int oif, __u8 tos,
+static inline void flowi4_update_output(struct flowi4 *fl4, int oif,
 					__be32 daddr, __be32 saddr)
 {
 	fl4->flowi4_oif = oif;
-	fl4->flowi4_tos = tos;
 	fl4->daddr = daddr;
 	fl4->saddr = saddr;
 }
diff --git a/include/net/route.h b/include/net/route.h
index 4185e6da9ef85..cdca622c5c6fe 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -325,8 +325,7 @@ static inline struct rtable *ip_route_connect(struct flowi4 *fl4, __be32 dst,
 		if (IS_ERR(rt))
 			return rt;
 		ip_rt_put(rt);
-		flowi4_update_output(fl4, oif, fl4->flowi4_tos, fl4->daddr,
-				     fl4->saddr);
+		flowi4_update_output(fl4, oif, fl4->daddr, fl4->saddr);
 	}
 	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 	return ip_route_output_flow(net, fl4, sk);
@@ -341,8 +340,7 @@ static inline struct rtable *ip_route_newports(struct flowi4 *fl4, struct rtable
 		fl4->fl4_dport = dport;
 		fl4->fl4_sport = sport;
 		ip_rt_put(rt);
-		flowi4_update_output(fl4, sk->sk_bound_dev_if,
-				     RT_CONN_FLAGS(sk), fl4->daddr,
+		flowi4_update_output(fl4, sk->sk_bound_dev_if, fl4->daddr,
 				     fl4->saddr);
 		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 		return ip_route_output_flow(sock_net(sk), fl4, sk);
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index d40a4ca2b27f5..f9ae72122e343 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -139,7 +139,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 		if (PTR_ERR(rt) == -EINVAL && *saddr &&
 		    rt_mode & IP_VS_RT_MODE_CONNECT && !loop) {
 			*saddr = 0;
-			flowi4_update_output(&fl4, 0, 0, daddr, 0);
+			flowi4_update_output(&fl4, 0, daddr, 0);
 			goto retry;
 		}
 		IP_VS_DBG_RL("ip_route_output error, dest: %pI4\n", &daddr);
@@ -147,7 +147,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 	} else if (!*saddr && rt_mode & IP_VS_RT_MODE_CONNECT && fl4.saddr) {
 		ip_rt_put(rt);
 		*saddr = fl4.saddr;
-		flowi4_update_output(&fl4, 0, 0, daddr, fl4.saddr);
+		flowi4_update_output(&fl4, 0, daddr, fl4.saddr);
 		loop = true;
 		goto retry;
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index bcd3384ab07a4..036dc574af4f9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -497,9 +497,7 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 			continue;
 
 		fl4->fl4_sport = laddr->a.v4.sin_port;
-		flowi4_update_output(fl4,
-				     asoc->base.sk->sk_bound_dev_if,
-				     RT_CONN_FLAGS_TOS(asoc->base.sk, tos),
+		flowi4_update_output(fl4, asoc->base.sk->sk_bound_dev_if,
 				     daddr->v4.sin_addr.s_addr,
 				     laddr->a.v4.sin_addr.s_addr);
 
-- 
2.39.5



