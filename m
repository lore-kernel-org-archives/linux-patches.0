Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954FD1862;
	Wed, 11 Feb 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813115; cv=none; b=d4KH/NxJD0X60rdX44hYFRgv89B8ct1k4xy7ZHb2ABrjwXNcgqi9Ifu0ix00IpErVA4uVqnXuRKLOCF4bIfGc0C2XthA3rPClxIlOK6rIoCajf45gTBW7pYFE+3oUbG4Qh2CfZqoSz618CpXQKa10TpJ8oV5QzHx9p/dn67nmTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813115; c=relaxed/simple;
	bh=u2n7BnhyPsEoYIPAqRYA2pGFUbLE9JbnXHr9HOuQkds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SeXfzzeAeZ8xNze9lIH/TeK97b1XwXbhmu83oVBSzcbZNYAILhqbghDwIWcNeM3VjbkMAWvWrj6QqyJ0JasaDWsmITs2EEgTMeB2I9PbNaivlOEPYTF2nQd80oaRwE1cj45IubTAV/sn8YV3HC3eA8D7dSScS177TaAhVQ+9VMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/1SViAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/1SViAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44A0C2BC9E;
	Wed, 11 Feb 2026 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813115;
	bh=u2n7BnhyPsEoYIPAqRYA2pGFUbLE9JbnXHr9HOuQkds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/1SViAXsUYKEoIIOgIJA5vpBKlql7SoDNkqnpd2OLkUNYbcTJvzZXoOLJF4LCjv7
	 deWc+wMdxU4M4/YnzhrPZnjiCX53p8xIcTckZXZCH87FcaUntitY1bPGA2Q4R/mk19
	 dGzs3IEZv1trrs5bHldNL+013jvRuwOoOKMhvI/HFwYjcFq5KPwYpIznK+P7P6tKgn
	 BydLTA/b1qkKBVbDINv4QbAoERBr+it9fxRUj8fRayS2dkVVQHYOrCZWxXgoamNrMl
	 EJy0qWAyJQu45dU2XpZTeDcHuFm5zOP16MK5IVcKetXnYTGNMi5na8vhiNfyW+Zuwg
	 W26qpTQhmLKWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.19-5.10] tools/power cpupower: Reset errno before strtoull()
Date: Wed, 11 Feb 2026 07:30:31 -0500
Message-ID: <20260211123112.1330287-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit f9bd3762cf1bd0c2465f2e6121b340883471d1bf ]

cpuidle_state_get_one_value() never cleared errno before calling
strtoull(), so a prior ERANGE caused every cpuidle counter read to
return zero. Reset errno to 0 before the conversion so each sysfs read
is evaluated independently.

Link: https://lore.kernel.org/r/20251201121745.3776703-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the real-world usage pattern. In `cpuidle_start()` and
`cpuidle_stop()`, `cpuidle_state_time()` is called in a loop for each
CPU and each state. If the first call encounters any situation where
errno is set to ERANGE (or if errno was already ERANGE from a prior
operation like `open()`, `read()`, or even `snprintf()`), then ALL
subsequent calls in the loop will return 0 because the stale ERANGE
persists.

Now here's a detailed analysis.

---

## Complete Analysis

### 1. Commit Message Analysis

The subject and body clearly describe the bug:
`cpuidle_state_get_one_value()` never cleared `errno` before calling
`strtoull()`, so if `errno` was already set to `ERANGE` from a prior
operation, every subsequent cpuidle counter read would return zero. The
fix is to reset `errno = 0` before the conversion.

The commit was authored by an Intel engineer (Kaushlendra Kumar),
reviewed through LKML, and accepted by Shuah Khan. No Fixes: tag or Cc:
stable tag, which is expected for commits under manual review.

### 2. Code Change Analysis

The change is a single line addition:

```153:153:tools/power/cpupower/lib/cpuidle.c
        errno = 0;
```

Added right before the `strtoull()` call at line 153, and before the
`errno == ERANGE` check at line 155.

**The bug mechanism is textbook-correct and well-documented:**

The C standard and the Linux `strtoull(3)` man page explicitly state:
**"This function does not modify errno on success."** This means:
- On successful conversion, `strtoull()` returns the correct value but
  **does not clear errno**.
- If `errno` was already `ERANGE` (from ANY prior call — `open()`,
  `read()`, `close()`, `snprintf()`, or a prior failed `strtoull()`),
  the check `errno == ERANGE` at line 155 will still be true, and the
  function returns 0 even though the conversion was successful.

The correct pattern (per POSIX and the C standard) is:
```c
errno = 0;
value = strtoull(...);
if (errno == ERANGE) { /* handle error */ }
```

