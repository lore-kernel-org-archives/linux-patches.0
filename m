Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497D20E6E2;
	Thu, 16 Jul 2026 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212354; cv=none; b=rd2pwyhCzmWuulMsdFUtoiFT14xyb/T3+bOaMuCRjF17iB/tzZJ/cwPynG3UedhDFqbFR1b8R9QWJEgMP0FtiouD7S1oagNFTS93W609Sc7YZ4BC9bQ46l5n8jDIxnWS1j+AMGBi7eYcdfcUd8CkdMVAoq54JoSONyWqdPNpj9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212354; c=relaxed/simple;
	bh=6QPCRn3B3IwdzcTz77VyHRbTT4JN+wvoedjkLiPvtVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNGXHZBxg8O4ap6YcpHLeg5j5986H45nuldV+P8sf/A1ft6NVNm5ewZAgSsLuPpWCvslNLnr1YamMFrN7eO8EIF0o/f3/z+JrD7X7bCKIYxHoFfuhFGngB76TsHCgOfzsVKM7a9LivCz/zZRGgQJFVaCsHOb+gQmh4oCg8ROdgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/X3+V5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/X3+V5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADF01F000E9;
	Thu, 16 Jul 2026 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212353;
	bh=VePnLIqMvFrx355OwRS8IevV8LjTAyK6wAkwVkTKPqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/X3+V5WQKwgK/cFm35UyNmU00Jx7kUyZ69/xMl6rBwbQrPtgGm4G9NS4cCVhtE93
	 colrXncf6CHpwTfEsdXrFROZsCjcCSHeZj+V2o7doaxgOl0swfg4VIrrZlpsk6Lxk3
	 D6/6V2kvUtUZbZdRAKfORsPuTLA+HgdmXO4mVs30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 296/349] crypto: talitos/hash - fix SEC2 64k - 1 ahash request limitation
Date: Thu, 16 Jul 2026 15:33:50 +0200
Message-ID: <20260716133039.945789021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit 6e12daff6ec125102a6fdcafc5aa7199f7ce8933 upstream.

The problem described in commit 655ef638a2bc ("crypto: talitos - fix
SEC1 32k ahash request limitation") also apply for the SEC2 hardware,
but with a limitation of 64k - 1 bytes.

Split ahash_done() into SEC1 and SEC2 paths: SEC1 continues to free the
whole descriptor list at once, while SEC2 now iterates through
descriptors one by one, submitting the next only after the previous
completes, which is required since SEC2 cannot chain descriptors in
hardware.

Cc: stable@vger.kernel.org
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   49 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1820,16 +1820,46 @@ static void ahash_done(struct device *de
 	struct talitos_edesc *edesc =
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(dev));
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_edesc *next;
 
-	if (!req_ctx->last_request && req_ctx->to_hash_later) {
-		/* Position any partial block for next update/final/finup */
-		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
-		req_ctx->nbuf = req_ctx->to_hash_later;
+	if (is_sec1) {
+		if (!req_ctx->last_request && req_ctx->to_hash_later) {
+			/* Position any partial block for next update/final/finup */
+			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
+			req_ctx->nbuf = req_ctx->to_hash_later;
+		}
+
+		free_edesc_list_from(areq, edesc);
+		ahash_request_complete(areq, err);
+	} else {
+		next = edesc->next_desc;
+
+		common_nonsnoop_hash_unmap(dev, edesc, areq);
+		kfree(edesc);
+
+		if (err)
+			goto out;
+
+		if (next) {
+			err = talitos_submit(dev, ctx->ch, &next->desc,
+					     ahash_done, areq);
+			if (err != -EINPROGRESS)
+				goto out;
+			return;
+		}
+out:
+		if (!req_ctx->last_request && req_ctx->to_hash_later) {
+			/* Position any partial block for next update/final/finup */
+			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
+			req_ctx->nbuf = req_ctx->to_hash_later;
+		}
+		if (err && next)
+			free_edesc_list_from(areq, next);
+		ahash_request_complete(areq, err);
 	}
-
-	free_edesc_list_from(areq, edesc);
-
-	ahash_request_complete(areq, err);
 }
 
 /*
@@ -1940,7 +1970,8 @@ ahash_process_req_prepare(struct ahash_r
 	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_edesc *first = NULL, *prev_edesc = NULL, *edesc;
-	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN : SIZE_MAX;
+	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN :
+				    TALITOS2_MAX_DATA_LEN;
 	struct scatterlist tmp[2];
 	size_t to_hash_this_desc;
 	struct scatterlist *src;


