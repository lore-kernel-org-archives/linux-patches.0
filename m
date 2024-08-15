Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C197B1A256C;
	Thu, 15 Aug 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731224; cv=none; b=Ihx5tpZ2KpLHlX4IgoyakPkitQ1KLkJiuYb5zefbPQwpeYSgaLl/n3inwqqblK73vkg210lmHxvAxefX+FyBvmkjZzqI3XfBjxtdjtFx/vj8cCVcpmS+wvQfJSXTfiPin0B0nuwXA4RlBTf3RbKsDMEoElE6cwcDhjB00rRJ/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731224; c=relaxed/simple;
	bh=Vm0eDcX8rAs9WtIE2xgUN3SJ/1iyqb7SrqtSnY5Cktg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwZ0WL2tLoPvmfD6eub3ubkTaSuxjxD+w2qsDtXRTZ6xyVNb7CB1O8TdoEe/0/BEsHN8ejWK3IUDLkV68GI6PmnML6jPmf1GOh59u03rIcGrQMg7QFkl8YiwxGoStkLMn2C+HLDwah+Ha/VQX8WxVugW0pmeMHIkLymDdXCvFC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUVRBTcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUVRBTcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA11EC32786;
	Thu, 15 Aug 2024 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731224;
	bh=Vm0eDcX8rAs9WtIE2xgUN3SJ/1iyqb7SrqtSnY5Cktg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUVRBTcul9hsa2uhA3i6XmHx+7YgmQ+iE8mJmIZMH1hMbQDIJ8eE2YORGuLcggQvX
	 VUhy61SFG75TXy7CtzS2tW11J4voe5/RvWx0Y3/0HuAObDV47SrjqpTvIfPmPCkJQ4
	 eViACVGv5vNbt63Lky8VrU3Y/1AQjvZ/53ryVekE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Raspl <raspl@linux.ibm.com>,
	Guvenc Gulce <guvenc@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/259] net/smc: Allow SMC-D 1MB DMB allocations
Date: Thu, 15 Aug 2024 15:22:43 +0200
Message-ID: <20240815131903.961984390@linuxfoundation.org>
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

From: Stefan Raspl <raspl@linux.ibm.com>

[ Upstream commit 67161779a9ea926fccee8de047ae66cbd3482b91 ]

Commit a3fe3d01bd0d7 ("net/smc: introduce sg-logic for RMBs") introduced
a restriction for RMB allocations as used by SMC-R. However, SMC-D does
not use scatter-gather lists to back its DMBs, yet it was limited by
this restriction, still.
This patch exempts SMC, but limits allocations to the maximum RMB/DMB
size respectively.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3ac14b9dfbd3 ("net/smc: set rmb's SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 66cdfd5725acf..fb3543f7f278e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -681,21 +681,30 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	return rc;
 }
 
-/* convert the RMB size into the compressed notation - minimum 16K.
+#define SMCD_DMBE_SIZES		6 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
+#define SMCR_RMBE_SIZES		5 /* 0 -> 16KB, 1 -> 32KB, .. 5 -> 512KB */
+
+/* convert the RMB size into the compressed notation (minimum 16K, see
+ * SMCD/R_DMBE_SIZES.
  * In contrast to plain ilog2, this rounds towards the next power of 2,
  * so the socket application gets at least its desired sndbuf / rcvbuf size.
  */
-static u8 smc_compress_bufsize(int size)
+static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 {
+	const unsigned int max_scat = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	u8 compressed;
 
 	if (size <= SMC_BUF_MIN_SIZE)
 		return 0;
 
-	size = (size - 1) >> 14;
-	compressed = ilog2(size) + 1;
-	if (compressed >= SMC_RMBE_SIZES)
-		compressed = SMC_RMBE_SIZES - 1;
+	size = (size - 1) >> 14;  /* convert to 16K multiple */
+	compressed = min_t(u8, ilog2(size) + 1,
+			   is_smcd ? SMCD_DMBE_SIZES : SMCR_RMBE_SIZES);
+
+	if (!is_smcd && is_rmb)
+		/* RMBs are backed by & limited to max size of scatterlists */
+		compressed = min_t(u8, compressed, ilog2(max_scat >> 14));
+
 	return compressed;
 }
 
@@ -796,17 +805,12 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 	return buf_desc;
 }
 
-#define SMCD_DMBE_SIZES		6 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
-
 static struct smc_buf_desc *smcd_new_buf_create(struct smc_link_group *lgr,
 						bool is_dmb, int bufsize)
 {
 	struct smc_buf_desc *buf_desc;
 	int rc;
 
-	if (smc_compress_bufsize(bufsize) > SMCD_DMBE_SIZES)
-		return ERR_PTR(-EAGAIN);
-
 	/* try to alloc a new DMB */
 	buf_desc = kzalloc(sizeof(*buf_desc), GFP_KERNEL);
 	if (!buf_desc)
@@ -850,9 +854,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* use socket send buffer size (w/o overhead) as start value */
 		sk_buf_size = smc->sk.sk_sndbuf / 2;
 
-	for (bufsize_short = smc_compress_bufsize(sk_buf_size);
+	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
 	     bufsize_short >= 0; bufsize_short--) {
-
 		if (is_rmb) {
 			lock = &lgr->rmbs_lock;
 			buf_list = &lgr->rmbs[bufsize_short];
@@ -861,8 +864,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			buf_list = &lgr->sndbufs[bufsize_short];
 		}
 		bufsize = smc_uncompress_bufsize(bufsize_short);
-		if ((1 << get_order(bufsize)) > SG_MAX_SINGLE_ALLOC)
-			continue;
 
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
-- 
2.43.0



