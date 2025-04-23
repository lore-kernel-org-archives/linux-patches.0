Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680B129008D;
	Wed, 23 Apr 2025 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421020; cv=none; b=Q+2VpRMKw4Ruk77mhwer8H4nHYF9qT7OxjTwEtsSQRJSyCVeb5ACE52IiqkON3SwBgSFOFQ9tNA4Tipy9HQ9nl712blkOe5zUGGjQ6WT0/pQ3fDWRMG9I2PqJWcmgV5i/Gk1spcMy5DnAjvTNJUebPNwzzq/9wc0I1J74dtnApQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421020; c=relaxed/simple;
	bh=uvmg8TX0n1JcxuiC8HGgtjQVBIULWx8+WuxeZjDNkRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9VpFAKJxq8uolBVXERpNt4bAF6wdMMFETnc/RZ2oEcMBXPWcpCfGSCzn5o+jSNAbnGf74NR8iHN/SpxaXTHOJXBvJvz9MVAYWwxPWOyycuAW00kudVmgrrK8GgmBuQKPb/AnQUd5alZ0ZrR8BTKAC0v7gwqtH3EsSBlpJX6gbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxwL26zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxwL26zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F104DC4CEE2;
	Wed, 23 Apr 2025 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421020;
	bh=uvmg8TX0n1JcxuiC8HGgtjQVBIULWx8+WuxeZjDNkRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxwL26zLutbQ1sslRlQdOn40KdWcikPME0ADscWckwOaWQX11hCU+IMQO7sdQolOr
	 arANyp5fsPJS3jVqdo8mhhsuulSvSRfTE+JInd4ktmrHkXEemyGJiCFltiqQUAFPVs
	 Mh63/uHI+COkwQJzteMrB8PqXCX/6gtp+vQlN3w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 6.14 131/241] crypto: caam/qi - Fix drv_ctx refcount bug
Date: Wed, 23 Apr 2025 16:43:15 +0200
Message-ID: <20250423142625.921773471@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit b7b39df7e710b0068356e4c696af07aa10e2cd3d upstream.

Ensure refcount is raised before request is enqueued since it could
be dequeued before the call returns.

Reported-by: Sean Anderson <sean.anderson@linux.dev>
Cc: <stable@vger.kernel.org>
Fixes: 11144416a755 ("crypto: caam/qi - optimize frame queue cleanup")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Tested-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/qi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -122,12 +122,12 @@ int caam_qi_enqueue(struct device *qidev
 	qm_fd_addr_set64(&fd, addr);
 
 	do {
+		refcount_inc(&req->drv_ctx->refcnt);
 		ret = qman_enqueue(req->drv_ctx->req_fq, &fd);
-		if (likely(!ret)) {
-			refcount_inc(&req->drv_ctx->refcnt);
+		if (likely(!ret))
 			return 0;
-		}
 
+		refcount_dec(&req->drv_ctx->refcnt);
 		if (ret != -EBUSY)
 			break;
 		num_retries++;


