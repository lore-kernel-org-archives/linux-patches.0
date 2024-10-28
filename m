Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F9318E74D;
	Mon, 28 Oct 2024 06:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097533; cv=none; b=guL5CqN0Tp3J+XwNbJF1JcmTCuGdfn6azLSCF/3k7E5S1M/zV5dpEaPYwDIkYpBnBwTaU+Ne76HVPMX4WnkT29riegvK5qIJ+l8idLyki3UDeacMwVkyEpSpagTHgkoOjKHp4BAgrdOagWHNrfgCT5Fykt6M1XyMD8Nco0kaF8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097533; c=relaxed/simple;
	bh=s/rByy9AX1GuWzCuUX/dYHFNw+rThpjgmkn2/moCBvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SunZ+6JpHg2bg5PwKyPPKgUa/w04MozKMvzblv0SC13suqpuRV2xKAuR5G1nrx/lSLNVUDPosqpO1kUelB3EiDzrGSqVdcJGvSrflqluocQ3MSWb3MzZ9sj+LQRAd1+KseZD74W2TyhPEFtpZz7xcV6AWh1ocJbV1QQmKcTUd9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgXIvvD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgXIvvD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AE8C4CEC3;
	Mon, 28 Oct 2024 06:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097532;
	bh=s/rByy9AX1GuWzCuUX/dYHFNw+rThpjgmkn2/moCBvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgXIvvD23buathuE6Xoquhe6R7k/AGJmeP2X6QrQh5IdleSjNbtAotmRe/OyVfoei
	 Z9yhaKaUETiEw6Ds8RSvvJNkMs3OZmvEXIeSKBr8g15137nH4Sn9bZSfZZjmrWFtzR
	 A+m2o9iIdmzWUz7PcXDWZ5JNjXbt4aMxWh9sq8ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/208] RDMA/bnxt_re: Fix out of bound check
Date: Mon, 28 Oct 2024 07:23:35 +0100
Message-ID: <20241028062307.521784209@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit a9e6e7443922ac0a48243c35d03834c96926bff1 ]

Driver exports pacing stats only on GenP5 and P7 adapters. But while
parsing the pacing stats, driver has a check for "rdev->dbr_pacing".  This
caused a trace when KASAN is enabled.

BUG: KASAN: slab-out-of-bounds in bnxt_re_get_hw_stats+0x2b6a/0x2e00 [bnxt_re]
Write of size 8 at addr ffff8885942a6340 by task modprobe/4809

Fixes: 8b6573ff3420 ("bnxt_re: Update the debug counters for doorbell pacing")
Link: https://patch.msgid.link/r/1728373302-19530-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 128651c015956..1e63f80917483 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -366,7 +366,7 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 				goto done;
 			}
 		}
-		if (rdev->pacing.dbr_pacing)
+		if (rdev->pacing.dbr_pacing && bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
 			bnxt_re_copy_db_pacing_stats(rdev, stats);
 	}
 
-- 
2.43.0



