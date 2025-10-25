Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2942F5A2D;
	Sat, 25 Oct 2025 16:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408883; cv=none; b=LN0LFkEu+JJvfSZF8WWaXeYYeWDlBowxLOTsR2yBysRHq7ii6cE/TELaRP5Cv8pWkpHn0o5ZxR8LlqFOd/AvguMGxgTRmsTs69PeaUUr+CZs9TwXrD231g97vQJ+Vqz/x470VUL1D8KQkmFuFJs+kARznzRkDrd5bBU+YpqW6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408883; c=relaxed/simple;
	bh=1j5LLkVUlBtSya9h1vRmkpTO5fE1P1gDGoiivneeic0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H5eu/0+h7aBko+u8kk8emfsft2pXkZ2W7yGf1ebPbZbR6N3hfs/WR/RThl2JNdcSgAoDUOq/TS4ow81/YLPcPhknb8AnwIGwAdJieLlEA4ZhTvlwbWI03Zlv2RUtgLpvoiaVsfUc4iFS6xXCEERWZPogzz8AhlHp1iybpgG8KvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPL5xlJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPL5xlJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8352C4CEF5;
	Sat, 25 Oct 2025 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408883;
	bh=1j5LLkVUlBtSya9h1vRmkpTO5fE1P1gDGoiivneeic0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPL5xlJ0160IktwJUPEvcATa2zwj9zi0MtMh1tKrVZGJdVgDDVi0qBdCn95rD1Olv
	 YEmlNVPoLmsVKMmR1rfDreScybZN77AKNtTyus4mdYJSd/yZ3VLQrhYuYbbQa52ZPc
	 xf23ghgp6KwHNChrbsyys9XSogdqox3HW36flLXkgP3Mxg0tG6jJaaxR2u+abxA6JN
	 9FOodP4QTT/EPUlreeQmHuLm2OgxSMINVkjjoSKHhjpGrzGbog2etEseuqb18GFD1u
	 tr7+GT7f4Qs51TaKt1q90MbjJKb7Tg9bmymj/aesYww2TlNx/EDcn3R4RY+cdlIWCf
	 oG4IIf8avt3gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenglei Xie <Chenglei.Xie@amd.com>,
	Shravan Kumar Gande <Shravankumar.Gande@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	victor.skvortsov@amd.com,
	zhigang.luo@amd.com,
	lijo.lazar@amd.com,
	Tony.Yi@amd.com,
	srinivasan.shanmugam@amd.com,
	yunru.pan@amd.com,
	alexandre.f.demers@gmail.com,
	david.rosca@amd.com,
	ruijing.dong@amd.com,
	sunil.khatri@amd.com,
	le.ma@amd.com,
	asad.kamal@amd.com,
	Prike.Liang@amd.com,
	gerry@linux.alibaba.com,
	boyuan.zhang@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: refactor bad_page_work for corner case handling
Date: Sat, 25 Oct 2025 11:55:43 -0400
Message-ID: <20251025160905.3857885-112-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chenglei Xie <Chenglei.Xie@amd.com>

[ Upstream commit d2fa0ec6e0aea6ffbd41939d0c7671db16991ca4 ]

When a poison is consumed on the guest before the guest receives the host's poison creation msg, a corner case may occur to have poison_handler complete processing earlier than it should to cause the guest to hang waiting for the req_bad_pages reply during a VF FLR, resulting in the VM becoming inaccessible in stress tests.

To fix this issue, this patch refactored the mailbox sequence by seperating the bad_page_work into two parts req_bad_pages_work and handle_bad_pages_work.
Old sequence:
  1.Stop data exchange work
  2.Guest sends MB_REQ_RAS_BAD_PAGES to host and keep polling for IDH_RAS_BAD_PAGES_READY
  3.If the IDH_RAS_BAD_PAGES_READY arrives within timeout limit, re-init the data exchange region for updated bad page info
    else timeout with error message
New sequence:
req_bad_pages_work:
  1.Stop data exhange work
  2.Guest sends MB_REQ_RAS_BAD_PAGES to host
Once Guest receives IDH_RAS_BAD_PAGES_READY event
handle_bad_pages_work:
  3.re-init the data exchange region for updated bad page info

