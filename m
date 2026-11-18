Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049296;
	b=n1pwSeHyj9lbKEKA8eiEb8dlDGBSg0tYykHqS4QmDJvvDVxFNXPWOHozJiUtW78sCrgV
	 8qvCwxu8l1dSNJufx3OKLHADib1ow8AqwwKQFNgA4x6WemVO7E5l2zG0waMZLuMRlWsT5
	 YpRzQHhOPtp+9nuYJuYHMuCLL+KSwhELpYMhdJlwe5yo2JxSMaKIGRj34M9XO7hw6gHdl
	 hFNgVW3tHHtX+nxMFs1jwb5lZ+qGZH5wWpw91LmRzfAojT9pbpKVq1QQT7ncIAKed73+E
	 pGf42lxFBKg8caj9NV5IVEmF79oDqvCtm+X+PcQw7o7yLgZMRWbEb9uc+5j2W/9/MtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFxxprRP9Uk8t0JSsbLEhoIzekNGFT/1ruE6NwK5Hh0=;
	b=RXQLjr5GZpNwzDITKkYoqkF5eAwIuwsDCl8vVnrooH9SUu5zkd+fcpz1B55pW8eCMJy+
	 LRBsTYunO3Pb9gngVUcPlTD5xBoebrraue3kt2/yUk1xyfrBO6mQybRpCj9fSfIHejD9I
	 B/u/aOo0ULc16NxnJh8g71Z7l1M9ZWgBkpQhxZRzlUU5XTovQuVy1Vl/oHtshUZpRcq87
	 JwCQZjERKH1JyqUos++PsGsiw59fXFJBSOaMp66pNwvGEN5e2u3brh4LhlwBj8J3aBaPR
	 h4cVE/GpM5oO7emDlz3jyyceGBXOehuQh3BYYwvKNmEqpmgVkY+zvWPmnW7a/pa32WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FbPxNV/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9701606A31C;
	Thu, 19 Nov 2026 00:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbPxNV/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73821F000C4;
	Thu, 19 Nov 2026 00:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049296;
	bh=UFxxprRP9Uk8t0JSsbLEhoIzekNGFT/1ruE6NwK5Hh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbPxNV/LUzyZJDFPQKzAfb2JUBxGiX1QO/7YCqZVUKZ265lkb+WsWk3flB1TckyHo
	 AZF8Hq8Q5MDnCFih/kgW81Fd8hH/DKib2fTATHjrC3z18TNNjjimnQcE+XfpsQ8E5W
	 LvE5nZ4Gp14dCvWdaEC4amk+lJWI5qMqIMd0rJBA=
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
Subject: [PATCH 6.1 2274/2857] ipv4: fix IP ID reuse in ip_select_ident_segs()
Date: Wed, 18 Nov 2026 15:55:08 +0100
Message-ID: <20261118150323.330364481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 855998087701e..11a8a0a331fc9 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -565,7 +565,7 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
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



