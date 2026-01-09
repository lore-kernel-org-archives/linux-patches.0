Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B3C32FA3D;
	Fri,  9 Jan 2026 11:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959390; cv=none; b=PwkGKBjmA+sVefC0OEGDnfAcKXJQJi6o5Q8AYQV4507u8gVSID33fNg3TPaXY6KVfjLQcj+iUvqACl0zhDh6pfgfgrAqr1SUZbN9wvm/z3pd2B2pPPJuG73R422h7pF6c7tBI1xDyDs8pzFrKiYXNph6zsEMzuv7D9yUBMFvGCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959390; c=relaxed/simple;
	bh=u+yuu3MYSLcaTbvoJ3uvz0awBoENN8o1iljvgkHYr8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyNwefqOpHl+pGbhrLlxhuWywGnB6Unv83ki6Qymd7rF3Ix+EJqr7wfSpYAB4GxAVptD4DGJd6tzTKE3/0hs65UeClfabbLkHZ4OV+CgD/Y+jr7GrT7qULorwJqfkK81Ja17uNGMTeIwI66V/cmER0rlUF7JeCJ9H6t+5DNbNFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixb8CqmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixb8CqmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED984C4CEF1;
	Fri,  9 Jan 2026 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959390;
	bh=u+yuu3MYSLcaTbvoJ3uvz0awBoENN8o1iljvgkHYr8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixb8CqmIalunaI9fDP0YLgk37lnfEtPU2hdHslrBgNROqAmeAZ8GeFy6144TRWcxc
	 jXtBBOChmp+bHDjNA8xeGM6fwbcCN/WTHzEONO8Jxw0/ny/i4CEV7SeU2Wu3mXG+Zz
	 2Y4n+iVOcopeRRsD0s8eiHCbBl7LqczANIvdCiN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6641a61fe0e2e89ae8c5@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/737] xfrm: flush all states in xfrm_state_fini
Date: Fri,  9 Jan 2026 12:32:23 +0100
Message-ID: <20260109112134.155936457@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 42e42562c9cfcdacf000f1b42284a4fad24f8546 ]

While reverting commit f75a2804da39 ("xfrm: destroy xfrm_state
synchronously on net exit path"), I incorrectly changed
xfrm_state_flush's "proto" argument back to IPSEC_PROTO_ANY. This
reverts some of the changes in commit dbb2483b2a46 ("xfrm: clean up
xfrm protocol checks"), and leads to some states not being removed
when we exit the netns.

Pass 0 instead of IPSEC_PROTO_ANY from both xfrm_state_fini
xfrm6_tunnel_net_exit, so that xfrm_state_flush deletes all states.

Fixes: 2a198bbec691 ("Revert "xfrm: destroy xfrm_state synchronously on net exit path"")
Reported-by: syzbot+6641a61fe0e2e89ae8c5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6641a61fe0e2e89ae8c5
Tested-by: syzbot+6641a61fe0e2e89ae8c5@syzkaller.appspotmail.com
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_tunnel.c | 2 +-
 net/xfrm/xfrm_state.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 3645ab427e128..775ae1171ef89 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -334,7 +334,7 @@ static void __net_exit xfrm6_tunnel_net_exit(struct net *net)
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	unsigned int i;
 
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	xfrm_flush_gc();
 
 	for (i = 0; i < XFRM6_TUNNEL_SPI_BYADDR_HSIZE; i++)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3d806492e1de9..5396fe6b90c66 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2982,7 +2982,7 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
-- 
2.51.0