Signed-off-by: Chenglei Xie <Chenglei.Xie@amd.com>
Reviewed-by: Shravan Kumar Gande <Shravankumar.Gande@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Summary
- Fixes a real hang: guest can hang and VM becomes inaccessible during
  VF FLR when bad-page poison timing races with the host message. The
  change splits the handling so the VF only refreshes shared memory
  after the host signals readiness, eliminating the race.

What Changed (by file)
- drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h:270
  - Replaces single `virt.bad_pages_work` with two workers:
    `virt.req_bad_pages_work` and `virt.handle_bad_pages_work`. This
    split allows “request” and “consume” phases to be sequenced by the
    mailbox READY event rather than racing in one worker.
- drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
  - Old worker `xgpu_ai_mailbox_bad_pages_work` at mxgpu_ai.c:295 stops
    exchange, issues request, and immediately re-inits the exchange.
  - New workers: `xgpu_ai_mailbox_req_bad_pages_work` sends the request
    (under `reset_domain->sem`), and
    `xgpu_ai_mailbox_handle_bad_pages_work` later re-inits the data
    exchange after READY arrives. The IRQ handler gains an explicit case
    for `IDH_RAS_BAD_PAGES_READY` to schedule the “handle” worker;
    `IDH_RAS_BAD_PAGES_NOTIFICATION` now schedules only the “request”
    worker.
- drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
  - Old worker `xgpu_nv_mailbox_bad_pages_work` at mxgpu_nv.c:362 stops
    exchange, requests bad pages, polls for READY via the request path,
    then re-inits.
  - New workers mirror the AI refactor: `..._req_bad_pages_work` (stop
    exchange + request) and `..._handle_bad_pages_work` (stop + re-init
    on READY). The IRQ handler adds an explicit
    `IDH_RAS_BAD_PAGES_READY` case to schedule the “handle” worker and
    changes `IDH_RAS_BAD_PAGES_NOTIFICATION` to only schedule the
    “request” worker (mxgpu_nv.c:396).
  - Critically, `xgpu_nv_send_access_requests_with_param` no longer maps
    `IDH_REQ_RAS_BAD_PAGES` to `IDH_RAS_BAD_PAGES_READY`
    (mxgpu_nv.c:205), so it no longer polls synchronously; readiness is
    now handled asynchronously by the IRQ path.
- drivers/gpu/drm/amd/amdgpu/soc15.c
  - No functional change; only whitespace cleanup near
    `soc15_set_virt_ops` (soc15.c:743).

Why This Fix Matters
- Eliminates a race and hang: Previously, on
  `IDH_RAS_BAD_PAGES_NOTIFICATION`, the VF immediately re-initialized
  the PF2VF exchange region after sending a request (AI even re-inited
  without actually sending a VF request), which could complete “too
  early” relative to the host’s bad-page population and READY signaling.
  During VF FLR, that could leave the VF waiting for a reply in a timing
  window and hang the VM.
- By:
  - Separating request and handling into `req_bad_pages_work` and
    `handle_bad_pages_work`,
  - Triggering re-init only after `IDH_RAS_BAD_PAGES_READY` via the IRQ
    handler,
  - Removing synchronous polling from the NV request path,
  the mailbox handshake is correctly sequenced by the host’s READY
event, which is robust against the poison timing corner case noted in
the commit message.

Risk and Backport Considerations
- Scope is small and contained to the AMDGPU SR-IOV mailbox/RAS path; no
  architectural or cross-subsystem churn.
- Behavior change is deliberately more conservative: do not re-init
  until `IDH_RAS_BAD_PAGES_READY`. Hosts that already send READY (the NV
  path already relied on READY by polling) remain compatible; the VF
  merely stops busy-waiting and switches to IRQ-driven handling.
- AI path previously didn’t issue a real VF request
  (`amdgpu_virt_request_bad_pages()` no-ops for AI). The refactor leaves
  AI requesting behavior unchanged (it still no-ops) but now defers the
  re-init until the host READY event, which is safer with respect to
  host timing.
