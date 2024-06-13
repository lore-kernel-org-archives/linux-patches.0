Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92753145A05;
	Thu, 13 Jun 2024 12:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281398; cv=none; b=SmMEITXXn4bWYk7cQ0Big/z9rKmplTQyaNKdWyoi9MU6FJznrtXgO6fr2brUtjfk+RK1aRvY8z/LiyoCIA6QoVBV2/f2ledtBKrIxUvd4xefW3X5aSgMAHI1ZawoYJ7Z60c/LGSTdDZU4l/5Vy0GcFC6C2N6nZXmcgUVyjW5jA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281398; c=relaxed/simple;
	bh=NSz+Syag+rlNBhRu6BsL2LXiUbBBWp5dA3tWpBf1e9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpRL00rxposn0SOli9IS2MJJzhvqnrHQjsIP5c98tGOKfhZ//Ky2Rw88YbBMQp+gQLpY+ZClADaboIjApGisax+25YTr2tICtEQJLOfuwseLgA/dWA8QUxaXJsOdjo73aPAdp9qbEOn4I4HSQhl7LkHBAoaqxKGl0xkJ+6CsqvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjCI0qv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjCI0qv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185D9C32786;
	Thu, 13 Jun 2024 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281398;
	bh=NSz+Syag+rlNBhRu6BsL2LXiUbBBWp5dA3tWpBf1e9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjCI0qv3qjpsUaCQ4HLYgBFEbqYMbHJ+nOBPuiB59lcKUnEhaKAixRzLQ+PoPckuS
	 y1II1y1OhVAE5sjCeXkiYZjCu8ro4YXVSOjAbNFeV6mFd5MQ3O8B+xZlOcG9VRQBhm
	 aPu1luh72HC7zZu9SBI4czqrQFPIywlU7s70i5zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yewon Choi <woni9911@gmail.com>,
	"Dae R. Jeong" <threeearcat@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/317] tls: fix missing memory barrier in tls_init
Date: Thu, 13 Jun 2024 13:34:20 +0200
Message-ID: <20240613113256.909693692@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Dae R. Jeong <threeearcat@gmail.com>

[ Upstream commit 91e61dd7a0af660408e87372d8330ceb218be302 ]

In tls_init(), a write memory barrier is missing, and store-store
reordering may cause NULL dereference in tls_{setsockopt,getsockopt}.

CPU0                               CPU1
-----                              -----
// In tls_init()
// In tls_ctx_create()
ctx = kzalloc()
ctx->sk_proto = READ_ONCE(sk->sk_prot) -(1)

// In update_sk_prot()
WRITE_ONCE(sk->sk_prot, tls_prots)     -(2)

                                   // In sock_common_setsockopt()
                                   READ_ONCE(sk->sk_prot)->setsockopt()

                                   // In tls_{setsockopt,getsockopt}()
                                   ctx->sk_proto->setsockopt()    -(3)

In the above scenario, when (1) and (2) are reordered, (3) can observe
the NULL value of ctx->sk_proto, causing NULL dereference.

To fix it, we rely on rcu_assign_pointer() which implies the release
barrier semantic. By moving rcu_assign_pointer() after ctx->sk_proto is
initialized, we can ensure that ctx->sk_proto are visible when
changing sk->sk_prot.

Fixes: d5bee7374b68 ("net/tls: Annotate access to sk_prot with READ_ONCE/WRITE_ONCE")
Signed-off-by: Yewon Choi <woni9911@gmail.com>
Signed-off-by: Dae R. Jeong <threeearcat@gmail.com>
Link: https://lore.kernel.org/netdev/ZU4OJG56g2V9z_H7@dragonet/T/
Link: https://lore.kernel.org/r/Zkx4vjSFp0mfpjQ2@libra05
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 2bbacd9b97e56..ebf856cf821da 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -633,9 +633,17 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 		return NULL;
 
 	mutex_init(&ctx->tx_lock);
-	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	ctx->sk_proto = READ_ONCE(sk->sk_prot);
 	ctx->sk = sk;
+	/* Release semantic of rcu_assign_pointer() ensures that
+	 * ctx->sk_proto is visible before changing sk->sk_prot in
+	 * update_sk_prot(), and prevents reading uninitialized value in
+	 * tls_{getsockopt, setsockopt}. Note that we do not need a
+	 * read barrier in tls_{getsockopt,setsockopt} as there is an
+	 * address dependency between sk->sk_proto->{getsockopt,setsockopt}
+	 * and ctx->sk_proto.
+	 */
+	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	return ctx;
 }
 
-- 
2.43.0



