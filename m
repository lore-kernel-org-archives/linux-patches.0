Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0FE2EBB9D;
	Thu,  9 Oct 2025 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025480; cv=none; b=kB0uLVZOHRa2eIQZUqvKpPHZB4RorRT26ZU2+oHU7WFj4HEQ769ySgTCPpbUzOcTlyLNXdx7HrSOgqh8Sgn9BC8bzdfSnpYvoAftccPhgDTq6qAeBmoON0GK1EftUk9iYoiSfpOrRv7YnVFpule8uj7bnmpPrbDRlAJ7Jwv2SHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025480; c=relaxed/simple;
	bh=6tock45EY/0mBBpByyg1vQKFyWyuWtkyaiydwNBMa4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afLQHuh4HCMvuxUdTcHW3FmydqHwI8WOZKyxAdFCZMV33eDUTeYAP+assH5Ch1VA4BB/at4iM8JG8q0qyUU/SedzGCOTLqBkMsIFBTPGhUQ4Jakl/Q3Y5g4bcNW/iqqi6ZBUZcbpHKKr9WPWYr4pl7TVwcO00bmjZ7rE+PLSbME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p43ud5OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p43ud5OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172F0C4CEE7;
	Thu,  9 Oct 2025 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025479;
	bh=6tock45EY/0mBBpByyg1vQKFyWyuWtkyaiydwNBMa4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p43ud5OJuf3aGZnYu9lmfGXxG/oYtn5iS8+fPNq5Vg5yxMGXyTajn8HLoh/Tt1ROF
	 GdIyoy7UFWURywbgMR8rPXC/YgueI+t6hTdNTLGPOXi/AU1mH064XgwyAFTCm8MliN
	 LsafHuHuZxnDyrVHCgjqmXOb1lgO8neW2z0A3ULSokwnxuKl1gvMX0DstWf3IwxYEW
	 brvQK0qmaojucpXEo94YmsOBpX2n7dvSCh39eJ8Q59WLTvXWx0PFv4PevMUdPvApYX
	 QwDmRJF7ZxQzIGsL8ZcOkcOKw0Hq04ps0mstqS08iXG+oAlAG5ILAv7RVGx5QgDPsm
	 Kzg7qohOb0Gmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.16] mfd: qnap-mcu: Handle errors returned from qnap_mcu_write
Date: Thu,  9 Oct 2025 11:54:31 -0400
Message-ID: <20251009155752.773732-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit bf2de43060d528e52e372c63182a94b95c80d305 ]

qnap_mcu_write can return errors and those were not checked before.
So do that now.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250804130726.3180806-3-heiko@sntech.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prior to this change, `qnap_mcu_exec()` ignored failures from the
    low-level write routine, always proceeding to wait for a reply. That
    loses the original error and forces a needless timeout path. The
    commit makes `qnap_mcu_exec()` bail out immediately on write errors,
    propagating the true cause to callers.
  - Evidence: `qnap_mcu_write()` can and does return negative errors
    from `serdev_device_write()` (drivers/mfd/qnap-mcu.c:81), but
    previously the call site discarded the return. The commit changes
    the call site to capture and check the return value.

- Specific code changes
  - Before: `qnap_mcu_exec()` called `qnap_mcu_write(mcu, cmd_data,
    cmd_data_size);` without checking its return.
  - After: `ret = qnap_mcu_write(mcu, cmd_data, cmd_data_size); if (ret
    < 0) { … return ret; }` so failures are handled early.
    - Current code location for the effect: drivers/mfd/qnap-mcu.c:167
      (assign return), drivers/mfd/qnap-mcu.c:168 (early return on `<
      0`).
    - The rest of the flow is unchanged: it still waits for transmit
      completion (drivers/mfd/qnap-mcu.c:171), waits for the reply with
      a timeout (drivers/mfd/qnap-mcu.c:173), and validates checksum
      (drivers/mfd/qnap-mcu.c:178).
  - In trees without `guard(mutex)`, the patch explicitly unlocks the
    bus mutex before returning on error, preserving the original locking
    discipline in the error path. In newer trees (like current HEAD),
    `guard(mutex)` covers this automatically.

- Why it matters to users
  - If the UART write fails (e.g., device disconnected, runtime PM,
    transient serdev error), the old code would block up to
    `QNAP_MCU_TIMEOUT_MS` and convert the condition into a misleading
    `-ETIMEDOUT`. This affects all clients using `qnap_mcu_exec()`:
    - LEDs: LED state updates via `qnap_mcu_exec_with_ack()` return
      later and with the wrong error.
    - hwmon: sensor reads wait unnecessarily and mask the real I/O
      error.
    - input: command/ack round-trips behave similarly.
    - Power-off path: system shutdown delays by a timeout and logs an
      unrelated error code.
  - The fix returns the precise failure from the actual write, reducing
    latency and aiding diagnostics.

- Scope and risk
  - Small, contained change: 1 file, 5 insertions/1 deletion in the
    original patch; no API/ABI changes, no architectural changes,
    success path unchanged.
  - Touches only the QNAP MCU MFD core; no critical kernel subsystems.
  - Regression risk is minimal: it only alters behavior when a low-level
    write already failed, in which case proceeding never had a chance to
    succeed. Callers already propagate non-zero `ret` values.

- History and applicability
  - The bug was introduced when the base driver landed (mfd: Add base
    driver for qnap-mcu devices, likely 998f70d1806bb, 2024-11-07).
    Backporting should target all stable series that include that
    driver.
  - Follow-up refactors (convert to `guard(mutex)`, structure cleanups)
    are not required to realize this fix; the original patch includes
    the explicit `mutex_unlock()` to keep locking correct on older
    branches.

- Stable criteria
  - Fixes a real bug with user-visible impact (spurious timeouts, loss
    of original error).
  - Small, localized, and low-risk patch.
  - No new features; adheres to stable rules.
  - No explicit “Cc: stable” in the message, but still a textbook
    stable-worthy bug fix.

Conclusion: Backporting will improve reliability and diagnostics for all
users of the QNAP MCU driver with negligible risk.

 drivers/mfd/qnap-mcu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/qnap-mcu.c b/drivers/mfd/qnap-mcu.c
index 89a8a1913d42d..9d3edc3e7d93b 100644
--- a/drivers/mfd/qnap-mcu.c
+++ b/drivers/mfd/qnap-mcu.c
@@ -163,7 +163,11 @@ int qnap_mcu_exec(struct qnap_mcu *mcu,
 	reply->received = 0;
 	reinit_completion(&reply->done);
 
-	qnap_mcu_write(mcu, cmd_data, cmd_data_size);
+	ret = qnap_mcu_write(mcu, cmd_data, cmd_data_size);
+	if (ret < 0) {
+		mutex_unlock(&mcu->bus_lock);
+		return ret;
+	}
 
 	serdev_device_wait_until_sent(mcu->serdev, msecs_to_jiffies(QNAP_MCU_TIMEOUT_MS));
 
-- 
2.51.0

