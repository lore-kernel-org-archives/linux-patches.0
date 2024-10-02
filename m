Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C731D0949;
	Wed,  2 Oct 2024 13:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876395; cv=none; b=g4XeWVWOwFlhgnfKW6rs5nCaSqGiScCwsEarEsMUg09Sd+uhJbKGcH7fw3ooiyhUojpgEfFF+i287BESISsNwWD5lyMEmyjXfQKEt/Lglo3RRn+ruedfxp26htU/mdhj3vH8TmtX48c8AasliQGMae64raFVP/0yZLNQZ9jLeYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876395; c=relaxed/simple;
	bh=c6vnXjBvZgAELsSsXN5WoWPyNwJOhskYveqgLr/3sTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsU6Ly5ztsJ84hXeGfKrDpxf+Kz7KjVL7+wlkjvbeG1G6gtymJah9Ie4emBANeFXETu6yNa4XC1Dh+3IOusqId6asAvvtcFGZBbQwH4Etaf1F3zKEq2Tni4O+gdI2OanUPP/hiVEKtjqYujTHv3o7O9xRuyiipgE+bs7IEE1ink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkvz4cFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkvz4cFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A6C4CECE;
	Wed,  2 Oct 2024 13:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876395;
	bh=c6vnXjBvZgAELsSsXN5WoWPyNwJOhskYveqgLr/3sTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkvz4cFtqko21U3geTuAAZxlaZOZ295FZRtl9oMLwsYMoBaMH9ci1gcyTaC3oPadM
	 1ax6CG11wUXHHkse0scFycpFiqmXF1ODi+TDIGtDPcBTTYxCqWlTQufR/2QI/TzvHO
	 Zx1g3D2h/SjKKSngdScqMIOL3ye6C5HaU+qKsNCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 422/695] RDMA/hns: Fix ah error counter in sw stat not increasing
Date: Wed,  2 Oct 2024 14:57:00 +0200
Message-ID: <20241002125839.297943704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 39c047d4047a1242aeefa87513174b56a91080ab ]

There are several error cases where hns_roce_create_ah() returns
directly without jumping to sw stat path, thus leading to a problem
that the ah error counter does not increase.

Fixes: ee20cc17e9d8 ("RDMA/hns: Support DSCP")
Fixes: eb7854d63db5 ("RDMA/hns: Support SW stats with debugfs")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240912115700.2016443-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 3e02c474f59fe..4fc5b9d5fea87 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -64,8 +64,10 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	u8 tc_mode = 0;
 	int ret;
 
-	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08 && udata)
-		return -EOPNOTSUPP;
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08 && udata) {
+		ret = -EOPNOTSUPP;
+		goto err_out;
+	}
 
 	ah->av.port = rdma_ah_get_port_num(ah_attr);
 	ah->av.gid_index = grh->sgid_index;
@@ -83,7 +85,7 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 		ret = 0;
 
 	if (ret && grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
-		return ret;
+		goto err_out;
 
 	if (tc_mode == HNAE3_TC_MAP_MODE_DSCP &&
 	    grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
@@ -91,8 +93,10 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	else
 		ah->av.sl = rdma_ah_get_sl(ah_attr);
 
-	if (!check_sl_valid(hr_dev, ah->av.sl))
-		return -EINVAL;
+	if (!check_sl_valid(hr_dev, ah->av.sl)) {
+		ret = -EINVAL;
+		goto err_out;
+	}
 
 	memcpy(ah->av.dgid, grh->dgid.raw, HNS_ROCE_GID_SIZE);
 	memcpy(ah->av.mac, ah_attr->roce.dmac, ETH_ALEN);
-- 
2.43.0



