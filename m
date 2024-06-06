Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DA519AD4A;
	Thu,  6 Jun 2024 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683038; cv=none; b=VUVLxaixO3/WS+BIPijWeS7ZQhhMiz9XYRo1ztSnf08sUhps45rGgZz2DGhXFgx+JBFTsY6Cd4XMIDVuIMDm25O/kYEY+u4AnQeioVGMjPOr054FSPLXRSWBxq+63ptlV6i/RI/K/J+C8T7Aea57B8y0JxROTp8+dcyC0KPel0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683038; c=relaxed/simple;
	bh=bElNPHG+1gVvxrKu2wh9nxbnFFfj+Y7NhYc9yRhq8OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CC/PNsQHOL5w0yieenz4R+VC6hU8ByENM1lOViRgAor3bZLObff15TvNgoaz3V50+TAUPlBs+vhy4WXu/SWW6PdAJHo8W6nxRf25lmR15yJq+2b6I3Dgj+l5Dn6SVaTsV4leK/dnFdOBgyEEiaLWCeQB3wFRL6VkY1MrAjRtB6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQzaDDUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQzaDDUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABABFC4AF60;
	Thu,  6 Jun 2024 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683038;
	bh=bElNPHG+1gVvxrKu2wh9nxbnFFfj+Y7NhYc9yRhq8OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQzaDDUbMA5xfyXM5uqxV2ZF3+1+Y5TQIZvrVTTcuTjihBNmnX51IEhbMsbSyMwZB
	 +qZqC/PS6iu+ZGqY53jlHS9Sxaf/kf+s9Z9ZFei6l7XNIeIooBr2AaJ+ohqwPTksQw
	 o6AuQGOmJsLev2cPIQnYLzbM5c1wgHaNPnvB9oOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yewon Choi <woni9911@gmail.com>,
	"Dae R. Jeong" <threeearcat@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 268/374] tls: fix missing memory barrier in tls_init
Date: Thu,  6 Jun 2024 16:04:07 +0200
Message-ID: <20240606131700.881020639@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b4674f03d71a9..90b7f253d3632 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -816,9 +816,17 @@ struct tls_context *tls_ctx_create(struct sock *sk)
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