- Uses existing enums and helpers (`IDH_RAS_BAD_PAGES_READY`,
  `amdgpu_sriov_runtime`, `reset_domain->sem`) already present in the
  same code branch. No ABI changes; only internal fields and workers.
- Regression potential is low and outweighed by fixing a real hang. If a
  very old PF firmware never emits `IDH_RAS_BAD_PAGES_READY`, those
  trees likely also didn’t have the current SR-IOV RAS flow; in such
  cases, this patch should be applied along with the READY event support
  already present in these files.

Stable Criteria
- Fixes a hang affecting users in SR-IOV scenarios (important bugfix).
- Minimal, localized changes without feature additions or architectural
  refactors.
- Clear sequencing fix with limited side effects; aligns AI and NV
  paths.
- No performance regressions; actually removes synchronous polling in
  NV.

Conclusion
- Backport Status: YES. This is a focused, correctness-oriented fix to a
  real hang in the SR-IOV RAS mailbox interaction and fits stable
  backport criteria.

 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h |  3 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c    | 32 +++++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c    | 35 +++++++++++++++++++-----
 drivers/gpu/drm/amd/amdgpu/soc15.c       |  1 -
 4 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 3da3ebb1d9a13..58accf2259b38 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -267,7 +267,8 @@ struct amdgpu_virt {
 	struct amdgpu_irq_src		rcv_irq;
 
 	struct work_struct		flr_work;
-	struct work_struct		bad_pages_work;
+	struct work_struct		req_bad_pages_work;
+	struct work_struct		handle_bad_pages_work;
 
 	struct amdgpu_mm_table		mm_table;
 	const struct amdgpu_virt_ops	*ops;
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
index 48101a34e049f..9a40107a0869d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
@@ -292,14 +292,32 @@ static void xgpu_ai_mailbox_flr_work(struct work_struct *work)
 	}
 }
 
-static void xgpu_ai_mailbox_bad_pages_work(struct work_struct *work)
+static void xgpu_ai_mailbox_req_bad_pages_work(struct work_struct *work)
 {
-	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, bad_pages_work);
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, req_bad_pages_work);
 	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
 
 	if (down_read_trylock(&adev->reset_domain->sem)) {
 		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_request_bad_pages(adev);
+		up_read(&adev->reset_domain->sem);
+	}
+}
+
+/**
+ * xgpu_ai_mailbox_handle_bad_pages_work - Reinitialize the data exchange region to get fresh bad page information
+ * @work: pointer to the work_struct
+ *
+ * This work handler is triggered when bad pages are ready, and it reinitializes
+ * the data exchange region to retrieve updated bad page information from the host.
+ */
+static void xgpu_ai_mailbox_handle_bad_pages_work(struct work_struct *work)
+{
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, handle_bad_pages_work);
+	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
+
+	if (down_read_trylock(&adev->reset_domain->sem)) {
+		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_init_data_exchange(adev);
 		up_read(&adev->reset_domain->sem);
 	}
@@ -327,10 +345,15 @@ static int xgpu_ai_mailbox_rcv_irq(struct amdgpu_device *adev,
 	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
 
 	switch (event) {
+	case IDH_RAS_BAD_PAGES_READY:
+		xgpu_ai_mailbox_send_ack(adev);
+		if (amdgpu_sriov_runtime(adev))
+			schedule_work(&adev->virt.handle_bad_pages_work);
+		break;
 	case IDH_RAS_BAD_PAGES_NOTIFICATION:
 		xgpu_ai_mailbox_send_ack(adev);
 		if (amdgpu_sriov_runtime(adev))
-			schedule_work(&adev->virt.bad_pages_work);
+			schedule_work(&adev->virt.req_bad_pages_work);
 		break;
 	case IDH_UNRECOV_ERR_NOTIFICATION:
 		xgpu_ai_mailbox_send_ack(adev);
@@ -415,7 +438,8 @@ int xgpu_ai_mailbox_get_irq(struct amdgpu_device *adev)
 	}
 
 	INIT_WORK(&adev->virt.flr_work, xgpu_ai_mailbox_flr_work);
-	INIT_WORK(&adev->virt.bad_pages_work, xgpu_ai_mailbox_bad_pages_work);
+	INIT_WORK(&adev->virt.req_bad_pages_work, xgpu_ai_mailbox_req_bad_pages_work);
+	INIT_WORK(&adev->virt.handle_bad_pages_work, xgpu_ai_mailbox_handle_bad_pages_work);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index f6d8597452ed0..457972aa56324 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -202,9 +202,6 @@ static int xgpu_nv_send_access_requests_with_param(struct amdgpu_device *adev,
 	case IDH_REQ_RAS_CPER_DUMP:
 		event = IDH_RAS_CPER_DUMP_READY;
 		break;
-	case IDH_REQ_RAS_BAD_PAGES:
-		event = IDH_RAS_BAD_PAGES_READY;
-		break;
 	default:
 		break;
 	}
@@ -359,14 +356,32 @@ static void xgpu_nv_mailbox_flr_work(struct work_struct *work)
 	}
 }
 
