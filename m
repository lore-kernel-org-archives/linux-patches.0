Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25152F3C08;
	Thu,  9 Oct 2025 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025599; cv=none; b=u9nqsiS7j9OK8eakElSzwg436w8Neq6Fuc1dSsxF7gUe0kfN/aqtnDkNhTyE83/wt4qT38ZpdQyAwznRu8Cu+hBOs9jnQAcWU88kpPKfk+uRtbBis2SO8iAwBkCveKTnqeEJU1cvq/eTkKDiQEvzcCKXP5TtempXvT1eDZ8V864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025599; c=relaxed/simple;
	bh=lPM1YBZADVg/ysU1qDCn+/3SC2trH32e6mG4B0qcwek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXmKLAMd3Y7Tr9IonrH1ETZPFoNcfhrhVDJx8k38UWxoV07zOFOqHO1QWxWYVYYK3JXV66p3A4FiGHfe8edH5n1q2U5zpAD6mb1VQAqghD1g2i3FWhO9pOBcuwUVuHd0N+Q2M9/Kmq7YgxRhK0Adi1eVLhW/jFOy7xumWJjrs98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAC3Dh7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAC3Dh7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC92C4CEE7;
	Thu,  9 Oct 2025 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025599;
	bh=lPM1YBZADVg/ysU1qDCn+/3SC2trH32e6mG4B0qcwek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAC3Dh7sC0VP/9d3zwdTicszclt22rVYUX4yfG5sRxGZCu54cbRCBp0z2LwuTD10g
	 e95waYOZf7rxZnXOWoD5YPNBv/PnsNJXfAQJE1UJIA5j75YwdLCUJSFRE+pZn7hVUA
	 S1tmYhsMTIAnF5f1sRXOl036B/u4fLSEbpo9G71wPVB6gAxKqZC+i7qDkPHAeeMr4p
	 ZKIVM1gQy+sYfmnXzDtK5AKJr9GSt/sPj5N5gZiKOW18HusZZdQMkFHR6TR1qxQZtC
	 aiP7J4uYQSEHeR9DGQamoltTNzD1O2CWFnZsruNJyL+mGdKA45TU0GMq6bC+L2LviP
	 qMXJImG51Bw1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.4] tools/cpupower: Fix incorrect size in cpuidle_state_disable()
Date: Thu,  9 Oct 2025 11:55:33 -0400
Message-ID: <20251009155752.773732-67-sashal@kernel.org>
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 23199d2aa6dcaf6dd2da772f93d2c94317d71459 ]

Fix incorrect size parameter passed to cpuidle_state_write_file() in
cpuidle_state_disable().

The function was incorrectly using sizeof(disable) which returns the
size of the unsigned int variable (4 bytes) instead of the actual
length of the string stored in the 'value' buffer.

Since 'value' is populated with snprintf() to contain the string
representation of the disable value, we should use the length
returned by snprintf() to get the correct string length for
writing to the sysfs file.

This ensures the correct number of bytes is written to the cpuidle
state disable file in sysfs.

Link: https://lore.kernel.org/r/20250917050820.1785377-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The patch corrects the length passed to the sysfs write helper from
    a fixed, incorrect size to the actual string length:
    - Before: `cpuidle_state_disable()` used `sizeof(disable)` (always
      4) when writing the textual value to sysfs, causing 4 bytes to be
      written regardless of the actual string length.
      - See old call site changed in
        `tools/power/cpupower/lib/cpuidle.c:247` (post‑patch numbering):
        `value, sizeof(disable)` → `value, len`
    - After: It computes `len = snprintf(value, SYSFS_PATH_MAX, "%u",
      disable);` and passes that `len` to the writer, ensuring only the
      intended number of bytes is written:
      - New local `int len;` added at
        `tools/power/cpupower/lib/cpuidle.c:236`.
      - `len = snprintf(...)` at
        `tools/power/cpupower/lib/cpuidle.c:245`.
      - Correct write length used at
        `tools/power/cpupower/lib/cpuidle.c:247-248`.

