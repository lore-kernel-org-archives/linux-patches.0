Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D72EF299;
	Thu,  3 Jul 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554214; cv=none; b=bRx+NGaCTNrJAFozYJItlBK31bNwrddFK8WuKDCpUdJNOiRFRzNA5HhZMES7rBlY1NlPpdq0ViDOdiq9VL4FhBgwgFA9lzVrnbvHxI05X8YCyN59y8NFR4Tpi3HwDqpolbsGKF7LK0+aHEPXxQ2edym52FRc3u48SO2vl8CmQvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554214; c=relaxed/simple;
	bh=FEYmclfBdXjCdxwXVEdh/8KPi214qbxEb4pJU/e2GCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqwCiJvaqEJtzhJFaobtJghOZM+B+lDHm42ukYBWpB0N0rKscip32nyLHwOZ06a4MGRu9OMAJYSy2nrmW8PZO1JiaJr4Ok8fHPfsX3Fnh1pbmNH2ku5bfNIwfE11DKEbTa5zU7RYZJT1t5F2tszQyCNq3+D7FrS7PRMojnQeJI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm2sUjy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm2sUjy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC0BC4AF09;
	Thu,  3 Jul 2025 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554214;
	bh=FEYmclfBdXjCdxwXVEdh/8KPi214qbxEb4pJU/e2GCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm2sUjy+EGX8wD3W2e4IA6gs5lavp3WlyMDaTINLTQUmMeRXQLbtIKfLcqRirpoer
	 fdySXQNRkW6xHF25U8WeiisaolV9DKil/gHLtQClgjRE+A6x4VJd5QA2fEQVZ8dk1e
	 ADZVE+ZQx2EJW6nyla4onqCdYCQmACW2cPgAjRRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/218] drm/xe: Process deferred GGTT node removals on device unwind
Date: Thu,  3 Jul 2025 16:41:04 +0200
Message-ID: <20250703144000.580199261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff19eca5d358b..e9820126feb96 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -198,6 +198,13 @@ static const struct xe_ggtt_pt_ops xelpg_pt_wa_ops = {
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
@@ -254,6 +261,10 @@ int xe_ggtt_init_early(struct xe_ggtt *ggtt)
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



