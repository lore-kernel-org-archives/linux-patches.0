Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36081347517;
	Wed,  8 Apr 2026 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671843; cv=none; b=TQEmeJkWDTjnrBWAh5wviVTxp3W57QDcRA52ADsW94El9gNoEAPbDAls3d2rGV+KrcA9f/tZ18xCnFmvDcDumVBmrdmLIuWTw8vx1tDvyRPdEhuNnxLgXg1vQY46buod7CG5qqI+Weg1ej5AFWd/kL8sDfaBCXCBAoQKPyDEPeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671843; c=relaxed/simple;
	bh=s6Gu3SpX1Ba4hkrP+u4dtIN2Car1mINJ/MGROlE31N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pphuExNsT6gGTFi0NFRUJocjiY6cEBfP9xhxFYGrkiA1mrxoWoaE8/vgxn5h8HTlUHaDIWluN/80h5ko8F5CvZb283KuIOwQDD8JJgf6x8gQMK6esAlSUSIjrr6wXqnDNRzcfLpexvwukf30gdc13j7Kx6UFCOkAyVYhK8wQ2E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCv1hbS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCv1hbS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9197C19421;
	Wed,  8 Apr 2026 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671843;
	bh=s6Gu3SpX1Ba4hkrP+u4dtIN2Car1mINJ/MGROlE31N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCv1hbS5P3hv8V4V5z5fvrg53ShnPKYGhVkyFgktfzNDp6aAdN9E/eBCRcR0aTaoc
	 k0zoZlDn/d/juBzeWcpNpG820cB1XwkCwGAi7UIHYdd1qy8o9OLrHXHpGLdliT0ZJX
	 QOhq88bRxVA81RwOp9Gz9fQjzjb4ZEyF5cPcJD8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Yiming Qian <yimingqian591@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/312] tls: Purge async_hold in tls_decrypt_async_wait()
Date: Wed,  8 Apr 2026 19:59:33 +0200
Message-ID: <20260408175935.830307412@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7f151c98eb93..4948af3bad13f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -245,6 +245,7 @@ static int tls_decrypt_async_wait(struct tls_sw_context_rx *ctx)
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 	atomic_inc(&ctx->decrypt_pending);
 
+	__skb_queue_purge(&ctx->async_hold);
 	return ctx->async_wait.err;
 }
 
@@ -2278,7 +2279,6 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		/* Wait for all previously submitted records to be decrypted */
 		ret = tls_decrypt_async_wait(ctx);
-		__skb_queue_purge(&ctx->async_hold);
 
 		if (ret) {
 			if (err >= 0 || err == -EINPROGRESS)
-- 
2.51.0



