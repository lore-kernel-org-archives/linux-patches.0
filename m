Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333A416B384;
	Wed,  3 Jul 2024 11:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004480; cv=none; b=kWKtdP24sJ5YqLx/py7S7iar7nO5ZvgTFBri1QYF7b8ybFH4v1Xz/GkzBAyE73p/Mte8vwYcZ8+RX2dRHAtgBUDBeTPg9WS9qXRHA6XFBmfUtfh7DwdBqVGXRimTR1zVg5v7xhMt1Hxog+hhVV7zCapVFrVj8dOyv+yP8yZVgbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004480; c=relaxed/simple;
	bh=O2DO8Kj6wTea+6hg7Mvpcf0h+iHO9gU1P9LwnE5ivDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTInvKLEUvtujkbu/nRqD9pN0pnUI3RmWF5VRDdhkyqIf0TJuRHjaI7zyHtum0LTHSA9xe/0pLJqnobdp3grcUC65KG+foaeWs5PZIeSLHQMFLGz73Vk+h6YlnOSTdhHRHb8h9mpjPt1ogaOPDe8SWQHitfGC9a221udiA7X9Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOcTSLRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOcTSLRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDE7C2BD10;
	Wed,  3 Jul 2024 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004480;
	bh=O2DO8Kj6wTea+6hg7Mvpcf0h+iHO9gU1P9LwnE5ivDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOcTSLRIsmGUHwFFFDINYnfgWWW835+UItvGrNVGULpDX2HZtHCT57WZ1w53XEa9l
	 q0ARPl2AUIjYROFj0K3Wf//YGM/bIWAMuebMmkIqNkZhI/Uuhg7WE6C/Ti39p5Jz4l
	 j0H6JRzwjmSn+6pGAc8oWV31XeC4yyUOJPhOz9As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/290] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed,  3 Jul 2024 12:36:45 +0200
Message-ID: <20240703102905.104793028@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2456170c9ddc4..f1a9b3759d462 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -815,7 +815,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
-	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
+	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
 	u->inflight = 0;
-- 
2.43.0



