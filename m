Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844B53E95A9;
	Tue, 31 Mar 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975821; cv=none; b=NLAvvPBobyjHwwontchqUimCDtVw9Xvw5+jtdvjX+Sm0NT53MbzJqtPHZld294eJW2zrF7EV2ES72yk4r3hm3nGR4yRae/SvhhsATfheCgjDmfY9IgjkSEeQzYjJM9xRFkSe9/dugxFX1Q89Orgxjk1kXoU98fpWwX0Er6uGnqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975821; c=relaxed/simple;
	bh=cJmtRqBQryDM7IItYRkApkzNqtPdTD5RR/fJ+bF/c48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGT8C6QQLi2jFqHJJNxgl3XtQZLBhz79/a4ReBM+1flLeSsPcqpanKjvOPhV1oDO+wNbMv3TfDELlaCBuJJeGm/QTBbOQyfH+PYelEvaz9YBkasbBxor4x9E0TR0Gw2wZsCMYARB2+6EalPgrdC7FFlsCxtCDa0vIOpN6kePqoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNUXJkmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNUXJkmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BE8C19423;
	Tue, 31 Mar 2026 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975821;
	bh=cJmtRqBQryDM7IItYRkApkzNqtPdTD5RR/fJ+bF/c48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNUXJkmo6mjf/dy2iSKFVlRVcAJ/zVe4YPI3CJagAyzwsj13tgTKqpdB3x+37PVe3
	 B3d/1wzdvx+7ta5iT6S+vGjGXxBP7pCjogwMXtxaK5x38zH5a2+8uvP14P5lh57+nN
	 cmpgZUdAcxXsvJ7yvXJntlfOTrt9NPTEZqXjqo1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Yiming Qian <yimingqian591@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/244] tls: Purge async_hold in tls_decrypt_async_wait()
Date: Tue, 31 Mar 2026 18:20:48 +0200
Message-ID: <20260331161745.293673295@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bf01155b1011a..e12aa76d1aa71 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -246,6 +246,7 @@ static int tls_decrypt_async_wait(struct tls_sw_context_rx *ctx)
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 	atomic_inc(&ctx->decrypt_pending);
 
+	__skb_queue_purge(&ctx->async_hold);
 	return ctx->async_wait.err;
 }
 
@@ -2191,7 +2192,6 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		/* Wait for all previously submitted records to be decrypted */
 		ret = tls_decrypt_async_wait(ctx);
-		__skb_queue_purge(&ctx->async_hold);
 
 		if (ret) {
 			if (err >= 0 || err == -EINPROGRESS)
-- 
2.51.0



