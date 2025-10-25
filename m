Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6083F306490;
	Sat, 25 Oct 2025 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409632; cv=none; b=hjTdT44PylSo300RdVwD7GRPwYTwnHtpl3W5xU51GAr07zQTQhi5aAbVuqQUbeCqC1U5Qj7wS1LnUQZ09czzb0fZjhRg0nahFhcF+CzDMrMqmS9kaFzesNXTeqHd4xQvwlC4x7J+Gttl1eILqM30FkLBlAS5Pf8ltD3l5VZomGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409632; c=relaxed/simple;
	bh=2xB4C/lDc29H6nQywY+9Qio3H83VJ8xbPa21DmkNVoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8fc0WjgzbmWuudvyZzczrYeBm6rL/I6qczf/kJhnfqyBfRwaSDo+rIVGmlooAq2db+hbsmLGwoMEYQfdYBlmCM50Q25dCgOcwKkuWv1+fE6Zq1d3pDBuiEVGRsWvP35F3fXKcbyceRefipdrx0FPo5ZHGfOgnHSPmlU+NraCYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDf8tfkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDf8tfkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5679AC4CEF5;
	Sat, 25 Oct 2025 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409630;
	bh=2xB4C/lDc29H6nQywY+9Qio3H83VJ8xbPa21DmkNVoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDf8tfkxJ/BhLLWZTNJTMv5iMhhZoWfAgsZR7bUREVa7gK77ac3e+Yz7ZStrSZq1Z
	 lKVROdKZGOjI5vtyEuzA2+iE5ucA+LLGq61PZxgGjLhrpZSea6VXCfKLOXScnJkfq+
	 GiH0YK6+PuhMy2VtL7fPf0/Bqh56KSjhqtfLYbN5QMVG1DO39kBeK3TJHIq1KtU0fL
	 M6FTBrj2vsglVuG8BLgGdU7cxGPqsGxwZ+O8GIrgZZC8T6GtJQHZK2Ke5uq3zfXtRM
	 qi+oT7ZhAPEzFMBwwyo4V+AiQpkKfLC0pxloC7Id6rABDYQbGPQk0OVGXbBZOUH66G
	 qYNntvQ91bYtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ce Sun <cesun102@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	tao.zhou1@amd.com,
	ganglxie@amd.com,
	lijo.lazar@amd.com,
	victor.skvortsov@amd.com,
	candice.li@amd.com,
	alexandre.f.demers@gmail.com,
	Stanley.Yang@amd.com,
	YiPeng.Chai@amd.com,
	xiang.liu@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Correct the loss of aca bank reg info
Date: Sat, 25 Oct 2025 12:00:29 -0400
Message-ID: <20251025160905.3857885-398-sashal@kernel.org>
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

From: Ce Sun <cesun102@amd.com>

[ Upstream commit d8442bcad0764c5613e9f8b2356f3e0a48327e20 ]

By polling, poll ACA bank count to ensure that valid
ACA bank reg info can be obtained

v2: add corresponding delay before send msg to SMU to query mca bank info
(Stanley)

v3: the loop cannot exit. (Thomas)

v4: remove amdgpu_aca_clear_bank_count. (Kevin)

v5: continuously inject ce. If a creation interruption
occurs at this time, bank reg info will be lost. (Thomas)
v5: each cycle is delayed by 100ms. (Tao)

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- Fixes real bug: Prevents loss of ACA/MCA bank register info when
  poison consumption interrupts poison creation, which can drop error
  records and delay/skip bad-page retirement. The change adds explicit
  coordination between “creation” and “consumption” paths.
- Scoped and minimal: Changes are confined to amdgpu RAS/UMC v12 logic;
  no uAPI changes or architectural rewrites.
- Bounded behavior: Polling now has a clear, short timeout (about 1
  second) to avoid hangs while ensuring valid ACA/MCA bank data is
  captured.

Key technical changes
- Add explicit creation/consumption counters to gate polling completion:
  - New fields to track state:
    - `struct ras_ecc_log_info`: `de_queried_count`,
      `consumption_q_count`
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h:495,
      drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h:496).
    - `struct amdgpu_ras`: `atomic_t poison_consumption_count`
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h:568).
- Creation path now waits until both sides are observed (or timeout):
  - `amdgpu_ras_poison_creation_handler()` resets both counters each
    cycle, polls via `amdgpu_ras_query_error_status_with_event()`, and
    exits early when both `de_queried_count` and `consumption_q_count`
    are non-zero; otherwise sleeps 100ms, up to 10 cycles
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3405,
    drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3423,
    drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3424,
    drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3426).
  - If any DEs were actually found (`de_queried_count`), schedule page-
    retirement work promptly
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3432).
  - Defines the polling budget as 10 cycles, each 100ms, by changing
    `MAX_UMC_POISON_POLLING_TIME_ASYNC` to 10
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:125) and using
    `msleep(100)`.
