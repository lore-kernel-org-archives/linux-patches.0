Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66945145334;
	Wed, 19 Jun 2024 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802845; cv=none; b=O7dC8p7p3Bsiy00VL3WLuk2zOt7Sgyiy1rb8CJZYIxAff1xCInLU7jSf5Br/DTMyec5vZOSygIM3wJ1cRGxsmTZJ1tAYmzxjqW6x01I67stEWplTvvItyZK9iJ/GaH0OsLtxRMHcrJqaqTcIIlKCjkzb9UAe3Rmo0C+maH0+z8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802845; c=relaxed/simple;
	bh=I/awBOsqi8yv+BDpqfGRPuWjsskbAoRs6ccN/2iRZNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWPw4lBBfzewZbZpVVJNNknlWghjCEQBRUhScO6uZhIWxnwpe3k8k/YVCgxZGTGcPyJBA53kKOFPmW/iUCiGgDOto4kHef3RAqAwz3Sz0Y7t3iNstQ9psfyqpiDgffV72TAxH2yAnHR7Ke2y3wR7b+aiAbpXoPvBpoGEkvA9ECo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/PPaI4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/PPaI4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0399C2BBFC;
	Wed, 19 Jun 2024 13:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802845;
	bh=I/awBOsqi8yv+BDpqfGRPuWjsskbAoRs6ccN/2iRZNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/PPaI4XwkQ8dKEwEtFQOR0psuU8QGrxdjr42inOOEbD57GYdwWmgNN8pSJN9xym5
	 Pe+Ia/8SYrXcDckhzJ477DfjfMtltUYIfcB3F9OBi93BoPkVIZMmTjMSLLiAJXQBpz
	 USQPYE6Y79e+lBHiV2xvzh54LtbaPFzgxgZmA4Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 066/281] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed, 19 Jun 2024 14:53:45 +0200
Message-ID: <20240619125612.384812508@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 84bc1de2fd967..0c217ac17e053 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -976,7 +976,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
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



