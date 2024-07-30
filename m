Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C57B1A6160;
	Tue, 30 Jul 2024 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356774; cv=none; b=BqctTFG+jNd/L3/A/hqR9BQoqYD0stOnEHtCTiC3Sa57xVEsYbUx/KkpVnf9MC8qlKU7UI/3rL9oEW/r5GSYVN0SY+eUzLMvOgoDeQrkHwUIiIc36D1NLbj5QFxInVmUJ6J+PPxrPHr/Chj2YYVVzSyHT4HUuIWaiyqRi5EXptg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356774; c=relaxed/simple;
	bh=pO+rpmkqMgS8rzw1ZTii3IGImyLH/fn0nmfG+yBFw14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhvjrZ/cd4Ii9xCjDuKGqDapCJGIszA2gySgXzRwzhthiO3BjoRHRezoOjki283MOEy0PfckzMbW9oHrXXFlGfYJWoXRhmO+qhNuUbdw3KfBe19SAl0DMcWhjfEHE8YQ3rzr3VBlY3HCky3GvZrHdu/9eEqAxdtcG4nzu+tp+ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rI2JDFnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rI2JDFnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3673C32782;
	Tue, 30 Jul 2024 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356774;
	bh=pO+rpmkqMgS8rzw1ZTii3IGImyLH/fn0nmfG+yBFw14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rI2JDFnn7nr8kH2qxlaDneBu+HE+l8S+gZdeyDHnEifkEfajW1pC6OeoTKSCHrzQO
	 I9lQOODyYIbAVBTNesuEEhfFZceqrMPGlvSBfyxsk1F8Y1ZirzXdOodDPCjMBeueTW
	 IYZkjbUEvfwzp22d29GbVu8IIKBk17I2QEr1fvYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 179/809] net/smc: set rmbs SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined
Date: Tue, 30 Jul 2024 17:40:55 +0200
Message-ID: <20240730151731.681761682@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit 3ac14b9dfbd345e891d48d89f6c2fa519848f0f4 ]

SG_MAX_SINGLE_ALLOC is used to limit maximum number of entries that
will be allocated in one piece of scatterlist. When the entries of
scatterlist exceeds SG_MAX_SINGLE_ALLOC, sg chain will be used. From
commit 7c703e54cc71 ("arch: switch the default on ARCH_HAS_SG_CHAIN"),
we can know that the macro CONFIG_ARCH_NO_SG_CHAIN is used to identify
whether sg chain is supported. So, SMC-R's rmb buffer should be limited
by SG_MAX_SINGLE_ALLOC only when the macro CONFIG_ARCH_NO_SG_CHAIN is
defined.

Fixes: a3fe3d01bd0d ("net/smc: introduce sg-logic for RMBs")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Co-developed-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fafdb97adfad9..acca3b1a068f0 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2015,7 +2015,6 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
  */
 static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 {
-	const unsigned int max_scat = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	u8 compressed;
 
 	if (size <= SMC_BUF_MIN_SIZE)
@@ -2025,9 +2024,11 @@ static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 	compressed = min_t(u8, ilog2(size) + 1,
 			   is_smcd ? SMCD_DMBE_SIZES : SMCR_RMBE_SIZES);
 
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
 	if (!is_smcd && is_rmb)
 		/* RMBs are backed by & limited to max size of scatterlists */
-		compressed = min_t(u8, compressed, ilog2(max_scat >> 14));
+		compressed = min_t(u8, compressed, ilog2((SG_MAX_SINGLE_ALLOC * PAGE_SIZE) >> 14));
+#endif
 
 	return compressed;
 }
-- 
2.43.0



