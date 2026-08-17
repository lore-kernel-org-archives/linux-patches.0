Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C34399F8;
	Mon, 17 Aug 2026 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978475; cv=none; b=k3o/DYMBL4brbZMHKRB7FAxx/W9xnzer86cK419UPeDronX8Pzc2tNHhdouU4pzlROlA62qVhiOKL534bvDCN9V6ZNzKdVjPRBym03W6Ad0vMsBRMf4qjE01k/uS3lPiqHkapcovSowQ8n50+fG8zPX4IUwSy+qUNiUiwGqdYKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978475; c=relaxed/simple;
	bh=ohE5EPTUERhn3NGJHwRlmnJGWsemlIzbuEL/mMd6JJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8tt7fj+2EdwNsRiOjDBEFVC/vITh2gt/7VDkqPCAbIhkEbxRnep64KV0srrRlb8YyL7yq3JEI1iZLKCwsHMnSJW8IsETXGUNnjQKyY1NoYXAcXI5/CIJvv1sBtmDle9Oy6Ahon8uYRr7zSyiEE64/vsgF4b3a8S0a1I6Vl3Nik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrMoTeol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrMoTeol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080721F000E9;
	Mon, 17 Aug 2026 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978473;
	bh=czMy6j+olyWiJ14kT2Ja37CiFr9lPm7/6+IAvRWpbsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrMoTeol/8BiNDt2D2YyJ4NEgQKuoXp71nWWgpjAmtdt/c1zdWcaClVvImAGD0D3v
	 U5cAMSrWYoJsSps/PFBMfyxt+/DD+qTrZ1mmuoS9clfjhAJLgaPSUScmksUt6yj4yO
	 leIOjFR5r4eiS05d0icaW4rRZrZM8+cBz4StYilI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22c3218a6fa219e47321@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/156] net: remove WARN_ON_ONCE() from sk_mc_loop()
Date: Mon, 17 Aug 2026 15:33:04 +0200
Message-ID: <20260817132536.551178595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 87e6060c8bca7..846e95805c199 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -776,7 +776,6 @@ bool sk_mc_loop(struct sock *sk)
 		return inet6_sk(sk)->mc_loop;
 #endif
 	}
-	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
-- 
2.53.0



