Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048808;
	b=PJR0+wnAISeAWZfwqJRF+913mxCtRS1gWHNMxgyxN0I8JAJCVz1rRNxbIIBaJwMVov/H
	 zmOQVAah2NgC3HkeQrdnZ8jB+DOcNMWcN9WVt1LmyJthe+TJ0H9np9qiZwraUYMDjJ4Pl
	 RlyepNAUVIjkJlelnzdEiUmuAj3M+H/OtqlhSet/dYDoDRRNr1LsIuQ10Ku0FQsu5Ax+j
	 yFaSt6E88tIHWLfkJNUrvZtOEJSjqOj1byAOjJf9YMikL0pKkpmF7uvb7od778rhc+Krp
	 JmHEPOGGuu4+miDiNJtwjADzQHTAI8ECdRlmycSOKAYsFcJsDOBvmOAtO6wGC+p+lrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=56B0LjO/qKWphMjvpUKGUZnCfsNKxP1bb6fFYbCcQLE=;
	b=sogwCUQo/mUW7eHqRoky57+4X2jBdLJMwbOCZOXwcF6CVWNi645pS4N38wM5oiHCy4iq
	 sc4QMm0xHKKD6JkCAAy8KflNw4DZ2UKoIxYxuHdSQjlIR1JhD9vbyEi2Fa6ttNihLGHul
	 7PEPI5pWJyAx3YEzCxD1uIUihuSgfCkJEIU1/kAFHzW0Wej6/5fZHz7Y3l/FPKV2hK5EV
	 KYMTyVryuRkVlln84DxNTeotVfaucqcJ5PTWc9X7UgHOUBxz1CyZcgIQMrXQ68rjQB8oh
	 jGAiCc2hEGojPGTfc745taX6RlCsuxkJEz2P2xwU+1/ullmxv8s+8Avlvy7xA5x2iaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlCIor5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4FE606A32F;
	Thu, 19 Nov 2026 00:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlCIor5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0FD1F000C4;
	Thu, 19 Nov 2026 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048808;
	bh=56B0LjO/qKWphMjvpUKGUZnCfsNKxP1bb6fFYbCcQLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlCIor5+5gL2bFAuWvF7+4rCvfraWdTK3YZ9Le1Gmuigm8vcq69/wSkOl5VWMDdUd
	 f3AzL4CYM3pKJJv/99BqQZeYlPOsyOxoS2CKHVIJt8cWbR1H7GkaoWD+bm0MzziII/
	 fy6ToV/5z9Vg5f0drGID38i4ZdwsvA9HqlMVphqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2128/2857] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:52:42 +0100
Message-ID: <20261118150318.022650625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a85bede4df3d..a9d15a297ff8d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -671,9 +672,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
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
@@ -778,9 +779,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
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



