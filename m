Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089CE17B434;
	Wed,  3 Jul 2024 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003329; cv=none; b=KycRir39OsKAreEtjuzM8LPxqGxazQtG2GZXoxXtx5HJILp3n0dOYxhGJrQgaiT9Y6L5tM9rYAB9F873KkwexNF8i9KfhX7tPpMcY+Df4NRUmJ4OdzZ58vbDxQstFxk86pSdybgQy4k10/gXxd4P6Gua4KdyufNg+YRZGsPwwb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003329; c=relaxed/simple;
	bh=KIn2TKbwkmzjC6+485EYr3UkQC4wfuCEvdUtoviGw2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csfV5yZKIRbPOWlMHzRVho46JeYqp21F7vJeFNYVh+LkhcSelzzyVrSv9S7JbfnCW6XoQ2Bol9DzEJjPNdzgmXWGF8Gz73pTYT7YGTK8wfu4MW7Q807fhHI1GxTrPo7RWTKiDrlfkUsAY10Gtox+JYTJtMXJEGmDnvlvKBaT7OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyREQMxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyREQMxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809B6C4AF0A;
	Wed,  3 Jul 2024 10:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003328;
	bh=KIn2TKbwkmzjC6+485EYr3UkQC4wfuCEvdUtoviGw2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyREQMxnNe48COVJZSBQR39wADy3jFvsRestTqnab9BVWInuXZ+JVLH3iZ0YH3Hu3
	 FNPYbb6WKAQV8IzFbfFaWPBT915fRmvhT2MEskxNUixVFxxF/0ekcsc9SIi/ltFwxS
	 uFnUer6+22AqCwimqNjP6/sgr7xWEUzazdOoDVv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/139] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed,  3 Jul 2024 12:38:30 +0200
Message-ID: <20240703102830.939687264@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c01955ccf6b39..4a4b6d2544534 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -812,7 +812,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
-	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
+	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
 	u->inflight = 0;
-- 
2.43.0



