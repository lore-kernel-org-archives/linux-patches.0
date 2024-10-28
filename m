Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24718DF7D;
	Mon, 28 Oct 2024 06:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098034; cv=none; b=fYMvfQteDX2H2/hpWk6utlJ913cNhrSwKc9rCJfR6ICQ3+ERYTXSYuTfKgsyvWr8kgkdDarVMUe9/ESQhdob2VnKrrz3O0hBVjynPXXb1ZzNA+yVJ1zOurj28wD0Pgz6LNPZxeSy7yxUIaKUpa5fy6z0FGm1pKUQ/ihfbOTSzEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098034; c=relaxed/simple;
	bh=BANr4PTN2X2P5mRazVknbw+AbONfWE0SawxQTuqBLKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVGZ5RnloxRZhycRdNENUZD2df9CA6CdEZ1I09mS4bKSnO4PirDX1mOItEUuVhT5frIvD6vdeursaQSNfO2co35ANHWghRXqcGS39ZOFotYtGW0KJxkLkXMNBS0hllLJxF1w+v1FYZhaV9qxF8oGGhT9MN0ubH2WZhkEujuPR54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1RVUfU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1RVUfU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9461C4CEC3;
	Mon, 28 Oct 2024 06:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098034;
	bh=BANr4PTN2X2P5mRazVknbw+AbONfWE0SawxQTuqBLKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1RVUfU/6B7vhcq6MXmKxolQdqbLiAy7clbAmcBdzhUPvo3UteFNB7caUuN/oH55v
	 SlyH0sKzggN6eHk5g9X9kldnaftQbC4gHXkULELmyyKtkIYP2al8pemQawL74rgtSV
	 GkPriPhoKFj4V4dbEB3eKZhBtV5jeJFzDfa36GxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 047/261] RDMA/bnxt_re: Fix the GID table length
Date: Mon, 28 Oct 2024 07:23:09 +0100
Message-ID: <20241028062313.190656657@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8e59422dd137e..420f8613bcd51 100644
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
 	attr->dev_cap_flags2 = le16_to_cpu(sb->dev_cap_ext_flags_2);
 
-- 
2.43.0



