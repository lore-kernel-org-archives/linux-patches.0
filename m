Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA2A19AD5C;
	Tue,  8 Apr 2025 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112426; cv=none; b=odQXRT8nKKUldajaSRHHQCrcyWYz+/s4Dm6wBfGg2yQdEMZ3D6h6bo7H2/vZYDqOlcGSa35qVXzIT6dJHa5uvirnBq7Q6L9ErVTnbZ/Akl0gXn7WMBT97i5PQRuKfzMVMr1dg0Pd5I8yUY8mA60/XjlmYG90lruhMsZVC98TawM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112426; c=relaxed/simple;
	bh=lR63EVLo9gXJjLM3dyuJUMyG8OHkXzvPFPws0LaB/Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfyJZt025xX1o5tQI3Zcbt8GzskjHWB8faHTP68slhBLOu3ks6B6983VaI2JVBwX/7gCbctOseoXkDLHq6dT1cso5RgDqBA79IOnsLQAVKw41C2w0/aZF/8sfaoH6kDbKEj8jmd3sVr7mkXRDHNoFVNLcytfX3Qqi92Sz3FIm84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yquhnb9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yquhnb9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF81C4CEE5;
	Tue,  8 Apr 2025 11:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112425;
	bh=lR63EVLo9gXJjLM3dyuJUMyG8OHkXzvPFPws0LaB/Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yquhnb9O8COmVbbOcQFIRxMbvuayWz6v7MaJEkNPrbBko1zBijl8NNaY3bTU4abUm
	 u6ak+qRaXTqe8aoylLguZF43QJG7uvODaOk8NdoM9VL/0RfvdY9lb+m4/O2Sq2w7V/
	 gFYdgSIMHGNqJ4eGkHvn3I5YiteNz2SAcLbvjgxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Youngmin Nam <youngmin.nam@samsung.com>
Subject: [PATCH 5.15 064/279] tcp: fix races in tcp_abort()
Date: Tue,  8 Apr 2025 12:47:27 +0200
Message-ID: <20250408104828.071772244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 5ce4645c23cf5f048eb8e9ce49e514bababdee85 upstream.

tcp_abort() has the same issue than the one fixed in the prior patch
in tcp_write_err().

In order to get consistent results from tcp_poll(), we must call
sk_error_report() after tcp_done().

We can use tcp_done_with_error() to centralize this logic.

Fixes: c1e64e298b8c ("net: diag: Support destroying TCP sockets.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20240528125253.1966136-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[youngmin: Resolved minor conflict in net/ipv4/tcp.c]
Signed-off-by: Youngmin Nam <youngmin.nam@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4514,13 +4514,9 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
-		WRITE_ONCE(sk->sk_err, err);
-		/* This barrier is coupled with smp_rmb() in tcp_poll() */
-		smp_wmb();
-		sk_error_report(sk);
 		if (tcp_need_reset(sk->sk_state))
 			tcp_send_active_reset(sk, GFP_ATOMIC);
-		tcp_done(sk);
+		tcp_done_with_error(sk, err);
 	}
 
 	bh_unlock_sock(sk);


