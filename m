Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C978187FFB;
	Tue, 30 Jul 2024 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355412; cv=none; b=CvgsYe850j9dAn7+1MoKgLvTQXUUSttlQt6a9jQNcx2VlAHoMB/5eEBV0kX2q1oAYUv1g8ofHD/kxO43tMmd0/5qE2In1UirggnA1cMmGCWS9EL0277ZUS5VDQyHgs2beBeub40ykqnSFBw6eMBRPg3/ZhEGl6E9LtRad3OXL80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355412; c=relaxed/simple;
	bh=bfYFJsLEHotii6BkAZ6zE3suakjk8eXWtblhNLMLIvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLWHGh83GOjbT9HUXuGVwR2LLwlzVsCUonOdLNb2zJ+3kGPVaRag/VxhK76nT5l8192Y8O4fMjbqCBlry666Z2SeU/hUVL32Ndvsfd7xVTDEIz6onCLNVpD1hLJwt4hHK79CeFWvy6iV81tqVRM+gpVG5MtRpg+WvnBDqxepZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On/6A0hU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On/6A0hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8260FC4AF12;
	Tue, 30 Jul 2024 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355412;
	bh=bfYFJsLEHotii6BkAZ6zE3suakjk8eXWtblhNLMLIvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On/6A0hUO4eV5txD7g4Ejd/XICgdAmprp8Vs3JZoypIWfu/703RIRlxDhEWfJ1Mjb
	 yvorvDzh/Owc7cdKT7tkSr1ZAddJgAdAQLGh/bj8FrulgdIiBqr5sHb9Bp0u4/7yBX
	 ieF6rnwBo/q1VYzxtf+w47rHSxyEJuTqE7A0TfrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/440] net/smc: set rmbs SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined
Date: Tue, 30 Jul 2024 17:45:24 +0200
Message-ID: <20240730151619.313436260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64b6dd439938e..10d79cb55528d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1959,7 +1959,6 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
  */
 static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 {
-	const unsigned int max_scat = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	u8 compressed;
 
 	if (size <= SMC_BUF_MIN_SIZE)
@@ -1969,9 +1968,11 @@ static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
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



