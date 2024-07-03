Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444FC1799F;
	Wed,  3 Jul 2024 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005286; cv=none; b=NLyRQhzjGo0a738RzKDp21q/8s6/Y56O35I+5+Wn/jhjJg269XEl0FPwL3wwCbfRaJG5wuCif+FzLbom8L82KpgU5bD4fnzRuIGU6FBnMNgjc5H/ieWreItog6rjxlLqwYkTY8lmoAMblcOxSyupDuB4L5rBh/1GYNiI+KpbK80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005286; c=relaxed/simple;
	bh=eXvJFSjMVt1Osbb6Kvy2IruTUnLhVLtdZkbwr+EPpH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip0xDRcpPqxACdSed9tL7EObPXbOTr2YdKCxAKfdr4T7j4yiklnhK8BnvPlDXXnPIr3MMTEF/t4fCrtLrqbvqeiJOFngh33hWuhYVLdWPOnrwqnqBpmRjGGwDtH+aJD5fAPDbeVkyTTVZLwLGT5zhTsYbA/bLS038JSfOxHsDI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5/Jh92Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5/Jh92Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CC4C2BD10;
	Wed,  3 Jul 2024 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005286;
	bh=eXvJFSjMVt1Osbb6Kvy2IruTUnLhVLtdZkbwr+EPpH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5/Jh92Z6ccapbmhRGbwxSso02fGyQu0Ajg4zmtbZMBq9S7MxfH/MLraClzQSZb2D
	 Tzx2FPrmHvnI5xYvAL1YHDLi0ohw0BKC/gTNNSRfO9lmu/nAcZ5nK/BXaTVCaaKQnC
	 2Yxt141GZWY9ntbV71wIxYfTioGC+870vkO+qkD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/356] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed,  3 Jul 2024 12:36:06 +0200
Message-ID: <20240703102914.238312474@linuxfoundation.org>
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

[ Upstream commit bd9f2d05731f6a112d0c7391a0d537bfc588dbe6 ]

net->unx.sysctl_max_dgram_qlen is exposed as a sysctl knob and can be
changed concurrently.

Let's use READ_ONCE() in unix_create1().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -873,7 +873,7 @@ static struct sock *unix_create1(struct
 
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
-	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
+	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
 	u->inflight = 0;


