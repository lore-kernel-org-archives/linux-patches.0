Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C58C1474AD;
	Wed, 19 Jun 2024 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803622; cv=none; b=TFGtFeIMpB/Kb4kASZ5RsJreuiFekmWU5knZfBtf2F7cg2WvXIhLUS0WS1twi6210u06vRzbyZSN06d437TNc4JtFKHs8rLAB0aGGcSWilTA3K6+leStpWUJZ3Q8H/f0186zJMOObklWZVEX4xbFBgSPyJWZxWyv/mba5S8PtO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803622; c=relaxed/simple;
	bh=3JAvG72JxXU6ErAb6KVtHH0Fj58x69bny2gmqHjdKwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpRfkikrG+H35V4QBHKWRGtejhUYOTBe/Tlb4JnNGPKyY0hXbGfbrMr9HPn6XTrCWohXiM8aEz9UDiQXP3N1fYkOxGSxTejxMTHuPHZzzatUMgrS5FxAR+03QuTorx68oawnEtly0K14lW0tY379jxUAeQzbv/L2E4Zsm8lSijA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHK+n2rS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHK+n2rS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F098C2BBFC;
	Wed, 19 Jun 2024 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803621;
	bh=3JAvG72JxXU6ErAb6KVtHH0Fj58x69bny2gmqHjdKwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHK+n2rSim7S5t+kPYvakxtSM7AFW5e9JOImId+o2ONqcs9bZIuq75DmwKLWtz3VB
	 gezpmwdmb/lazYplPkrbBO94BW0xs4vL19RgrRogNw9VyOYr4XrKCASUAoBRijejU4
	 Sqf/H+tzaUAvefX/ZGNS1HZP//73Hn4ylWGb5kOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/217] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed, 19 Jun 2024 14:54:51 +0200
Message-ID: <20240619125558.517127339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit efaf24e30ec39ebbea9112227485805a48b0ceb1 ]

While dumping sockets via UNIX_DIAG, we do not hold unix_state_lock().

Let's use READ_ONCE() to read sk->sk_shutdown.

Fixes: e4e541a84863 ("sock-diag: Report shutdown for inet and unix sockets (v2)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index fc56244214c30..1de7500b41b61 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -165,7 +165,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	    sock_diag_put_meminfo(sk, skb, UNIX_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
-	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
+	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, READ_ONCE(sk->sk_shutdown)))
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-- 
2.43.0



