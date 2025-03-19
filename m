Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CC21DED4A;
	Wed, 19 Mar 2025 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395177; cv=none; b=IEMqTk8UqFYlfQgElsc/425GvCkt9ZkvZD+B3oacQqySv6d8WMqhUR8uNANhHk54NEeNJboTqm2KCQqImSmhxIFapSmaQ/gAASVfSHZcGjCXgWm4GZfoGVSyvcl1IOfepJ/iEXCgU20oeJAaK9NBK9kOm13q4rfzm8voMLaRZRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395177; c=relaxed/simple;
	bh=3ZVKPlpIvJGxo1tktWA3C19RWDN0ZVO5CQm7DCGM5As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hgbm/8YnF0Omc00Z+xOKCcNS0fyxD6/ngg0TnJ0YZfCcBol5NlNjwdi3nPHx1RGfSFmnBjF+0JvuLPixOKHERPay57QgCdrtyt+VlUrSDn3HQuCrW4fN5EK2hf7flIaV74kw3yX5UDbBrf9SB9Hezoef9woclEyodU2A1S95+XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmqCd+LK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmqCd+LK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E59CC4CEE4;
	Wed, 19 Mar 2025 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395177;
	bh=3ZVKPlpIvJGxo1tktWA3C19RWDN0ZVO5CQm7DCGM5As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmqCd+LKTqMLqF88/SKa9856eVhfpEOtzc2kpyR0GqG8IZGjpJ5CszA0Vgc2HQ8Rp
	 RlL5qY2NPorYoQo+TIi3nXcGVTzaHstML3DFc26DxWw4f2acTMnWU3NfcWJV32UMtl
	 v5W7eYYbjzQy2AbRtcC04f/o7llPkgTYTYvh2m2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Youngmin Nam <youngmin.nam@samsung.com>
Subject: [PATCH 6.6 006/166] tcp: fix races in tcp_abort()
Date: Wed, 19 Mar 2025 07:29:37 -0700
Message-ID: <20250319143020.154369464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4630,13 +4630,9 @@ int tcp_abort(struct sock *sk, int err)
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


