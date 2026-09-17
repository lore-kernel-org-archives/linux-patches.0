Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718B749D584;
	Thu, 17 Sep 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664319; cv=none; b=LYoi200HGskFfmvBYJsHNcI6C+bc9yie3EFpC7W8yVl2/en5bRsEDbKoi1olDwfLxOEaPIZgTSaeIibPCR5uYiZ4boTlnvBvS8A9eZkE04yrW3m5JrGNU9OQRRLdoqrW61StJguaO6eDaRdjv1Mnm70BPDr+/OfUzgX0hnLN3S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664319; c=relaxed/simple;
	bh=V9uCXuXb1b4UiqwWt4Cl/kUYWlk3wJq21vo6H01hs5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJMM+Kal97/YneiBuxUhSM9gk+FfNYHNtu76aKAFz54BqYxWAMz30i7E8tUe+0jyrUC7Cz7APi0YxwF6FrCJiygZ62gYeYhgPBaNFFAbErqIScFI+ajfOe2Q/cWiK9A9pWhSMCgfNt/MI4w6NA4U32rLVMmp9I4XqYmVuzP6ZnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLouTdXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLouTdXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11671F000FF;
	Thu, 17 Sep 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664318;
	bh=QRpRAbBIgAiIjosoFc8Mkg9XiPPj+4k6cF2Duv+X9W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLouTdXc7a0+ww9rUHIjD9wyJ/pz8B9YkXgwZg8H2Puxd4ckq8tEmrPzHadv45TNA
	 G5LucyXrPt2PDVozjCwLl+heMiY7MV/rwnfF1iqGMDAc6sLo41P0pHPydtKddUGuLh
	 C0GLm87+jrR18vgtN+Tiv66ttRcB3vbdCBvvBJjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koba Ko <kobak@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0331/1250] cxl/region: Validate partition index before array access
Date: Thu, 17 Sep 2026 16:02:06 +0100
Message-ID: <20260917151601.062906276@linuxfoundation.org>
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

From: Koba Ko <kobak@nvidia.com>

[ Upstream commit 16329b510f76e5b824e05bf8add8b29850f1f16f ]

construct_region() reads cxled->part and uses it to index
cxlds->part[] without checking for a negative value. If the
partition was never resolved, part remains at its initial value
of -1, causing an out-of-bounds array access.

Add a guard to return -EBUSY when part is negative.

The check was dropped during a merge.

Signed-off-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260414024527.3399590-1-kobak@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index d518d463b28c4..e840ac002f9b1 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3521,6 +3521,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 	int rc, part = READ_ONCE(cxled->part);
 	struct cxl_region *cxlr;
 
+	if (part < 0)
+		return ERR_PTR(-EBUSY);
+
 	do {
 		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
 				       atomic_read(&cxlrd->region_id));
-- 
2.53.0



