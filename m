Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D341799F;
	Wed,  3 Jul 2024 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005301; cv=none; b=slN3zJWRHkBzwfnxL6IyDzW8mxZawb/gvWy5koCze3OM3Q+iz+dGAc/FvUjgqXZOzIuy/ydAC+L0CAVNhaXJV33cQ5Z8ZjkqoFZdsQQAgqTYFVCrSUEmGA+0sD8xCd8dNyl203Pohe4Ircvfv2U5eT5xZfJb5Kf5POJOJ9RnW8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005301; c=relaxed/simple;
	bh=r2w9XY4JmW3yW0MlIuLqwBuoJPKKaQaQ4E+kzESbb90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llZyWiAQKjLQqkG4XxccG3vq62zSxd8UU77ButI4/ShIGyH5MzkFovTNYv4iJfzSsjaCyg/zr456/XQvSRIPlQp9kkAQR34WYanebHaSDttgb+QPJbHFK+1FyZCl3oOFJsTgpshMF5S6f/FqdqfGvw2m0jlGW/E64VOjeWgRixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luePAexy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luePAexy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D730C2BD10;
	Wed,  3 Jul 2024 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005300;
	bh=r2w9XY4JmW3yW0MlIuLqwBuoJPKKaQaQ4E+kzESbb90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luePAexy+HsdxrzFBMzgTV39W/x+aI3rLjoTJ8qJ4a9tkh7DNLE6Y2K+VtJzCjhYn
	 dOgDd+aMlAXpmsqIR5eirhO6ZhEGgYYymjeHUck7zO8Juom4tSdxtRbFlTQQ2tgH7J
	 ytrRosP4FoYf6IDhzpjL0SuzbxA2VV6GnjLygCDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/356] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed,  3 Jul 2024 12:36:11 +0200
Message-ID: <20240703102914.425196399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/unix/diag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -164,7 +164,7 @@ static int sk_diag_fill(struct sock *sk,
 	    sock_diag_put_meminfo(sk, skb, UNIX_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
-	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
+	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, READ_ONCE(sk->sk_shutdown)))
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&


