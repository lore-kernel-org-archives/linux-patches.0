Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824EA2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C3DC433EF;
	Tue, 18 Apr 2023 12:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821528;
	bh=WNWEFS5CsuWrgh/uto+zkswrGyXbcLgIZLOzPBaJG/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwV1aeQC/YBPmPURDjGKy8jQc9Ala62XY2Ux8TyE61ycDG17eWVnb1peem6im8+cg
	 n0cHPYhLjscbHZwPkKIEV21JwWKIalO0OCPZ2WiyUuoIELQnicmDtYIpiZ/mHQU9yk
	 QqH6uCLp2DCMQwBGnQ91O6Vv0sWgsGXr9jLr00Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lena wang <lena.wang@mediatek.com>,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/91] udp6: fix potential access to stale information
Date: Tue, 18 Apr 2023 14:21:38 +0200
Message-Id: <20230418120306.771437689@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1c5950fc6fe996235f1d18539b9c6b64b597f50f ]

lena wang reported an issue caused by udpv6_sendmsg()
mangling msg->msg_name and msg->msg_namelen, which
are later read from ____sys_sendmsg() :

	/*
	 * If this is sendmmsg() and sending to current destination address was
	 * successful, remember it.
	 */
	if (used_address && err >= 0) {
		used_address->name_len = msg_sys->msg_namelen;
		if (msg_sys->msg_name)
			memcpy(&used_address->name, msg_sys->msg_name,
			       used_address->name_len);
	}

udpv6_sendmsg() wants to pretend the remote address family
is AF_INET in order to call udp_sendmsg().

A fix would be to modify the address in-place, instead
of using a local variable, but this could have other side effects.

Instead, restore initial values before we return from udpv6_sendmsg().

Fixes: c71d8ebe7a44 ("net: Fix security_socket_sendmsg() bypass problem.")
Reported-by: lena wang <lena.wang@mediatek.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20230412130308.1202254-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9dfb4bb54344b..921129c3df8ad 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1359,9 +1359,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			msg->msg_name = &sin;
 			msg->msg_namelen = sizeof(sin);
 do_udp_sendmsg:
-			if (__ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
+			err = __ipv6_only_sock(sk) ?
+				-ENETUNREACH : udp_sendmsg(sk, msg, len);
+			msg->msg_name = sin6;
+			msg->msg_namelen = addr_len;
+			return err;
 		}
 	}
 
-- 
2.39.2



