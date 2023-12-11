Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458AF5101A;
	Mon, 11 Dec 2023 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6cecbF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD25DC433C8;
	Mon, 11 Dec 2023 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319351;
	bh=X8L2aLsAf6j3Ax7MXnmjzwUZxGELwpAIJH/t4cybVxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6cecbF7LkBMQ4Qko0GqGeOBonUX4CKDlyIq530RvDlaJtc6/Icf9bId+N5IrgyS/
	 hgIAWk6IXpVcV6m38mYeksGxlVGMrMQnQjruqK2Lf+Yh86CM+RollxYjHH4LTkE7ws
	 okCP5IF8aGR1V9NZkV4dqIpIiir7DXWlTNJdw8qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yewon Choi <woni9911@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/244] xsk: Skip polling event check for unbound socket
Date: Mon, 11 Dec 2023 19:18:56 +0100
Message-ID: <20231211182047.748213248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 55f8b9b0e06d1..3515e19852d88 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -919,7 +919,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	rcu_read_lock();
 	if (xsk_check_common(xs))
-		goto skip_tx;
+		goto out;
 
 	pool = xs->pool;
 
@@ -931,12 +931,11 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
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



