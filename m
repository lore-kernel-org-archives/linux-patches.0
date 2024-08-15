Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723D214AD0A;
	Thu, 15 Aug 2024 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729298; cv=none; b=VmjeeVYFmuS9drHdXrzM15AW/UYDgI/xK08ZDu5dpCWOFsbiqPZPW6R1u8bMliVHWbcBoZbBTZetd1s4GQ3r2z/izgKPuE0nJ3uFGGgngNddaa4FBRzwwCZPRrPxynrdVp679dq+F4X28tKHcKmuaDiOBH5L/tx7Babb2KSKtJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729298; c=relaxed/simple;
	bh=xAGJbZAx4vCD3qquBSfmjcfLhVRwJTSZM8MnSh++qPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJARfUla++WH+yTtiOTrayPPf9fUG0ksTeDc0PiSpTg+NlsmvuAOHdgNSQ6gT8JNvV2unsuxv1Wbq1ztERHmm24C16Kk2MkiUok9XK8IV95ka2LrB008R9U/xcRf9sUasS7F3mbyPVv5rR+Iegj7+4S1mUc8Q798RQHb/p3MKPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oW+4lUTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oW+4lUTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E3EC32786;
	Thu, 15 Aug 2024 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729298;
	bh=xAGJbZAx4vCD3qquBSfmjcfLhVRwJTSZM8MnSh++qPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oW+4lUTcqVM2O/UJMqqvB0HunpJzVruU2d2ecPBZvH4/m/zkOiKZv66y/9uvFpfcC
	 bboAv59874dBB0ilv2CsHQ+0wGdD3CDaiteqbBNja23LILFHLD9Lg+hqeJpAh6XKby
	 uhe+d4VnRy3bs/TN78me1iWzue8P33deuoZJ9mn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/484] net/smc: set rmbs SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined
Date: Thu, 15 Aug 2024 15:18:31 +0200
Message-ID: <20240815131943.330945534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b84896acd4732..0b32612b86aa2 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1772,7 +1772,6 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
  */
 static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 {
-	const unsigned int max_scat = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	u8 compressed;
 
 	if (size <= SMC_BUF_MIN_SIZE)
@@ -1782,9 +1781,11 @@ static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
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



