Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BE33A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2SAftMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227CBC433C7;
	Wed, 15 Nov 2023 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077980;
	bh=SmGDb1w8DeTJDLTSdXVybRrHHfj/kbu/ZIZB2nqgDyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2SAftMcwo8EuLg/7z1PqaMDbEl9KWKM/3polGfpLTf202Zqh9YnEsGuLe/YC2sst
	 ql1r19Fs9S/2+BMM1LQkZEgEVK+QBch/1Kwh9JGTO/xiFJbjyFM+NO+1Rm8U0Xil3k
	 hlwpnCkP1jVb/Ke5YuISDfWlJ/HTRNPK/D64YE/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/379] tls: Use size_add() in call to struct_size()
Date: Wed, 15 Nov 2023 14:21:51 -0500
Message-ID: <20231115192647.295299450@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit a2713257ee2be22827d7bc248302d408c91bfb95 ]

If, for any reason, the open-coded arithmetic causes a wraparound,
the protection that `struct_size()` adds against potential integer
overflows is defeated. Fix this by hardening call to `struct_size()`
with `size_add()`.

Fixes: b89fec54fd61 ("tls: rx: wrap decrypt params in a struct")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 62d25f355d2c0..2e60bf06adff0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1512,7 +1512,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	 */
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
 	aead_size = ALIGN(aead_size, __alignof__(*dctx));
-	mem = kmalloc(aead_size + struct_size(dctx, sg, n_sgin + n_sgout),
+	mem = kmalloc(aead_size + struct_size(dctx, sg, size_add(n_sgin, n_sgout)),
 		      sk->sk_allocation);
 	if (!mem) {
 		err = -ENOMEM;
-- 
2.42.0



