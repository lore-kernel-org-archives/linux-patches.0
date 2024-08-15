Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABF1AC896;
	Thu, 15 Aug 2024 14:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731984; cv=none; b=URR7H08388rgtmmwbBt0QfuKudtvdr+XHWoE1T53vzcRhzOrXhaSsn6G9rU7lzhXcNLjzmEEvNJufYn8a0/Rjeb48ynfWBmAh+HOXNvGPH5fgvUzXReaHcl7PJOEuQNWRHy1ogztPOcRQQTsT6hf+whbsHnkmfRMHKN4INpRQqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731984; c=relaxed/simple;
	bh=8RiSu2xWxCZbtC2wjk3GgN9h/JlwpjOiS3kHcCD63+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0n5Th9FfjfXkLT+J03fisJb5m90DJl02gPibIxoKPVp0+IkQEz+GVPRSawAXo6nccRMG+YhCj+N86iOWDMJjacnOxZry73YSdt2ZgYbrlehIp2bYQ9T5H1VGohhqN8H8nUJM9IMTsnL5V3mthEfBj6wfM3z6ChwKtSd3sRA0WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3JL6rE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3JL6rE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6CFC32786;
	Thu, 15 Aug 2024 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731984;
	bh=8RiSu2xWxCZbtC2wjk3GgN9h/JlwpjOiS3kHcCD63+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3JL6rE+wx80DGUS2ACq2LOplQiKJtwHyDacLeHjVjexhlVkG5yTPOJCpJV59nzZi
	 wk9C28GZvGlUfRWeiPqTHE5crw71IkXRRWV7thmo6QP2WjIFOitUPOtbwuBe1vZ1aR
	 Fg0+Vz+UMQvOj25EHy37/3fDXROG4s6720QWjupU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Raspl <raspl@linux.ibm.com>,
	Guvenc Gulce <guvenc@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/352] net/smc: Allow SMC-D 1MB DMB allocations
Date: Thu, 15 Aug 2024 15:21:44 +0200
Message-ID: <20240815131920.703491184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ab9ecdd1af0ac..701bfc2bab239 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1375,21 +1375,30 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
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
 
@@ -1608,17 +1617,12 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 	return rc;
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
@@ -1666,9 +1670,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* use socket send buffer size (w/o overhead) as start value */
 		sk_buf_size = smc->sk.sk_sndbuf / 2;
 
-	for (bufsize_short = smc_compress_bufsize(sk_buf_size);
+	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
 	     bufsize_short >= 0; bufsize_short--) {
-
 		if (is_rmb) {
 			lock = &lgr->rmbs_lock;
 			buf_list = &lgr->rmbs[bufsize_short];
@@ -1677,8 +1680,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			buf_list = &lgr->sndbufs[bufsize_short];
 		}
 		bufsize = smc_uncompress_bufsize(bufsize_short);
-		if ((1 << get_order(bufsize)) > SG_MAX_SINGLE_ALLOC)
-			continue;
 
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
-- 
2.43.0



