Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC02382871;
	Wed, 19 Jun 2024 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802290; cv=none; b=ezZR/P8m+TDiDUR7z/zNJhCEZk93b1C9Nl8Arv8uOzrHrTzqucrZQPzlx731YwDdPknwvrvYKCNXfSgXyLYY7jKHYulE34RnFted4qRWbdjvATx8D6ndZCHsv5cX08rojO1z6T5RPa72dtMEmLIvUGGuk+PVau3teANm0K0PSIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802290; c=relaxed/simple;
	bh=viym7NXw/0jAXH0HCg1+BtVH/DgOiS4w/vQ0pdI/kfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVycvHyUb3UYs/GdgX+a5b5Q2X+cIFMbJ3+z+YFGzjUnjHGZWFlJ74nmK2VjcXQdQ7/63YRWnziqOtDQCqi0Bcx/aqefJzC6TFkhlw+mXAF2j/sZ5DQnc/QhaNsNxXVk8vDka0zqx+jWVVz9txGjezLZtr+KGjoqxLZIt8VuQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rp5hFV6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rp5hFV6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7FAC2BBFC;
	Wed, 19 Jun 2024 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802290;
	bh=viym7NXw/0jAXH0HCg1+BtVH/DgOiS4w/vQ0pdI/kfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rp5hFV6zrGPbz+jG+UZNTdFfrSW931B7GXsHSxsmutSX/RLGlzqqZEfmcXIVokDRQ
	 Kq4O95iyhr/nT8+9wxr6x34SEPRP3Getf/gk4RHDMcqB2DgEHiLdL/dcpIflTdOH32
	 R2Tq3dN9luQo2abVZVIYe5aozOj0pKocBMI8K2VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/267] SUNRPC: return proper error from gss_wrap_req_priv
Date: Wed, 19 Jun 2024 14:54:30 +0200
Message-ID: <20240619125610.917195286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1af71fbb0d805..00753bc5f1b14 100644
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



