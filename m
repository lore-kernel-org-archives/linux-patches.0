Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB53B4457CF;
	Mon, 17 Aug 2026 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980303; cv=none; b=dU7KbVLU3/nfq+DIlpW76WTXPddRq+5jvNvCVckRjyW6q4dLZbp2BRzUxPZ3qwk/kXWm8e135/6BDOvSA1vo6C3BQsvmnFctuH8U/a112yUg3Eik/NoAE/8ne/rdNx2HTppScoGgkfNY2Y1sxMqhlXfRi6IUtgvpwLZ1Vfow/d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980303; c=relaxed/simple;
	bh=uDnlfAdP2+wolpLbnf9zAS1osFn0Oc1jYSB0QGgAShE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKDAbav0Tw0qhnZ7qKF7RJiVhrMHbHKjfjkyMZek7U+O/rlFbuZRLUpVQW3AQk1oqY4Yh/DPTpdG6LitP/EH4/pkET8QYEVves7zQRjEfk2CGHm4/QejtvekLm4UizH1WvH27mPH1VXIGWBGH+9yrnbMYBio3BKFuyMpCD+PbDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bK7Vsb7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bK7Vsb7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202D11F000E9;
	Mon, 17 Aug 2026 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980302;
	bh=t31hNfKR/aul2v0XkLYt4STu8MsNBvMEzT6X7glv/ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bK7Vsb7oPG6561bRKJisdEbeKKhVaVpIcHJAO44bWzPXBiHt+lzfIK4JdYvffG5hB
	 LzI2fqeZv/1mcVz1wTYkaijfdg2nAY4WmG5v5E1X5P1muIhOx/CKGRg6g9NhzgNjVh
	 x8YQ9gO3pif+JC3KnhSLOHlVF9vVvIaizKW4+5H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22c3218a6fa219e47321@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 524/609] net: remove WARN_ON_ONCE() from sk_mc_loop()
Date: Mon, 17 Aug 2026 15:33:40 +0200
Message-ID: <20260817132601.347902187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f79f0b78321c..2a701e0b052b7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -772,7 +772,6 @@ bool sk_mc_loop(struct sock *sk)
 		return inet6_sk(sk)->mc_loop;
 #endif
 	}
-	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
-- 
2.53.0



