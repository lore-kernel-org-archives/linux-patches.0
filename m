Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776DC2F691F;
	Thu, 28 May 2026 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998907; cv=none; b=fv6e179kBJFuSJydxhjDXU6DD55C4DyYFCfvX7panA7Nc+OoRyj+HVCslCrq0dCxRbVyMSWnTDixgTIn3z3U5r1h3lPfS/UrnHQo9Z4XFDa1ODxUPKbooRgSQ1AFnbz39CYsyckGRJBcbMuuXS4iKNZEgIW/VPMmz0yaY1FzZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998907; c=relaxed/simple;
	bh=ZufeHywBbfyCjkt/8N3vc33bmRvbu8GndFttBRzAVZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj/VT4FeNCo2cJSNwGgP0sTBi6zsHs29VrrEH6BKpV139fvnPAoqXpXP2YDOql0dr6dNnAbZ5B3oyoR0BE6KxMbB9ENGfS72gInlQ2IGCIIpYkxfeVnn33q+UELwcZegqBQthv/7gGiZ5yOOaD0dfcGJeWhV8JWrFW5t1bzZ3/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ca/fXQM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ca/fXQM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBE31F000E9;
	Thu, 28 May 2026 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998906;
	bh=5BofnAC95mDsd4WN+JFfb42luWelGbawjv8U+NzXQoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ca/fXQM8h4H9MXktlAmbQUWngUJaOiV4ME/00kM5KUsZPhWVt2T99NCNZhgmVjXfQ
	 k3Kmjji0Zrakxep0o4PwzQgjwrjuyC9ZMAsd+MNkyNRKuFiJtQ1RHqps7Y8VXRrQu3
	 lSkMuD4SQiCeijkfx49jSL/6aWnnexR3/owDLk68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Josua Mayer <josua@solid-run.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Pranjal Shrivastava <praan@google.com>
Subject: [PATCH 7.0 340/461] iommupt: Fix the end_index calculation in __map_range_leaf()
Date: Thu, 28 May 2026 21:47:49 +0200
Message-ID: <20260528194657.204442212@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 58829512ad461af8f35941069c209941e3a97b65 ]

Sashiko noticed a mismatch of units in this math: num_leaves is
actually the number of leaf *entries* (so a 16-item contiguous leaf
is one num_leaves), while index is in items. The mismatch in maths
causes __map_range_leaf() to exit early instead of efficiently
filling a larger range of contiguous PTEs.

The early exit is caught by the functions above and then
__map_range_leaf() is re-invoked, so there is no functional issue.

Correct the misuse of units by adjusting num_leaves with the leaf
size and avoid the performance cost of looping externally.

There are also some mismatched types for num_leaves; simplify
things to remove the duplicated calculations.

Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewd-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/generic_pt/iommu_pt.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 4be33c45bedc9..55faad4b9dc75 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -523,10 +523,12 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	struct pt_state pts = pt_init(range, level, table);
 	struct pt_iommu_map_args *map = arg;
 	unsigned int leaf_pgsize_lg2 = map->leaf_pgsize_lg2;
+	unsigned int leaves_avail;
 	unsigned int start_index;
 	pt_oaddr_t oa = map->oa;
-	unsigned int num_leaves;
+	pt_vaddr_t num_leaves;
 	unsigned int orig_end;
+	unsigned int step_lg2;
 	pt_vaddr_t last_va;
 	unsigned int step;
 	bool need_contig;
@@ -535,21 +537,25 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	PT_WARN_ON(map->leaf_level != level);
 	PT_WARN_ON(!pt_can_have_leaf(&pts));
 
-	step = log2_to_int_t(unsigned int,
-			     leaf_pgsize_lg2 - pt_table_item_lg2sz(&pts));
-	need_contig = leaf_pgsize_lg2 != pt_table_item_lg2sz(&pts);
+	step_lg2 = leaf_pgsize_lg2 - pt_table_item_lg2sz(&pts);
+	step = log2_to_int_t(unsigned int, step_lg2);
+	need_contig = step_lg2 != 0;
 
 	_pt_iter_first(&pts);
 	start_index = pts.index;
 	orig_end = pts.end_index;
-	if (pts.index + map->num_leaves < pts.end_index) {
+	leaves_avail =
+		log2_div_t(unsigned int, pts.end_index - pts.index, step_lg2);
+	if (map->num_leaves <= leaves_avail) {
 		/* Need to stop in the middle of the table to change sizes */
-		pts.end_index = pts.index + map->num_leaves;
+		pts.end_index = pts.index + log2_mul(map->num_leaves, step_lg2);
 		num_leaves = 0;
 	} else {
-		num_leaves = map->num_leaves - (pts.end_index - pts.index);
+		num_leaves = map->num_leaves - leaves_avail;
 	}
 
+	PT_WARN_ON(
+		log2_mod_t(unsigned int, pts.end_index - pts.index, step_lg2));
 	do {
 		pts.type = pt_load_entry_raw(&pts);
 		if (pts.type != PT_ENTRY_EMPTY || need_contig) {
-- 
2.53.0



