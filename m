Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE61DDC23;
	Wed,  7 May 2025 18:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643741; cv=none; b=ui50++usNRpSPZ7CTVYABi6z1TSbyaiEgMjnM7xRNkPMaBqwk/JC7WYwcMpML3vNbNu3J8f+yDIQBPp46p4yIDft1tyRqlCK4kyamsEGwbWd/bvI1PiqRr3mZWrSUWmFFGBLoI1w1tuHOE5VkCyrMGtSYTUwMSYS+7Hd4wqoQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643741; c=relaxed/simple;
	bh=Yp17EldaxP9MZ2n9TUqbPcZB88cKXWQUkteN5BjCoCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmP3hfDwNENLjU2eH5VhRb8rF2cFJfOndz+pnzIXPC+7BhCqmhYho7qB1m9axxWTuTHsbJ7t+7apXkrOpshgkQF7tmsNlX99zoRg/hWHFyoTA0MkGfUgk0BiCmMsRQleSNA14UxREjexp8WvIojT+vT73/e2ECp+ga0Wz2/jmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+QlknsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+QlknsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94E0C4CEE2;
	Wed,  7 May 2025 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643741;
	bh=Yp17EldaxP9MZ2n9TUqbPcZB88cKXWQUkteN5BjCoCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+QlknsDZqkl0BH3Cit+tiaCmV+AoDqhryXacRBSIXoZXIlgxESgu52vK3xnmrTFz
	 f532+YM6apmKzBlWJAA7CLLExLC81AkWRSYHVx9qCeoXiD2bNYmegKkowpMgqf7FSJ
	 28wv17jCKjG17IzQDD7UyEiFnkAetmphi46Q5rJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 89/97] iommu/arm-smmu-v3: Use the new rb tree helpers
Date: Wed,  7 May 2025 20:40:04 +0200
Message-ID: <20250507183810.557013417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a2bb820e862d61f9ca1499e500915f9f505a2655 ]

Since v5.12 the rbtree has gained some simplifying helpers aimed at making
rb tree users write less convoluted boiler plate code. Instead the caller
provides a single comparison function and the helpers generate the prior
open-coded stuff.

Update smmu->streams to use rb_find_add() and rb_find().

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: b00d24997a11 ("iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 68 ++++++++++-----------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 96b72f3dad0d0..1ab2abab46800 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1443,26 +1443,37 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	return 0;
 }
 
+static int arm_smmu_streams_cmp_key(const void *lhs, const struct rb_node *rhs)
+{
+	struct arm_smmu_stream *stream_rhs =
+		rb_entry(rhs, struct arm_smmu_stream, node);
+	const u32 *sid_lhs = lhs;
+
+	if (*sid_lhs < stream_rhs->id)
+		return -1;
+	if (*sid_lhs > stream_rhs->id)
+		return 1;
+	return 0;
+}
+
+static int arm_smmu_streams_cmp_node(struct rb_node *lhs,
+				     const struct rb_node *rhs)
+{
+	return arm_smmu_streams_cmp_key(
+		&rb_entry(lhs, struct arm_smmu_stream, node)->id, rhs);
+}
+
 static struct arm_smmu_master *
 arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 {
 	struct rb_node *node;
-	struct arm_smmu_stream *stream;
 
 	lockdep_assert_held(&smmu->streams_mutex);
 
-	node = smmu->streams.rb_node;
-	while (node) {
-		stream = rb_entry(node, struct arm_smmu_stream, node);
-		if (stream->id < sid)
-			node = node->rb_right;
-		else if (stream->id > sid)
-			node = node->rb_left;
-		else
-			return stream->master;
-	}
-
-	return NULL;
+	node = rb_find(&sid, &smmu->streams, arm_smmu_streams_cmp_key);
+	if (!node)
+		return NULL;
+	return rb_entry(node, struct arm_smmu_stream, node)->master;
 }
 
 /* IRQ and event handlers */
@@ -2590,8 +2601,6 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 {
 	int i;
 	int ret = 0;
-	struct arm_smmu_stream *new_stream, *cur_stream;
-	struct rb_node **new_node, *parent_node = NULL;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
 
 	master->streams = kcalloc(fwspec->num_ids, sizeof(*master->streams),
@@ -2602,9 +2611,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
+		struct arm_smmu_stream *new_stream = &master->streams[i];
 		u32 sid = fwspec->ids[i];
 
-		new_stream = &master->streams[i];
 		new_stream->id = sid;
 		new_stream->master = master;
 
@@ -2613,28 +2622,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 			break;
 
 		/* Insert into SID tree */
-		new_node = &(smmu->streams.rb_node);
-		while (*new_node) {
-			cur_stream = rb_entry(*new_node, struct arm_smmu_stream,
-					      node);
-			parent_node = *new_node;
-			if (cur_stream->id > new_stream->id) {
-				new_node = &((*new_node)->rb_left);
-			} else if (cur_stream->id < new_stream->id) {
-				new_node = &((*new_node)->rb_right);
-			} else {
-				dev_warn(master->dev,
-					 "stream %u already in tree\n",
-					 cur_stream->id);
-				ret = -EINVAL;
-				break;
-			}
-		}
-		if (ret)
+		if (rb_find_add(&new_stream->node, &smmu->streams,
+				arm_smmu_streams_cmp_node)) {
+			dev_warn(master->dev, "stream %u already in tree\n",
+				 sid);
+			ret = -EINVAL;
 			break;
-
-		rb_link_node(&new_stream->node, parent_node, new_node);
-		rb_insert_color(&new_stream->node, &smmu->streams);
+		}
 	}
 
 	if (ret) {
-- 
2.39.5



