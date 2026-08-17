Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136C22E738B;
	Mon, 17 Aug 2026 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977621; cv=none; b=nrw+9mDJh83dez7uoB7gT12ev8QoV4+TOKKuC5xMz3ICRxLE/ZK+DXcbi7WOxiQ94qdfiXidOhterVt9xyZrVSmbYsGwxitZ2zE7rhN4j1+lvsz47pONW1qdSD2QCmjyW7gyrrLsjaj1u25r21LTW+7ai6RdnOcKkSQ0mqzzOMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977621; c=relaxed/simple;
	bh=MvlWUFI71uKYdR0GNlEEwjqbwcK2tEj0msj/izD0hto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ha4mlr3G2/yxvZqOyJsBNqhvczbC3wvvwH9kpJdxPLasi5J4MBwDLeQtusY6p/Z39U0XEDKqjBSw5I3xfJuqbvOpA4ukjOdPG2u9V237Q/Z8/ltjJaxUseixoahW/L0EeDmKFOgSYMLH+JZ4YH7i2GX/pedxPDMEaSkGjEiQqNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMFJjj18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMFJjj18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0B11F000E9;
	Mon, 17 Aug 2026 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977620;
	bh=fV2pBH6rDwXaAEYDoD9uLv0iJrc1HgsSw+YdZy11a7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMFJjj18iqrQ5SYU90OBvu8rSMZAW6SUBdwtfnh+oftfEfk6ffN9g9dVo+98HOc3H
	 cxC62ZZM4Q1FtWdrwjwr0olxYNO2s4nnQtMmJQpVFJWPronrI/3/Tgy+gG2BgBZlqL
	 VjsFSHMaarRzqWgGwNbVOGYkFIPVqcvp/71HOnGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22c3218a6fa219e47321@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/456] net: remove WARN_ON_ONCE() from sk_mc_loop()
Date: Mon, 17 Aug 2026 15:33:01 +0200
Message-ID: <20260817132554.708619580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b8a39a09ae4eaae04309e1e38ed6a1101d967496 ]

sk_mc_loop() can be called for sockets that are neither AF_INET
nor AF_INET6 (e.g. AF_PACKET sockets when sending packets via raw/packet
socket over virtual devices such as VRF or ipvlan).

In such cases, sk_family is not AF_INET/AF_INET6 and sk_mc_loop() falls
through the switch statement and triggers WARN_ON_ONCE(1).

Non-INET sockets do not support IP_MULTICAST_LOOP or IPV6_MULTICAST_LOOP
options, so loopback should default to true without generating a warning.

Fixes: f60e5990d9c1 ("ipv6: protect skb->sk accesses from recursive dereference inside the stack")
Reported-by: syzbot+22c3218a6fa219e47321@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a72024c.13623e66.bdc14.0019.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260804152048.2134341-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bf2bec10d5d6a..e5f8916aa85b8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -724,7 +724,6 @@ bool sk_mc_loop(struct sock *sk)
 		return inet6_sk(sk)->mc_loop;
 #endif
 	}
-	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
-- 
2.53.0



