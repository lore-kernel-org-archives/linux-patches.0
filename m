Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44427713;
	Tue,  9 Jul 2024 11:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524491; cv=none; b=WAZJtun836IE/tMmUgXlzTpRV6Rrz3iTIR1RJvp28M+VXv0nXdyfI2ZVn/mue5PSeVfnIOTGELBf9qQoON02UosmtMgGrIj/lCdyiz2wBHL14nfZcWDqC3PmqrkNrivn6Ei2zelUcJ2KMIBiyNN2cIKrsvPeBDcNeE2whUMsBlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524491; c=relaxed/simple;
	bh=elLVg3ZVeOFAo49MrB7EPNcEV7cYCu455XCmeO6GcAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=len8qmiuADxaDidnZF8t35TJJl2yztkHnEBmghJCfit+7zGdWT/O5++72WuEKaz1i3F0uQ58k5ZmgN4HUPrMCHeRWRqFJF4lBGu1qN/94fyikS3RyLXsRYMCxzvFpd8vvIVh4DzQeXKftMUc3Aj+6b8ewghZyaWiWCreUAhb9LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+xU15bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+xU15bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42931C3277B;
	Tue,  9 Jul 2024 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524491;
	bh=elLVg3ZVeOFAo49MrB7EPNcEV7cYCu455XCmeO6GcAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+xU15bn+w7UYhQ+Itfe7r2q2a+CVk/QznC5l3G3lNPKMEF1kBe5nocbs5TQy4n71
	 oewxksenbWLdAvnW4xEsIc/P80TkuJlFSZlMZvqM6R/66F36ADmAxwwYRp5Kfqc2mh
	 KxdxILucNZ/VIXqx2cBPl21/h87KyS/3He4v12RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.9 167/197] s390/dasd: Fix invalid dereferencing of indirect CCW data pointer
Date: Tue,  9 Jul 2024 13:10:21 +0200
Message-ID: <20240709110715.413645157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit b3a58f3b90f564f42a5c35778d8c5107b2c2150b upstream.

Fix invalid dereferencing of indirect CCW data pointer in
dasd_eckd_dump_sense() that leads to a kernel panic in error cases.

When using indirect addressing for DASD CCWs (IDAW) the CCW CDA pointer
does not contain the data address itself but a pointer to the IDAL.
This needs to be translated from physical to virtual as well before
using it.

This dereferencing is also used for dasd_page_cache and also fixed
although it is very unlikely that this code path ever gets used.

Fixes: c0bd39601c13 ("s390/dasd: use new address translation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c | 4 ++--
 drivers/s390/block/dasd_fba.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 2f16f543079b..a76c6af9ea63 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -4906,7 +4906,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 				ccw++;
 			if (dst) {
 				if (ccw->flags & CCW_FLAG_IDA)
-					cda = *((char **)dma32_to_virt(ccw->cda));
+					cda = dma64_to_virt(*((dma64_t *)dma32_to_virt(ccw->cda)));
 				else
 					cda = dma32_to_virt(ccw->cda);
 				if (dst != cda) {
@@ -5525,7 +5525,7 @@ dasd_eckd_dump_ccw_range(struct dasd_device *device, struct ccw1 *from,
 
 		/* get pointer to data (consider IDALs) */
 		if (from->flags & CCW_FLAG_IDA)
-			datap = (char *)*((addr_t *)dma32_to_virt(from->cda));
+			datap = dma64_to_virt(*((dma64_t *)dma32_to_virt(from->cda)));
 		else
 			datap = dma32_to_virt(from->cda);
 
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 361e9bd75257..9f2023a077c2 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -585,7 +585,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 				ccw++;
 			if (dst) {
 				if (ccw->flags & CCW_FLAG_IDA)
-					cda = *((char **)dma32_to_virt(ccw->cda));
+					cda = dma64_to_virt(*((dma64_t *)dma32_to_virt(ccw->cda)));
 				else
 					cda = dma32_to_virt(ccw->cda);
 				if (dst != cda) {
-- 
2.45.2



