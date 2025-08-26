Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D731FBCB1;
	Tue, 26 Aug 2025 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213122; cv=none; b=Aj4PizdhuKUMCYiMjDtWJXzZgH70rQyz+BJldSFRdijFIQpx78q4SbXAJniYg0+wu7pXnsfkq75qbOz8QcSHi4kJH4wo8TgUx0QqhayOTj2Sg5YhwYCs8ex4EjCDoSo4hgemlQnNLgrWVNAkvhpVxcNCeANDUe7OQKHJf572myE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213122; c=relaxed/simple;
	bh=ePwQ6UPmASLTzbVYdoT8Gh5bOsD/He+byyI9kpaG5Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siOtwq0lNtrjgR78+fSmoMRWayuRfN2EZ9MdM29bJj1VsdMaltBMCFvMXhbB4tLgsJMiYBgIlj8r0BCLXLH95WCr22OQkc6YyYrqNMYakYg3O4LWdZvQIxlrokuQFVoqK1wTR9FthkfQtTlHainNHtU2HXYy1HuUfjgNF+D8k2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNIKVgbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNIKVgbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C69C4CEF1;
	Tue, 26 Aug 2025 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213121;
	bh=ePwQ6UPmASLTzbVYdoT8Gh5bOsD/He+byyI9kpaG5Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNIKVgbrUD+WbbrEubeKOJSm1lq+lM/b6Ya13cKoqL8CXAVhFIRnNKgA7rBWFV5SP
	 4D71NAlpjYccSMNtD6uQ02EdbBFmgUvRYXuD18UykMGTgBmzx2lmPCR5oSeXMXyHdN
	 lmplovUS7xHolOsfx5srW6HVMcGZUpmJe7AOZ5e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/587] crypto: hisilicon/hpre - fix dma unmap sequence
Date: Tue, 26 Aug 2025 13:06:11 +0200
Message-ID: <20250826110958.584419189@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a1c61be32cc..059319f7a716 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1482,11 +1482,13 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
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
@@ -1796,9 +1798,11 @@ static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
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



