Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBDE258EC2;
	Thu, 15 Jan 2026 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497604; cv=none; b=NYLn1pY+7Sgh6n1uc6vmEPSTHdsJzs3+tCx0TG7/7882k4RRy4qIy8WCx7plB0FSOjqMQQPOW1wBjV4OyiPEGZj/dywpEGT0ZLkEoRA2qJq3WARNSnQmJxrH3/qfEs2zK2qvPgdGzMam4wJLA1uyiPfwMBveCOcn0hhQlUkYwUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497604; c=relaxed/simple;
	bh=IkDU48IR9BQ6q/QcrYZhFVPRbRpQonD06QWsXjIAj7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSY1NbSqaPQMVi0ZDJ4SnAKcdpK7bd02NU4fvEhB8B+VUymb1S5Ij5CUz/LJa177hxJbCvxNDITfu2hWxh9j6rpO5EuhSlsPBpKEswNDoWBQQv95H4OI/fvx2LaYVliLk6GLZWROK5amDmyP0ShyHr/VLJ9VOULWl+HhT0e+Q4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqBsWwDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqBsWwDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3BFC116D0;
	Thu, 15 Jan 2026 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497604;
	bh=IkDU48IR9BQ6q/QcrYZhFVPRbRpQonD06QWsXjIAj7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqBsWwDiRbVOTxlwcZpwzjITbOTjOJmQ7IIjj9PJpggTfAAVfUYtH1NY92RHtNIk9
	 wAmjjrNBqIQZPWlvHiZb+lmJJk+Kg8WNghwKmlybkfxyyTyxoYvSe6MZ4k/jQ63p6z
	 HvcygttljZ7FepH5HCjMKIYOLu2wPr0yHuEUrOCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/554] crypto: ccree - Correctly handle return of sg_nents_for_len
Date: Thu, 15 Jan 2026 17:43:18 +0100
Message-ID: <20260115164251.028728977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6140e49273226..5754dc88c684c 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1235,6 +1235,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	int rc = 0;
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
+	int sg_nents;
 
 	dev_dbg(dev, " update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
@@ -1248,7 +1249,10 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	if (total_in_len < block_size) {
 		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
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



