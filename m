Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1539FD9;
	Tue, 16 Dec 2025 11:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884582; cv=none; b=jSLebxyWNbvfbglVE0sdDXOQzeQj7ZaWyaNUqwiB5nk/PgaG70l9edIVnaRZwRe3IjuH9UvZtzGf/8r4AjWHS96eqDDIQJVqpgu0LpjVDQIKdCGkl3ikvRfH/eVV6KNvEibk/eGyBsYFvdC9GsKjy4dgYtPr/DWDg2eK1tipzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884582; c=relaxed/simple;
	bh=BDO+Q5e7U1dZds16hpnG9isQZPLBXQzW43UPW8BsXVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbiehAm3G4exotkTUreawnBmY6LVAaLG7qiK/bq7cX/EZ6i4LumgwHv6wBVx9lti8M5YBNEfhsjTwP6PswHLBj8ojl32qZeVU5/0ic19lJb8SYog3/vAW3xlAqkL0DCI1KMLSrvm8X3Vh01QN6uwQrA3XFXvDAEoDMQe0rCf8fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttx5yF3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttx5yF3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF07C4CEF1;
	Tue, 16 Dec 2025 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884582;
	bh=BDO+Q5e7U1dZds16hpnG9isQZPLBXQzW43UPW8BsXVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttx5yF3Vg1jAdwbafUgQ8vgwJYiWvHvMVBjOLf308WBGSvJh2E0n1p330ZznqG0Fx
	 7U8GjUkMkrvLW7cYsTVHjPPWYMQY0OuPWpwGedWme1xpN+AYUS/By4c5e743u09i95
	 eFj94hNt9zrHYzjq0BOWMl1pnMTmssfYSLYmyf5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/354] crypto: ccree - Correctly handle return of sg_nents_for_len
Date: Tue, 16 Dec 2025 12:12:57 +0100
Message-ID: <20251216111328.529267602@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index bcca55bff910e..286e0d4b8f95e 100644
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



