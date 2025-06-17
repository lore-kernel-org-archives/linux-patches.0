Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F8D2ECD2F;
	Tue, 17 Jun 2025 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174946; cv=none; b=i8H/oTmMhGkB2Eb+z9bkqonkR2X3u51edvh4cOd/3UjTmSJm5DHdael8hu0Z3qZSI0WVyVnwtGOsSuFW5iGkUC/qXBN4WfdT67gJMWRcovnifVj1tR7wd6IVuneTiCYYVBScQaWJVDvaU7GqPTvH61D9MkmFWS6TN8Lks0BUjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174946; c=relaxed/simple;
	bh=ecTFWCd5Nm+4orZv0ROOt3wbbkm7n5I0eVNQhooTIZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYGsZvgHGS3WKQtsiOVytm/6G9JKIr6EBuokiyli5oRtyEwyzjkRl8D5Z9lbE/KcMziej2NQVOB3G4gSzfD6/dTltgDl9CoPUi46LinneBW1+U4ZIurSxor2+LwKcV5RXLiu4g3vVmm5w2Mz0W5kCLMhXlE34KunmvIDOVoL79c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFHwiLhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFHwiLhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2E1C4CEE7;
	Tue, 17 Jun 2025 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174946;
	bh=ecTFWCd5Nm+4orZv0ROOt3wbbkm7n5I0eVNQhooTIZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFHwiLhbfzUEj1y2VkBuFQ5ggb8CBGsBcC4KJZ/WwO1RrX4jjgIHJSbOBHW1DW0WI
	 RUiBkj5fdNd7OILInBre7PfibAuzbyvMkQmYLnS0CGf41aOVZD6Jm+K9/Q9dmCzH/t
	 XVmSMJrmk2oEhq9+2Ef2+ObSpMGggREZGwvxisUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 036/780] crypto: marvell/cesa - Avoid empty transfer descriptor
Date: Tue, 17 Jun 2025 17:15:44 +0200
Message-ID: <20250617152452.970543914@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1bafd82d9a40cf09c6c40f1c09cc35b7050b1a9f ]

The user may set req->src even if req->nbytes == 0.  If there
is no data to hash from req->src, do not generate an empty TDMA
descriptor.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index f150861ceaf69..6815eddc90681 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -663,7 +663,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (iter.src.sg) {
+	if (iter.base.len > iter.src.op_offset) {
 		/*
 		 * Add all the new data, inserting an operation block and
 		 * launch command between each full SRAM block-worth of
-- 
2.39.5



