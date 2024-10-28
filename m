Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252A08837;
	Mon, 28 Oct 2024 06:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097916; cv=none; b=eX7SSBGXnIWujiRRmNRsHyYX9EGeR81dDUS5kmqAvX07Gp6+OCH1TqwftXsDrSFs+HalYUmysE54iTzq5hZsawnLsnOV5E7gN6C6S38nHclVyOKv11kS+PC+ZxCFDcwec8jzAdQHvVV3VRlUKlLdGFpLHOD2qWanqRXTKTGsTk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097916; c=relaxed/simple;
	bh=Lf/pva2e3SehLq6MTANTeS8ZZJZf/Q0i9/rixAV/cgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQxCXWSuKEC/YG4PjTvp7e/OEpZtBkphVEfwWVQUNiiUUUYjLFokuggDNR0tvW2ErtV2uKlFWgUqiugAddgRsJwcPdnADQPrLSforG+xSqCxB/3763Zkc1WC8PBzgeM+aKwxxshsbbPczuZILPKh61lT6ND8OroF8hntESfl394=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmFQ6XBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmFQ6XBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9723EC4CEC3;
	Mon, 28 Oct 2024 06:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097916;
	bh=Lf/pva2e3SehLq6MTANTeS8ZZJZf/Q0i9/rixAV/cgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmFQ6XBdN7NzO6ipYrQfUTVHBaequx+1+DeTi18cxgh3MS6ZugPM1NJiE4+HIyZHi
	 4O87Y1Wo/ntojeAwUSqVOgMjIEwAvRYRZIwpee08AjWVfQEQjaQmjDFVn8+564BalX
	 U7+HsvhvQLPkzlf14zzMGPPechzzGzOYoRxoJtfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 204/208] RDMA/bnxt_re: Fix the offset for GenP7 adapters for user applications
Date: Mon, 28 Oct 2024 07:26:24 +0100
Message-ID: <20241028062311.669136451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit 9248f363d0791a548a9c7711365b8be4c70bd375 upstream.

User Doorbell page indexes start at an offset for GenP7 adapters.
Fix the offset that will be used for user doorbell page indexes.

Fixes: a62d68581441 ("RDMA/bnxt_re: Update the BAR offsets")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1702987900-5363-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -107,12 +107,14 @@ static void bnxt_re_set_db_offset(struct
 		dev_info(rdev_to_dev(rdev),
 			 "Couldn't get DB bar size, Low latency framework is disabled\n");
 	/* set register offsets for both UC and WC */
-	if (bnxt_qplib_is_chip_gen_p7(cctx))
+	if (bnxt_qplib_is_chip_gen_p7(cctx)) {
 		res->dpi_tbl.ucreg.offset = offset;
-	else
+		res->dpi_tbl.wcreg.offset = en_dev->l2_db_size;
+	} else {
 		res->dpi_tbl.ucreg.offset = res->is_vf ? BNXT_QPLIB_DBR_VF_DB_OFFSET :
 							 BNXT_QPLIB_DBR_PF_DB_OFFSET;
-	res->dpi_tbl.wcreg.offset = res->dpi_tbl.ucreg.offset;
+		res->dpi_tbl.wcreg.offset = res->dpi_tbl.ucreg.offset;
+	}
 
 	/* If WC mapping is disabled by L2 driver then en_dev->l2_db_size
 	 * is equal to the DB-Bar actual size. This indicates that L2


