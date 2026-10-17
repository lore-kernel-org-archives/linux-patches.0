Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CFD38F950;
	Sat, 17 Oct 2026 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260391; cv=none; b=j9x6FG5plkAPlefSdVF5FcVaZALN7+SDSH1JyzyOikpRVHKiRNWuI7nJEbWrwQ4sirl2WezrSnhvBk6McIZtm8LRdElanlfx7HEQ3Bs0RL/0hqRwi9GY7O0f+yKbIaYBN7DHnKHNZ01tycb0bZnlTl/5tN/v1GquyLkDZTo5x54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260391; c=relaxed/simple;
	bh=7JHKIpbQjcND464pMFEhc1dqypte3W7JafZOH79hxyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6024kMp4qaoagL8CrR0Vjpk6U7vkonIEKkdkPmpXhDl2v8YAg2iNz2doW+HGn02vHnLFfu915UUssHvLRj6OAWjcglX7/KCaqAnN7ejqmmS7VfXvzW+p3te2GJO7ZY4oMKj0xkpNpTtcN2VYkyXd3Hkja3VxmQXi2s1hpCHSs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKGIFSBG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKGIFSBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AAF1F000C4;
	Sat, 17 Oct 2026 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260390;
	bh=vNV3W2SPgtefcg6U6p0lOEIqQdRaeCbkhHqAAav9E6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKGIFSBGzzCeQO1ZlaNTd7BTx3stKFS1ZD/J01rj9bsPiUyMR2/pobGIvW9oTNQ4G
	 LOeZD4+bxTWr3uJb7zzoE2beojKfhhdQm3AncyRj1CPtOpVzPPGRpzujW4vhwi8hEK
	 w8TN7Ot6n01eanOsXtSLvTWoW9vqEZd+plIZBC7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1528/1674] drm/amdgpu/ras: add ras_suspend callback and use it for cp_ecc_error_irq
Date: Sat, 17 Oct 2026 18:03:20 +0200
Message-ID: <20261017160510.341945008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit e3829992dd9fa0a82511af4f01733fc854cd15a5 ]

cp_ecc_error_irq is acquired in amdgpu_gfx_ras_late_init() but
released in gfx_v9_0_hw_fini(), so the put site has to query
amdgpu_irq_enabled() because the get is skipped on SR-IOV VF.

ras_late_init / ras_fini have no suspend counterpart, so move the
put to amdgpu_gfx_ras_suspend() / amdgpu_gfx_ras_fini() and add a
matching ras_suspend callback that is invoked from
amdgpu_ras_suspend() before disable_all_features().  The get and
put now sit in the same place and check the same condition (not
VF, funcs registered), no refcount querying needed.

An active flag gates ras_fini so the
suspend-then-unload-without-resume path falls into
amdgpu_ras_block_late_fini_default() instead of double-releasing
what ras_suspend already cleaned up.

Drop the cp_ecc_error_irq put from gfx_v9_0_hw_fini().  gfx_v8_0
manages cp_ecc_error_irq locally and is unaffected; no other GFX
generation has this IRQ.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 25 ++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h |  3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 32 +++++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h |  1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |  2 --
 5 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index e7b053898f9e9..4ade7b68ad154 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -803,7 +803,7 @@ int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *r
 		if (r)
 			return r;
 
