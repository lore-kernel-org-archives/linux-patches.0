Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1ECC148;
	Tue, 29 Apr 2025 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948916; cv=none; b=WH5j6oKo5UZJAS+Ms67jOrB11qvM7I37jE743QmiiHt+3hJ2XjSoxOiiDN+LXm1247rCNWaheoYfh8r8godwkcrNTiMfmRYMyqZb1E9XgUjtcyzb1BrlSsLOVc9Q8zqSdq7W8/16q4PRD3jvYqyhSMm1X0Cs1evvQSZahz8Cicc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948916; c=relaxed/simple;
	bh=W44X0iwujwBhbpfdB1Q1pRqIoq8Jf3L+/H12n/lh6NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vm/QNYjNwTWM5dzS23oy7HV0L9DjkLYwrAeouTHLs+zRxhPg2kV93/DJy7uq29BM04OhYW/+Eio21rmyI7cME01Esjs0O6kn6/tYpvXeYCSEhmWRo7Y6zN3zdNgn25TFD3fXkvV+wsGZC4qISNsrrQU18H0oFPpV8Rrn6bVZXA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daP8g8La; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daP8g8La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A281C4CEE3;
	Tue, 29 Apr 2025 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948916;
	bh=W44X0iwujwBhbpfdB1Q1pRqIoq8Jf3L+/H12n/lh6NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daP8g8La7fcocGK55rd17UvlePdttQE1ZnPwr3W/VHFRknjFJoEv8RyaXhYmst5/T
	 35nBCwL76uuv2n1k9htf6DJH3N8xNQJA7orn559yHEGOOkCswJjAuvpQW9FwomxsAH
	 w9y1/02iQcJWrXdomxZ+spA/ijoAdVZAkOyeglZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 5.15 163/373] crypto: caam/qi - Fix drv_ctx refcount bug
Date: Tue, 29 Apr 2025 18:40:40 +0200
Message-ID: <20250429161129.844905332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


