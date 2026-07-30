Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B3D43F4C7;
	Thu, 30 Jul 2026 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423986; cv=none; b=QbUNEFBS+n/+Dxh+yU7Ce1FeJDQML755myRofVsFj26LdtdDrRYAd80cwqwp8eIHylzuRR12TyJFqoQFxA7L7FOnhcuunKQfTlsKDLcGx+UL9Vz0lObryXB1FWrQUBgDMa8m/bzd4qV+oNOcEN7rftLxJxqYFSLNfJ9J3NJh/s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423986; c=relaxed/simple;
	bh=NAwD2oVJBXSarzKu+sqYj1q3pNe3NPkd5iZ7aGwZ8B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KArlDOaFVx2ZaineVi8/LgrMCjQAaIHRs24+ffzDPqcsXRgEwqx2jVNPSVVZxLBNvUveSwZU2+6kSKHxJ6PoJWAcSO2qBkhzWJ0lqRQgyAAUikUuk786XVt+3FwnCBdST7/39r7eOguppFlOnj1PwvPFsQlPWbw+LccGQobzpak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYuougN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYuougN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0291F000E9;
	Thu, 30 Jul 2026 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423985;
	bh=crlbne/R2DcA575cMrSNvDMJDtB7lKbgLmHXP1iD0vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYuougN2emFENiSGkA0SSRQxnITnw4xiqmlelUBM4vzSvY1PzLwfrhagOgEtwQ+tw
	 gndM33eusLUhPznSsCCurWQFxj2ysQuedvZDjaXuMnyBrReSYBELyTlauHihywqP2V
	 mnCxT1izylLN8yKBDqd66hFVM6wzjAxeFjaHYZQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/675] net: Call net_enable_timestamp() before failure in sk_clone().
Date: Thu, 30 Jul 2026 16:09:26 +0200
Message-ID: <20260730141450.151538366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit d50557779257a00162411e3048d82971ff1f644c ]

When sk_clone() fails, sk_destruct() is called for the new socket.

If the parent socket has SK_FLAGS_TIMESTAMP in sk->sk_flags,
net_disable_timestamp() is called for the child socket even though
net_enable_timestamp() is not called for it.

Let's call net_enable_timestamp() before any failure path in
sk_clone().

Fixes: 704da560c0a0 ("tcp: update the netstamp_needed counter when cloning sockets")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260709032007.9E4D61F000E9@smtp.kernel.org/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260709183315.965751-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9803926942c559..5a658606c50e8a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2527,6 +2527,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
 
+	if (sock_needs_netstamp(sk) && newsk->sk_flags & SK_FLAGS_TIMESTAMP)
+		net_enable_timestamp();
+
 	rcu_read_lock();
 	filter = rcu_dereference(sk->sk_filter);
 	if (filter != NULL)
@@ -2575,9 +2578,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	if (newsk->sk_prot->sockets_allocated)
 		sk_sockets_allocated_inc(newsk);
-
-	if (sock_needs_netstamp(sk) && newsk->sk_flags & SK_FLAGS_TIMESTAMP)
-		net_enable_timestamp();
 out:
 	return newsk;
 free:
-- 
2.53.0