There's even an existing instance of correct usage in the same codebase
at `tools/power/cpupower/utils/cpufreq-set.c:133`:

```133:134:tools/power/cpupower/utils/cpufreq-set.c
        errno = 0;
        freq = strtoul(normalized, &end, 10);
```

### 3. Impact Assessment

The function `cpuidle_state_get_one_value()` is called by 5 wrapper
functions:
- `cpuidle_state_latency()` — reads C-state latency
- `cpuidle_state_residency()` — reads C-state residency
- `cpuidle_state_usage()` — reads C-state usage count
- `cpuidle_state_time()` — reads time spent in C-state
- `cpuidle_is_state_disabled()` — checks if state is disabled

These are called from `cpuidle-info.c` (the `cpupower idle-info`
command) and `cpuidle_sysfs.c` (the cpuidle monitor), typically in loops
over all CPUs and all idle states. Once errno gets "stuck" at ERANGE,
ALL subsequent reads return 0, giving users completely wrong idle state
information.

The `cpuidle_state_read_file()` helper called just before `strtoull()`
internally calls `open()`, `read()`, and `close()`, any of which can set
`errno`. Additionally, the `snprintf()` call inside it could
theoretically set errno on truncation. A single ERANGE from any source
poisons all subsequent calls for the rest of the program's execution.

### 4. Scope and Risk

- **Files changed:** 1
- **Lines added:** 1
- **Lines removed:** 0
- **Complexity:** Trivial — adding a single `errno = 0;` assignment
- **Risk of regression:** Essentially zero. Setting `errno = 0` before
  `strtoull()` is the universally recommended practice. It cannot break
  anything.

### 5. The Same Bug Exists in Multiple Other cpupower Files

Notably, the same missing `errno = 0` pattern exists in several other
files:
- `tools/power/cpupower/lib/cpufreq.c:109` — `strtoul()` without errno
  reset
- `tools/power/cpupower/lib/acpi_cppc.c:53` — `strtoull()` without errno
  reset
- `tools/power/cpupower/utils/helpers/sysfs.c:221` — `strtoull()`
  without errno reset
- `tools/power/cpupower/utils/helpers/misc.c:65` — `strtol()` without
  errno reset
- `tools/power/cpupower/lib/cpupower.c:128` — `strtol()` without errno
  reset

These are NOT fixed by this commit (they would need separate fixes), but
they confirm the bug pattern is real and systemic in this codebase.

### 6. Stable Suitability

**Positive factors:**
- Fixes a **real, user-visible bug**: cpupower reporting all zeroes for
  idle state counters
- **Trivially correct**: this is the universally documented correct way
  to use `strtoull()`
- **Minimal change**: 1 line, 1 file, zero risk
- **Long-standing bug**: this code has been buggy since it was added in
  2016 (commit `ac5a181d065d7`), so it affects ALL stable trees
- **No dependencies**: completely self-contained, applies cleanly to any
  version with this file
- **Tested in mainline**: accepted and merged for 6.19

**Potential concerns:**
- This is a **userspace tool**, not kernel code. Stable trees do include
  userspace tool fixes, but some consider them lower priority.
- The impact is limited to incorrect data display in cpupower, not a
  crash, security vulnerability, or data corruption.
- However, cpupower is widely used by distributions and sysadmins for
  power management monitoring. Incorrect data is a significant usability
  bug.

### 7. Dependencies

None. The change is completely self-contained. The function has existed
unchanged (in terms of this pattern) since 2016 across all stable kernel
versions that include cpupower.

### 8. Conclusion

This is a clear, obvious, one-line bug fix that corrects well-documented
incorrect usage of `strtoull()` per the C standard. The bug causes
cpupower to report all-zero cpuidle counters when errno happens to be
set to ERANGE, which is a real user-visible problem. The fix is zero-
risk, has no dependencies, and applies cleanly to all stable trees.
While it's a userspace tool rather than kernel code (which slightly
lowers the urgency), it's still a fix to widely-used infrastructure
tooling that ships with the kernel.

**YES**

 tools/power/cpupower/lib/cpuidle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/cpupower/lib/cpuidle.c b/tools/power/cpupower/lib/cpuidle.c
index f2c1139adf716..bd857ee7541a7 100644
--- a/tools/power/cpupower/lib/cpuidle.c
+++ b/tools/power/cpupower/lib/cpuidle.c
@@ -150,6 +150,7 @@ unsigned long long cpuidle_state_get_one_value(unsigned int cpu,
 	if (len == 0)
 		return 0;
 
+	errno = 0;
 	value = strtoull(linebuf, &endp, 0);
 
 	if (endp == linebuf || errno == ERANGE)
-- 
2.51.0

