Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFDA3F1651;
	Tue, 28 Apr 2026 10:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372898; cv=none; b=q65yswJxMF8BrNtcziAjZ7Sy7k4iofeuqfYEI/BwzZ7MXTC/G5WODZ/YQq2ckSv5UOvB8ISfNJDNnek29zYDLh28hLFsGNEVkGN5OnJ0nThnBPGCDOwHm6zIzJpdawXMikH56bb8NF0KQgePn2lQE9hIh1yyhAsQiAnwImkyeSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372898; c=relaxed/simple;
	bh=AU8iZLEwSA2y2k1MIvnLTa00lMtRpKahe1DlX8rEntY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4H1uE7aCfAB+KXzEvAy/igcV/qjKyhLCzv6bkid+JOJlDiZ7yLjHSvmO4fb9cy0UST/O3Jbpt6MFdBf1FGEhTVOUWBSFBfHTXl8RV0FfC3O454NtXn8Mo8ceXoqlkon3BaECTQmLtVy6dzLAgjQuHnpaRHU3+VK7qsJ4KZox8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUDUw/QW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUDUw/QW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5BCC2BCAF;
	Tue, 28 Apr 2026 10:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372898;
	bh=AU8iZLEwSA2y2k1MIvnLTa00lMtRpKahe1DlX8rEntY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUDUw/QWR+SYyRngKv33qnKY3vZBoAW5qnea2RnBFCjSV4na4neKw9zigImzF2MCL
	 0YIBKmPrpHOBsxQ1gwqyHHNvKQLkLieSTjxKfwoY9I0tMIaYqN7Z2OmBQZ1qKFnRG6
	 uxLk9pm5LVTVJWobdhPxPQRmFQNg7uLdG+TGyA7VxVwB8PlzQwkRTscjHd8IhTGUqI
	 KDGzdd6Fm3MCxmNbHbTT84Luo5pr5vMqL2nM3CT3GrFDkc80/nlcFolwtXyBCsAdf7
	 7yMVivZHalge8VojVWIfpDeJrvN5/tcnwCT2E9OMOuS+eRv9Z1lNilQ+gum+ENJxya
	 NbbrzMhbFRA3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Marcel W. Wysocki" <maci.stgn@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] um: fix address-of CMSG_DATA() rvalue in stub
Date: Tue, 28 Apr 2026 06:40:14 -0400
Message-ID: <20260428104133.2858589-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Marcel W. Wysocki" <maci.stgn@gmail.com>

[ Upstream commit 4076f7329832074196e050def49d22265fce2021 ]

The UML stub takes the address of CMSG_DATA(fd_msg):

    fd_map = (void *)&CMSG_DATA(fd_msg);

CMSG_DATA() is specified by POSIX to return unsigned char *.  Taking
its address is semantically wrong -- the intent is to get a pointer
to the control message data, which is exactly what CMSG_DATA()
already returns.

This happens to compile with glibc because glibc's primary
CMSG_DATA definition accesses a flexible array member:

    #define CMSG_DATA(cmsg) ((cmsg)->__cmsg_data)

An array lvalue can have its address taken, and &array yields the
same address as array.  However, glibc also has an alternative
definition that uses pointer arithmetic (returning an rvalue), and
musl's definition always uses pointer arithmetic:

    /* musl */
    #define CMSG_DATA(cmsg) \
        ((unsigned char *)(((struct cmsghdr *)(cmsg)) + 1))

Taking the address of an rvalue is a hard error in C, so the
current code fails to compile with musl libc.

Remove the erroneous & operator.  The resulting code is correct
regardless of the CMSG_DATA implementation -- it simply assigns the
data pointer, which is what the subsequent code (fd_map[--num_fds])
expects.

No functional change with glibc; fixes the build with musl.

Signed-off-by: Marcel W. Wysocki <maci.stgn@gmail.com>
Link: https://patch.msgid.link/20260215142803.1455757-1-maci.stgn@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to provide a thorough analysis.

## Phase 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
Record: [arch/um] [fix] Fixes address-of operator applied to CMSG_DATA()
macro which is an rvalue under musl libc, breaking UML build with musl.

