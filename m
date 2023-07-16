Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97FF8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58578C433C8;
	Sun, 16 Jul 2023 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538060;
	bh=w54u5yvgqbfpZ7B+eblfgWr3V142jshsCCp4iovDTuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRBdQQxXAui+ffrUZqL6+obZIRoLoZa7zOZOSunzn68MmdkObJRqkvFesdEcOlpfd
	 JwehhBbU3tXSNMDLCtM3bnaG5lbGNkqoBaKgIsX4jzVdlRb8ubNKbTHlEBn1atqrG6
	 YEZX14+tlAJBi+3mWAxKiiPhx0nvUTKdGgqcRoEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 271/800] RDMA/bnxt_re: Remove a redundant check inside bnxt_re_update_gid
Date: Sun, 16 Jul 2023 21:42:04 +0200
Message-ID: <20230716194955.388887058@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit b989f90cef0af48aa5679b6a75476371705ec53c ]

The NULL check inside bnxt_re_update_gid() always return false.  If
sgid_tbl->tbl is not allocated, then dev_init would have failed.

Fixes: 5fac5b1b297f ("RDMA/bnxt_re: Add vlan tag for untagged RoCE traffic when PFC is configured")
Link: https://lore.kernel.org/r/1684478897-12247-5-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index cb4465b0792b9..1936f4b4002a7 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -969,12 +969,6 @@ static int bnxt_re_update_gid(struct bnxt_re_dev *rdev)
 	if (!ib_device_try_get(&rdev->ibdev))
 		return 0;
 
-	if (!sgid_tbl) {
-		ibdev_err(&rdev->ibdev, "QPLIB: SGID table not allocated");
-		rc = -EINVAL;
-		goto out;
-	}
-
 	for (index = 0; index < sgid_tbl->active; index++) {
 		gid_idx = sgid_tbl->hw_id[index];
 
@@ -992,7 +986,7 @@ static int bnxt_re_update_gid(struct bnxt_re_dev *rdev)
 		rc = bnxt_qplib_update_sgid(sgid_tbl, &gid, gid_idx,
 					    rdev->qplib_res.netdev->dev_addr);
 	}
-out:
+
 	ib_device_put(&rdev->ibdev);
 	return rc;
 }
-- 
2.39.2