- Why it matters
  - The writer `cpuidle_state_write_file()` is a thin wrapper around
    `write(2)` that takes a `len` and writes it verbatim to the sysfs
    attribute `disable`:
    - See `tools/power/cpupower/lib/cpuidle.c:85-111`.
  - The backing kernel sysfs store for `stateX/disable` parses a
    NUL/newline-terminated string using `kstrtouint()` (see
    `drivers/cpuidle/sysfs.c:281-306`). While the kernfs write path
    guarantees NUL termination for the internal buffer, passing a length
    larger than the actual string (e.g., 4 for “0”) causes extra bytes
    beyond the first NUL to be sent. This is conceptually incorrect and
    can lead to surprising behavior (e.g., stray bytes copied into the
    sysfs buffer), even if parsing usually succeeds due to the early
    NUL.
  - In practice, cpupower only writes “0” or “1”, so `sizeof(unsigned
    int)` = 4 led to writing “1\0??” instead of just “1”. That typically
    works today because:
    - Kernfs appends a NUL at position `count` and `kstrtouint()` stops
      at the first NUL, so the extra bytes after the embedded NUL are
      ignored in most cases.
    - However, this is still a correctness bug and fragile across
      attribute implementations and future changes.

- Scope and risk
  - Scope is minimal and fully contained to the cpupower userspace
    library:
    - Only `tools/power/cpupower/lib/cpuidle.c` is changed.
    - No ABI changes; only a local variable and corrected length usage.
  - No architectural changes; no kernel/runtime impact beyond how many
    bytes userspace writes.
  - Regression risk is negligible:
    - Success semantics in `cpuidle_state_disable()` remain the same
      (returns 0 if any positive byte count is written; see
      `tools/power/cpupower/lib/cpuidle.c:247-251`).
    - Downstream callers (cpupower `cpuidle-set`, Python bindings, and
      `rtla`) do not depend on writing exactly 4 bytes and will continue
      to work; see callers such as `tools/power/cpupower/utils/cpuidle-
      set.c:117,130` and `tools/tracing/rtla/src/utils.c:596,661`.

- Affected history
  - The incorrect `sizeof(disable)` usage dates back to the introduction
    of the cpuidle library to cpupower in 2016 (commit `ac5a181d065d7`),
    so all stable series carrying cpupower’s cpuidle library are
    affected.
  - The fix is already in mainline as `23199d2aa6dca` (“tools/cpupower:
    Fix incorrect size in cpuidle_state_disable()”), authored
    2025-09-17.

- Stable backport criteria
  - Important bugfix: Yes — corrects wrong write length to sysfs,
    eliminating stray bytes and making behavior robust and explicit.
  - Small and contained: Yes — one function, a few lines in a single
    file.
  - No new features or architectural changes: Correct.
  - Minimal regression risk: Correct.
  - Critical subsystem: It’s in `tools/` (userspace cpupower), which
    stable regularly backports fixes for.

Given the above, this is a low-risk correctness fix confined to
cpupower, addressing a long-standing bug. It should be backported to
stable trees.

 tools/power/cpupower/lib/cpuidle.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/lib/cpuidle.c b/tools/power/cpupower/lib/cpuidle.c
index 0ecac009273ce..f2c1139adf716 100644
--- a/tools/power/cpupower/lib/cpuidle.c
+++ b/tools/power/cpupower/lib/cpuidle.c
@@ -233,6 +233,7 @@ int cpuidle_state_disable(unsigned int cpu,
 {
 	char value[SYSFS_PATH_MAX];
 	int bytes_written;
+	int len;
 
 	if (cpuidle_state_count(cpu) <= idlestate)
 		return -1;
@@ -241,10 +242,10 @@ int cpuidle_state_disable(unsigned int cpu,
 				 idlestate_value_files[IDLESTATE_DISABLE]))
 		return -2;
 
-	snprintf(value, SYSFS_PATH_MAX, "%u", disable);
+	len = snprintf(value, SYSFS_PATH_MAX, "%u", disable);
 
 	bytes_written = cpuidle_state_write_file(cpu, idlestate, "disable",
-						   value, sizeof(disable));
+						   value, len);
 	if (bytes_written)
 		return 0;
 	return -3;
-- 
2.51.0

