Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A311B388364;
	Tue, 10 Mar 2026 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142043; cv=none; b=aOhO2nqA7Vk/iHitvml33aTDdR1JFDtUBtyyQ0f0hSvxfACa7tJDKFLu/B6TRMwnJR9oWCPBqgidhkkW6IHcKlPZXE+XeOaHjhMnCOs8w4KV/Z3nP7sI638UYhO+85/1lmOGdOunPUsKn2zY811/CvYaJIKSuHd+q41A/4BityU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142043; c=relaxed/simple;
	bh=Pn5BGJbcgfzC6g35oA/yN9XarwmBoWfno7+j+YQGA/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCSy3BvDZA6VtlWoBw2FWKiNxleVLKLuBFOuZ+npMGOT1b3tP8Xj5dHSX16/lFaibsySVlJQF0VYIuGRVJSNUb1O7vhJIUTKlwWDZfZcF5CW/k9PsxTLCRQzlMNaOI7trOyMjvDewRQXQwnokqyfK85E7MYlhYpHnOG6YzKVy5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdnY350o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdnY350o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D391AC19423;
	Tue, 10 Mar 2026 11:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142043;
	bh=Pn5BGJbcgfzC6g35oA/yN9XarwmBoWfno7+j+YQGA/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdnY350oYzhGpnmmC9ngZi6JFebQrSS/V+EEQ7AOcAfmsmPKz/eeMm61rwfkhvLCX
	 GqjErBI83uzBClGNcKU7bNjo+qTWuxwzyjH0yLpxmVEBp6H7YubCQz3gv8jHfO+g18
	 m0VUfuazd+DWgq818jp/K3Lne537KAZhd48XycMiiVCylc6oAp0XDdXlAXSnkTPqAh
	 JdFOcVhEF3eUycuyhq7x2WVwkTldXhpTmS4NiyLkSuXQxiZmwTgBzun+/jVLZxMYFr
	 25ZGnYQ+ZUzomKXg/l6srcVYRTRc4uVnl8HbTnI4omzcueow4Eoi+3dswZcF6tWFWA
	 E7ZTrNcVenAww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 171/314] RDMA/ionic: Fix kernel stack leak in ionic_create_cq()
Date: Tue, 10 Mar 2026 07:17:10 -0400
Message-ID: <ec236cf1aca2dbac690a50f61f56f0f2d8078a00.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

commit faa72102b178c7ae6c6afea23879e7c84fc59b4e upstream.

struct ionic_cq_resp resp {
    __u32 cqid[2];         // offset 0 - PARTIALLY SET (see below)
    __u8  udma_mask;       // offset 8 - SET (resp.udma_mask = vcq->udma_mask)
    __u8  rsvd[7];         // offset 9 - NEVER SET <- LEAK
};

rsvd[7]: 7 bytes of stack memory leaked unconditionally.

cqid[2]: The loop at line 1256 iterates over udma_idx but skips indices
where !(vcq->udma_mask & BIT(udma_idx)). The array has 2 entries but
udma_count could be 1, meaning cqid[1] might never be written via
ionic_create_cq_common(). If udma_mask only has bit 0 set, cqid[1] (4
bytes) is also leaked. So potentially 11 bytes leaked.

Cc: stable@vger.kernel.org
Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/4-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Acked-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index ea12d9b8e125f..83573721af2c0 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -1218,7 +1218,7 @@ int ionic_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		rdma_udata_to_drv_context(udata, struct ionic_ctx, ibctx);
 	struct ionic_vcq *vcq = to_ionic_vcq(ibcq);
 	struct ionic_tbl_buf buf = {};
-	struct ionic_cq_resp resp;
+	struct ionic_cq_resp resp = {};
 	struct ionic_cq_req req;
 	int udma_idx = 0, rc;
 
-- 
2.51.0

