Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886947044D;
	Tue, 21 Jul 2026 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656970; cv=none; b=fsG5J08gBv25NJrsWuKjP9fycVLB6nRnsS4aA/FA5hEIXlMIRM3cjItV2C7jm+5fIhSv0sVM5W6RvW4fgkizjFTn1osvNgYpGrL9INPHyC7r9A/UU3YUprWCzE2G4X609j6lHGzSaZIAetavhmJv0dc5Lx5sGQuy6fw0wmuWyMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656970; c=relaxed/simple;
	bh=feBk2Sufv54jfX9bpyI/rCI1JjzMTYEYetUkWyyRAv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATPBe0kXEm/loRenLdvCMnn/4uZvxYQI/wsATh24GS9zoCle0qg87vkMNJH4AChkgBBMxYUbVGglLm4BhXFrFn/Tmj6qx9YRX9pIXSidUpwA2t2lWBMeOwXDqzc2Ivejm56YRgxES/klEq0BMq5vXYMvxwUGoKFU4kdRtDWesM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcVPdN/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcVPdN/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D240D1F000E9;
	Tue, 21 Jul 2026 18:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656968;
	bh=30YKKBg+iwDaNOPp+gsILkmHevUHfoRc2XAWPsB4g3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcVPdN/h7CK/nkCms9uf99o2b/wL88lE7uzyh+NzBSRy4x2MGokOxH4IrMwsqUVou
	 Z60eIEjuLXM0foaq2msDpY2+E63EICZIN86TqIW3zD300924sn0YoyjvHOZggoEAGq
	 /yS7b44yD/VFszCTNbIic/0y04cvBBCzssmTGIXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0560/1611] RDMA/bnxt_re: Fail DBR related page allocation UAPIs if the feature is disabled
Date: Tue, 21 Jul 2026 17:11:16 +0200
Message-ID: <20260721152527.973122289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit a57592c6392a8e333c9c2731701297a5a279313a ]

No need to support the DBR related page allocations if the pacing feature
is disabled. Fail the request if pacing is disabled.

Fixes: ea2224857882 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
Link: https://patch.msgid.link/r/20260615224751.232802-15-selvin.xavier@broadcom.com
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/uapi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 0145882e49f6ed..d5e29d95a6385c 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -112,12 +112,16 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
 
 		break;
 	case BNXT_RE_ALLOC_DBR_BAR_PAGE:
+		if (!rdev->pacing.dbr_pacing)
+			return -EOPNOTSUPP;
 		length = PAGE_SIZE;
 		addr = (u64)rdev->pacing.dbr_bar_addr;
 		mmap_flag = BNXT_RE_MMAP_DBR_BAR;
 		break;
 
 	case BNXT_RE_ALLOC_DBR_PAGE:
+		if (!rdev->pacing.dbr_pacing)
+			return -EOPNOTSUPP;
 		length = PAGE_SIZE;
 		addr = (u64)rdev->pacing.dbr_page;
 		mmap_flag = BNXT_RE_MMAP_DBR_PAGE;
-- 
2.53.0



