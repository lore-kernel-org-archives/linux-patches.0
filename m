Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1EA2ED143;
	Thu,  3 Jul 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555073; cv=none; b=k/uAlHFJR7aYnx7/hDXLIk4ETZINNiY+KL6CSFaMNvf6qqZbvlXQKEKBZOVCoSgEAo0Yk2bxN4PA0lvfoI8X4euMuAgHv3L+OCmcREfIZZ52ynV7RnHm0GtdhZHynb5LGkCojBXSBo9I9MIZ0MUL+mZDNdsWEhFf1GoFvnWEDCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555073; c=relaxed/simple;
	bh=Pl04QGGXh8Bqreg5ZQ/FOtHl7MK1qouMXlAMjtHHYLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9xX3MEAwTJ9P4dCy6AM2WjoT5sQ/UD/SuKM24QXLP/xM2E8m6cvX848wUzfHUtcDvYIrGxmpIBSSb0kz03L9vvy+7AIn/9MRzXOiPgyzjouw2MTbmurR+kFyu7MDjhj1kZUugAhPKjjnwUYTIrqr1GFgkJ+zGeT0Zqw0HMgutc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCQ2s5oF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCQ2s5oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F25BC4CEEE;
	Thu,  3 Jul 2025 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555073;
	bh=Pl04QGGXh8Bqreg5ZQ/FOtHl7MK1qouMXlAMjtHHYLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCQ2s5oFCkKU0KKMwvI6rLsneLiwEI8LCZ2Srw8/sMMZipBUTB5Ppbe9NiJjdmxXY
	 dCZmSZVbMVEmgoWfoOH3Rd7qKjg904bFFbNUBwuUuXj00nqOx+xpdWEilZJ1g6bwuF
	 qhoY3DCkg68iEnS/pLy2fdj7bgrrN9wpdhTqS30I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 169/263] drm/xe: Process deferred GGTT node removals on device unwind
Date: Thu,  3 Jul 2025 16:41:29 +0200
Message-ID: <20250703144011.132633083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit af2b588abe006bd55ddd358c4c3b87523349c475 ]

While we are indirectly draining our dedicated workqueue ggtt->wq
that we use to complete asynchronous removal of some GGTT nodes,
this happends as part of the managed-drm unwinding (ggtt_fini_early),
which could be later then manage-device unwinding, where we could
already unmap our MMIO/GMS mapping (mmio_fini).

This was recently observed during unsuccessful VF initialization:

 [ ] xe 0000:00:02.1: probe with driver xe failed with error -62
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e747340 __xe_bo_unpin_map_no_vm (16 bytes)
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e747540 __xe_bo_unpin_map_no_vm (16 bytes)
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e747240 __xe_bo_unpin_map_no_vm (16 bytes)
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e747040 tiles_fini (16 bytes)
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e746840 mmio_fini (16 bytes)
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e747f40 xe_bo_pinned_fini (16 bytes)
 [ ] xe 0000:00:02.1: DEVRES REL ffff88811e746b40 devm_drm_dev_init_release (16 bytes)
 [ ] xe 0000:00:02.1: [drm:drm_managed_release] drmres release begin
 [ ] xe 0000:00:02.1: [drm:drm_managed_release] REL ffff88810ef81640 __fini_relay (8 bytes)
 [ ] xe 0000:00:02.1: [drm:drm_managed_release] REL ffff88810ef80d40 guc_ct_fini (8 bytes)
 [ ] xe 0000:00:02.1: [drm:drm_managed_release] REL ffff88810ef80040 __drmm_mutex_release (8 bytes)
 [ ] xe 0000:00:02.1: [drm:drm_managed_release] REL ffff88810ef80140 ggtt_fini_early (8 bytes)

and this was leading to:

 [ ] BUG: unable to handle page fault for address: ffffc900058162a0
 [ ] #PF: supervisor write access in kernel mode
 [ ] #PF: error_code(0x0002) - not-present page
 [ ] Oops: Oops: 0002 [#1] SMP NOPTI
 [ ] Tainted: [W]=WARN
 [ ] Workqueue: xe-ggtt-wq ggtt_node_remove_work_func [xe]
 [ ] RIP: 0010:xe_ggtt_set_pte+0x6d/0x350 [xe]
 [ ] Call Trace:
 [ ]  <TASK>
 [ ]  xe_ggtt_clear+0xb0/0x270 [xe]
 [ ]  ggtt_node_remove+0xbb/0x120 [xe]
 [ ]  ggtt_node_remove_work_func+0x30/0x50 [xe]
 [ ]  process_one_work+0x22b/0x6f0
 [ ]  worker_thread+0x1e8/0x3d

Add managed-device action that will explicitly drain the workqueue
with all pending node removals prior to releasing MMIO/GSM mapping.

Fixes: 919bb54e989c ("drm/xe: Fix missing runtime outer protection for ggtt_remove_node")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250612220937.857-2-michal.wajdeczko@intel.com
(cherry picked from commit 89d2835c3680ab1938e22ad81b1c9f8c686bd391)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index 5fcb2b4c2c139..60bce5de52725 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -201,6 +201,13 @@ static const struct xe_ggtt_pt_ops xelpg_pt_wa_ops = {
 	.ggtt_set_pte = xe_ggtt_set_pte_and_flush,
 };
 
+static void dev_fini_ggtt(void *arg)
+{
+	struct xe_ggtt *ggtt = arg;
+
+	drain_workqueue(ggtt->wq);
+}
+
 /**
  * xe_ggtt_init_early - Early GGTT initialization
  * @ggtt: the &xe_ggtt to be initialized
@@ -257,6 +264,10 @@ int xe_ggtt_init_early(struct xe_ggtt *ggtt)
 	if (err)
 		return err;
 
+	err = devm_add_action_or_reset(xe->drm.dev, dev_fini_ggtt, ggtt);
+	if (err)
+		return err;
+
 	if (IS_SRIOV_VF(xe)) {
 		err = xe_gt_sriov_vf_prepare_ggtt(xe_tile_get_gt(ggtt->tile, 0));
 		if (err)
-- 
2.39.5



