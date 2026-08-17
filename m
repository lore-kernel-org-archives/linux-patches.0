Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A01303C97;
	Mon, 17 Aug 2026 14:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976320; cv=none; b=INKFyKX+8NzXpH0ikYMYsRs1qdjvIcXrtWvBx4u6hzVCUSAH7XLdcnu7gVrrQG5TYHl0c8GWGSkjec8CMTPyVZb9e/0ZONWjp4t5YQ0MxKh+5j9riO+lJnuU4BqVcqDmNmpyQ6DspgjqtBlTJ3ckJvURICZCXGTAm/uov0RBhd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976320; c=relaxed/simple;
	bh=Y5ytszMThPJTlKhdVvrN6J6NKQhK50N3r7xqKnTW6uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS1sxYD1wFFwz07/Rw+LQxjJ1B2P5EOvl7sqWdTh2sXplkMzz6551mUjo0cXlhyOGssiipd+bi7tffOjkAWZ++PcAXR1Fjecr745/0OkSh5oM4AA99PLES5CUzR49sdysEMte/KQSlXr40+rfViwrBcR6ieuDoRN/V6ZVjm5f/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYIXdCap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYIXdCap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97701F00A3A;
	Mon, 17 Aug 2026 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976319;
	bh=3cKxWw1BnHf124ftOWawJGodFW44jyJqUstw+GlLcV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYIXdCapFmykr0B2j8Do34sUJX4r7NHTVSJHu6kuV3kXJj78yhYu2Ze6c8kGc7w8O
	 MgLF9rrTqVtrJFpKwVa5EAkc053X2Et0j2qwk388xHYIf7NxLMhsqRUx0oRNO0XxJt
	 6NLeP6/d2vbeNA1lNYr27Ad7/MC9YzM+kaS2ten8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22c3218a6fa219e47321@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/389] net: remove WARN_ON_ONCE() from sk_mc_loop()
Date: Mon, 17 Aug 2026 15:32:52 +0200
Message-ID: <20260817132551.865962484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 963ea323362ad..b51a154ec5913 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -699,7 +699,6 @@ bool sk_mc_loop(struct sock *sk)
 		return inet6_sk(sk)->mc_loop;
 #endif
 	}
-	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
-- 
2.53.0



