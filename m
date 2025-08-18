Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F0B335BA1;
	Mon, 18 Aug 2025 13:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523990; cv=none; b=hj+p10hCselDAUfmq/EI5q2ltV0PkCpCnnNfoHkTcuPQnQRc+/R75Jdp0TA5s5diR6HsToJXmrNosPWZcE1K0zsmieEaJ9Zr4ReS85wqKxg8wcz/zd+1slA2IGTAQir3/MLCArH3CZ0zAoF/hnqUsqUNJbx7OdcyfRFUsxwdLfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523990; c=relaxed/simple;
	bh=Gu4szEaJPjobXveju7pATTAe7zEpe1qiBfspOo/btjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXiXOh0boL3IBtxJ+tQY8U45FJL4XThBkj1V8CLdbc8fQBboGs3AYqXKZij/V7MmWZ+XUqRJocWuHaSOBze5iakobspdFPMFTIWmEjxaY/NnzSWkiefYVZRW4RKSxBiYuFPhZd/t3zTTIgqy055QkH2frJ6THdN+aGcz5nC7YYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzqVSp9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzqVSp9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A53BC4CEEB;
	Mon, 18 Aug 2025 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523989;
	bh=Gu4szEaJPjobXveju7pATTAe7zEpe1qiBfspOo/btjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzqVSp9Wuw/lfh/jlQ3BMIDfYrOZ5KqzP8garp1Ghw0g6CXhMlA+GuZUrSfDxfmue
	 e84uGgH4IY2W/Dxc74BWRp2Xj8FcDicNzRJl15g+ZnOLUwfJmZKfdRi3cCPcYuQEgo
	 7B4Zzg9+c+Q8wjdKxJUPx14pFi7t1u7+gEPLhIt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 335/515] crypto: hisilicon/hpre - fix dma unmap sequence
Date: Mon, 18 Aug 2025 14:45:21 +0200
Message-ID: <20250818124511.324290844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Zhiqi Song <songzhiqi1@huawei.com>

[ Upstream commit 982fd1a74de63c388c060e4fa6f7fbd088d6d02e ]

Perform DMA unmapping operations before processing data.
Otherwise, there may be unsynchronized data accessed by
the CPU when the SWIOTLB is enabled.

Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 61b5e1c5d019..1550c3818383 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1491,11 +1491,13 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
 	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
+	/* Do unmap before data processing */
+	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+
 	p = sg_virt(areq->dst);
 	memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
 	memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
 
-	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
 	kpp_request_complete(areq, ret);
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
@@ -1808,9 +1810,11 @@ static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
 	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
+	/* Do unmap before data processing */
+	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+
 	hpre_key_to_big_end(sg_virt(areq->dst), CURVE25519_KEY_SIZE);
 
-	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
 	kpp_request_complete(areq, ret);
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
-- 
2.39.5