### Step 1.2: Parse All Commit Message Tags
Record:
- `Signed-off-by: Marcel W. Wysocki <maci.stgn@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260215142803.1455757-1-maci.stgn@gmail.com`
  (lore link)
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (UML
  maintainer applied)
- No `Fixes:` tag, no `Reported-by:`, no `Reviewed-by:`, no explicit
  `Cc: stable` (expected)

### Step 1.3: Analyze the Commit Body
Record: The commit explains in depth:
- Bug: UML stub does `fd_map = (void *)&CMSG_DATA(fd_msg);`
- Root cause: POSIX specifies `CMSG_DATA()` returns `unsigned char *`;
  the `&` operator applied to an rvalue is a hard C error
- Why it compiles with glibc: glibc's primary macro accesses a flexible
  array member (lvalue)
- Why it fails with musl: musl always uses pointer arithmetic (rvalue)
- Fix: Remove the `&` operator - result is correct for any `CMSG_DATA()`
  implementation
- Impact: "No functional change with glibc; fixes the build with musl."

### Step 1.4: Detect Hidden Bug Fixes
Record: Not hidden - this is explicitly stated as a build fix. It also
has semantic merit (even under glibc's primary definition,
`&array_member` followed by a void* cast is nonsensical - you get the
array address, same as without `&`).

## Phase 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
Record: 1 file changed, 1 insertion, 1 deletion. Single character
removal (`&`) in `arch/um/kernel/skas/stub.c` inside
`stub_signal_interrupt()`. Classification: minimal surgical fix.

### Step 2.2: Code Flow Change
Record:
- Before: `fd_map = (void *)&CMSG_DATA(fd_msg);` - takes address of
  expression returned by `CMSG_DATA()`
- After: `fd_map = (void *)CMSG_DATA(fd_msg);` - uses the pointer
  returned by `CMSG_DATA()` directly
- With glibc's primary macro (flexible array): `&array` == `array`, so
  result is identical
- With musl (or glibc alternative): before = build error; after = works
- Path: normal path (FD handling during stub signal interrupt)

### Step 2.3: Identify the Bug Mechanism
Record: Build fix / portability issue (category h - hardware workarounds
is not a match; this is a build fix category). The existing code uses a
macro in a way that violates POSIX's return-type contract and fails on
conforming implementations.

### Step 2.4: Fix Quality
Record: Fix is trivially correct. Since `CMSG_DATA()` already returns
`unsigned char *`, casting that to `(void *)` is exactly what's needed.
Zero regression risk on glibc - the resulting pointer value is
identical.

