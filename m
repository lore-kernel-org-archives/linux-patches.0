Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DA835975;
	Tue, 24 Jun 2025 04:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738281; cv=none; b=Akl02DQvdz54cQtcDzXpVWTsavouPb7ixQvwCiQnm3AZaLXc+lWpSUMPWI7SmxPjDf28JsrAZ1S6eWwW5W0GnGLgX2YLn9A3NVEFMEISW5j2su/pxee9pMdWdkQkrKqbMx5goYS5NoIKXhGWmbrJGFEE60whLdQ9hnrnf8LZ1vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738281; c=relaxed/simple;
	bh=KKvj6cJIJcysGb3kB1M149YzOZwxaDjGEKQImeiRojY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=OzT9oAMy6fgitgxPIz7ZCl3DfVq7YQrg9McSSGqLmprqo0LD/lMNbrxIntjHMiaZWXHhW1pcnXNx1boX/j6akaSL625AAyBKh84S+Y8P8zvFT2x8/FYGVr9L8uJhl+TEQY1eZIe2tE5d+T4Gj44nHmfWMb32aHk3sBZr7pdjsmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qY5QLMmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qY5QLMmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D57C4CEE3;
	Tue, 24 Jun 2025 04:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738281;
	bh=KKvj6cJIJcysGb3kB1M149YzOZwxaDjGEKQImeiRojY=;
	h=From:To:Cc:Subject:Date:From;
	b=qY5QLMmpweLdfzFePWVfh5kFRAFeSXzqcF2mUVd4IWMpSVWdMmOemi/buRQplK6Ky
	 VbHSU3t+JJtolt8o0Vq5UnsRBGM1VGukWEOUvq4rKOBMpMwPmqUFq0Nxp1DXh1ASF6
	 aEZqUqfuUgV6qH6ve/xstz0KmWhLoeVcwcfWsouDXgTaoZ6YYE7AO8Li54sLU3gPU6
	 6pOHsgbQVHVjDYfBMZZiqOrbdWk+sYXKBcEu6Tz+E3GhwqIBQ/wC8KJbs6r9gpB60O
	 YvvoKs3Eyn/aiwt39QFl2/2VYpDHsHaZ0+Ufn/b+SDRFxhFCG2ArQxpvynibDKVX98
	 Vgb9scgu6Yt7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jake Hillion <jake@hillion.co.uk>,
	Blaise Sanouillet <linux@blaise.sanouillet.com>,
	Suma Hegde <suma.hegde@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	naveenkrishna.chatradhi@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 01/20] x86/platform/amd: move final timeout check to after final sleep
Date: Tue, 24 Jun 2025 00:11:00 -0400
Message-Id: <20250624041120.83191-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.3
Content-Transfer-Encoding: 8bit

From: Jake Hillion <jake@hillion.co.uk>

[ Upstream commit f8afb12a2d7503de6558c23cacd7acbf6e9fe678 ]

__hsmp_send_message sleeps between result read attempts and has a
timeout of 100ms. Under extreme load it's possible for these sleeps to
take a long time, exceeding the 100ms. In this case the current code
does not check the register and fails with ETIMEDOUT.

Refactor the loop to ensure there is at least one read of the register
after a sleep of any duration. This removes instances of ETIMEDOUT with
a single caller, even with a misbehaving scheduler. Tested on AMD
Bergamo machines.

Suggested-by: Blaise Sanouillet <linux@blaise.sanouillet.com>
Reviewed-by: Suma Hegde <suma.hegde@amd.com>
Tested-by: Suma Hegde <suma.hegde@amd.com>
Signed-off-by: Jake Hillion <jake@hillion.co.uk>
Link: https://lore.kernel.org/r/20250605-amd-hsmp-v2-1-a811bc3dd74a@hillion.co.uk
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a critical race condition in the AMD HSMP driver's
timeout handling. The issue occurs in the `__hsmp_send_message()`
function where:

1. **Original code flaw**: The loop checks `time_before(jiffies,
   timeout)` at the start of each iteration, then sleeps, but doesn't
   check the register one final time after the last sleep completes.

2. **Race condition scenario**: Under heavy system load (as mentioned in
   the commit message - "Under extreme load"), the sleep operations
   (`usleep_range()`) can take significantly longer than intended. If
   the final sleep extends beyond the 100ms timeout window, the code
   exits with `-ETIMEDOUT` without checking if the SMU actually
   responded during that extended sleep.

3. **The fix**: Changes the loop from `while (time_before(jiffies,
   timeout))` to `while (true)` and moves the timeout check to after the
   register read, ensuring at least one register check occurs after any
   sleep duration.

## Why This Qualifies for Stable Backport

1. **Fixes a real bug affecting users**: The commit message explicitly
   states this was "Tested on AMD Bergamo machines" and fixes actual
   instances of ETIMEDOUT errors. AMD Bergamo is a server processor used
   in production data centers.

2. **Small, contained fix**: The change is minimal - just restructuring
   the loop logic without changing functionality. This meets the stable
   kernel criteria of being a small, obvious fix.

3. **No new features**: This purely fixes existing behavior without
   adding capabilities.

4. **Critical subsystem**: The HSMP driver is essential for AMD EPYC
   server management, controlling:
   - Power management
   - Thermal monitoring
   - Performance states
   - System telemetry

5. **Production impact**: Spurious `-ETIMEDOUT` errors would cause
   failures in:
   - Data center management tools
   - Power capping operations
   - Performance monitoring
   - Thermal management

6. **Clear problem and solution**: The race condition is well-
   understood, and the fix ensures the code behaves as intended -
   checking the register after sleeping rather than potentially timing
   out without a final check.

## Risk Assessment

The risk is minimal because:
- The logic change is straightforward and correct
- It's been tested on production AMD Bergamo systems
- It only affects the timeout path behavior
- The worst case is the same as before (timeout after 100ms)
- The best case fixes false timeouts under load

This is exactly the type of bug fix that stable kernels exist to deliver
- fixing real issues users encounter in production without introducing
new risks.

 drivers/platform/x86/amd/hsmp/hsmp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/hsmp/hsmp.c b/drivers/platform/x86/amd/hsmp/hsmp.c
index a3ac09a90de45..ab877112f4c80 100644
--- a/drivers/platform/x86/amd/hsmp/hsmp.c
+++ b/drivers/platform/x86/amd/hsmp/hsmp.c
@@ -99,7 +99,7 @@ static int __hsmp_send_message(struct hsmp_socket *sock, struct hsmp_message *ms
 	short_sleep = jiffies + msecs_to_jiffies(HSMP_SHORT_SLEEP);
 	timeout	= jiffies + msecs_to_jiffies(HSMP_MSG_TIMEOUT);
 
-	while (time_before(jiffies, timeout)) {
+	while (true) {
 		ret = sock->amd_hsmp_rdwr(sock, mbinfo->msg_resp_off, &mbox_status, HSMP_RD);
 		if (ret) {
 			dev_err(sock->dev, "Error %d reading mailbox status\n", ret);
@@ -108,6 +108,10 @@ static int __hsmp_send_message(struct hsmp_socket *sock, struct hsmp_message *ms
 
 		if (mbox_status != HSMP_STATUS_NOT_READY)
 			break;
+
+		if (!time_before(jiffies, timeout))
+			break;
+
 		if (time_before(jiffies, short_sleep))
 			usleep_range(50, 100);
 		else
-- 
2.39.5

