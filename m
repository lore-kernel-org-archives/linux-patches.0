Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC414389C;
	Wed, 19 Jun 2024 13:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802763; cv=none; b=Y/9/xiAl18iyYMlXv4iYcZqn8M5qczCR6HI8bdgJJMzALen3FhXzgjh0yD92W92K2IQoDY/q2Cmbmuvn+AZX0mjoCe1hBz9mLusFL5MkMMd7p+LIUrjdExzcoLuBBvfzLJZhI+DvO1FEtL/Sg5a4XhsVrSVcQR+G5HlSm898tTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802763; c=relaxed/simple;
	bh=tMhptKip71JApJaakFOmpvKiITuVjbFdYpj2Ni+RjQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfcm2vTqcHrHYZeDfhnL/RUNPBzHtFJlYf2TEZko+B9uBC8pMfLvFcb1y1hicyEmrYPxqT5mW8LM51RYqsunaszPZ14fWDbodWFRqv8YyiOGWEKPb8TfI+6sZ3VC/BmndBl5b3SSg3m2AbrzV5HE6h/ONUTc77NhilznadhLp0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IONRr+o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IONRr+o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F61CC4AF1A;
	Wed, 19 Jun 2024 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802762;
	bh=tMhptKip71JApJaakFOmpvKiITuVjbFdYpj2Ni+RjQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IONRr+o2ivtCKBUC3Wvekr4vtgte9PPGDgRfaW8hhSU7xqdKOaMWFqIjHlvVXZo70
	 n1MYsi3hpQY/OicNz/iP67wGgr6TQEIheFz1/Qj5KCF6W4QANywaj+A+88pJz/JT9E
	 VLavqlCxC15Pt+jcB+KoUUeU+jWizlinAEOrWf84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH 6.9 037/281] net/smc: avoid overwriting when adjusting sock bufsizes
Date: Wed, 19 Jun 2024 14:53:16 +0200
Message-ID: <20240619125611.277071273@linuxfoundation.org>
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
index 4b52b3b159c0e..5f9f3d4c1df5f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -460,29 +460,11 @@ static int smc_bind(struct socket *sock, struct sockaddr *uaddr,
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



