Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9980917083F;
	Wed,  3 Jul 2024 10:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003773; cv=none; b=QLYEEotfGSRKoKzFQhaT2ybJ94UcVMjoKBv1/kaOwiG8VPHKFCIDsqCbUkXEyzj3pfJawAHu6PCQ5jaRimKWmrPgRKk+qD1oeQCaESIsj4Qh9dbPyVSwH13nEpDYYk58eSePDXPaW8esjSPjAQbo1eoPLj+rw56eVrdSqYF1N00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003773; c=relaxed/simple;
	bh=JrCxKKUVYzURNTgCyP1TEYrrhoIeiiBG4df8M3FbyMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuK6rtmgZIa5cTXIIf0JODBclZ8NAVulUzBDctPNtMyMjQTM5UyXw/EFL+DnYhnkS/TwHLRfURgNV5J3wfba6X3Q9OImD5Hbg7FMEAbssfHKQG4JcxMKfHEdVRckDgRIVL3MS1HCglaEgUfR2UNkPyyWm3crzkeOvclWTg0zsXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWg6Ld5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWg6Ld5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C40FC2BD10;
	Wed,  3 Jul 2024 10:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003773;
	bh=JrCxKKUVYzURNTgCyP1TEYrrhoIeiiBG4df8M3FbyMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWg6Ld5JKM9YVYzR4/kHpzxm5DJXwZhhAjLruBLIHq0gtRU+D8OwE+fegiYZCJmv1
	 dV34OIK1dquxCCB8D+HuF+TqadluLajIMUWztEiqnAOXOWcmWM7bxJg24raYqWRaS9
	 5/1ifBSI1VAH9FG9YQpjefn+iU+f7+dZFLPgfnco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/189] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed,  3 Jul 2024 12:37:59 +0200
Message-ID: <20240703102842.190998488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0611ff921421e..ec4c462a87f06 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -807,7 +807,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
-	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
+	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
 	u->inflight = 0;
-- 
2.43.0



