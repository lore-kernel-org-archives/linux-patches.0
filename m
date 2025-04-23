Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B228DEFD;
	Wed, 23 Apr 2025 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421976; cv=none; b=aFPSHQhU0GF3bjOKePAcRQAv14Ak/GjoKF4NWbr+ULEkDyqCDaG+99RMjxl7jImms0prxcYvs3YBTK2h4UBjj4Lt6gYaiZjVF1VrR/b+qjd1JdL1RvtCClqxvdNuMCbLU+mUXUzWjZ3Cbnv0mFhd/KzcQ8QdLACd2uVgE7OTrfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421976; c=relaxed/simple;
	bh=VPO4qKIgaZmRM7C4RZDTR6/oiLzW8bKVhAO8j2lO0QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cs6ADNVS0Bs4ouPj3IlsDLUxDfV4aiUe5nshHY9xFobXGOw7gmG/y/ZPl1AjRfLeFklAZyk3bTVgk95rlhGT/s5v2Gm3HcygOISXL/BmSqg3pN+ZN6hgSjfrdnOIQ+LxzmqEMSm929Xrc6ABUIoPoX82h0a1yynpaTLOeLftPvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lN6454j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lN6454j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC54C4CEE2;
	Wed, 23 Apr 2025 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421973;
	bh=VPO4qKIgaZmRM7C4RZDTR6/oiLzW8bKVhAO8j2lO0QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN6454j2tKFOPWxonaR6sryXscEWeTx8TrfYjJtbfTeK2CnZ2V1VYMjnO2f3R+VLw
	 Id+iWwV0FjNf6lQA9nuLLmvwiazMSHHb4HKzavYlniwAM0KXCNjc+CG9lXDnVlQ1zt
	 nVycnr1Iv/tm+DcZKNpD1QSDqFE6znsiv3FRzD5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 6.1 208/291] crypto: caam/qi - Fix drv_ctx refcount bug
Date: Wed, 23 Apr 2025 16:43:17 +0200
Message-ID: <20250423142632.885907628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


