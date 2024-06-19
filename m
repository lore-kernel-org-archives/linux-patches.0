Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1FCAD58;
	Wed, 19 Jun 2024 13:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803010; cv=none; b=Ctn8ZXwhKylZ9jFKpnnauR6J5Bs2VfprMQ0jJSG73dr8Rbc2oOX0IltGVQTKYWh8Pbv6exl3R5sodNPHbIBCTLywz5cvZkAHdd0PgxewCax94rn7/GL+1xhrviBhSvDUt1U/nx1RnrywUh1p+6zXHtk5Js7w8nlzb6VHZbUws+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803010; c=relaxed/simple;
	bh=66zkwvNRPFwLQ9GfVWr3f1ZNUb7Xp8OFCTMuynCvWZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6piWSnNduwZqzVTocqhN0yJP67psJhJsrmfPSI//Ri6kyQTuJh12ASKwChPLjr/UqoTLcmQ2QhPJeLVIANANM/Q4IeJMBQhAtoKFRc3HMRJeGojvL7CnLtqhq1pxJCkxKDbKqZbZ/FbFCR2gjghVoQeFVh8COC/s3hoRpqV1bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwM+zeT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwM+zeT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F2BC2BBFC;
	Wed, 19 Jun 2024 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803010;
	bh=66zkwvNRPFwLQ9GfVWr3f1ZNUb7Xp8OFCTMuynCvWZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwM+zeT6w0BnxTOTYO6LPqfEygAUq8RtLAOHzjF6IC1DIObe4nZTQSEN6FxyhwZfY
	 +PWmMFTZCH7GVlnT8ofoHT+imal5P0n59zOaj+/I7hYzVoFJ3KqgV/NCkrbHnLpodc
	 vkx00T6ls66JNSF1BJtTwA4U8NMq7v7he2JbFpJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 123/281] SUNRPC: return proper error from gss_wrap_req_priv
Date: Wed, 19 Jun 2024 14:54:42 +0200
Message-ID: <20240619125614.578545823@linuxfoundation.org>
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
index c7af0220f82f4..369310909fc98 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1875,8 +1875,10 @@ gss_wrap_req_priv(struct rpc_cred *cred, struct gss_cl_ctx *ctx,
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



