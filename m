Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF0F349B09;
	Tue,  6 Jan 2026 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719923; cv=none; b=aDWiYufUG1snbOadHprlc/8aQN2dCeiGVAlxOdEGqWq5LlrSLwJxRz7o7YWO6wGEy/Dj2sH8Z3ybsmtQ2Zga9g8Hsx64XwNuJzHmmEf8lbi9B9KdShL6oIQ0YGQn9d+sId2/p6i3Q5c87U8Z9e7bf9CKBlvem2xVG58Wes1Gi/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719923; c=relaxed/simple;
	bh=nPTYtfBj39Nzm7ta159JQ4ind0CBc8vsoZZSibbwJPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRdKim3TXr9ubSU3Q5UAMYxBMn9MIvL7rG6SthijNtsVbzwCtO0L9U5HmDqWIx1yWegUVQ82qGdEa/2zDnykJD0dELuWkrTjFZSuc61SX9kuhwRJcaw4AWJUkDkk4TCvhLCVXFSkdnz6TSeDZZVmYXh9BHGKV3Ky0AAl5MqbWps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/qYKw72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/qYKw72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4096C116C6;
	Tue,  6 Jan 2026 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719923;
	bh=nPTYtfBj39Nzm7ta159JQ4ind0CBc8vsoZZSibbwJPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/qYKw72F1M63VPRiiMw+xDGHlfLqETQqWUwJbUSWsUZLWZwHqNcubJxzfImenDBD
	 uHKODaLWo4gg7bdr1SudZDfYBXMPCI6ME3olB+ugVyirGE1hspWQRqxGI3rI4KFopy
	 yHrW/3731QjsqKKPts91oDlYWgowHFHLGpKzxLe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Maslak <jan.maslak@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/567] drm/xe: Restore engine registers before restarting schedulers after GT reset
Date: Tue,  6 Jan 2026 17:57:44 +0100
Message-ID: <20260106170454.364453213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jan Maslak <jan.maslak@intel.com>

[ Upstream commit eed5b815fa49c17d513202f54e980eb91955d3ed ]

During GT reset recovery in do_gt_restart(), xe_uc_start() was called
before xe_reg_sr_apply_mmio() restored engine-specific registers. This
created a race window where the scheduler could run jobs before hardware
state was fully restored.

This caused failures in eudebug tests (xe_exec_sip_eudebug@breakpoint-
waitsip-*) where TD_CTL register (containing TD_CTL_GLOBAL_DEBUG_ENABLE)
wasn't restored before jobs started executing. Breakpoints would fail to
trigger SIP entry because the debug enable bit wasn't set yet.

Fix by moving xe_uc_start() after all MMIO register restoration,
including engine registers and CCS mode configuration, ensuring all
hardware state is fully restored before any jobs can be scheduled.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Jan Maslak <jan.maslak@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251210145618.169625-2-jan.maslak@intel.com
(cherry picked from commit 825aed0328588b2837636c1c5a0c48795d724617)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index de011f5629fd..292947e44a8a 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -721,9 +721,6 @@ static int do_gt_restart(struct xe_gt *gt)
 		xe_gt_sriov_pf_init_hw(gt);
 
 	xe_mocs_init(gt);
-	err = xe_uc_start(&gt->uc);
-	if (err)
-		return err;
 
 	for_each_hw_engine(hwe, gt, id) {
 		xe_reg_sr_apply_mmio(&hwe->reg_sr, gt);
@@ -733,6 +730,10 @@ static int do_gt_restart(struct xe_gt *gt)
 	/* Get CCS mode in sync between sw/hw */
 	xe_gt_apply_ccs_mode(gt);
 
+	err = xe_uc_start(&gt->uc);
+	if (err)
+		return err;
+
 	/* Restore GT freq to expected values */
 	xe_gt_sanitize_freq(gt);
 
-- 
2.51.0



