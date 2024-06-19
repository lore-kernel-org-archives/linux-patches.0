Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A34314E2D7;
	Wed, 19 Jun 2024 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803607; cv=none; b=XJTR2EboBav3FAwwVHkOMrIfQnE9wfBfTR59xnLYyIQW2LNSaf1zc8djJM1jBpyog4x64zYH9NT8k7I7DgwI5usJl6Fe6japsqMpvVl4m2qldxVOf9it6q7L7Alv9615ls6PNBJqZuYnZXCCYP5LBD+l7hwARgxogVX/567/gwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803607; c=relaxed/simple;
	bh=+e5WZM8p5Rdce8WBvaDo8INRlSk787khhtEhqRYRhek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed1H4/ldlWmAFm8GD6wS2gvMJETHUet9VfJW7A40n0Sq7+v/fVTR57MV1z5EktODLNMz14p/fMzwOX27EPHbEUg7wnRrhDCVflTB8PYK3TYY/T7lvt/qb80FjqK+n7ShMJe7UoavM9EN0+UC58SYUS9UvKri/gymmTsrggGl3U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhXOLd6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhXOLd6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6146C2BBFC;
	Wed, 19 Jun 2024 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803607;
	bh=+e5WZM8p5Rdce8WBvaDo8INRlSk787khhtEhqRYRhek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhXOLd6CKL3hxOxzJxT1eu6n0kZkd1MTU06rKo+5FyN5n/Z6Ungor3WBmjBQ1ajUf
	 iRW01/N6xz5G158Bl/bYezzmHSHawWYPbVTl0LdaXwPkEaWsfFikJSTkfTOe9czGOz
	 qSe5ddhmgxZsIzbNUqVEgBrURZOcEIDHGYJ3GPsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/217] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed, 19 Jun 2024 14:54:46 +0200
Message-ID: <20240619125558.318852778@linuxfoundation.org>
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

[ Upstream commit bd9f2d05731f6a112d0c7391a0d537bfc588dbe6 ]

net->unx.sysctl_max_dgram_qlen is exposed as a sysctl knob and can be
changed concurrently.

Let's use READ_ONCE() in unix_create1().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f6ba015fffd2f..5cffbd0661406 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -966,7 +966,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	sk->sk_hash		= unix_unbound_hash(sk);
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
-	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
+	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
 	u->inflight = 0;
-- 
2.43.0



