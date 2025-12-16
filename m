Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436E5358D2A;
	Tue, 16 Dec 2025 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887902; cv=none; b=l0M2ywzkO7oW58RPffE66ow6lS70jUAgR/tHjNQFtDmvx6Fn+4gtJCEC2rCCYcJamqc21uzD5kKzw1FU3Iamtn8ADggXSeFMP12X/m0IB7yGUUJEF950eyKVhucCobbi61Qpkk0ySazDegAbUd58dkExFEWNVsmc25/mqHozAC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887902; c=relaxed/simple;
	bh=HXt7Vum7lRgDj8Mxj8VW5e6gC3WCEkx8VNz7/h1s5QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFyOuvUIQZHSdjp9ENY/CDHtl+5T9PPkizR2nHuTi3WvR84craYD57iSLc4xIxttOO/UAGc6kPmhM+TQ52gge8iQW2bw6qNQawMZNwi5mLq/Ss2CjOVsMiOize1bhMKEzAb7LE+D3edEF3RJ7yM5OIuJcs8KBvPqQL7uqiVAkwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk9iXZPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk9iXZPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0735C4CEF1;
	Tue, 16 Dec 2025 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887902;
	bh=HXt7Vum7lRgDj8Mxj8VW5e6gC3WCEkx8VNz7/h1s5QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk9iXZPR9pnUOKxrwuNQuA2AK8VOY9AVEqOBjx+L8H/OGsaLAEPUEke99g/P4Enox
	 TDuWlybesRLr+2stMiAxPWG/g1YX7Mk2xmTe/X0ZMcoT/OygxJugWWimPml7wuD4C6
	 PLM7siXsy8f1jBSf/yMDh7EL3FNIFMTschMhXaVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/614] crypto: ccree - Correctly handle return of sg_nents_for_len
Date: Tue, 16 Dec 2025 12:12:19 +0100
Message-ID: <20251216111414.840485037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 8700ce07c5c6bf27afa7b59a8d9cf58d783a7d5c ]

Fix error handling in cc_map_hash_request_update where sg_nents_for_len
return value was assigned to u32, converting negative errors to large
positive values before passing to sg_copy_to_buffer.

Check sg_nents_for_len return value and propagate errors before
assigning to areq_ctx->in_nents.

Fixes: b7ec8530687a ("crypto: ccree - use std api when possible")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 3963bb91321fc..dc7e0cd51c259 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1235,6 +1235,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	int rc = 0;
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
+	int sg_nents;
 
 	dev_dbg(dev, " update params : curr_buff=%p curr_buff_cnt=0x%X nbytes=0x%X src=%p curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
@@ -1248,7 +1249,10 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	if (total_in_len < block_size) {
 		dev_dbg(dev, " less than one block: curr_buff=%p *curr_buff_cnt=0x%X copy_to=%p\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
-		areq_ctx->in_nents = sg_nents_for_len(src, nbytes);
+		sg_nents = sg_nents_for_len(src, nbytes);
+		if (sg_nents < 0)
+			return sg_nents;
+		areq_ctx->in_nents = sg_nents;
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;
-- 
2.51.0