-static void xgpu_nv_mailbox_bad_pages_work(struct work_struct *work)
+static void xgpu_nv_mailbox_req_bad_pages_work(struct work_struct *work)
 {
-	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, bad_pages_work);
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, req_bad_pages_work);
 	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
 
 	if (down_read_trylock(&adev->reset_domain->sem)) {
 		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_request_bad_pages(adev);
+		up_read(&adev->reset_domain->sem);
+	}
+}
+
+/**
+ * xgpu_nv_mailbox_handle_bad_pages_work - Reinitialize the data exchange region to get fresh bad page information
+ * @work: pointer to the work_struct
+ *
+ * This work handler is triggered when bad pages are ready, and it reinitializes
+ * the data exchange region to retrieve updated bad page information from the host.
+ */
+static void xgpu_nv_mailbox_handle_bad_pages_work(struct work_struct *work)
+{
+	struct amdgpu_virt *virt = container_of(work, struct amdgpu_virt, handle_bad_pages_work);
+	struct amdgpu_device *adev = container_of(virt, struct amdgpu_device, virt);
+
+	if (down_read_trylock(&adev->reset_domain->sem)) {
+		amdgpu_virt_fini_data_exchange(adev);
 		amdgpu_virt_init_data_exchange(adev);
 		up_read(&adev->reset_domain->sem);
 	}
@@ -397,10 +412,15 @@ static int xgpu_nv_mailbox_rcv_irq(struct amdgpu_device *adev,
 	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
 
 	switch (event) {
+	case IDH_RAS_BAD_PAGES_READY:
+		xgpu_nv_mailbox_send_ack(adev);
+		if (amdgpu_sriov_runtime(adev))
+			schedule_work(&adev->virt.handle_bad_pages_work);
+		break;
 	case IDH_RAS_BAD_PAGES_NOTIFICATION:
 		xgpu_nv_mailbox_send_ack(adev);
 		if (amdgpu_sriov_runtime(adev))
-			schedule_work(&adev->virt.bad_pages_work);
+			schedule_work(&adev->virt.req_bad_pages_work);
 		break;
 	case IDH_UNRECOV_ERR_NOTIFICATION:
 		xgpu_nv_mailbox_send_ack(adev);
@@ -485,7 +505,8 @@ int xgpu_nv_mailbox_get_irq(struct amdgpu_device *adev)
 	}
 
 	INIT_WORK(&adev->virt.flr_work, xgpu_nv_mailbox_flr_work);
-	INIT_WORK(&adev->virt.bad_pages_work, xgpu_nv_mailbox_bad_pages_work);
+	INIT_WORK(&adev->virt.req_bad_pages_work, xgpu_nv_mailbox_req_bad_pages_work);
+	INIT_WORK(&adev->virt.handle_bad_pages_work, xgpu_nv_mailbox_handle_bad_pages_work);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 9e74c9822e622..9785fada4fa79 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -741,7 +741,6 @@ static void soc15_reg_base_init(struct amdgpu_device *adev)
 void soc15_set_virt_ops(struct amdgpu_device *adev)
 {
 	adev->virt.ops = &xgpu_ai_virt_ops;
-
 	/* init soc15 reg base early enough so we can
 	 * request request full access for sriov before
 	 * set_ip_blocks. */
-- 
2.51.0

