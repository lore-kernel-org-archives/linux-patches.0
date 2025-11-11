Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C2525D209;
	Tue, 11 Nov 2025 01:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823632; cv=none; b=rd9Jeo+L9ewfqyDLvj7gF3UDONV7v/udwxEX9FoY/xfv2s8ew4lhfkJzpac/mbXzHjGLw8bUUSyC0D14+SCtBGdcN3NjAL+TWYJNfTnov7BicLgM86Yf3krCoL33+c66HlIY4y89s/hPDD8hzXjrNgwzlNtCK1RxqQvUXI/O0rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823632; c=relaxed/simple;
	bh=TboICJPvuCnUHM8FDxaBtaaWxC25mmV/jduLscEoawo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYEjE33X/hRB+DQKDHWQWkUlqmCAAXWyz+BtnuvwXIJNsHCaWEWPcVVyNf7gPEHBhVRgg9xc3wYuvxXu3JUrb7Lr39+YC3g/0zNoFNeQrlhqNJhWN7neN/Ptj6FkbTHLekOBHpYBrk7Nr/l0B1LyrZIPhmkMC13BByXeLafz7ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gn8wvORC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gn8wvORC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5088EC2BC86;
	Tue, 11 Nov 2025 01:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823631;
	bh=TboICJPvuCnUHM8FDxaBtaaWxC25mmV/jduLscEoawo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gn8wvORCrnvHSN5sJd5xdZlYXCEZ/fn3IzsVdVFs4ZaFepJaEoheZyQv+Oq/wyf9G
	 D0aS4YuvbuJ7LuM0AgNpWCLqkHEGrnkgtbsm/y2EGPyznR23j7iVCQdfKzGg4dRoNu
	 deXW+8qv9nfhPso5DdR/FLTgbOjsz4VGAxs7RYfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/565] tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()
Date: Tue, 11 Nov 2025 09:42:12 +0900
Message-ID: <20251111004533.092397371@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 86c995dc1c5e5..f9460e7531ba7 100644
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
2.51.0



