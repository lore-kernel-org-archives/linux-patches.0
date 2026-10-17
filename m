Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519A439934B;
	Sat, 17 Oct 2026 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258236; cv=none; b=utaGHl9rPAFKweEBz4qRo1WGpA72Ej1/Q2MmyYA6IAXxSjFTEyw9QerN9o4tKYXMLkuNhYgi9+MYg2YFa5/M+Jq85oCGQj3ObjV51mGNfwkkinXui4+GHtEopbNCt9sef8IrC/mXHUKqavAbW9kzZzta45m4VmsmqbveVoGRm78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258236; c=relaxed/simple;
	bh=ImigujwoPHsQJ9UfC2fF1nmIpLS5uMKl18K+VpvIzLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq4kVCe/8r69ygo5MVZXzt93n8B0yEaNy5Bt2OG2rED+DiZ099KacjCY1sqqaTqU+5rFHUvDS5SHrSs7g2xnrI3c5dde77+yJZEh/BqRro0tJ4Bmzws7GfhYQl75OnnFMwTMH1W2DuKJodksJiifFhvOoNWwkK7RdKwMq5u93+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef0SmtC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef0SmtC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFE41F000C4;
	Sat, 17 Oct 2026 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258234;
	bh=RjKp2bjHOCSTluVK5+sFgvtvwhnXdoIPK0JqTu19VyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef0SmtC1KQfwa2n+CsxfCb96QdJ/Lmh3n0lN06P7Y2WCxQvUZ3obrB9ykW4vqsZAA
	 Y8Ju2JP3WYTOVMKVJFMmRr5kBEx2qBWhvi0sTNfvRbC9TIN7XryYR50wEw6f+sBQV2
	 5IauFy0hacYbfYl8NS8fK4TpgIZE+V6nxsipXM5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0817/1674] tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()
Date: Sat, 17 Oct 2026 17:51:29 +0200
Message-ID: <20261017160452.093970431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit b62a59c18b692f892dcb8109c1c2e653b2abc95c ]

Use RCU to avoid a pair of atomic operations and a potential
UAF on dst_dev()->flags.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index e874ec597014d..d36a1ceb75101 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -575,11 +575,12 @@ void tcp_fastopen_active_disable_ofo_check(struct sock *sk)
 		}
 	} else if (tp->syn_fastopen_ch &&
 		   atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times)) {
-		dst = sk_dst_get(sk);
-		dev = dst ? dst_dev(dst) : NULL;
+		rcu_read_lock();
+		dst = __sk_dst_get(sk);
+		dev = dst ? dst_dev_rcu(dst) : NULL;
 		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&sock_net(sk)->ipv4.tfo_active_disable_times, 0);
-		dst_release(dst);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.53.0



