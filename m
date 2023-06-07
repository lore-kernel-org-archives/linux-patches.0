Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E024E19E58
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFC2C433D2;
	Wed,  7 Jun 2023 20:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170351;
	bh=yWGy8ZGyrzMYLtP2DLZn6PidiKx2wqyt54dSSwUJnhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrYKhnvv9A1JcR1POwdeuu3SeaDZX0Sf2A2mGaE+s3gUiIkFSomYjzR1zr9AQvg3k
	 eyc8GheGxwCIj5aFm4LT1aTUmHDdMzLPsKbWOorqrzhrDmVVVO3A55sF20BPFqc3HF
	 +M8B38Z+785VPo2x1k58a9Ezqsr+Dl63RlE85mqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/225] tls: improve lockless access safety of tls_err_abort()
Date: Wed,  7 Jun 2023 22:13:37 +0200
Message-ID: <20230607200915.111773595@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8a0d57df8938e9fd2e99d47a85b7f37d86f91097 ]

Most protos' poll() methods insert a memory barrier between
writes to sk_err and sk_error_report(). This dates back to
commit a4d258036ed9 ("tcp: Fix race in tcp_poll").

I guess we should do the same thing in TLS, tcp_poll() does
not hold the socket lock.

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 4 +++-
 net/tls/tls_sw.c   | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index da95abbb7ea32..f37f4a0fcd3c2 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -20,7 +20,9 @@ static void tls_strp_abort_strp(struct tls_strparser *strp, int err)
 	strp->stopped = 1;
 
 	/* Report an error on the lower socket */
-	strp->sk->sk_err = -err;
+	WRITE_ONCE(strp->sk->sk_err, -err);
+	/* Paired with smp_rmb() in tcp_poll() */
+	smp_wmb();
 	sk_error_report(strp->sk);
 }
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 992092aeebad9..2e5e7853a6101 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -67,7 +67,9 @@ noinline void tls_err_abort(struct sock *sk, int err)
 {
 	WARN_ON_ONCE(err >= 0);
 	/* sk->sk_err should contain a positive error code. */
-	sk->sk_err = -err;
+	WRITE_ONCE(sk->sk_err, -err);
+	/* Paired with smp_rmb() in tcp_poll() */
+	smp_wmb();
 	sk_error_report(sk);
 }
 
-- 
2.39.2



