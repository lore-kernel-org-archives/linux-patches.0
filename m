Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040522;
	b=ny061O3WTIqwRB6r/6ZSrXZ3BoTDb0J8wkUOL3PG7ABPr2qf2biL58PLXZu9Vn+u5XiB
	 AvSZ00p2Yk8sA/i8+TASUWrRkfPN3YenllHfsrUYvf4Qgb5CbG7VjhJkZB6OUkn86DRtC
	 E6BiDAXqlMf0wBdCcJKuYurr9SvMVgCfvYAzyptSnSGaix97fm4Jls2NMaShgw//ZlWHm
	 2CjoeqgfneM7zrEYbSQZ7siTDWW9wsopUasURKkMn5ousEc0y/cyXfcZ9ZnSVJzawYn2h
	 75oT/Dv26Ji63j6BOfPuFSyh7wd7MHesoPWruzh0QV10gqE8sv0DJqhWsCEhlEF4ieg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyPmYO9fdpz9A3+tIfOEhY7xzEa74t5L9QBsUxL+VTg=;
	b=hsFm6spXmYtbQNSEwWpeSTXYCO8CeWC527OB4MeLXXlUWAtwOBhitoaVe2RZSX5ls0KB
	 a8GxAVgm3863VTZhDSLvXAIJJFgkRb79CE0ByW1oV3Ho0iPDqfxb6EoPTziI9DgVtdkhm
	 H8jPYp8MO0D9L9daAH6ERcac3OosVKkR2g7hwstlDowzknx3iNzLcZVQZIXBABvPCLvda
	 AAl34ee3FNQ/witcioz0DoUsTmIe6J4ztJuzd4Xgj501Guy1/DbLESFqBcD/IoykOi8rv
	 11ZInPQAaAKcCrqx2MIGhzADjVHDG8FgUpop1Zvy7/U6S05zQ1KHjK9ixW8Tel4CBfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpN4+XKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02353606A31C;
	Wed, 18 Nov 2026 22:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpN4+XKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575C11F000C4;
	Wed, 18 Nov 2026 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040521;
	bh=xyPmYO9fdpz9A3+tIfOEhY7xzEa74t5L9QBsUxL+VTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpN4+XKhOFPuW0vDCUuJQlrYSDXLIRyEpcV1iyY5kys96+xlxew/ldNRv80VpGual
	 6cbeJan0kwRj8hzbIkFvPxwXTrwKROzCHBbPfJjdODEnG3YJXud+upBTIVjp/XzOYS
	 Gv+kU9OQDvrJJwKdCUwwV/f/4X27Y2FXwmLZgb1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2450/3318] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:51:12 +0100
Message-ID: <20261118150434.945501306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit aa6c2ef821a6ba7f3fd58cfcc031b2d16f3811c6 ]

The PD and DPI bitmaps were sized as max >> 3 (bytes),
but bitmap ops (set_bit(), clear_bit(), find_first_bit(),
test_and_set_bit()) operate on whole unsigned long words,
so whenever max isn't a multiple of BITS_PER_LONG,
the buffer under-allocates and the top word's bitops
read/write past the end of the kmalloc()'d buffer.
Most exposed on the DPI table, since dpit->max comes from the
firmware-reported dev_attr->max_dpi with no alignment guarantee.

Fix the size of both allocations with
BITS_TO_LONGS(max) * sizeof(unsigned long).

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index c360f70f1c8b9..ef1dcb60a9446 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -684,9 +685,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
 {
 	u32 bytes;
 
-	bytes = max >> 3;
+	bytes = BITS_TO_LONGS(max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 	pdt->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!pdt->tbl)
 		return -ENOMEM;
@@ -821,9 +822,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res *res,
 	if (!dpit->app_tbl)
 		return -ENOMEM;
 
-	bytes = dpit->max >> 3;
+	bytes = BITS_TO_LONGS(dpit->max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 
 	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!dpit->tbl) {
-- 
2.53.0



