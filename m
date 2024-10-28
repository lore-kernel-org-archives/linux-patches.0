Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E912418E374;
	Mon, 28 Oct 2024 06:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097542; cv=none; b=lbIUgdKIUlFmKoyCeMChOBwvKzk5JXNLHpelkPTWKIVCdoYklIINErBMdcg+a1YU5SpZbAH/EUe0oZQDACyXY284mcJfR3AO08BsSofRfCuDyX3of48vLWhRBtanCezprY9LG/fYyaGsDqM2pYVCUzXgFvhUous/8jVkwFrCJ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097542; c=relaxed/simple;
	bh=ez1WNUYACjktdwux6bMcW5zH2b5lfzrWa52tcwYazbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWA0fKIogLi0hXMTv1UIkVG5ynKpgSF5AkEUjpNFsmt60T8lw4NunZMDI3HJ7VWWXqvdRlKNQVShEbnDa4rqAnLUj9e2SVhUVkoc16q+hAjSueQ/d5LkZAosTiV/SaVu2LrB0n1L4yPjWsOYyXIsop1uCeSdF9ll/YYsoqO9glk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fG/7kgJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fG/7kgJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BBCC4CEC3;
	Mon, 28 Oct 2024 06:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097541;
	bh=ez1WNUYACjktdwux6bMcW5zH2b5lfzrWa52tcwYazbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fG/7kgJUqX8MnLodEoDcWrJokQJ18XkJfUUPQlJTU6UBQr+RUKGzu30Nmk4ZcPZC6
	 09LKifrFCqsCH+UI8zy2pB5ersLJOyvPG5KvVOwFhnoyTc6bD9N/irrcdchGcCtkuf
	 KjAlc2NWwKLJUUW86EeKvCiCQn9CoTjrAHULWFGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/208] RDMA/bnxt_re: Fix the GID table length
Date: Mon, 28 Oct 2024 07:23:39 +0100
Message-ID: <20241028062307.618627672@linuxfoundation.org>
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

[ Upstream commit dc5006cfcf62bea88076a587344ba5e00e66d1c6 ]

GID table length is reported by FW. The gid index which is passed to the
driver during modify_qp/create_ah is restricted by the sgid_index field of
struct ib_global_route.  sgid_index is u8 and the max sgid possible is
256.

Each GID entry in HW will have 2 GID entries in the kernel gid table.  So
we can support twice the gid table size reported by FW. Also, restrict the
max GID to 256 also.

Fixes: 847b97887ed4 ("RDMA/bnxt_re: Restrict the max_gids to 256")
Link: https://patch.msgid.link/r/1728373302-19530-11-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 7e550432ccb14..0b98577cd7082 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -156,7 +156,14 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
 		attr->l2_db_size = (sb->l2_db_space_size + 1) *
 				    (0x01 << RCFW_DBR_BASE_PAGE_SHIFT);
-	attr->max_sgid = BNXT_QPLIB_NUM_GIDS_SUPPORTED;
+	/*
+	 * Read the max gid supported by HW.
+	 * For each entry in HW  GID in HW table, we consume 2
+	 * GID entries in the kernel GID table.  So max_gid reported
+	 * to stack can be up to twice the value reported by the HW, up to 256 gids.
+	 */
+	attr->max_sgid = le32_to_cpu(sb->max_gid);
+	attr->max_sgid = min_t(u32, BNXT_QPLIB_NUM_GIDS_SUPPORTED, 2 * attr->max_sgid);
 	attr->dev_cap_flags = le16_to_cpu(sb->dev_cap_flags);
 
 	bnxt_qplib_query_version(rcfw, attr->fw_ver);
-- 
2.43.0



