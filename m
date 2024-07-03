Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A861FDF;
	Wed,  3 Jul 2024 10:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003884; cv=none; b=Wq/e0dDBsFy5QKyB8AcBo+vD7yld26jQjbqPIHFKuBNUc3HcQouANBsqaFzjGM7rt1jkAZ0JvM90WdoDQq8DWTU/hqtmveySXLZ4RBDAB9AWXyFW6iuYiTh2CYlopnrz/i7fQdUkvgfwS5dgk54yKnhTmw7ewbKepvvTwpNM0Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003884; c=relaxed/simple;
	bh=jkTWSofPyLwQr00QWXC84SRBkf2jyvf79DKTZUIde2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAJL/vA8QTdRd+D+cvZAc8EreaEjn6PwEWOp7g/Z4mDxq3gyB2vULwSwAciqfJE6MdPun4O54moDOXsOoJS2Nhshvk3wcHiuhQROeG6I7JQ2YnQFfQ81ZEz1trDlN727y2qwnuqDFDnJCUCRe6oqHsKreZ6aq2iwJPbsYu7PJGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH90RQwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH90RQwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D243BC2BD10;
	Wed,  3 Jul 2024 10:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003884;
	bh=jkTWSofPyLwQr00QWXC84SRBkf2jyvf79DKTZUIde2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH90RQwtX+xmWvIEsYEwwtlvprT53KQhrxtM+ormzpG2J/kahcBrf8bCyuFvIlVh9
	 sPcUPZ4uAYoQwuhkHzBsJX9Nbaun604viVAqzdwrprW6WI9uZmbqDpeymVXAbctjny
	 yt3iCcopgs30zGFezPjstCe64x27c//bQFKAJZzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/189] SUNRPC: return proper error from gss_wrap_req_priv
Date: Wed,  3 Jul 2024 12:38:32 +0200
Message-ID: <20240703102843.440797162@linuxfoundation.org>
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

From: Chen Hanxiao <chenhx.fnst@fujitsu.com>

[ Upstream commit 33c94d7e3cb84f6d130678d6d59ba475a6c489cf ]

don't return 0 if snd_buf->len really greater than snd_buf->buflen

Signed-off-by: Chen Hanxiao <chenhx.fnst@fujitsu.com>
Fixes: 0c77668ddb4e ("SUNRPC: Introduce trace points in rpc_auth_gss.ko")
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/auth_gss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 4d3cf146f50a5..a1aa4f3d7e50e 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1849,8 +1849,10 @@ static int gss_wrap_req_priv(struct rpc_cred *cred, struct gss_cl_ctx *ctx,
 	offset = (u8 *)p - (u8 *)snd_buf->head[0].iov_base;
 	maj_stat = gss_wrap(ctx->gc_gss_ctx, offset, snd_buf, inpages);
 	/* slack space should prevent this ever happening: */
-	if (unlikely(snd_buf->len > snd_buf->buflen))
+	if (unlikely(snd_buf->len > snd_buf->buflen)) {
+		status = -EIO;
 		goto wrap_failed;
+	}
 	/* We're assuming that when GSS_S_CONTEXT_EXPIRED, the encryption was
 	 * done anyway, so it's safe to put the request on the wire: */
 	if (maj_stat == GSS_S_CONTEXT_EXPIRED)
-- 
2.43.0



