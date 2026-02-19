Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AE42D876F;
	Thu, 19 Feb 2026 02:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466679; cv=none; b=s2lJ5N96g45uv905sFkSzLWEGpb0W+n3A5TZc8JT8hDvTNi1RuYtynCyLA0ITF2iLPIqY6H6E2lF3zgZE047pEHqgPluS2kRAII6HgPEjFCJ2skJ8Y2ifjoPaAjAfS/J/wnOeOabdViQWx+vvrPtMCPIjru0ry5/lkAW1FwJQBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466679; c=relaxed/simple;
	bh=CuMhCVSmuT5vA+n2XKKILWQICnHS1GTuDcB33JxXLmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IdnXogl3X0mr+eJzlAWCwdQtzhqW+lc+POiptNiKLNCOjhgvTIquBXPUleyyh91p3243pmwdbgutLMHGOkaxrKzac3WLmlILWtiuhNmG0kxSj2OPSKUbgCDKxPjGJ3p6AgVTt6+En9BagbI6zL2fa1joCht9npt7vda38QLAnuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXYgQdTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXYgQdTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F871C116D0;
	Thu, 19 Feb 2026 02:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466679;
	bh=CuMhCVSmuT5vA+n2XKKILWQICnHS1GTuDcB33JxXLmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXYgQdTgglEX91madhD+2JqTRJaT2mocZKgD8/xuoLT2ADC+SY23zNaMwxSiBm0e2
	 jKY88pgKCnQKIgn5oT1gsowXfwgJoUoy4xE301max922N7OOtW15txxfZxFsrQ5A8l
	 qOfIVdW4Qsnf1N6maz0pRDrWufKv09aGqzLePRUGtVQ8CvCYRbP4eWQKrh2JKfRXwQ
	 b7+PJAqgvmQXedxAOwFh8PWZ82DMvzsjhlo9N31KUP+gRNQERHMKaDa3Bdo+NcFmv0
	 qu2oZJwSXZQ+4KpBY5xq7KYcM61mH72e1n5yBHIYhVwrw04/qeCzxOEOidqYjDCVWu
	 AoPdroNXGnH9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Artem Shimko <a.shimko.dev@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	ilpo.jarvinen@linux.intel.com,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] serial: 8250_dw: handle clock enable errors in runtime_resume
Date: Wed, 18 Feb 2026 21:03:48 -0500
Message-ID: <20260219020422.1539798-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Shimko <a.shimko.dev@gmail.com>

[ Upstream commit d31228143a489ba6ba797896a07541ce06828c09 ]

Add error checking for clk_prepare_enable() calls in
dw8250_runtime_resume(). Currently if either clock fails to enable,
the function returns success while leaving clocks in inconsistent state.

This change implements comprehensive error handling by checking the return
values of both clk_prepare_enable() calls. If the second clock enable
operation fails after the first clock has already been successfully
enabled, the code now properly cleans up by disabling and unpreparing
the first clock before returning. The error code is then propagated to
the caller, ensuring that clock enable failures are properly reported
rather than being silently ignored.

Signed-off-by: Artem Shimko <a.shimko.dev@gmail.com>
Link: https://patch.msgid.link/20251104145433.2316165-2-a.shimko.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Classification

This is an **error handling fix** — a recognized category of bug fixes
for stable. The commit adds missing error checking for
`clk_prepare_enable()` return values in the runtime resume path.

## Bug Assessment

**What was broken:**
- `clk_prepare_enable()` can fail (e.g., clock hardware issues,
  regulator failure), returning a negative error code.
- The old code ignored these return values and always returned 0
  (success).
- This means the PM runtime framework would believe the device is active
  when clocks may not actually be enabled.

**Consequences of the bug:**
1. **Inconsistent clock state**: If `clk` fails after `pclk` succeeds,
   only one clock is enabled but the function claims success. On the
   next `runtime_suspend`, both clocks will be disabled/unprepared —
   leading to an unbalanced `clk_disable_unprepare()` on a clock that
   was never successfully enabled.
