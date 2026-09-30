Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9535D3BFAE7;
	Wed, 30 Sep 2026 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794883; cv=none; b=eM4n8yunqkyZ6aR2/HwxRv+mCWyRjPAujo5AqjXygRiO9qsPxuJjbd+Uum+CNyy098ydAWS0JvTucEvTC5zJX45p26YS6EXtTxTKd6x36hN8zwn+VVvV8eVZdDan/+w0Ldzf41XRQc3q9wFU1LqdVqg60H77LLFhAIT30VuBZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794883; c=relaxed/simple;
	bh=OJyds4PT+EpL9a5RmuYyPmTpkcFer8iQaVQa3B9nPCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7jTSU8UqNhuNYt9r69dGNzCC0JiRFs+RU441mx+4z8JUQiApbDSRDuFWJpyS7feR3s1BTWtZG1R+fSc2yfnhCJLzaJFmdELP1lVYPYWp2r+9qHqaKykBLhn/ReDCZFFmbbnbMfWc4DhDpA5DCd626aPFjCw4pmKj91UCH+GcvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo8bhG/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo8bhG/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2661F008A0;
	Wed, 30 Sep 2026 19:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794867;
	bh=Sbe53HpmAbyWg4xZrWvNmnlZ6aKiZr1R7L6BeGfB0vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bo8bhG/Sulw0XtbJTZiBTUTa5ecX31joYm2olpvO4osCSAuoBF6Dyeu4XIv4b3R0s
	 1xtFxB8xOs1XfFPraeWeNFJi5/IvgrqMao0nQ4gJM7CpaxDBwt+CjU6gNamHVgYjJV
	 PSqFmaIW4G82NjiLOhF6pWDmDSoY8hRE6R8syz9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0360/1193] RDMA/bnxt_re: Proper rollback if the ioremap fails
Date: Wed, 30 Sep 2026 17:17:24 +0200
Message-ID: <20260930152442.172258560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 19cfadf3297bf..c360f70f1c8b9 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -737,9 +737,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
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
 
@@ -747,6 +751,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
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



