Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8930ACF8;
	Mon, 13 Oct 2025 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367710; cv=none; b=ddJsZcWfQMM2gtppa+04nT8CQS+kUgJhRkVH5mHJ6AtP/jpNJPqmA+GVxE2Pt64V2VDH/9RNm02yY+6O6S7urjG+gVpCjGsKtk8sZviNnn1TcifgxBBQ0qFum3Qd7j+fqN9ROSYJMreWqq1pH67x10aLMl9dYGhJrSTM4WtSAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367710; c=relaxed/simple;
	bh=SkEMIjjaBoH2/etsIEx0CHFH3rTCDRcOxvVmtpQNwDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adjF0MfFrfEiEPR3MXPlc+aDWx6Z6ur1CAvX0yn7OV7l3QCVdQO07/rStw5ae4rW649PGyHAsEauY3kmmH9jnApY8BcbsI99zh0fUvO5Zb8IgXuxo7cnDQu92hLKyo0gflLvbieTneUYCazyFel9ZIOGHzJ1wuIm9rm2lZmvO5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErlTGxRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErlTGxRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6BEC4CEE7;
	Mon, 13 Oct 2025 15:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367710;
	bh=SkEMIjjaBoH2/etsIEx0CHFH3rTCDRcOxvVmtpQNwDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErlTGxRoNyrp6DuxKEQu5xG5HXXD09UClEUFFq9hpPPjZXIgEf/QiHx9YcYy7ubeN
	 kardLurm0Xl/RKH0aaNN0PYDkDFIL4w/Nn8QK3k26Y5aOn8qRy0gRMCHlo9cjumbgu
	 vKUMquj8jYCCoMNOmt9l2CsnRN+RCI080Medwm5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/196] crypto: keembay - Add missing check after sg_nents_for_len()
Date: Mon, 13 Oct 2025 16:44:23 +0200
Message-ID: <20251013144317.796284023@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index b732223035399..3b5d5b64e1414 100644
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



