Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D11B3EB7F8;
	Mon, 17 Aug 2026 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974911; cv=none; b=U4AtclhGVHlceKqynr4HdiJP6m763i7tKWFhDVujDuqHPpNqVE9MD5OTaZ/SOo3xJTjY0K++T0R1WKowr5hvKKg/icsW2PKqaJsnZcjP8ik4IWgZYojuczZtyYfarnZsh0JdT5pGj/NMio5fIvxSk8JNoK/RCYeMxq2anynqkck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974911; c=relaxed/simple;
	bh=+6eyQ0j/bU6xcFiAT82XtIWzsxp2FClBzK/yZ4UCVEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwMIVZDRpclsjuE3miCCteJHrJ/CATaEB9PAcHAVdg+hA6NSTse4OcvZAQN1IhI0Nqb0MmaucibWCVjk0jS3uOE9y/QavUrVnNtumexOXZQoDEdDZF6E2vDemNNJtu8jrIpLv/zjcaDuq/P9zE7wDLS9D3oTJq5ckeKqebj0B3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mA/HVp2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mA/HVp2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237871F000E9;
	Mon, 17 Aug 2026 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974906;
	bh=xxabxowkHx3L/qNp3wW3+KDe45k9RErhxNZfWI2LUic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mA/HVp2brLwWeq/vUelDKMMYBSTNCuzEBoO1SUddk9ydDUk78LcqKpfk6A8gBnppw
	 EEPAkilnId3Pv1T9XK3nAurSdfl5SHYge1WuMFq3CHgr13WXMTPAxRcMeX5ozPhL27
	 G0MVHJnGIa1HE62O7mpUvAMcFk6MqCZq/lwn3dao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22c3218a6fa219e47321@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/250] net: remove WARN_ON_ONCE() from sk_mc_loop()
Date: Mon, 17 Aug 2026 15:30:56 +0200
Message-ID: <20260817132540.390864300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a658606c50e8..b69c574c20ad3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -786,7 +786,6 @@ bool sk_mc_loop(const struct sock *sk)
 		return inet6_test_bit(MC6_LOOP, sk);
 #endif
 	}
-	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
-- 
2.53.0



