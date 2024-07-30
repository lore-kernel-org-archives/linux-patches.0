Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F8A1A6186;
	Tue, 30 Jul 2024 16:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356702; cv=none; b=U3F+SvuEf7Pzlbt2OzBSphBRNzyB1cDNx9cPdETEuCaiOYiXUVb/kMdh/05jyMOXRKisaZn393ncCibOyBgoUBtEP3zvfD1r2PIwCmxqEKzNYqZfRYHx1I9FSiwCD9WV+H9AgXkVYpVJxrZ3RSHNc5d/9tMkX8uNse48DrAoOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356702; c=relaxed/simple;
	bh=OY2f/pkRWlPsbj/2yw7jQaMhmcsLuT0wbvy4a04zVCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvuA6U2dFZyoSQmkM0o11dCLpHPPyaQMwekmSsBTJRJVy8CXrGWHKt6Dmzvetag3MMqR96EGl3OEY3fvIXFQbmabwLv6Z/WfvQH8G2qQPpZT+QillJwGwDCC+0kNRzu8fr36kDf6ay4vdcL2UZQOEUcAPhppc+0XSnceJks259o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q74qZrRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q74qZrRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCECC4AF0A;
	Tue, 30 Jul 2024 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356701;
	bh=OY2f/pkRWlPsbj/2yw7jQaMhmcsLuT0wbvy4a04zVCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q74qZrRtBevWKICMGI7K8UlvuAjMMhO9AeBv5k9ioFqeNDuw4NfWP/XQO9XFPYazV
	 VAZ3v4LRe7ofcor+ZrzCVbWNY0+RnJahoIukOv1Zr6ZVnbOgyFyaJrK9SrgQF9gZ5l
	 ciS0QRtIQMkTWniQ0dFaoUjFFfzVsP508Ff7krNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 175/809] tcp: fix races in tcp_abort()
Date: Tue, 30 Jul 2024 17:40:51 +0200
Message-ID: <20240730151731.515616382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5ce4645c23cf5f048eb8e9ce49e514bababdee85 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cc36ff797484b..ec6911034138f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4583,14 +4583,10 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
-		WRITE_ONCE(sk->sk_err, err);
-		/* This barrier is coupled with smp_rmb() in tcp_poll() */
-		smp_wmb();
-		sk_error_report(sk);
 		if (tcp_need_reset(sk->sk_state))
 			tcp_send_active_reset(sk, GFP_ATOMIC,
 					      SK_RST_REASON_NOT_SPECIFIED);
-		tcp_done(sk);
+		tcp_done_with_error(sk, err);
 	}
 
 	bh_unlock_sock(sk);
-- 
2.43.0



