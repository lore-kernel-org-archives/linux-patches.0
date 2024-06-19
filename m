Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22017D08F;
	Wed, 19 Jun 2024 13:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802036; cv=none; b=VPGsavKYvgSdHlSItQFZ9cqUEHQIGFlLISWYf91JmkLQpTQqOyoGstIao09DAfZTRUry5uHmCBR0IzatEaBEU5UQS2AyyTRtKHGUS6jrl21vymcKe9eGJB6u8plew39HA0ukFrsv/pWuBZSs2HYjrgUeyePMQlBETXiWMsbS5Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802036; c=relaxed/simple;
	bh=U2rLwJPbukXWcG4AQttOYLKnT/O4gOxO2xKGgb2UF9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkPzhkDipe8DwRaJJ3eMTek5qeu8LobI7tQNhZCCCKgrRM84aH/V7WsJMRbjYMMOK12uIGkR3OW3roZoQc68j5aAi3Sa/u/a/kflFn0aeIVN3aerCI0XhRYEpqnTX5NkjJ5TEZYxatrBTiKdr0WA3W6/rgxeT9IQbqzYeDfMFk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbK8pncJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbK8pncJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57675C2BBFC;
	Wed, 19 Jun 2024 13:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802036;
	bh=U2rLwJPbukXWcG4AQttOYLKnT/O4gOxO2xKGgb2UF9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbK8pncJRqo3KuJOET96+OUbxqRHvlxBJT5mQ+baQKW221wNwW7yRY5MmpLTtzff2
	 UnLPiAsdFDR+FpMB84hoOzmVxbTAJkJgp1o8RjtI3ZLGl+Q7/ilWovl5jFTcug/+N2
	 vO+ag07wEZuxBFRR61HAMO76AG7NpnLM1LJJoD04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/267] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed, 19 Jun 2024 14:53:32 +0200
Message-ID: <20240619125608.702072784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



