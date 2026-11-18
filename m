Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055540;
	b=u14iH89caGv1jWaJB20Zs49k8Nd0rV6l8RTkLla6Fv7MEy8fKr8ODF5vvPacrsVgTnHP
	 FtPZp/BEds1IzzJWE5oAyBXvB0J3xaaAvVGt1uuHFadNQYoSqgvQCYIuHX0jbuFD/6YPI
	 8qr8zff78Ff8ADQ3Zgs2TZa6Ex4lWrlXsl7Ygc5JHRiZTOlUa3rC+2fHqqo9FLJUkm2NJ
	 qRWFK4ZM4HG3gVC5i/kGaN/TSR/DZlfrNldXrPgHlFY5EsWmTvrUetdB7xGcn4bzUhMkh
	 +VDm8Wqq6KOX0IjlbxJO+Al8MWJ8vDnQttN1dSnJuTM8PwfJgUgC0j6WwxeLHFBY/JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GlvKtFSbEYDn/o/PS5vYyNNedYImi398Q5uIY9xT7jk=;
	b=x03NqKc+gEMyWWu3mec50lHLaA6tuS4teqULcExiYGdQerOpaGHirGDkhOlGjAHJgALy
	 0eSfCddgULeqqTB89d2CUGI17CFKRs2qjjiyZEGdnzTIk/od21zGxdOzV8DJRwz04mX5w
	 mfFed60HKc8U6c0oqtST7IApbTmOZIKneA2n6rEsLQttLVWCyy8aVNUYgDibq1/Ktzxiy
	 iJ1DaZE23qMeKCYBqZfpYzEjX5jtj4piuun//97X2g1JRfDo0ohDUCC1NHMgbUBAT27WY
	 aVTX4gwfovHXI2dVtIGe8G/EA13tW5s4QezZpSxcyu4xZqa74s2IOxHjXSwgRjaS/Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vV9Y40vV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD784606A333;
	Thu, 19 Nov 2026 02:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vV9Y40vV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B951F000C4;
	Thu, 19 Nov 2026 02:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055540;
	bh=GlvKtFSbEYDn/o/PS5vYyNNedYImi398Q5uIY9xT7jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vV9Y40vVeSXnCImNy6Ps8ISrifvLt9vuwLNABYqu/nnJtiOe/CAMHX+0EeVVclruR
	 xauAfeh4uf1jirlZgr7uWUVF0Zzul+FmbbXoaOUdh+1JMmS2qp7C4XMQAH3jIVoZKA
	 syttO6LxVF9EFD+hTuap4/UbCtVhzRTWvdYz7dCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1667/2214] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:55:43 +0100
Message-ID: <20261118150118.543072724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 64c3ef8985ee1..b72dce9209f72 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -712,9 +713,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
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
@@ -819,9 +820,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
 	if (!dpit->app_tbl)
 		goto unmap_io;
 
-	bytes = dpit->max >> 3;
+	bytes = BITS_TO_LONGS(dpit->max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 
 	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!dpit->tbl) {
-- 
2.53.0



