Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC5C425CDD;
	Tue, 31 Mar 2026 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975034; cv=none; b=FP6vxzCb4dQ9KaWOaqU1DA6UJv8Gi0Ore0zAM7o6GmPW4BFtP1x7JallfW+zv2G/qBKguOrzIN5dH5bfekzdnmBdBf2Hfy5zs2oZ1OTqpUY5wQYGPNkHbzPo4IKy+MnO5EVWMD5K0RRHlxK/0C+cV44eMZTBY5YLPlTEi2NPJ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975034; c=relaxed/simple;
	bh=CUZjpnr87X7P7YxVHZFZ3Q7P/F13ivX9RRQLO/AYISs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A67seMCWP13pyNLEU1ZMBouTluonY7eTT9zfmWPpSvQxlnA33C6YpKvNTxWKQmJSf8+LllI6y9ubriO59LppUkE1WB1Q1ljzRxqn6BArSAvzVGiVWsXEh8K4cdf8B/JJVi/kuAi/miTS+v9eU1hej6ODmh1Fo0Mg7vKDKf848hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKP6SZDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKP6SZDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8522C19423;
	Tue, 31 Mar 2026 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975034;
	bh=CUZjpnr87X7P7YxVHZFZ3Q7P/F13ivX9RRQLO/AYISs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKP6SZDLjDCjmxE6AS4BuAvnm0iU4S87IalcAS8dUc/QPlKPkIVpaQQ6tmX9MkMVO
	 EgYkSBcv6z53vACOGy23XGsGYynPIacpq3H9ygKZ+mSjD8QPO/tVhy1PjyM6QKB+vO
	 p7V+XBmlLCI9cj/bHC1Fo7n/OwaQgpTeP92Uf0vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Yiming Qian <yimingqian591@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 139/342] tls: Purge async_hold in tls_decrypt_async_wait()
Date: Tue, 31 Mar 2026 18:19:32 +0200
Message-ID: <20260331161804.123028225@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 84a8335d8300576f1b377ae24abca1d9f197807f ]

The async_hold queue pins encrypted input skbs while
the AEAD engine references their scatterlist data. Once
tls_decrypt_async_wait() returns, every AEAD operation
has completed and the engine no longer references those
skbs, so they can be freed unconditionally.

A subsequent patch adds batch async decryption to
tls_sw_read_sock(), introducing a new call site that
must drain pending AEAD operations and release held
skbs. Move __skb_queue_purge(&ctx->async_hold) into
tls_decrypt_async_wait() so the purge is centralized
and every caller -- recvmsg's drain path, the -EBUSY
fallback in tls_do_decryption(), and the new read_sock
batch path -- releases held skbs on synchronization
without each site managing the purge independently.

This fixes a leak when tls_strp_msg_hold() fails part-way through,
after having added some cloned skbs to the async_hold
queue. tls_decrypt_sg() will then call tls_decrypt_async_wait() to
process all pending decrypts, and drop back to synchronous mode, but
tls_sw_recvmsg() only flushes the async_hold queue when one record has
been processed in "fully-async" mode, which may not be the case here.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: b8a6ff84abbc ("tls: wait for pending async decryptions if tls_strp_msg_hold fails")
Link: https://patch.msgid.link/20260324-tls-read-sock-v5-1-5408befe5774@oracle.com
[pabeni@redhat.com: added leak comment]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index b1fa62de9dab5..c0aadc8dce146 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -246,6 +246,7 @@ static int tls_decrypt_async_wait(struct tls_sw_context_rx *ctx)
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 	atomic_inc(&ctx->decrypt_pending);
 
+	__skb_queue_purge(&ctx->async_hold);
 	return ctx->async_wait.err;
 }
 
@@ -2225,7 +2226,6 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		/* Wait for all previously submitted records to be decrypted */
 		ret = tls_decrypt_async_wait(ctx);
-		__skb_queue_purge(&ctx->async_hold);
 
 		if (ret) {
 			if (err >= 0 || err == -EINPROGRESS)
-- 
2.51.0