## Phase 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
Record: The buggy line was introduced in commit `e92e2552858142b` ("um:
pass FD for memory operations when needed", June 2, 2025), which landed
in v6.16.

### Step 3.2: Follow the Fixes: Tag
Record: No Fixes: tag, but git blame identifies `e92e2552858142b` as the
introducing commit. That commit is in v6.16 and all subsequent stable
trees (6.16.y, 6.17.y, 6.18.y, 6.19.y).

### Step 3.3: Check File History
Record: `git log v6.16..v7.0 -- arch/um/kernel/skas/stub.c` returns
empty - no intervening changes between v6.16 and v7.0 in this file. This
means the fix will apply cleanly to every stable tree from 6.16.y
onward.

### Step 3.4: Author's Other Commits
Record: Author Marcel W. Wysocki has 2 commits in linux-next, both musl
compatibility fixes for UML. First-time contributor in this area.
Maintainer Johannes Berg (UML maintainer) applied the patch.

### Step 3.5: Dependent/Prerequisite Commits
Record: Standalone fix. Part of a 2-patch musl series, but patch 2/2
(struct sigcontext redefinition) is independent - they don't depend on
each other.

## Phase 4: MAILING LIST RESEARCH

### Step 4.1: Original Patch Discussion
Record: Found via `b4 dig`: https://lore.kernel.org/all/20260215142803.1
455757-1-maci.stgn@gmail.com/
- Series: v1 only (no revisions)
- No reviewer comments captured in the mbox thread (only the 2 patches
  themselves)
- Patch applied as-is by Johannes Berg

### Step 4.2: Who Reviewed
Record: Originally addressed to UML maintainers Richard Weinberger,
Anton Ivanov, Johannes Berg, linux-um@lists.infradead.org, linux-
kernel@vger.kernel.org. Applied by Johannes Berg (subsystem maintainer).

### Step 4.3: Bug Report
Record: No syzbot, no external bug report. Bug is self-evident: UML
simply doesn't build under musl.

### Step 4.4: Related Patches
Record: Part of a 2-patch series for musl compatibility; patch 2/2 is an
independent header conflict fix. Prior historical patch series exist
(e.g., `5e1121cd43d4d` "um: Some fixes to build UML with musl" from
2020).

### Step 4.5: Stable Mailing List History
Record: Not separately discussed in stable context. No NAKs or stable
nominations captured.

## Phase 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
Record: `stub_signal_interrupt()` in `arch/um/kernel/skas/stub.c`.

### Step 5.2: Callers
Record: `stub_signal_interrupt` is the signal handler installed by UML
for the userspace stub process (SECCOMP-based). It's invoked via signal
delivery - not directly called by normal C code. Entry is from the
SECCOMP trap handler in the userspace stub.

### Step 5.3: Callees
Record: Uses `stub_syscall3(__NR_recvmsg, ...)`, `CMSG_DATA()`,
`syscall_handler(fd_map)`, `stub_syscall2(__NR_close, ...)`.

### Step 5.4: Call Chain / Reachability
Record: This is core UML stub code - runs in every UML process when
handling signals/syscalls. For glibc: change produces the same runtime
behavior. For musl: fixes the build so it runs at all.

### Step 5.5: Similar Patterns
Record: Prior musl compatibility patches exist (e.g., `5e1121cd43d4d`).
This is a continuation of making UML buildable under non-glibc C
libraries.

## Phase 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable?
Record: Verified via `git grep` on tags - `fd_map = (void
*)&CMSG_DATA(fd_msg);` is present verbatim in v6.16, v6.17, v6.18,
v6.19. Introduced in v6.16 via commit `e92e2552858142b`.

### Step 6.2: Backport Complications
Record: No churn in the file between v6.16 and v7.0 (the diff is against
identical context). Fix applies cleanly to all affected stable trees
with zero modification required.

### Step 6.3: Related Fixes in Stable
Record: None - this is the first fix for this specific issue.

## Phase 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
Record: arch/um (User-Mode Linux). Niche but real users (CI testing,
isolation, security research). Criticality for affected users: CORE (UML
doesn't build at all with musl).

### Step 7.2: Subsystem Activity
Record: Active - UML gets regular updates, with musl support being
periodically improved (2020 series, 2026 series).

## Phase 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Record: UML users on musl-based distributions (Alpine Linux, Void Linux
musl variant, embedded systems). Anyone attempting to build UML with a
non-glibc libc. Glibc users: unaffected.

### Step 8.2: Trigger Conditions
Record: Trigger = attempting to build arch/um with musl libc. 100% of
musl build attempts fail at this line in v6.16+.

### Step 8.3: Failure Mode Severity
Record: Build failure → UML cannot be built at all on affected
configurations. Severity: HIGH for affected users (blocker), NONE for
glibc users.

### Step 8.4: Risk-Benefit Ratio
Record:
- BENEFIT: Enables UML build for musl libc users. Build fix category,
  explicitly allowed.
- RISK: Near-zero. With glibc's primary definition, `&array == array`,
  so the cast to `(void *)` produces the identical pointer value. No
  runtime change.
- Ratio: Clearly favorable.

## Phase 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation
FOR backport:
- One-character build fix with zero runtime impact for glibc users
- Falls under explicit "BUILD FIXES" stable exception category
- Buggy code exists in all active stable trees (6.16.y through 6.19.y)
- Applied cleanly (no file churn since introduction)
- Applied by subsystem maintainer
- The semantic argument is also correct: taking `&` of `CMSG_DATA()`'s
  return is wrong per POSIX

AGAINST backport:
- No explicit `Cc: stable` (expected, not disqualifying)
- No `Fixes:` tag (expected, not disqualifying)
- Niche subsystem (UML + musl) - but still real users

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? YES - trivial one-char removal,
   semantically correct
2. Fixes a real bug? YES - build failure
3. Important issue? YES - build fix (explicit stable exception category)
4. Small and contained? YES - 1 line
5. No new features or APIs? YES
6. Apply to stable trees? YES - clean apply to all affected trees

### Step 9.3: Exception Category
Record: BUILD FIX - explicitly allowed in stable per guidelines: "Fixes
for compilation errors or warnings... These are critical for users who
need to build the kernel."

### Step 9.4: Decision
YES - classic build fix with:
- Trivial, obviously correct change (1 char)
- Zero regression risk for glibc users (unchanged pointer value)
- Enables musl libc builds which are currently broken
- Buggy code in v6.16.y through v6.19.y
- Clean apply to all affected stable trees

## Verification

- [Phase 1] Parsed commit message: author Marcel W. Wysocki, applied by
  Johannes Berg (UML maintainer), lore Link present, no Fixes:/Reported-
  by:/stable tags (expected for review pipeline)
- [Phase 2] Diff analysis: 1 file, +1/-1, removes `&` from `fd_map =
  (void *)&CMSG_DATA(fd_msg);` in `stub_signal_interrupt()`
- [Phase 3] `git log --oneline -- arch/um/kernel/skas/stub.c`: buggy
  line introduced in commit `e92e2552858142b` ("um: pass FD for memory
  operations when needed")
- [Phase 3] `git tag --contains e92e2552858142b`: confirmed present in
  v6.16 through v7.0 (all active stable trees)
- [Phase 3] `git log v6.16..v7.0 -- arch/um/kernel/skas/stub.c`: empty -
  no intervening changes, clean apply guaranteed
- [Phase 3] `git log --author="Marcel W. Wysocki"`: 2 commits total,
  both musl compatibility fixes for UML
- [Phase 4] `b4 dig -c 4076f73298320`: found at https://lore.kernel.org/
  all/20260215142803.1455757-1-maci.stgn@gmail.com/
- [Phase 4] `b4 dig -a`: only v1 exists, no revisions
- [Phase 4] `b4 dig -w`: addressed to UML maintainers (Richard
  Weinberger, Anton Ivanov, Johannes Berg) and linux-um/linux-kernel
  lists
- [Phase 4] `b4 dig -m /tmp/thread.mbox`: mbox contains the 2 patches of
  the series; no reviewer replies present
- [Phase 6] `git grep -n "fd_map = (void \*)&CMSG_DATA" v6.16 v6.17
  v6.18 v6.19 -- arch/um/kernel/skas/stub.c`: buggy code confirmed
  present in all four stable release tags at line 149
- [Phase 6] Same line count (149) in all versions confirms no contextual
  drift, fix applies cleanly
- [Phase 8] Failure mode: compilation error when building UML with musl
  libc - blocks build entirely
- UNVERIFIED: Exact range of glibc versions that use the alternative
  (rvalue) `CMSG_DATA` definition - commit message asserts both
  definitions exist but did not verify personally; however this does not
  affect the decision (the fix is correct in either case).

**YES**

 arch/um/kernel/skas/stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/skas/stub.c b/arch/um/kernel/skas/stub.c
index 67cab46a602cf..e09216a20cb57 100644
--- a/arch/um/kernel/skas/stub.c
+++ b/arch/um/kernel/skas/stub.c
@@ -146,7 +146,7 @@ stub_signal_interrupt(int sig, siginfo_t *info, void *p)
 		/* Receive the FDs */
 		num_fds = 0;
 		fd_msg = msghdr.msg_control;
-		fd_map = (void *)&CMSG_DATA(fd_msg);
+		fd_map = (void *)CMSG_DATA(fd_msg);
 		if (res == iov.iov_len && msghdr.msg_controllen > sizeof(struct cmsghdr))
 			num_fds = (fd_msg->cmsg_len - CMSG_LEN(0)) / sizeof(int);
 
-- 
2.53.0