- Consumption path signals promptly:
  - When queuing poison consumption messages, increment
    `poison_consumption_count` to indicate pending consumption
    (drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c:255).
  - For UMC v12 bank scans, if the IP decode indicates it is a SMU
    consumption query (i.e., not UMC HWID/MCATYPE), increment
    `consumption_q_count` so the creation loop knows consumption was
    observed (drivers/gpu/drm/amd/amdgpu/umc_v12_0.c:541).
- Thread sequencing and reset hygiene:
  - The page retirement thread now processes the creation loop while
    there are creation requests and stops early if a consumption event
    is pending (`!atomic_read(&con->poison_consumption_count)`)
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3531).
  - On GPU reset conditions, clear both `poison_creation_count` and
    `poison_consumption_count`, and flush/clear the FIFO, ensuring clean
    state and avoiding lost bank info across resets
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3548,
    drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3573).
  - Initialize `poison_consumption_count` on recovery init
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:3680).

Why it meets stable criteria
- Important bugfix: Prevents loss of RAS bank register info, ensuring
  accurate ECC error logging and timely bad-page retirement on affected
  AMD GPUs.
- Low risk of regression: Changes are local to RAS/UMC v12 error
  handling, use bounded waits, add simple counters, and don’t alter
  external interfaces.
- No architectural churn: Purely corrective synchronization and
  sequencing; no redesign or feature addition.
- Performance impact is negligible: Only affects rare error paths, with
  short bounded waits.

Notes for backport
- Target stable series that include ACA/UMC v12 poison handling; the
  patch relies on existing ACA/MCA decoding paths and
  `amdgpu_ras_query_error_status_with_event()`.
- No userspace ABI impact; struct layout changes are internal to the
  driver.

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 50 +++++++++++--------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h |  5 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c |  1 +
 drivers/gpu/drm/amd/amdgpu/umc_v12_0.c  |  5 ++-
 4 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 54909bcf181f3..893cae9813fbb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -122,7 +122,7 @@ const char *get_ras_block_str(struct ras_common_if *ras_block)
 /* typical ECC bad page rate is 1 bad page per 100MB VRAM */
 #define RAS_BAD_PAGE_COVER              (100 * 1024 * 1024ULL)
 
-#define MAX_UMC_POISON_POLLING_TIME_ASYNC  300  //ms
+#define MAX_UMC_POISON_POLLING_TIME_ASYNC  10
 
 #define AMDGPU_RAS_RETIRE_PAGE_INTERVAL 100  //ms
 
@@ -3239,7 +3239,7 @@ static void amdgpu_ras_ecc_log_init(struct ras_ecc_log_info *ecc_log)
 
 	INIT_RADIX_TREE(&ecc_log->de_page_tree, GFP_KERNEL);
 	ecc_log->de_queried_count = 0;
-	ecc_log->prev_de_queried_count = 0;
+	ecc_log->consumption_q_count = 0;
 }
 
 static void amdgpu_ras_ecc_log_fini(struct ras_ecc_log_info *ecc_log)
@@ -3259,7 +3259,7 @@ static void amdgpu_ras_ecc_log_fini(struct ras_ecc_log_info *ecc_log)
 
 	mutex_destroy(&ecc_log->lock);
 	ecc_log->de_queried_count = 0;
-	ecc_log->prev_de_queried_count = 0;
+	ecc_log->consumption_q_count = 0;
 }
 
 static bool amdgpu_ras_schedule_retirement_dwork(struct amdgpu_ras *con,
@@ -3309,47 +3309,34 @@ static int amdgpu_ras_poison_creation_handler(struct amdgpu_device *adev,
 	int ret = 0;
 	struct ras_ecc_log_info *ecc_log;
 	struct ras_query_if info;
-	uint32_t timeout = 0;
+	u32 timeout = MAX_UMC_POISON_POLLING_TIME_ASYNC;
 	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
-	uint64_t de_queried_count;
-	uint32_t new_detect_count, total_detect_count;
-	uint32_t need_query_count = poison_creation_count;
+	u64 de_queried_count;
+	u64 consumption_q_count;
 	enum ras_event_type type = RAS_EVENT_TYPE_POISON_CREATION;
 
 	memset(&info, 0, sizeof(info));
 	info.head.block = AMDGPU_RAS_BLOCK__UMC;
 
 	ecc_log = &ras->umc_ecc_log;
-	total_detect_count = 0;
+	ecc_log->de_queried_count = 0;
+	ecc_log->consumption_q_count = 0;
+
 	do {
 		ret = amdgpu_ras_query_error_status_with_event(adev, &info, type);
 		if (ret)
 			return ret;
 
 		de_queried_count = ecc_log->de_queried_count;
-		if (de_queried_count > ecc_log->prev_de_queried_count) {
-			new_detect_count = de_queried_count - ecc_log->prev_de_queried_count;
-			ecc_log->prev_de_queried_count = de_queried_count;
-			timeout = 0;
-		} else {
-			new_detect_count = 0;
-		}
+		consumption_q_count = ecc_log->consumption_q_count;
 
-		if (new_detect_count) {
-			total_detect_count += new_detect_count;
-		} else {
-			if (!timeout && need_query_count)
-				timeout = MAX_UMC_POISON_POLLING_TIME_ASYNC;
+		if (de_queried_count && consumption_q_count)
+			break;
 
-			if (timeout) {
-				if (!--timeout)
-					break;
-				msleep(1);
-			}
-		}
-	} while (total_detect_count < need_query_count);
+		msleep(100);
+	} while (--timeout);
 
-	if (total_detect_count)
+	if (de_queried_count)
 		schedule_delayed_work(&ras->page_retirement_dwork, 0);
 
 	if (amdgpu_ras_is_rma(adev) && atomic_cmpxchg(&ras->rma_in_recovery, 0, 1) == 0)
@@ -3446,7 +3433,8 @@ static int amdgpu_ras_page_retirement_thread(void *param)
 				atomic_sub(poison_creation_count, &con->poison_creation_count);
 				atomic_sub(poison_creation_count, &con->page_retirement_req_cnt);
 			}
