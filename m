Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B51257AD8;
	Tue, 25 Mar 2025 12:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905713; cv=none; b=lUQSwc/kpxJ342aka7BF222EC8gFQjuI9EFv6ULh1+lu2tshB87zcJdoIzA7Jg07DlZpTGo4gyAWbNtMtsYnJCPK8s+YHsi7fi0DAIZbHm7BPR4Ws1gpfWTJYDNCPIXvaTr4hEQDo03gTIzBPCRn/QUmK7hO5xaRJrECesFWD04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905713; c=relaxed/simple;
	bh=0ZKTG1Pyjjs2AFiGaaFLpgF/SgiO1lvNWwbjTzazT+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pw7VsbiipF6VOWzFb+D+PRWzyX+dwlIbP0c+mjsxxzQrqG+UFsopOPSQgB4rY9F2TDkkqYIXbkLLcvhr3ZeQ5oMAww4H/hUaMaA0SpGcYKhYqhIr5bUlDqzIell68yVmeCWNXgQvbZQHiPGpMWVJX4a+mPxuD4U/lppR10GImpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo3hfQI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo3hfQI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85179C4CEE4;
	Tue, 25 Mar 2025 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905713;
	bh=0ZKTG1Pyjjs2AFiGaaFLpgF/SgiO1lvNWwbjTzazT+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo3hfQI4irUd/gnbVXZ8IpZ16BMtTDF4WlzR+tvdcHvQmtYUpSQJtRF462IIuKh2c
	 md612iBWd9HUVbbMEN0yP/7/gr9jmjtZSe2L48Fy9A6Ytlt0Kfxv++THW7yg8Es0Pt
	 pFF7ylMutExbAKEm3/xm5sbnC5TU5WNlEwBKeAw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Youngmin Nam <youngmin.nam@samsung.com>
Subject: [PATCH 6.1 123/198] tcp: fix races in tcp_abort()
Date: Tue, 25 Mar 2025 08:21:25 -0400
Message-ID: <20250325122159.880259357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4755,13 +4755,9 @@ int tcp_abort(struct sock *sk, int err)
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


