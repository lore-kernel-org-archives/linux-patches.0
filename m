Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C317DA2E;
	Wed,  3 Jul 2024 11:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005452; cv=none; b=Eq/ZuIE24kVO6GxvUoUu5YUMpsuSCN0ne4h4O/Gn6V15QFFOnkPuzqbkL9C0FjgdKTasFjnqhbKZdbFxRFptJQpohaONLS9JKGCBTu2Ilj+XAeu4qywUgEk3PoRa97aZvfudF1uLl3WP3po0synCVmWDPdQQHELJR6JHapPqyPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005452; c=relaxed/simple;
	bh=5LQ9cN4Z7qXVhhVQ9+fmxVxeAHsKb9keBnlATHqyWIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb9qzFSTKxncKwCsmVfvT5HEQW3YIQvxeWpxkYJOyFkTmGbi+mR9aDkdYXCQVvdeqs12PRdqv7XleyL7T828wfXlPwzA2vUFdRbu9aljd8pxZtrbSJCVvJd3/bq9xjN1lbkD1I8VThcIndLADN0T4uReJqzu4sk2+IMgZeZlLOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh1BkKYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh1BkKYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD0FC2BD10;
	Wed,  3 Jul 2024 11:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005452;
	bh=5LQ9cN4Z7qXVhhVQ9+fmxVxeAHsKb9keBnlATHqyWIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh1BkKYgANcvHzAEUut02+d2CiwF0j8XxW+eSNPXqw+OjCI7tCYYSbdIeztRrfQGW
	 QiqwiA6BXOWgxVgoHG62d7hSW8o2vz06AzFxV+UXaVveQPhQ81rSPA2NPM/xuzsHXx
	 M9Nf13GERsHuWGl0CDQslmnCBmXw0u84n1zvRZfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/356] SUNRPC: return proper error from gss_wrap_req_priv
Date: Wed,  3 Jul 2024 12:37:02 +0200
Message-ID: <20240703102916.356873244@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2ff66a6a7e54c..7ce4a6b7cfae6 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1855,8 +1855,10 @@ gss_wrap_req_priv(struct rpc_cred *cred, struct gss_cl_ctx *ctx,
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



