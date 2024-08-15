Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78521A00F8;
	Thu, 15 Aug 2024 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731227; cv=none; b=t/pH8XofA6F92djjNfSOHdBCifxZjVID3YN9uZuGZAQ+9hVZEqyfoslDEGPyXytZkAaYIx1OAX+GOGgfjGROgvTRagvagu1Rmy9fQu1gzi3/oIwljkBiTRprWFQS8Oo6wR7GGFc/GW9+sKVHoARHbwGo/Pz/WOL/imgWicxYeGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731227; c=relaxed/simple;
	bh=uPOGKNXoWw+sUsJ7R4kRcRMvBuzarzJeQe2I7mJT4Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmnguhcCC5uZ0MTbjqP1zOMCUSEAjQRDU2Irg6pb5xsCG0i6wZCMLqEUzD9GjRCuqSqZOSxGqBSBLFDWwm5xT6xuXZTRxNr/waFcMOtqNVwSVMRms0uLiQ5gvbAOT0WCBJc3ZwGowSpZWUvWWuqXNjeQV6eyYLod9E9ObrFXNSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq19ZvLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq19ZvLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C1CC32786;
	Thu, 15 Aug 2024 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731227;
	bh=uPOGKNXoWw+sUsJ7R4kRcRMvBuzarzJeQe2I7mJT4Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aq19ZvLQzwiIP9DgOJPVDOpN1j5zEVtS+EoF8F7NG0PomzLBbODldrPuv2MSXwZk+
	 JdqeQA39qxbig6YHH8iOMm5EIv8yuz06xhp0YWe6wtOsJ/73T8/sLoeRxILJZ4NZiu
	 IU0kg1MwxWAF+sOKMzx7ods0hydpTMCO6Dir6FU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/259] net/smc: set rmbs SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined
Date: Thu, 15 Aug 2024 15:22:44 +0200
Message-ID: <20240815131904.000278699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fb3543f7f278e..0a1520c75b862 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -691,7 +691,6 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
  */
 static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 {
-	const unsigned int max_scat = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	u8 compressed;
 
 	if (size <= SMC_BUF_MIN_SIZE)
@@ -701,9 +700,11 @@ static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
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



