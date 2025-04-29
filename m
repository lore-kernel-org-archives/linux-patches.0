Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB4E251791;
	Tue, 29 Apr 2025 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946970; cv=none; b=Z+DZkBOdxi1YawO1dP4VqUO5/oyg9hIYPqTmULp0hsJASGf9V/xICyXm9fSuilgCmxFd2wi+exKd88oWp2OLt+jbHK8HM8QUMxBbI+pwp5zJJyxtmAgqmYQXfsc2aAXskJ6hCZOvPGa8sOt9uS8HMq99UYJF4hXo1oVMml7V3CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946970; c=relaxed/simple;
	bh=+oR1r3UWxu6qZU7dT81o8dtV59ITPS+6reaLdhTOhPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqacWTo9Hc7U6r9j6u997huMI/tMI0h6d5pDWyv3JarJsj91meff/yqcLPHORGuhJkfFYp96S4lvdbhyNdTYBUL2KUX6dbujmkZL/Os/Aybn8gGN+CZqswXvWmUJ9e2IRuKDl7d9CJO/8fLD1ojuTgEhYUZFEfI0bUXjXaNoUdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4KxeHI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4KxeHI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44549C4CEE9;
	Tue, 29 Apr 2025 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946969;
	bh=+oR1r3UWxu6qZU7dT81o8dtV59ITPS+6reaLdhTOhPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4KxeHI6b0HP5qgWQLM1ccASy3af/Tu97XiHYfz/jFeq+/gSy/4TqByNjdqhBa4r4
	 awxJW1JJxr23Q+fEy9zaO1H1gqi3WOat7wt1Vuu/DMBXyrjpriEMIUAXPP9MWQ5MYg
	 ER/XJnYIrvbBisHUA682bbJufGDBP/hjCGmG9VHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 5.10 127/286] crypto: caam/qi - Fix drv_ctx refcount bug
Date: Tue, 29 Apr 2025 18:40:31 +0200
Message-ID: <20250429161113.084053589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,12 +115,12 @@ int caam_qi_enqueue(struct device *qidev
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