-		if (adev->gfx.cp_ecc_error_irq.funcs) {
+		if (!amdgpu_sriov_vf(adev) && adev->gfx.cp_ecc_error_irq.funcs) {
 			r = amdgpu_irq_get(adev, &adev->gfx.cp_ecc_error_irq, 0);
 			if (r)
 				goto late_fini;
@@ -818,6 +818,23 @@ int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *r
 	return r;
 }
 
+void amdgpu_gfx_ras_suspend(struct amdgpu_device *adev,
+			    struct ras_common_if *ras_block)
+{
+	if (amdgpu_ras_is_supported(adev, ras_block->block) &&
+	    !amdgpu_sriov_vf(adev) && adev->gfx.cp_ecc_error_irq.funcs)
+		amdgpu_irq_put(adev, &adev->gfx.cp_ecc_error_irq, 0);
+}
+
+void amdgpu_gfx_ras_fini(struct amdgpu_device *adev,
+			 struct ras_common_if *ras_block)
+{
+	if (amdgpu_ras_is_supported(adev, ras_block->block) &&
+	    !amdgpu_sriov_vf(adev) && adev->gfx.cp_ecc_error_irq.funcs)
+		amdgpu_irq_put(adev, &adev->gfx.cp_ecc_error_irq, 0);
+	amdgpu_ras_block_late_fini(adev, ras_block);
+}
+
 int amdgpu_gfx_ras_sw_init(struct amdgpu_device *adev)
 {
 	int err = 0;
@@ -846,6 +863,12 @@ int amdgpu_gfx_ras_sw_init(struct amdgpu_device *adev)
 	if (!ras->ras_block.ras_late_init)
 		ras->ras_block.ras_late_init = amdgpu_gfx_ras_late_init;
 
+	if (!ras->ras_block.ras_suspend)
+		ras->ras_block.ras_suspend = amdgpu_gfx_ras_suspend;
+
+	if (!ras->ras_block.ras_fini)
+		ras->ras_block.ras_fini = amdgpu_gfx_ras_fini;
+
 	/* If not defined special ras_cb function, use default ras_cb */
 	if (!ras->ras_block.ras_cb)
 		ras->ras_block.ras_cb = amdgpu_gfx_process_ras_data_cb;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
index 0ca95c4d4bfbe..405d6b73afeb8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
@@ -516,7 +516,8 @@ bool amdgpu_gfx_is_me_queue_enabled(struct amdgpu_device *adev, int me,
 void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable);
 int amdgpu_get_gfx_off_status(struct amdgpu_device *adev, uint32_t *value);
 int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *ras_block);
-void amdgpu_gfx_ras_fini(struct amdgpu_device *adev);
+void amdgpu_gfx_ras_suspend(struct amdgpu_device *adev, struct ras_common_if *ras_block);
+void amdgpu_gfx_ras_fini(struct amdgpu_device *adev, struct ras_common_if *ras_block);
 int amdgpu_get_gfx_off_entrycount(struct amdgpu_device *adev, u64 *value);
 int amdgpu_get_gfx_off_residency(struct amdgpu_device *adev, u32 *residency);
 int amdgpu_set_gfx_off_residency(struct amdgpu_device *adev, bool value);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 4214bbd7a1a23..65a5edcb12ba4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -86,6 +86,9 @@ struct amdgpu_ras_block_list {
 	struct list_head node;
 
 	struct amdgpu_ras_block_object *ras_obj;
+
+	/* set by ras_late_init, cleared by ras_suspend/ras_fini */
+	bool active;
 };
 
 const char *get_ras_block_str(struct ras_common_if *ras_block)
@@ -2886,10 +2889,23 @@ void amdgpu_ras_resume(struct amdgpu_device *adev)
 void amdgpu_ras_suspend(struct amdgpu_device *adev)
 {
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
+	struct amdgpu_ras_block_list *node;
+	struct amdgpu_ras_block_object *obj;
 
 	if (!adev->ras_enabled || !con)
 		return;
 
+	/* run per-block ras_suspend before tearing down the RAS context */
+	list_for_each_entry(node, &adev->ras_list, node) {
+		if (!node->active)
+			continue;
+
+		obj = node->ras_obj;
+		if (obj && obj->ras_suspend)
+			obj->ras_suspend(adev, &obj->ras_comm);
+		node->active = false;
+	}
+
 	amdgpu_ras_disable_all_features(adev, 0);
 	/* Make sure all ras objects are disabled. */
 	if (con->features)
@@ -2920,8 +2936,15 @@ int amdgpu_ras_late_init(struct amdgpu_device *adev)
 					obj->ras_comm.name, r);
 				return r;
 			}
-		} else
-			amdgpu_ras_block_late_init_default(adev, &obj->ras_comm);
+		} else {
+			r = amdgpu_ras_block_late_init_default(adev, &obj->ras_comm);
+			if (r) {
+				dev_err(adev->dev, "%s failed to execute ras_block_late_init_default! ret:%d\n",
+					obj->ras_comm.name, r);
+				return r;
+			}
+		}
+		node->active = true;
 	}
 
 	return 0;
@@ -2955,11 +2978,12 @@ int amdgpu_ras_fini(struct amdgpu_device *adev)
 	list_for_each_entry_safe(ras_node, tmp, &adev->ras_list, node) {
 		if (ras_node->ras_obj) {
 			obj = ras_node->ras_obj;
-			if (amdgpu_ras_is_supported(adev, obj->ras_comm.block) &&
-			    obj->ras_fini)
+			/* fall back to default cleanup if ras_suspend already ran */
+			if (ras_node->active && obj->ras_fini)
 				obj->ras_fini(adev, &obj->ras_comm);
 			else
 				amdgpu_ras_block_late_fini_default(adev, &obj->ras_comm);
+			ras_node->active = false;
 		}
 
 		/* Clear ras blocks from ras_list and free ras block list node */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index ffb49b2d533ad..742449833c8b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -551,6 +551,7 @@ struct amdgpu_ras_block_object {
 	int (*ras_block_match)(struct amdgpu_ras_block_object *block_obj,
 				enum amdgpu_ras_block block, uint32_t sub_block_index);
 	int (*ras_late_init)(struct amdgpu_device *adev, struct ras_common_if *ras_block);
+	void (*ras_suspend)(struct amdgpu_device *adev, struct ras_common_if *ras_block);
 	void (*ras_fini)(struct amdgpu_device *adev, struct ras_common_if *ras_block);
 	ras_ih_cb ras_cb;
 	const struct amdgpu_ras_block_hw_ops *hw_ops;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index b1b4f75ebad35..4bcd5a93415b2 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3776,8 +3776,6 @@ static int gfx_v9_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__GFX))
-		amdgpu_irq_put(adev, &adev->gfx.cp_ecc_error_irq, 0);
 	amdgpu_irq_put(adev, &adev->gfx.priv_reg_irq, 0);
 	amdgpu_irq_put(adev, &adev->gfx.priv_inst_irq, 0);
 
-- 
2.53.0



