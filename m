Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832E6263C9E;
	Wed, 23 Apr 2025 14:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420231; cv=none; b=oRmLOP+OHBIvGIJ4SqU8/6/KITV7rfusZcFfgs9WeKqLkToo5HQEpr0CyfOmg7nVQKwwJmwA3FUF3BcI0OjavjdD73r4Quq3A1tK2p3iMWgqmzxspc/1+ew3ftNJmDXLt0l2RrYgS1K8jF3M+PUL1as+7/VyhCG4N9qUuLkjS7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420231; c=relaxed/simple;
	bh=CLX8xzo6ZoExV5f3Oc670zhqIE41x1vXqrc0Nhe6hdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fv3xdQNs4A+R1kID3DRkHnbKLcX3zyBe5+xwk2j3O3x0y7Cq1bbbwzwDz0rXB3ZoMIwDsfDdVnOv/nw/jTILaEgaztU6pAidVR0y//Siz1GAKrjluCOm2paE+OHR5VTYnXaSJv2qw1fcTe/PpXHwPDrhgJszcrFCsNKcNnCaX7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nRwEzYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nRwEzYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18645C4CEE2;
	Wed, 23 Apr 2025 14:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420231;
	bh=CLX8xzo6ZoExV5f3Oc670zhqIE41x1vXqrc0Nhe6hdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nRwEzYr6Lbo6eTiv4h2ER4dgzCWgFk2o0h42BUxdkiDC3jvmUOYoUC9KF2sg9xMd
	 LqfPTQqPhf8JeT8jeiTdgwWSOKawOkOA5Wv+98iH+xDp3OgH0IwFNHhO7efCPRHCB1
	 hiEgMRlFSxDc70fmtPbc4W+YPEXG8oVF7GLdTQ8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 6.12 111/223] crypto: caam/qi - Fix drv_ctx refcount bug
Date: Wed, 23 Apr 2025 16:43:03 +0200
Message-ID: <20250423142621.633423905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


