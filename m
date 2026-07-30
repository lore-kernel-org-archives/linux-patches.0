Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ED433D50F;
	Thu, 30 Jul 2026 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421905; cv=none; b=aVN9E0kJG/gb1Jmzh09bmDcAYpugEZH/BOr9WTfHSCal1yGKzzh6FOLqiGN0D56KIcHrBXjeZxvgcCfuij0F94mB1IO0CeNVBH6LTEogbsMczNhXWMc+54+hDPEm+6lLor8O+sr2cXTTnswu+sz6vbHra0RyFaSmUesei7Fr/a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421905; c=relaxed/simple;
	bh=mXbvSnU7MBj/P5E4SZX31/jd6fyT/d/YXFZgngsma5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKYvcvtpDo6bIF2Heu82CzSLuHXON6wJ5oZTKusSVFtXSLYPG3QgZ8Npo73PfHVUpflLLpzgmzuEIoiTG5IRc08tbf25bbwY5cKWhyPQg0xsdqkuxTCwj9T4YdKRmYpy8zJbCDTpbRznS5RxGai0q2VkrcCkMoHyvs5ds5oCsEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQEzq4Er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQEzq4Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9EA1F000E9;
	Thu, 30 Jul 2026 14:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421904;
	bh=D3UZS5I1n08pvpZ7wBSu/YEUEZ5B/rrLp1dPtByvRfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQEzq4ErvCPWaX6mMQtPNnxlpS0EDL8Uqoml5Ogki00UAMulfwG6aDYCOUm3OOdjD
	 Y0AdaFePSW53utZJEYq5GYViRYykEiUWXWc63fB+ivUqi9oT9Ei7MwMG8MOyXueW/X
	 eq92pJXx6aSLPZdfsj9/Abve333U6tPA38B8CSUw=
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
Subject: [PATCH 7.1 258/744] net: Call net_enable_timestamp() before failure in sk_clone().
Date: Thu, 30 Jul 2026 16:08:51 +0200
Message-ID: <20260730141449.777735231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0f518381334ca..5714436b087100 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2549,6 +2549,9 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 
 	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
 
+	if (sock_needs_netstamp(sk) && newsk->sk_flags & SK_FLAGS_TIMESTAMP)
+		net_enable_timestamp();
+
 	rcu_read_lock();
 	filter = rcu_dereference(sk->sk_filter);
 	if (filter != NULL)
@@ -2598,9 +2601,6 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 
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



