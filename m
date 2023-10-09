Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1D434185
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSsC9N8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68DBC433C7;
	Mon,  9 Oct 2023 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859099;
	bh=W+/W1bCvXY9lEGIno6eU5xiQQhk/8itLepnECbD62Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSsC9N8Id/LBD3HYMKE4P+64AdOYKh85XmBCvCHFOG95grvOA0X6lYsJ5HAb9RY2n
	 +NckhRtNBK4Ct81wlxmMMRgxTsZkqSGJgaglMrUKgnS+Y9gSP5yoME7dZRJdJTgQQa
	 2/OoXE2T9RVmiwRBrjPPrS3t2YP8Myns99odeW4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/226] net: fix possible store tearing in neigh_periodic_work()
Date: Mon,  9 Oct 2023 15:02:39 +0200
Message-ID: <20231009130131.762405444@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 25563b581ba3a1f263a00e8c9a97f5e7363be6fd ]

While looking at a related syzbot report involving neigh_periodic_work(),
I found that I forgot to add an annotation when deleting an
RCU protected item from a list.

Readers use rcu_deference(*np), we need to use either
rcu_assign_pointer() or WRITE_ONCE() on writer side
to prevent store tearing.

I use rcu_assign_pointer() to have lockdep support,
this was the choice made in neigh_flush_dev().

Fixes: 767e97e1e0db ("neigh: RCU conversion of struct neighbour")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 3b642c412cf32..15267428c4f83 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -935,7 +935,9 @@ static void neigh_periodic_work(struct work_struct *work)
 			    (state == NUD_FAILED ||
 			     !time_in_range_open(jiffies, n->used,
 						 n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
-				*np = n->next;
+				rcu_assign_pointer(*np,
+					rcu_dereference_protected(n->next,
+						lockdep_is_held(&tbl->lock)));
 				neigh_mark_dead(n);
 				write_unlock(&n->lock);
 				neigh_cleanup_and_release(n);
-- 
2.40.1



