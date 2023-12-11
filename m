Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87554437B;
	Mon, 11 Dec 2023 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzD9O4Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F3BC433C8;
	Mon, 11 Dec 2023 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320368;
	bh=GurwGzGqObfE6ReTrVN/CM3CW3i9zyU9PfUYhs17YKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzD9O4NxEeDpTMLkRoaRovVNMKUDZcmvA/CirPV5rVJgj8s1GpNtO8d8H2Ibgj4rE
	 fTduaWulBJi9iG3OHCRa875p/ztuAXsQbx0lq7Fbm7BiRXzayc802FybwbBXiZnSmx
	 LXlEf2eEsK54YS7s1skp0+Agl6tHDMwHXdiU7qho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yewon Choi <woni9911@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/194] xsk: Skip polling event check for unbound socket
Date: Mon, 11 Dec 2023 19:20:25 +0100
Message-ID: <20231211182038.137762413@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yewon Choi <woni9911@gmail.com>

[ Upstream commit e4d008d49a7135214e0ee70537405b6a069e3a3f ]

In xsk_poll(), checking available events and setting mask bits should
be executed only when a socket has been bound. Setting mask bits for
unbound socket is meaningless.

Currently, it checks events even when xsk_check_common() failed.
To prevent this, we move goto location (skip_tx) after that checking.

Fixes: 1596dae2f17e ("xsk: check IFF_UP earlier in Tx path")
Signed-off-by: Yewon Choi <woni9911@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20231201061048.GA1510@libra05
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f7592638e61d3..5c8e02d56fd43 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -722,7 +722,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	rcu_read_lock();
 	if (xsk_check_common(xs))
-		goto skip_tx;
+		goto out;
 
 	pool = xs->pool;
 
@@ -734,12 +734,11 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			xsk_generic_xmit(sk);
 	}
 
-skip_tx:
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (xs->tx && xsk_tx_writeable(xs))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-
+out:
 	rcu_read_unlock();
 	return mask;
 }
-- 
2.42.0



