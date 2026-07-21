Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536A12DBF75;
	Tue, 21 Jul 2026 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660003; cv=none; b=cMuI2kSll79IBKUl0bIDlU2POzBV2DyQCLucRAnV6/Rmc5uy3ewTgDZsqO12hmxYHVA8oHjEiAIME9ph6MDCE1FymDJX4kSts1YnkmpKAzXy67gilY11z1xRxu70cW0IWUgsu98qy6rdUWl5DLP5UvU3AGA1Qz38Um84DboX4gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660003; c=relaxed/simple;
	bh=aQlhGA40T+sWm2kSxamBBceLdztwhfb2F1PK/9REW8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHQMRRyEh2nM/SfRYMOxIyxUpvTq3xJeBh9XErrKkY8EA6Xw45vO4P6ZKz0/0MpQgnnfxWPJ0fRYbgAnJTKvD0TTO24zM/5eBxN33+KG/AtEdSTwLPF6PcNuUkd5I96Cg0I8V3A66l2Appm7PKbgk0zEyOsrsCsNpqotEHy50h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0MTIS5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0MTIS5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B420A1F000E9;
	Tue, 21 Jul 2026 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660001;
	bh=Tss/X7Y4JnLIjj/m6w1UmH6kgnvNvsUcnVjf5DVBImM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0MTIS5tePMbzP6fNdJWERCjAw4ftoU10+xjAZXm5ZV3q7MW7D2G/Nzepznf7Qk0l
	 vXxOhl1CBJneSq5ROdGzMmdvYrx4dau/itT+ziZ/UPAi3JU8+tDk21iPR93I8f7kWW
	 g8jfHNA1tZvXjv5yhypmv7i9MiyFGMql6wIbk5Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0813/2077] RDMA/bnxt_re: Proper rollback if the ioremap fails
Date: Tue, 21 Jul 2026 17:08:06 +0200
Message-ID: <20260721152611.967912962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 87267803a8c824616eb147c5dad7030a5db6f878 ]

bnxt_qplib_alloc_dpi returns success even if ioremap fails.
Add the proper rollback when the ioremap fails and return
-ENOMEM status.

Fixes: 0ac20faf5d83 ("RDMA/bnxt_re: Reorg the bar mapping")
Fixes: 360da60d6c6e ("RDMA/bnxt_re: Enable low latency push")
Link: https://patch.msgid.link/r/20260615224751.232802-11-selvin.xavier@broadcom.com
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 95e0489c53c371..756f8b5f042a94 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -764,9 +764,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
 		break;
 	case BNXT_QPLIB_DPI_TYPE_WC:
 		dpi->dbr = ioremap_wc(umaddr, PAGE_SIZE);
+		if (!dpi->dbr)
+			goto fail_ioremap;
 		break;
 	default:
 		dpi->dbr = ioremap(umaddr, PAGE_SIZE);
+		if (!dpi->dbr)
+			goto fail_ioremap;
 		break;
 	}
 
@@ -774,6 +778,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
 	mutex_unlock(&res->dpi_tbl_lock);
 	return 0;
 
+fail_ioremap:
+	/* Roll back the bit we just claimed. */
+	set_bit(bit_num, dpit->tbl);
+	dpit->app_tbl[bit_num] = NULL;
+	mutex_unlock(&res->dpi_tbl_lock);
+	return -ENOMEM;
+
 }
 
 int bnxt_qplib_dealloc_dpi(struct bnxt_qplib_res *res,
-- 
2.53.0



