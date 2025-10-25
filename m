Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A2630C600;
	Sat, 25 Oct 2025 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409127; cv=none; b=H3JnbX2plt+1MGQkY+D6WrWRTTTE7lA8YuQQi5WK8NdZ9xMWVPPF0RBS5iJ2Nq3OAt70+LeBftjpbxyohVYAtzpthqVUhxr5k1s2EeK8jE/ibyh57eZTSIDElHd+ehntEKZSeg20+hEA/9udOx/xuTF9Wztddfmza85Va24mLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409127; c=relaxed/simple;
	bh=Jl6ovmIwm65hPQvIzWGCapklVGiACBg6nsvpFOJihQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kX5O0uYvBxRlTQJ+RSZ06WLHyPc8bDGIFmxd27qjr4P2T/GNMY+EeWcA4nQwU2DH6UC7/s1RIY8oMVXIFxNwj5CmdnaUiRKYxtkfGg2So+dYovz23CKN1OWSCsNh2gwAW1q7LSiQT1A8XOlg5ycaQpGRDIOOhqXLTIx/qdw/EX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olGikDgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olGikDgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409D3C4CEFF;
	Sat, 25 Oct 2025 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409127;
	bh=Jl6ovmIwm65hPQvIzWGCapklVGiACBg6nsvpFOJihQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olGikDgv3AYR1CGybJMAPG59DkrXclCeS2y1N5u6cx4taAOLJTwaGPcUo4DqqlAfC
	 cnW/YuIefoUIlEHssGcSB44Y+Yw40aOJlExLcx+fh2hyw6T0Rv5gm27eIqZKQTCGRw
	 RC4eZi6HXiSadsl6hehM/KhIbEIMWiSr+M5hfSBfMaYY9OiP8Xma6mosRSJfXe6z3s
	 rCQxpHnPWQvVnuiNSlrrc0QY0Qp1LQvxIF5s7RauTq68AphcqnX1GmNPTEJiM33GeZ
	 tKsVPoRzi6eU5e0zqsPYHDVJ5BRz93FughkvlXByFCJXliYPeVTjBpTvfWMkDgHrfi
	 cyReMjCIPI54g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/xe/guc: Set upper limit of H2G retries over CTB
Date: Sat, 25 Oct 2025 11:57:21 -0400
Message-ID: <20251025160905.3857885-210-sashal@kernel.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 2506af5f8109a387a5e8e9e3d7c498480b8033db ]

The GuC communication protocol allows GuC to send NO_RESPONSE_RETRY
reply message to indicate that due to some interim condition it can
not handle incoming H2G request and the host shall resend it.

But in some cases, due to errors, this unsatisfied condition might
be final and this could lead to endless retries as it was recently
seen on the CI:

 [drm] GT0: PF: VF1 FLR didn't finish in 5000 ms (-ETIMEDOUT)
 [drm] GT0: PF: VF1 resource sanitizing failed (-ETIMEDOUT)
 [drm] GT0: PF: VF1 FLR failed!
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0

To avoid such dangerous loops allow only limited number of retries
(for now 50) and add some delays (n * 5ms) to slow down the rate of
resending this repeated request.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://lore.kernel.org/r/20250903223330.6408-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why Backport**
- Prevents infinite retry loops on GuC “NO_RESPONSE_RETRY” replies that
  can occur when the underlying condition never clears (e.g., VF FLR
  stuck), which was observed in CI. This is a real-world hang/DoS bug
  impacting system stability and recoverability.
- Change is small, self-contained to the Xe GuC CT H2G/G2H send/recv
  path, and does not alter UAPI or broader architecture.
- Returns a clear error after bounded retries instead of looping
  forever; adds linear backoff to reduce busy looping.

**What Changes**
- Introduces bounded retries and backoff for GuC “retry” responses
  within the blocking send/receive helper:
  - Adds retry budget and delay constants: `GUC_SEND_RETRY_LIMIT` = 50
    and `GUC_SEND_RETRY_MSLEEP` = 5 ms
    (drivers/gpu/drm/xe/xe_guc_ct.c:1081,
    drivers/gpu/drm/xe/xe_guc_ct.c:1082).
  - Tracks the number of retries in `guc_ct_send_recv()` and applies
    increasing sleep before re-sending
    (drivers/gpu/drm/xe/xe_guc_ct.c:1084).
  - On each retry indication from GuC (`g2h_fence.retry`), after
    unlocking the mutex, either:
    - Sleep for n*5ms and retry; or
    - If the retry count exceeds the limit, log an error and return
      `-ELOOP` (drivers/gpu/drm/xe/xe_guc_ct.c:1151,
      drivers/gpu/drm/xe/xe_guc_ct.c:1154,
      drivers/gpu/drm/xe/xe_guc_ct.c:1156,
      drivers/gpu/drm/xe/xe_guc_ct.c:1159).