2. **Serial port malfunction**: Without clocks properly enabled, the
   UART hardware won't function, but the software stack thinks it's
   ready.
3. **Clock framework imbalance**: Unbalanced enable/disable calls can
   cause issues in the clock framework, potentially affecting other
   devices sharing the same clock tree.

**Bug existed since 2013** (commit `ffc3ae6dd925b6`) — over 12 years.

## Severity Assessment

**Moderate severity.** While `clk_prepare_enable()` failing in runtime
resume is not a common occurrence in normal operation, when it does
happen:
- The consequences are real (clock imbalance, non-functional hardware)
- The PM framework gets incorrect state information
- Other drivers in the same subsystem (fsl_lpuart, imx) properly check
  these return values, showing this is a known pattern

## Stable Kernel Criteria Check

1. **Obviously correct and tested**: Yes — the pattern is
   straightforward error checking, matching what other serial drivers
   already do. Merged by Greg Kroah-Hartman (the serial/stable
   maintainer).
2. **Fixes a real bug**: Yes — ignoring clock enable failures leaves
   hardware in inconsistent state and can cause unbalanced clock
   operations.
3. **Important issue**: Moderate — clock enable failures can cause
   device malfunction and clock framework inconsistency.
4. **Small and contained**: Yes — only ~10 lines changed in a single
   function, single file.
5. **No new features**: Correct — purely error handling.
6. **Applies cleanly**: The affected code has been stable since 2019
   (`a8afc193558a4`), so it should apply cleanly to all active stable
   trees.

## Risk Assessment

**Very low risk.** The change:
- Only adds error checking to an existing code path
- Only affects the failure case (when `clk_prepare_enable()` returns
  non-zero)
- The success path is unchanged
- Proper cleanup of `pclk` when `clk` fails prevents resource leaks
- Follows established patterns used by other serial drivers

## Verification

- **Git blame** confirmed the buggy code has been present since 2013
  (`ffc3ae6dd925b6` by Heikki Krogerus) with pclk added in 2014
  (`7d78cbefaa465`).
- **Code review** of other serial drivers (fsl_lpuart.c, imx.c)
  confirmed they properly check `clk_prepare_enable()` return values in
  runtime_resume, establishing this as an expected pattern.
- **8250_mtk.c** has the same unchecked pattern, confirming this is a
  real class of bugs in 8250 drivers.
- **Commit was merged by Greg Kroah-Hartman** (serial subsystem and
  stable maintainer), who linked it via patch.msgid.link.
- **dw8250_runtime_suspend** unconditionally calls
  `clk_disable_unprepare()` on both clocks — verified that if
  runtime_resume falsely reports success, the next suspend would call
  disable on a clock that wasn't successfully enabled, causing clock
  framework imbalance.
- **Could NOT verify** whether any user actually reported hitting this
  bug in practice — the commit has no Reported-by tag, suggesting this
  was found by code review rather than a user report.

## Conclusion

This is a legitimate bug fix that adds missing error handling for clock
enable operations in a runtime PM callback. The fix is small, surgical,
obviously correct, follows patterns established by other drivers in the
same subsystem, and carries essentially zero regression risk. While the
bug may not be frequently triggered in practice (clock enable failures
are relatively uncommon), when it does trigger, it causes real problems
(clock imbalance, non-functional hardware). The code has been present in
all stable trees since 2013-2014, so the fix is applicable broadly.

**YES**

 drivers/tty/serial/8250/8250_dw.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 27af83f0ff463..0f8207652efe6 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -741,11 +741,18 @@ static int dw8250_runtime_suspend(struct device *dev)
 
 static int dw8250_runtime_resume(struct device *dev)
 {
+	int ret;
 	struct dw8250_data *data = dev_get_drvdata(dev);
 
-	clk_prepare_enable(data->pclk);
+	ret = clk_prepare_enable(data->pclk);
+	if (ret)
+		return ret;
 
-	clk_prepare_enable(data->clk);
+	ret = clk_prepare_enable(data->clk);
+	if (ret) {
+		clk_disable_unprepare(data->pclk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.51.0

