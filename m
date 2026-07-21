Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F60470440;
	Tue, 21 Jul 2026 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665394; cv=none; b=YrBm2OAjPwIUU2QCP6wYF8uvK1FwttNTUnAZ5OVo8Dw7O5QpaaxuFPHhGDVhgXvgifAx9BhL3Vm0Mise2uRY8s+XProhjPVMBUyPB8E2J/4wuKNn5rUJ2L3c0smiqzCQvAP+XLDTIPH/xMDaUi3C1Y796HoGGGb9ytjEN+33Gqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665394; c=relaxed/simple;
	bh=q82xrJCFePOUQT5tmGNQe5YF1Gv4phXFQ33hTlGx2v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ue+cNfigtCslwBjBGFtpkJieY+bRiIGU9Gn+g086AaNd0VVg25CJ/u7VlZoHAPFigprVWrfjVbVY6ZQ0QFGeRQXVroN5+iKbPN0zueB39UFbXsgT/8waH5GhgkelIiyEqVozyOPPw1FFLOONnNNeVfUVwo+RLCOQ+vZ5PSx28Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf1AWK2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf1AWK2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F811F000E9;
	Tue, 21 Jul 2026 20:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665392;
	bh=rmRailQ7Hz8oPnzaEauN0n2x3U39AUGx+f8WWzTGO98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yf1AWK2QfuCA0RrA9NM7o4b9hvkOMLIXYsZa/DRDkREY9+gccjCbb02pLAbfAb/zD
	 9FWHI1427Ukud6NYCMnC5+MWuk+izWoUYBykv2DwH6Am4W5VB7yd4qiAY3RaelXg8D
	 /7wy6XEM6Ta1h/8OjJ6R2/nh565xecqphzVpV5mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0288/1266] crypto: talitos/hash - fix SEC2 64k - 1 ahash request limitation
Date: Tue, 21 Jul 2026 17:12:05 +0200
Message-ID: <20260721152448.269583043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


