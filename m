Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE5143757;
	Wed, 19 Jun 2024 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803536; cv=none; b=kjjqbzj8RQ9Rc+cWLjFL3PDl2YFX1x8+ho+mZuZVDU5Qw5xurzFVVylsoM35k/RTD3QskkXe5Ow56apQLmPcPFH+aOU3igBnKOsJnhKbgm5EQiMrwN4HfFotAgmChI+EqZqume17Rk82+P+bfe0s84vGVAdGcxiyKIQGmOxqN9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803536; c=relaxed/simple;
	bh=3DlBj+6LdibsvDukbH+7bqgHlGq2/nQ3bK7hNwiK4hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neJmGPfKUqOjRWCJnPzLVMVI9JBWRyWQZ+iMUg2fY2XtgA/ptUJ6bKPWMWiwxMB43fC92dq6D/XdIGNRDzwPFCKGuTnnzCcgWMcpJi37ac1P1VpeqrZaXtAYMrlCmSKjawMKfaNWliKnbFo9vCoo+Hol3cgBBNfFzAgVxnvMXZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfDh0ZlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfDh0ZlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD9C2BBFC;
	Wed, 19 Jun 2024 13:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803536;
	bh=3DlBj+6LdibsvDukbH+7bqgHlGq2/nQ3bK7hNwiK4hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfDh0ZlKmF+jXGCJA8XL9OhZd0HHb8LTvI/sncrHivAkvzQ4xSROpyw3kDC8ve2Wz
	 nm5DlR3HtWHBHbeRIFZ6qMOcSgSK87XwfRMlSFeJ6Wyg1RWq8g0dQAUtWQWwFVAXdt
	 WBjYf5CjJn75pK0Ot8WHsiKvZ9EEnnojSPxOKx9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH 6.1 019/217] net/smc: avoid overwriting when adjusting sock bufsizes
Date: Wed, 19 Jun 2024 14:54:22 +0200
Message-ID: <20240619125557.384908824@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit fb0aa0781a5f457e3864da68af52c3b1f4f7fd8f ]

When copying smc settings to clcsock, avoid setting clcsock's sk_sndbuf
to sysctl_tcp_wmem[1], since this may overwrite the value set by
tcp_sndbuf_expand() in TCP connection establishment.

And the other setting sk_{snd|rcv}buf to sysctl value in
smc_adjust_sock_bufsizes() can also be omitted since the initialization
of smc sock and clcsock has set sk_{snd|rcv}buf to smc.sysctl_{w|r}mem
or ipv4_sysctl_tcp_{w|r}mem[1].

Fixes: 30c3c4a4497c ("net/smc: Use correct buffer sizes when switching between TCP and SMC")
Link: https://lore.kernel.org/r/5eaf3858-e7fd-4db8-83e8-3d7a3e0e9ae2@linux.alibaba.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>, too.
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b6609527dff62..e86db21fef6e5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -462,29 +462,11 @@ static int smc_bind(struct socket *sock, struct sockaddr *uaddr,
 static void smc_adjust_sock_bufsizes(struct sock *nsk, struct sock *osk,
 				     unsigned long mask)
 {
-	struct net *nnet = sock_net(nsk);
-
 	nsk->sk_userlocks = osk->sk_userlocks;
-	if (osk->sk_userlocks & SOCK_SNDBUF_LOCK) {
+	if (osk->sk_userlocks & SOCK_SNDBUF_LOCK)
 		nsk->sk_sndbuf = osk->sk_sndbuf;
-	} else {
-		if (mask == SK_FLAGS_SMC_TO_CLC)
-			WRITE_ONCE(nsk->sk_sndbuf,
-				   READ_ONCE(nnet->ipv4.sysctl_tcp_wmem[1]));
-		else
-			WRITE_ONCE(nsk->sk_sndbuf,
-				   2 * READ_ONCE(nnet->smc.sysctl_wmem));
-	}
-	if (osk->sk_userlocks & SOCK_RCVBUF_LOCK) {
+	if (osk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		nsk->sk_rcvbuf = osk->sk_rcvbuf;
-	} else {
-		if (mask == SK_FLAGS_SMC_TO_CLC)
-			WRITE_ONCE(nsk->sk_rcvbuf,
-				   READ_ONCE(nnet->ipv4.sysctl_tcp_rmem[1]));
-		else
-			WRITE_ONCE(nsk->sk_rcvbuf,
-				   2 * READ_ONCE(nnet->smc.sysctl_rmem));
-	}
 }
 
 static void smc_copy_sock_settings(struct sock *nsk, struct sock *osk,
-- 
2.43.0



