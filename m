Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168114373E;
	Wed, 19 Jun 2024 13:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803681; cv=none; b=MoSIG6Gce/oM4K78F0rn0jdEpkLWGR2YhpCgNOmCU05ZgTZVi1ZmvVWhX6ERhCPPeOnofTEQFsJA9sl6GMRH0EPdEgBgpmskmD+QWss6Ymgc+8wQ3e9ZMk04hU7WZXGL5WgjzTcUhrycWducDm0M27U4u6oKQjcnuvsRUa5j0rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803681; c=relaxed/simple;
	bh=WXtXFOcLARng3twWNeOVBHcerkDW+i32YCfwxGSzLD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLf8FlulGsCxhBnX7qL0jn2KiuhBJ9sy1eGPGIFmzyWMFkuc0bFfOGjgy8PXDA2LR/0miqOc4TMXh0PtMkniKv2cQIZTeTGsp4QKSfYNXgdgkSa8NETGnqgWakaBpeLu9zRYxkS6WlwF1m8GtSobUVmOZmafL3bfVMcdM1P7Yno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olnuwQhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olnuwQhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79430C2BBFC;
	Wed, 19 Jun 2024 13:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803680;
	bh=WXtXFOcLARng3twWNeOVBHcerkDW+i32YCfwxGSzLD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olnuwQhRWS7PA6m7e3OroD2qWPtWqwcQ/idLGzvyk06LUF/DN+Nkei47nny9jYKd5
	 NrdjZ2OcTwQ4wOwBDQ+5LYMB/nf2Oxndxz6+rFcUTRqaT2fwtKqR6h7NC6cpLISljS
	 rSWQGPcuy0OgQ033VYRV9sOgXYSx9weCk/rJZTEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/217] af_unix: Annotate data-race of sk->sk_state in unix_inq_len().
Date: Wed, 19 Jun 2024 14:54:40 +0200
Message-ID: <20240619125558.086970268@linuxfoundation.org>
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

[ Upstream commit 3a0f38eb285c8c2eead4b3230c7ac2983707599d ]

ioctl(SIOCINQ) calls unix_inq_len() that checks sk->sk_state first
and returns -EINVAL if it's TCP_LISTEN.

Then, for SOCK_STREAM sockets, unix_inq_len() returns the number of
bytes in recvq.

However, unix_inq_len() does not hold unix_state_lock(), and the
concurrent listen() might change the state after checking sk->sk_state.

If the race occurs, 0 is returned for the listener, instead of -EINVAL,
because the length of skb with embryo is 0.

We could hold unix_state_lock() in unix_inq_len(), but it's overkill
given the result is true for pre-listen() TCP_CLOSE state.

So, let's use READ_ONCE() for sk->sk_state in unix_inq_len().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 358e80956cb7b..6d7e1cd97c52e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3068,7 +3068,7 @@ long unix_inq_len(struct sock *sk)
 	struct sk_buff *skb;
 	long amount = 0;
 
-	if (sk->sk_state == TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN)
 		return -EINVAL;
 
 	spin_lock(&sk->sk_receive_queue.lock);
-- 
2.43.0



