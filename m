Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041053;
	b=cDhEOL3diJ+HT9ANa5JpLexofW0x15CD8aK+6vmq6SyM6/Gsf+DfygzvDLkUiSW0zBJd
	 KapKRynektUayjQK5WbSA69CQfikeeBezAYe+a3PVMCH6i5h4T+tfcz7oATNLmyyQ3rku
	 vzccoyOKeZJP4JhSIW3LhTq9aLQwBzjzIHUI/KXIswD9hCYcHnpAQGCOycM0rGaG/6XhN
	 azdbZGREob0se14YflFH8dSzd7HOnAxn4FZhass55x0FJLw5q7VutZUy4uJAUe6ulJN0c
	 V/8Q82QVXAnTxUs9a5T5p1qCI4yIqr7gZGGRM1+1kuUrZ70O4mi2wuAH7OvSTsvC+1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gSpgTuA8g1mU2LxVpP2NdmqWwIiF9FwXV+eXHCxpSU8=;
	b=LSLK3e1XPTDC07FOxoAJl4unSew6jdFkwhzMORPi8J4JXvp8wnDpP6h8tLF5g8OBFuBC
	 cFyQM0Y/bxv6R2UspVJt/jNieFplbx/9f5s4lHlrWUPcIhEtkWe2gC5vpXcBFRdrVrnFC
	 PpvcE44W6yMIy4OrWnAmopkR8aQAQJtftUWMtcgFw9Qqv5bWkFZjlas06JzucHHe2xE05
	 231LegGRO6u4vxtDSkOtayXhgOjd8ukbfbv4im3XVR5Rv2B0whF9M0PZyMLF4Jx+8JZ16
	 6rguUHCDoEGmxqi/EJ7hEHolKlpInYcTdCJOIDfnsVG2z7iUnDHzd2ElKoMeUO2aJfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8PquwWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E48606A31C;
	Wed, 18 Nov 2026 22:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8PquwWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBC31F000C8;
	Wed, 18 Nov 2026 22:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041053;
	bh=gSpgTuA8g1mU2LxVpP2NdmqWwIiF9FwXV+eXHCxpSU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8PquwWibZ6AIhfWTNmHQ+2iS2iiMt1VMeSoXnNqNtvcF9TqOm89Gp86D173T1fYE
	 bXntD5dBvNauk2jFFISO9LoPKRT3HBWcV0Uuqar+nYpLGvaMzR1OaOQvOURvkHdKLo
	 p6fLNsjSegQMdLqfkDBwjQJ3J0wtHpxIGTtj7lFY=
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
Subject: [PATCH 6.6 2626/3318] ipv4: fix IP ID reuse in ip_select_ident_segs()
Date: Wed, 18 Nov 2026 15:54:08 +0100
Message-ID: <20261118150439.879934887@linuxfoundation.org>
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
index 775185fe552f8..4bfa2b1fc4850 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -569,7 +569,7 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
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