**Key Code References**
- Retry limit and delay constants:
  - drivers/gpu/drm/xe/xe_guc_ct.c:1081
  - drivers/gpu/drm/xe/xe_guc_ct.c:1082
- Core change in `guc_ct_send_recv()` (retry handling/backoff/limit):
  - Function start: drivers/gpu/drm/xe/xe_guc_ct.c:1084
  - Retry debug log: drivers/gpu/drm/xe/xe_guc_ct.c:1151
  - Limit check and `-ELOOP`: drivers/gpu/drm/xe/xe_guc_ct.c:1154
  - Error log on limit reached: drivers/gpu/drm/xe/xe_guc_ct.c:1155
  - Backoff sleep: drivers/gpu/drm/xe/xe_guc_ct.c:1159

**Safety and Regression Risk**
- Concurrency correctness: The code explicitly unlocks `ct->lock` before
  sleeping, avoiding sleeping under a mutex
  (drivers/gpu/drm/xe/xe_guc_ct.c:1151).
- Blocking contract preserved: This helper is the blocking path; sleep
  is expected. The G2H-handler special path uses
  `xe_guc_ct_send_g2h_handler()` and does not call the blocking
  `send_recv()` (drivers/gpu/drm/xe/xe_guc_ct.h:63).
- Error propagation consistent: Callers already treat negative returns
  as failures and log/abort appropriately. For example:
  - `xe_guc_ct_send_block()` is a thin wrapper over
    `xe_guc_ct_send_recv()` (drivers/gpu/drm/xe/xe_guc_ct.h:57), and
    many users propagate errors directly (e.g.,
    drivers/gpu/drm/xe/xe_guc.c:303).
  - Relay path logs negative errors via `ERR_PTR(ret)` and returns
    failure (drivers/gpu/drm/xe/xe_guc_relay.c:298).
- Scope limited to Xe driver’s GuC CT path; no cross-subsystem impact,
  no API/ABI changes.
- The new `-ELOOP` code is a standard error value; replacing an
  unbounded loop with a bounded error is safer and more diagnosable. The
  linear backoff caps total added sleep to roughly 6.375 seconds in the
  worst case, which is acceptable for a blocking control path and
  reduces log spam/CPU waste.

**Stable Criteria Assessment**
- Fixes an important bug that can hang the driver and spam logs
  indefinitely (user-visible stability issue).
- Small, localized change with clear intent and minimal risk.
- No architectural changes or new features.
- Aligns with stable rules: a defensive fix that prevents system-harming
  behavior.

Given the above, this is a strong candidate for backporting to stable
trees that ship the Xe driver and GuC CT infrastructure.

 drivers/gpu/drm/xe/xe_guc_ct.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 6d70dd1c106d4..ff622628d823f 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -1079,11 +1079,15 @@ static bool retry_failure(struct xe_guc_ct *ct, int ret)
 	return true;
 }
 
+#define GUC_SEND_RETRY_LIMIT	50
+#define GUC_SEND_RETRY_MSLEEP	5
+
 static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 			    u32 *response_buffer, bool no_fail)
 {
 	struct xe_gt *gt = ct_to_gt(ct);
 	struct g2h_fence g2h_fence;
+	unsigned int retries = 0;
 	int ret = 0;
 
 	/*
@@ -1148,6 +1152,12 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 		xe_gt_dbg(gt, "H2G action %#x retrying: reason %#x\n",
 			  action[0], g2h_fence.reason);
 		mutex_unlock(&ct->lock);
+		if (++retries > GUC_SEND_RETRY_LIMIT) {
+			xe_gt_err(gt, "H2G action %#x reached retry limit=%u, aborting\n",
+				  action[0], GUC_SEND_RETRY_LIMIT);
+			return -ELOOP;
+		}
+		msleep(GUC_SEND_RETRY_MSLEEP * retries);
 		goto retry;
 	}
 	if (g2h_fence.fail) {
-- 
2.51.0

