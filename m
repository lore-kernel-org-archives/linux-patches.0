Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304FE2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC43C433EF;
	Sun, 22 Jan 2023 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401309;
	bh=LE0OPN2qfd1uibOfhO/F1alfbUuDPS6EWXNZYFNh7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkwbwCHls/KuEjQnTKFplIYNk2dWjD+d5TxF+qbGiEmohkJirRQagFaYDkRHUzQtL
	 JnwM2Zbjstqw9Wrvafhib7nEsJSKl+Qmx+uLHMPqC72gjkGHeBCGtwNQVDKu5wIe6+
	 J9lEF2ZLBUFAb5XlRqBKQHL/LJQxHuwYyyvvC3hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 188/193] net/ulp: use consistent error code when blocking ULP
Date: Sun, 22 Jan 2023 16:05:17 +0100
Message-Id: <20230122150255.006458698@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit 8ccc99362b60c6f27bb46f36fdaaccf4ef0303de upstream.

The referenced commit changed the error code returned by the kernel
when preventing a non-established socket from attaching the ktls
ULP. Before to such a commit, the user-space got ENOTCONN instead
of EINVAL.

The existing self-tests depend on such error code, and the change
caused a failure:

  RUN           global.non_established ...
 tls.c:1673:non_established:Expected errno (22) == ENOTCONN (107)
 non_established: Test failed at step #3
          FAIL  global.non_established

In the unlikely event existing applications do the same, address
the issue by restoring the prior error code in the above scenario.

Note that the only other ULP performing similar checks at init
time - smc_ulp_ops - also fails with ENOTCONN when trying to attach
the ULP to a non-established socket.

Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Fixes: 2c02d41d71f9 ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/7bb199e7a93317fb6f8bf8b9b2dc71c18f337cde.1674042685.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ulp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -139,7 +139,7 @@ static int __tcp_set_ulp(struct sock *sk
 	if (sk->sk_socket)
 		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 
-	err = -EINVAL;
+	err = -ENOTCONN;
 	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
 		goto out_err;
 


