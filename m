Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301CA253954;
	Mon, 13 Oct 2025 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368266; cv=none; b=eWzVTs+IRlozVAUTUpVwLI9SX10kTjiJcECqtG/H9FWrtcdPOHYqidaAedrMUSFzb9PKZmOQGVomooFI5n5AisZ8UjEWyfroxX+u1WwZ4Uh7Op1W70zge0bILEsdDMdB0Tt6/xUR7IZ48ZBTtxHXy9NufJthT4s9ypsa6ot9g7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368266; c=relaxed/simple;
	bh=uXMTvqsI2n/tBXURiBCa5WEMX/rk0DbmwtBSWCgPc5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYecrsPyEHC1Ei0bLfXY82Q1vFjXbx1ULqzGQGtMgfyj/ssq/1z0QvqfDH7pU37+1fEoIR9zuqVUuTAevsYHUEIzqL5TGsbqKE8fegupSwyd+enUHbPGFJVSTqyxpRUun1IYq21d9ny3dvsPLBb8Xg4qBaz+KW3iuCosIVruFpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsUu80ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsUu80ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0827C4CEE7;
	Mon, 13 Oct 2025 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368266;
	bh=uXMTvqsI2n/tBXURiBCa5WEMX/rk0DbmwtBSWCgPc5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsUu80ii8fO1iwqi7Lkk5bPbmutagabHH+z2guBmd/2nriXlufjl2QNL4UJPrcN3L
	 cjUWtV9vdNVE2P1GF0Fchr014NDKfeZ8NmtE8iQa0ZPhhv55Ab/YKFIEwaNq6QEn2o
	 oiIBqHZr0GH18s/GbaZR+p2ftVvjmo2fuva3X2O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/262] crypto: keembay - Add missing check after sg_nents_for_len()
Date: Mon, 13 Oct 2025 16:44:02 +0200
Message-ID: <20251013144329.732448155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 4e53be21dd0315c00eaf40cc8f8c0facd4d9a6b2 ]

sg_nents_for_len() returns an int which is negative in case of error.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index fdeca861933cb..903f31dc663e9 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -232,7 +232,7 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	struct device *dev = rctx->hcu_dev->dev;
 	unsigned int remainder = 0;
 	unsigned int total;
-	size_t nents;
+	int nents;
 	size_t count;
 	int rc;
 	int i;
@@ -253,6 +253,9 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
 	/* Determine the number of scatter gather list entries to process. */
 	nents = sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
 
+	if (nents < 0)
+		return nents;
+
 	/* If there are entries to process, map them. */
 	if (nents) {
 		rctx->sg_dma_nents = dma_map_sg(dev, req->src, nents,
-- 
2.51.0



