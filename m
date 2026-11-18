Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025616;
	b=vQC++F1Zo7XxCPqOCDPJJaiK32O0pxHoDXAplhJaq6eJ5I+DEUGbuFLteNWO8+ODlPi3
	 xkf+MfnqNWH1980FUqbAg9pqtcavwv2QAHQE+2t8hID2CARjXo5bN2QHiSVz2reuVECpw
	 Mhxg2EbuiZ1+Sax8gYLUE3ioXah8ZOkWaUXO70xFY1pCCNEk87ZnUxMSbJ+vyBZRE8XOI
	 2rdqEkNDnI4ZwInsASOClwLQTFZgHQUgBxDa4CuMKhqDq29LxM/oatnlDr2WetiOzepa0
	 fRRC25GoRmrDy8UjNvuveqnJ3j3eqLjrUSF8lM51DKIm4d9N/G9/kxe2v43Kp1Ezg/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7VFhHszNcQq4JFLx0rTu657NGh51wwbwQywQWdmqE8=;
	b=FDhSxoMVSydMypLbkpxjWUIjc+e+FKGbqM2rZejFxQMt5TavaDVbVuw/wY5T2Z/6BUbh
	 4j+162nCK1KZAQCn9b8LZ5fCNM29rLe08hBtEk0Txu44ZEW3ti+RH5PQggEEvkUCe93lZ
	 Jto750CvSJ093jhqP4KP2X0XD+1f6IJAz1rba4vva14oHjTNYlVkha0sVK1hVKirDRHz4
	 DVEfcj0nLO8GB7UNqK2qEspahrxSfLmu4pAuJ2CMkXLvxs5E3VPps6gkhc3Bgn7a9bKRo
	 UkMZF7Kdc06nF5M+2bfpeeD19cd2fDqMV2AOW12XMMsvKKlVqbzCdZS42kIJjJ+AYIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5F5PWwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4F2606A31C;
	Wed, 18 Nov 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5F5PWwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6836D1F000C4;
	Wed, 18 Nov 2026 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025615;
	bh=W7VFhHszNcQq4JFLx0rTu657NGh51wwbwQywQWdmqE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5F5PWwGISwwyIDpbdM58Jue3MHYbfA9TlRcNxl+nvCwPD+mWWONuXVOYAvJkK50v
	 l5yRU2rA510PO0eJsNOTIaooI3FuG6h9a/KsdnZ0EDEmYlzFN51BQij58wA0MCg+Ij
	 pZJksLIY5nLxus2p6CTx+3bfrdIMhLI72uGJs91w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1141/2151] ipv4: fix IP ID reuse in ip_select_ident_segs()
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118150203.769555173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit fe7ca0c13f7d477d6f461114815c57fde3f930ca ]

ip_select_ident_segs() must put the first of the @segs reserved IP IDs
in iph->id, as GSO assigns id, id + 1, ..., id + segs - 1 to segments.

Commit f866fbc842de ("ipv4: fix data-races around inet->inet_id")
used atomic_add_return() for non-TCP sockets, which returns the first
ID of the next packet instead. Consecutive GSO packets can then reuse
IP IDs.

SCTP GSO is affected. Other callers use segs == 1, and only see
a harmless off-by-one (UDP GSO has a separate, older issue).

Use atomic_fetch_add() instead, like the TCP path.

Fixes: f866fbc842de ("ipv4: fix data-races around inet->inet_id")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930144018.1174068-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 86e555fb6897b..1fcbdb3bfbbb4 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -580,7 +580,7 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
 			val = atomic_read(&inet_sk(sk)->inet_id);
 			atomic_set(&inet_sk(sk)->inet_id, val + segs);
 		} else {
-			val = atomic_add_return(segs, &inet_sk(sk)->inet_id);
+			val = atomic_fetch_add(segs, &inet_sk(sk)->inet_id);
 		}
 		iph->id = htons(val);
 		return;
-- 
2.53.0



