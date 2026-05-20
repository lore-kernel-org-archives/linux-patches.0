Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81983E314D;
	Wed, 20 May 2026 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297052; cv=none; b=ptB8Q4CtVEyUWZsLQcILjmi7syLc65BqkqunWaYjIzSqngmWc5ahpZD/KQy5t8tTU6iZXoyXnC7WGvU6uBH8uO+IpbU7yU/Jsmio8lguEe56Em6Z55sk87lcTgo7h5lQmK2VAJd9z8Grfjpkzx4wBFcMr88YoNC9d1gSsXMLRIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297052; c=relaxed/simple;
	bh=R83Jn/DAVbO4TR6K28ikF2DhZzA6VXkn69U3asmoFqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXeRqz+4fKJ1QKcljm7xeBOgNcQbMiMyQJi9TOtcReIpXELUU0zH9406swlDpy+wCUXJd2db7WGvdKFxxUqvNN3Zvx/Ko0j2s/C3gAXlY3/t0zpMhwR6NsYfJEei9EW4yHwj2YnBwVGUrPw71bN6T+E3cyJMyWR0AIPLcbU1+70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD8YC0WU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD8YC0WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181C21F000E9;
	Wed, 20 May 2026 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297051;
	bh=h23EfNRKBwllzyNSqBmacCj58mLfZMMtsDgu3VdLceE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SD8YC0WUasYfhAeqUAj9dK9mT1Qdpen1mUQnYQdnbCUaL1940Ps7L0PSp0LssEnZA
	 LlXoc7Zg+dUcpoezo01tqwdfre0ALTMbqnbf8D3dG2i47ZD+j2GLyRgxuIlUrVmfR3
	 xM820M2Ley5hlGmQiOHW1qIz/FY4QSIfkzb81f3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1031/1146] net: tls: fix strparser anchor skb leak on offload RX setup failure
Date: Wed, 20 May 2026 18:21:21 +0200
Message-ID: <20260520162211.560792200@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 58689498ca3384851145a754dbb1d8ed1cf9fb54 ]

When tls_set_device_offload_rx() fails at tls_dev_add(), the error path
calls tls_sw_free_resources_rx() to clean up the SW context that was
initialized by tls_set_sw_offload(). This function calls
tls_sw_release_resources_rx() (which stops the strparser via
tls_strp_stop()) and tls_sw_free_ctx_rx() (which kfrees the context),
but never frees the anchor skb that was allocated by alloc_skb(0) in
tls_strp_init().

Note that tls_sw_free_resources_rx() is exclusively used for this
"failed to start offload" code path, there's no other caller.

The leak did not exist before commit 84c61fe1a75b ("tls: rx: do not use
the standard strparser"), because the standard strparser doesn't try
to pre-allocate an skb.

The normal close path in tls_sk_proto_close() handles cleanup by calling
tls_sw_strparser_done() (which calls tls_strp_done()) after dropping
the socket lock, because tls_strp_done() does cancel_work_sync() and
the strparser work handler takes the socket lock.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260428231559.1358502-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h      | 1 +
 net/tls/tls_strp.c | 6 ++++++
 net/tls/tls_sw.c   | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 2f86baeb71fcb..a1d8467bece33 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -188,6 +188,7 @@ int tls_strp_dev_init(void);
 void tls_strp_dev_exit(void);
 
 void tls_strp_done(struct tls_strparser *strp);
+void __tls_strp_done(struct tls_strparser *strp);
 void tls_strp_stop(struct tls_strparser *strp);
 int tls_strp_init(struct tls_strparser *strp, struct sock *sk);
 void tls_strp_data_ready(struct tls_strparser *strp);
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 98e12f0ff57e5..c72e883176273 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -624,6 +624,12 @@ void tls_strp_done(struct tls_strparser *strp)
 	WARN_ON(!strp->stopped);
 
 	cancel_work_sync(&strp->work);
+	__tls_strp_done(strp);
+}
+
+/* For setup error paths where the strparser was initialized but never armed. */
+void __tls_strp_done(struct tls_strparser *strp)
+{
 	tls_strp_anchor_free(strp);
 }
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 83e78a3d1e651..23a31646d0387 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2625,8 +2625,12 @@ void tls_sw_free_ctx_rx(struct tls_context *tls_ctx)
 void tls_sw_free_resources_rx(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_sw_context_rx *ctx;
+
+	ctx = tls_sw_ctx_rx(tls_ctx);
 
 	tls_sw_release_resources_rx(sk);
+	__tls_strp_done(&ctx->strp);
 	tls_sw_free_ctx_rx(tls_ctx);
 }
 
-- 
2.53.0



