Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1457547052;
	Thu, 17 Sep 2026 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665091; cv=none; b=Uiq60aaJHmWQoc6WkGd03grk4j5hzZELtAamFX5IzSQyhKpGQzzbDbzBzjCZ3SANNluh4+abjP+oqfcjOUR5PoN1UxxlFiROaFm+mwcgWSq0pYAroDW/w62cy6/JRGwLGPIyQ6kYA31zKeCKK3HUPC+f3Yhf7+y+z+iNUtZQGXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665091; c=relaxed/simple;
	bh=vYJPVHt2QGkC75j6emqiK646st/Ue68yo6aXg++kN58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVguX/wwZuXeCv5QQci0qRQ59iFPYifxGaHGTvNH6b3QOKNNjYNQyxBxPznRdPYsiDvLfRU68l2CcVs9hFc5C467sDdcpifUR4VT+ZNru2etv3hPy1/G3BhCtID/tN+4YfEOpOlfz/LEq133fU9X+JsjvPw0tpUAzuBRMDWU2Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZi7Q2ML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZi7Q2ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0618F1F000FF;
	Thu, 17 Sep 2026 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665089;
	bh=D7B1nKyQc9+nCDGBheG4rlRbatjv9PXgIHaTJzlX98w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZi7Q2MLzc1VOqUbUYrUeC7K0838w5A2G/f00mbmPM2ALXdrW4ZfOX+vk3pbSBtNf
	 LEhSiIxTDl443W9HrjmpYPOPz70ZcwIa7mxmsUkww0Dur20+sNfxF2QTESdL2g11OJ
	 NxNDRQS7SDcgcyXoS8F+z1//phNifI+2MTCPGBPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0588/1250] RDMA/bnxt_re: Proper rollback if the ioremap fails
Date: Thu, 17 Sep 2026 16:06:23 +0100
Message-ID: <20260917151607.824320832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d321acb07335b..0fcea79eb110d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -721,9 +721,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
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
 
@@ -731,6 +735,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
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



