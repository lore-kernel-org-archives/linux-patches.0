Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E4D7E0E4;
	Mon,  8 Apr 2024 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582005; cv=none; b=HI1KaxcEXKUHVEmYckbhMcxixmh+j3kM2YZKwrFwIjLop+JR++7cPn4GL/34blOTS13M1fwQiZtg+p6pXm3e8zhE2yXH5u6TfZpGHVTPCKzzoBSAU5YEVaDXitbzU7fQNNktrRXhlt1CCIluadiaYupR7ip24+n+7B8SDmGOxKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582005; c=relaxed/simple;
	bh=1WuF6rrDEAh7DSoQuHHNORShHx42n4JduVtiDr8vxnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwvO9mvJu61LXF3Ro2SrkS1iefI/EVD7vNMRKJ5WLbc8Zj08qbWunJrXrPEsmRaFs9OTrlK7BhOMXggGInJ3XOqL58QgGf4VFFYSwkXG3iLoNWo+BLkKad3loJ+pGNgO2Feiisb5JdAGHOqAip2M27gPewFukXKtiyMABakfxgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2QPbtBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2QPbtBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA11C433C7;
	Mon,  8 Apr 2024 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582005;
	bh=1WuF6rrDEAh7DSoQuHHNORShHx42n4JduVtiDr8vxnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2QPbtBuhZOby7wFuy1TvsCqh2lFhs7PlmCoRAaLrr1nXoKDc6hkkdnBPmJE7i/e1
	 ncU1cejZ5aDxUquEjJkzUq5j5WGnYHupfFSN/NNBpsry23HS9fbzD4byN8O2/QK298
	 Vv2Ny30gf/7rEkRnDv/xKVzpLlpLGhKLPyhuS23Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 039/273] tls: get psock ref after taking rxlock to avoid leak
Date: Mon,  8 Apr 2024 14:55:14 +0200
Message-ID: <20240408125310.504966391@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 417e91e856099e9b8a42a2520e2255e6afe024be ]

At the start of tls_sw_recvmsg, we take a reference on the psock, and
then call tls_rx_reader_lock. If that fails, we return directly
without releasing the reference.

Instead of adding a new label, just take the reference after locking
has succeeded, since we don't need it before.

Fixes: 4cbc325ed6b4 ("tls: rx: allow only one reader at a time")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/fe2ade22d030051ce4c3638704ed58b67d0df643.1711120964.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 14faf6189eb14..b783231668c65 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1976,10 +1976,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return sock_recv_errqueue(sk, msg, len, SOL_IP, IP_RECVERR);
 
-	psock = sk_psock_get(sk);
 	err = tls_rx_reader_lock(sk, ctx, flags & MSG_DONTWAIT);
 	if (err < 0)
 		return err;
+	psock = sk_psock_get(sk);
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* If crypto failed the connection is broken */
-- 
2.43.0



