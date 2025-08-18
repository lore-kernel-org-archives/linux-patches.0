Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF1B31A055;
	Mon, 18 Aug 2025 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522315; cv=none; b=ETNjJuzjXHB+5+rzHxD5X5onMXDK1ih5DDOYnsvdYp9c7k3B7cqiH3kXd+9Au85NjtR24w31s0eamHZt04wCngVjVpjLgd/ztc8idAd3rIk4gdxrxI+KPSS/MEUlFKW8faUGvhkeB2LnG+sb94cmQ0mupKrwgwGysckG9pKpz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522315; c=relaxed/simple;
	bh=OUlIHdV3vjd8mWzDYz3IHufBT6lNFLyaKn12qFDZkNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kni3rt2N9fpNPxh4rrqfJopK4Tj77rxBtcI54B56Hes0pJX6L9LdNj/CkCg0HMeWVrgkvW40t70qn0HY9xznAyoDskCcAfpMyTyJ3H7pURmFDykJgpVUpycS0ELkfKRm2vfuDiQqbMPKiREK5ThBo5JfJJ+ttfJV03i1F+Kx/U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJBi40b/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJBi40b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02423C4CEEB;
	Mon, 18 Aug 2025 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522314;
	bh=OUlIHdV3vjd8mWzDYz3IHufBT6lNFLyaKn12qFDZkNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJBi40b/4gNJH+zpRz1GuEZkjaSLBqHnESB2ZvFAH/ZDYbddmU0/txwfZrln2nJa5
	 IZnPisu+L9Whc48OMyMRJDMt0HdPcMdxZQD50eq1JLcHjFq5JrMq9oTBtMxcyJBbyF
	 djJRlFd9M/oxQC4s2iUUkfR9px04sy7hNsTvU4j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/444] crypto: hisilicon/hpre - fix dma unmap sequence
Date: Mon, 18 Aug 2025 14:45:05 +0200
Message-ID: <20250818124459.429821981@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c167dbd6c7d6..e71f1e459764 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1487,11 +1487,13 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
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
@@ -1801,9 +1803,11 @@ static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
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