-		} while (atomic_read(&con->poison_creation_count));
+		} while (atomic_read(&con->poison_creation_count) &&
+			!atomic_read(&con->poison_consumption_count));
 
 		if (ret != -EIO) {
 			msg_count = kfifo_len(&con->poison_fifo);
@@ -3463,6 +3451,7 @@ static int amdgpu_ras_page_retirement_thread(void *param)
 			/* gpu mode-1 reset is ongoing or just completed ras mode-1 reset */
 			/* Clear poison creation request */
 			atomic_set(&con->poison_creation_count, 0);
+			atomic_set(&con->poison_consumption_count, 0);
 
 			/* Clear poison fifo */
 			amdgpu_ras_clear_poison_fifo(adev);
@@ -3487,6 +3476,8 @@ static int amdgpu_ras_page_retirement_thread(void *param)
 				atomic_sub(msg_count, &con->page_retirement_req_cnt);
 			}
 
+			atomic_set(&con->poison_consumption_count, 0);
+
 			/* Wake up work to save bad pages to eeprom */
 			schedule_delayed_work(&con->page_retirement_dwork, 0);
 		}
@@ -3590,6 +3581,7 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev, bool init_bp_info)
 	init_waitqueue_head(&con->page_retirement_wq);
 	atomic_set(&con->page_retirement_req_cnt, 0);
 	atomic_set(&con->poison_creation_count, 0);
+	atomic_set(&con->poison_consumption_count, 0);
 	con->page_retirement_thread =
 		kthread_run(amdgpu_ras_page_retirement_thread, adev, "umc_page_retirement");
 	if (IS_ERR(con->page_retirement_thread)) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index 699953c02649f..96cb62a44a35b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -492,8 +492,8 @@ struct ras_ecc_err {
 struct ras_ecc_log_info {
 	struct mutex lock;
 	struct radix_tree_root de_page_tree;
-	uint64_t	de_queried_count;
-	uint64_t	prev_de_queried_count;
+	uint64_t de_queried_count;
+	uint64_t consumption_q_count;
 };
 
 struct amdgpu_ras {
@@ -558,6 +558,7 @@ struct amdgpu_ras {
 	struct mutex page_retirement_lock;
 	atomic_t page_retirement_req_cnt;
 	atomic_t poison_creation_count;
+	atomic_t poison_consumption_count;
 	struct mutex page_rsv_lock;
 	DECLARE_KFIFO(poison_fifo, struct ras_poison_msg, 128);
 	struct ras_ecc_log_info  umc_ecc_log;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
index c92b8794aa73d..2e039fb778ea8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
@@ -252,6 +252,7 @@ int amdgpu_umc_pasid_poison_handler(struct amdgpu_device *adev,
 				block, pasid, pasid_fn, data, reset);
 			if (!ret) {
 				atomic_inc(&con->page_retirement_req_cnt);
+				atomic_inc(&con->poison_consumption_count);
 				wake_up(&con->page_retirement_wq);
 			}
 		}
diff --git a/drivers/gpu/drm/amd/amdgpu/umc_v12_0.c b/drivers/gpu/drm/amd/amdgpu/umc_v12_0.c
index e590cbdd8de96..8dc32787d6250 100644
--- a/drivers/gpu/drm/amd/amdgpu/umc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/umc_v12_0.c
@@ -536,8 +536,11 @@ static int umc_v12_0_update_ecc_status(struct amdgpu_device *adev,
 	hwid = REG_GET_FIELD(ipid, MCMP1_IPIDT0, HardwareID);
 	mcatype = REG_GET_FIELD(ipid, MCMP1_IPIDT0, McaType);
 
-	if ((hwid != MCA_UMC_HWID_V12_0) || (mcatype != MCA_UMC_MCATYPE_V12_0))
+	/* The IP block decode of consumption is SMU */
+	if (hwid != MCA_UMC_HWID_V12_0 || mcatype != MCA_UMC_MCATYPE_V12_0) {
+		con->umc_ecc_log.consumption_q_count++;
 		return 0;
+	}
 
 	if (!status)
 		return 0;
-- 
2.51.0

