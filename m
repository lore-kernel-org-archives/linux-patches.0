Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F981A00D3;
	Thu, 15 Aug 2024 13:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728493; cv=none; b=T+7Kt+mxactjr5r7nEynaf1GLULRSU+RWPwIhrQctUxBJ/BOc4jJoMRjiOEi2kkDORoFSkJ6u3jtgg7nrkCiA/YhekuR7lJHnA4s/jc3BMfF/pDCEf8bBA6t18oPCq4VlYRSXAEMNRmIZ+h8BllvdNw0rq1MPznW4KRbxS2nGOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728493; c=relaxed/simple;
	bh=oAHkRgojKcw8aw90xSPnQHVN2b54cc1SA27LRoNZcpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7HELp4LlbpDtELW9n8zAP06gWyMfaQL0L9+VJm5OyxqAaMQMLzuHWhdfgeg2Bk1V2w+wfim3UjoczBjW3geXF7B8Yo7fuIfY8Lwx/g9LppHLSKuhBlRV3eLZxS3suoq9qZTbigRxlbu0AQkhngFpRx6OrvmUE0ZvQQL8HVMjzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jekmlZNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jekmlZNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57A6C32786;
	Thu, 15 Aug 2024 13:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728493;
	bh=oAHkRgojKcw8aw90xSPnQHVN2b54cc1SA27LRoNZcpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jekmlZNocpDZIhWEkekcTjAldQLppBxFaHh/mCwzkdWexqjHvUsrAxY2TbLaTFkSp
	 hMyadn3BRbJx6o6OFkS6A3/6Jq6WSmRH76jFZew7SnR5jcAlYNtltsIaqlpOF7B2r7
	 oYzksWoROl9jYNuF2FOXYRpVU1u1br6XQuYxwQnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Raspl <raspl@linux.ibm.com>,
	Guvenc Gulce <guvenc@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/196] net/smc: Allow SMC-D 1MB DMB allocations
Date: Thu, 15 Aug 2024 15:22:15 +0200
Message-ID: <20240815131852.773814742@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4d421407d6fc6..691c1d9c4c560 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -656,21 +656,30 @@ int smc_conn_create(struct smc_sock *smc, bool is_smcd, int srv_first_contact,
 	return rc ? rc : local_contact;
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
 
@@ -771,17 +780,12 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
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
@@ -825,9 +829,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* use socket send buffer size (w/o overhead) as start value */
 		sk_buf_size = smc->sk.sk_sndbuf / 2;
 
-	for (bufsize_short = smc_compress_bufsize(sk_buf_size);
+	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
 	     bufsize_short >= 0; bufsize_short--) {
-
 		if (is_rmb) {
 			lock = &lgr->rmbs_lock;
 			buf_list = &lgr->rmbs[bufsize_short];
@@ -836,8 +839,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			buf_list = &lgr->sndbufs[bufsize_short];
 		}
 		bufsize = smc_uncompress_bufsize(bufsize_short);
-		if ((1 << get_order(bufsize)) > SG_MAX_SINGLE_ALLOC)
-			continue;
 
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
-- 
2.43.0



