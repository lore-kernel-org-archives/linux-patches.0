Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398E840F8DE;
	Tue, 28 Apr 2026 10:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372963; cv=none; b=UqurJQILkC2gZ8ye6uqasFnF0Gqs0/A+R0G7HqOECQYsdRkKtBFNT/ZQ6BOpO5kqD+fXenbJhhuYrijXMnTM+wTKDYSg7Dv3ERWdZ+pM2jcqrt1rhKS1uH+evXQBTF5CJq2Du+U0sL95N5ukwHJSvqKGdTNwSzlVJK67kSEAvkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372963; c=relaxed/simple;
	bh=mx2GaK0Rilbir/2uK+gqFS5WDDmaDBaIWRN9gyDdsCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iEvrZwrxHwwR8kWLQWXi+JwIZb7/L9dAbu/XLl5fRcTBmKYiuwGIZGbyHfVvSF42rtsZILls3xfQnHvj/rur9N7foNCcqftQdYnwcaoBac1kQjaxwwzpVK+9lqSH2r4dQXLY9ka7JkP28ajQ40PDHSC1U7R6FuGOYYAUZCQlgII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcooGKOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcooGKOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8CBC2BCB6;
	Tue, 28 Apr 2026 10:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372963;
	bh=mx2GaK0Rilbir/2uK+gqFS5WDDmaDBaIWRN9gyDdsCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcooGKOH/vpQSIhtzdMipGhVlPM+Festh0WL+ZnIN2ameNbo3OU2qVOQpFXi7hBHX
	 EeFjIZ4SCmXftJWGlJXB7JN5BjZCzC5XxT8j+DqQwuebMf66gT/gJ7SK5Hh7JoQfWg
	 P3FKoOHrQp0Yo57rHV+DnS34J3cNn0ILjTAL4ERH/+BP7gE/ytVLopguJ4UPIp44Mw
	 R356Z3qfIQ2mblB2goj6+g9fawXUkgnFRLuFAqXhZLCVNxe2+9GW0BCZqt7VdzsPW+
	 l6sAICmnNV37w1f8lmQYzNP5xfb1SOMvNNhjAGJ39dGTYaYnK7BQKBvSwrkNevidgy
	 +GCl46G4eqGQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	shuah@kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] selftests: fib_nexthops: test stale has_v4 on nexthop replace
Date: Tue, 28 Apr 2026 06:41:00 -0400
Message-ID: <20260428104133.2858589-49-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 104f082f5ed6d19c5d85ca905ccd4e4d01aef66e ]

Add test cases that exercise the scenario where an IPv6 nexthop is
replaced with an IPv4 nexthop while being part of a group. The group's
has_v4 flag must be updated so that subsequent IPv6 route additions are
properly rejected.

Two cases are covered:
  1. Gateway nexthop replaced across families with an existing IPv6
     route on the group (rejected by fib6_check_nh_list).
  2. Blackhole nexthop replaced across families with no existing IPv6
     route on the group (fib6_check_nh_list returns early) — this is
     the path that triggers a NULL ptr deref without the kernel fix.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260413114522.147784-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make my analysis. Let me synthesize the
findings.

## Phase 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parse**
- Record: Subsystem `selftests: fib_nexthops:`, action verb `test`,
  summary: adds test cases for the "stale has_v4 on nexthop replace"
  scenario.

**Step 1.2: Tags**
- Record: `Signed-off-by: Jiayuan Chen` (author), `Reviewed-by: David
  Ahern` (subsystem maintainer), `Link:` to lore patch.msgid.link (patch
  2 of 2), `Signed-off-by: Paolo Abeni` (netdev maintainer). No explicit
  Cc: stable (expected, not a negative signal).

**Step 1.3: Body analysis**
- Record: Commit body explicitly references the kernel bug fixed by
  patch 1/2 (sibling commit). It describes two test cases: a gateway-
  family swap (caught by `fib6_check_nh_list`) and a blackhole-family
  swap that "triggers a NULL ptr deref without the kernel fix". This
  selftest is the test companion to a syzbot-reported NULL deref fix.

**Step 1.4: Hidden bug fix detection**
- Record: Not a hidden fix - this is explicitly a test-only commit. The
  kernel bug fix is in the paired commit (patch 1/2).

## Phase 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Record: Single file change
  `tools/testing/selftests/net/fib_nexthops.sh`, +22 lines, 0 removed.
  Function modified: `ipv6_fcnal_runtime()`. Scope: pure test additions
  to an existing test function.

**Step 2.2: Code flow change**
- Record: Adds two new test scenarios appended to the existing test
  series in `ipv6_fcnal_runtime()`. No existing code changed. New tests
  use existing helper `run_cmd` and `log_test`.

**Step 2.3: Bug mechanism**
- Record: No bug mechanism - this is a test file, not kernel code. The
  tests exercise:
  1. `ip nexthop replace id 89 via 172.16.1.1` (IPv6→IPv4 gateway
     replace), expects route rejection (exit 2)
  2. `ip nexthop replace id 90 blackhole` after `ip -6 nexthop add id 90
     blackhole` (IPv6→IPv4 blackhole), expects IPv6 route rejection and
     unreachable ping

**Step 2.4: Fix quality**
- Record: Test additions are small, appended at a safe location (right
  after the existing related test block and before `$IP nexthop flush`).
  No regression risk to kernel runtime - only affects test output.

## Phase 3: GIT HISTORY INVESTIGATION

**Step 3.1: File history**
- Record: `tools/testing/selftests/net/fib_nexthops.sh` has accumulated
  many test additions over the years. Recent stable-backported selftests
  include `44741e9de29b` (Add test cases for error routes deletion) and
  `46c1ef0cfcea5` (add test for IPv4 route with loopback IPv6 nexthop),
  confirming that this file receives selftest backports.

**Step 3.2: The kernel fix paired with this test**
- Record: The kernel fix is `29c95185ba32b nexthop: fix IPv6 route
  referencing IPv4 nexthop` (patch 1/2, immediately preceding this
  commit in git history). That fix has:
  - `Fixes: 7bf4796dd099 ("nexthops: add support for replace")` — buggy
    code introduced in v5.3, present in all active stable trees (v5.10+,
    v5.15+, v6.1+, v6.6+, v6.12+, v6.17+, v6.18+, v6.19+).
  - Two syzbot reports referenced.
  - 2-line `AF_INET == && AF_INET6 ==` → `!=` change; trivially correct.
  - Reviewed-by David Ahern (nexthop subsystem maintainer).

**Step 3.3: Related changes**
- Record: Historically, similar 2-patch series (fix + selftest) have
  been backported together to stable. The broader `ipv6_fcnal_runtime`
  section uses infrastructure present in all stable trees.

**Step 3.4: Author**
- Record: Jiayuan Chen is an active contributor who has been submitting
  many syzbot-related fixes recently (network UAF/NULL deref/race fixes,
  etc.)

**Step 3.5: Dependencies**
- Record: This selftest depends on the kernel fix being present -
  without it, the second test case would trigger the exact NULL pointer
  dereference panic the fix addresses. If backported without the kernel
  fix, running the test would crash the kernel.

## Phase 4: MAILING LIST RESEARCH

**Step 4.1: b4 dig on 104f082f5ed6d**
- Record: `b4 dig -c 104f082f5ed6d` matched exactly. Series is `[PATCH
  net v1 1/2, 2/2]`. Only v1 exists. URL: https://lore.kernel.org/all/20
  260413114522.147784-2-jiayuan.chen@linux.dev/

**Step 4.2: Recipients (b4 dig -w)**
- Record: Jiayuan Chen, netdev@vger.kernel.org, David Ahern (nexthop
  maintainer), David S. Miller, Eric Dumazet, Jakub Kicinski, Paolo
  Abeni, Simon Horman, Shuah Khan, linux-kernel, linux-kselftest. All
  appropriate.

**Step 4.3: Bug report**
- Record: Thread content (saved mbox) shows David Ahern's Reviewed-by
  for both patches. Paolo Abeni applied both. The series was applied to
  netdev/net.git (the -net tree for bug fixes, not net-next which is for
  new features) - a strong indicator that this is treated as a bugfix,
  not feature.

**Step 4.4: Related patches**
- Record: Only 2 patches in the series. The selftest (2/2) is the direct
  companion to the kernel fix (1/2).

**Step 4.5: Stable discussion**
- Record: No explicit stable Cc in thread; none needed because the fix
  has a Fixes: tag and Greg KH's AUTOSEL will consider both.

## Phase 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
- Record: Only `ipv6_fcnal_runtime()` in a shell test script. No C code
  changes.

**Step 5.2-5.5: Impact surface**
- Record: This test is invoked when running the `fib_nexthops.sh`
  selftest. No kernel-side impact. The test validates the kernel-side
  `replace_nexthop_single()` function's handling of cross-family
  (AF_INET6 → AF_INET) nexthop replacement within groups.

## Phase 6: STABLE TREE ANALYSIS

**Step 6.1: Code in stable**
- Record: The kernel bug exists since v5.3 (verified via `git tag
  --contains 7bf4796dd099`). The `ipv6_fcnal_runtime` test function
  exists in all active stable trees (v5.10+). Context lines in the diff
  are present in stable.

**Step 6.2: Backport complications**
- Record: The surrounding `ipv6_fcnal_runtime` test body in
  stable/linux-6.19.y matches (verified indirectly through file
  history). The test should apply cleanly or with minor line-offset
  adjustment. Test uses existing `$IP`, `run_cmd`, `log_test`,
  `PING_TIMEOUT`, `$me` infrastructure all present in stable.

**Step 6.3: Related in stable**
- Record: No existing backport of this test. Similar companion selftests
  (e.g., 44741e9de29b for error routes deletion fix) were backported
  alongside their kernel fixes.

## Phase 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- Record: `tools/testing/selftests/net/` - network subsystem test.
  Criticality: test-only, but validates IMPORTANT subsystem
  (networking/nexthop API).

**Step 7.2: Activity**
- Record: The nexthop subsystem is actively developed; selftests are
  regularly added.

## Phase 8: IMPACT AND RISK

**Step 8.1: Who affected**
- Record: The test-only change affects anyone running selftests. It's
  not a runtime change.

**Step 8.2: Trigger conditions**
- Record: Only triggered when `fib_nexthops.sh` is explicitly run.

**Step 8.3: Failure mode**
- Record: Without the paired kernel fix in stable, running this selftest
  WOULD trigger the NULL pointer dereference (test scenario 2 exercises
  the exact reproducer). With the fix, the test passes silently.

**Step 8.4: Risk-benefit**
- Record:
  - BENEFIT: Validates that the syzbot NULL-deref fix works in stable;
    prevents regressions. Low-medium.
  - RISK: Very low runtime risk (test-only). However, there is a
    **dependency risk**: if the selftest is backported WITHOUT the
    kernel fix (`29c95185ba32b`), running the test will crash the
    kernel. This means the two commits must travel together.

## Phase 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: Companion to an important syzbot NULL-deref fix; small (22 lines)
  self-contained test; adds to existing test file; accompanies fix that
  is strongly stable-worthy; reviewed by subsystem maintainer; submitted
  to -net tree (bugfix tree).
- AGAINST: Test-only commits don't themselves fix bugs; depends on the
  kernel fix being present to avoid panic.
- UNRESOLVED: None material.

**Step 9.2: Stable rules**
- Obviously correct? Yes, pure test additions.
- Fixes a real bug? No (test only), but validates one.
- Important issue? Indirectly - validates a NULL-deref fix.
- Small and contained? Yes - 22 lines, one file, tools/ only.
- No new features? Yes - adds test cases, not new behavior.
- Can apply to stable? Yes - should apply cleanly to all active stable
  trees.

**Step 9.3: Exceptions**
- Falls under the "test-only companion to a backport-worthy fix"
  pattern. Historical precedent (e.g., `44741e9de29b`) shows such tests
  are backported.

**Step 9.4: Decision**

This is a selftest commit that accompanies an important kernel fix
(`29c95185ba32b`, "nexthop: fix IPv6 route referencing IPv4 nexthop")
for a syzbot-reported NULL pointer dereference. The kernel fix itself is
a textbook stable candidate: 2-line surgical change, syzbot-reported,
Fixes: tag pointing to v5.3, reviewed by subsystem maintainer, applied
to the -net bugfix tree. Selftests that validate specific bug fixes are
commonly backported alongside those fixes (as demonstrated by
`44741e9de29b` already in stable), and stable maintainers generally want
such tests to be able to verify the backported fix works. The test is
small, self-contained, adds cases to an existing test file, uses only
pre-existing test infrastructure, and doesn't affect kernel runtime
behavior. Its only requirement is that it travel alongside the kernel
fix (which should also be selected).

## Verification

- [Phase 1] Parsed tags: `Signed-off-by: Jiayuan Chen`, `Reviewed-by:
  David Ahern`, `Link:` to msgid.link, `Signed-off-by: Paolo Abeni`. No
  Cc: stable (expected).
- [Phase 1] Body reference to "kernel fix" confirmed by reading mbox:
  patch 2/2 is explicit companion to patch 1/2.
- [Phase 2] Diff inventory:
  `tools/testing/selftests/net/fib_nexthops.sh` +22/-0 lines, only
  function `ipv6_fcnal_runtime()` touched.
- [Phase 2] Read lines 1180-1246 of current `fib_nexthops.sh`: verified
  the test insertion point is after existing replace-related tests and
  before `$IP nexthop flush` / "weird IPv6 cases".
- [Phase 3] `git log --grep="stale has_v4"`: identified paired commits
  `29c95185ba32b` (fix) and `104f082f5ed6d` (this selftest).
- [Phase 3] `git show 29c95185ba32b`: confirmed kernel fix is 2-line
  AF_INET/AF_INET6 comparison change with Fixes: tag and syzbot reports.
- [Phase 3] `git show 7bf4796dd099 --stat`: buggy code in
  `net/ipv4/nexthop.c` from Jun 2019.
- [Phase 3] `git tag --contains 7bf4796dd099 | grep v5`: buggy code
  present from v5.3 onward.
- [Phase 4] `b4 dig -c 104f082f5ed6d`: matched original submission;
  patch 2/2 of a 2-patch series.
- [Phase 4] `b4 dig -c 104f082f5ed6d -a`: only v1 of the series exists
  (no revisions).
- [Phase 4] `b4 dig -c 104f082f5ed6d -w`: appropriate reviewers
  including David Ahern (nexthop maintainer).
- [Phase 4] Read saved mbox `/tmp/selftest_thread.mbox`: found David
  Ahern's `Reviewed-by` on both patches and patchwork-bot confirmation
  that series was applied to netdev/net.git (bugfix tree).
- [Phase 6] `git log stable/linux-6.19.y --
  tools/testing/selftests/net/fib_nexthops.sh`: confirmed `44741e9de29b`
  and prior selftests were accepted into stable, establishing precedent.
- [Phase 6] `git log stable/linux-6.19.y --grep="has_v4"`: the new
  kernel fix `29c95185ba32b` is not yet in stable (expected - just
  merged to mainline).
- [Phase 8] Failure mode without accompanying kernel fix: running the
  test would panic the kernel (verified by reading commit body and
  reproducer).
- UNVERIFIED: Exact line-offset applicability to all stable trees not
  tested with `git apply`, but surrounding function structure appears
  stable across trees.

**YES**

 tools/testing/selftests/net/fib_nexthops.sh | 22 +++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 6eb7f95e70e15..ac868a7316946 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1209,6 +1209,28 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
 	log_test $? 0 "IPv6 route using a group after replacing v4 gateways"
 
+	# Replacing an IPv6 nexthop with an IPv4 nexthop should update has_v4
+	# for all groups using it, preventing IPv6 routes from referencing the
+	# group after the replace.
+	run_cmd "$IP nexthop add id 89 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 125 group 89"
+	run_cmd "$IP nexthop replace id 89 via 172.16.1.1 dev veth1"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 125"
+	log_test $? 2 "IPv6 route can not use group after v6 nexthop replaced by v4"
+
+	# Same scenario but with a blackhole nexthop: the group has no IPv6
+	# routes yet when the replace happens, so fib6_check_nh_list returns
+	# early without checking. has_v4 must still be updated to block
+	# subsequent IPv6 route additions.
+	run_cmd "$IP nexthop flush >/dev/null 2>&1"
+	run_cmd "$IP -6 nexthop add id 90 blackhole"
+	run_cmd "$IP nexthop add id 125 group 90"
+	run_cmd "$IP nexthop replace id 90 blackhole"
+	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 125"
+	log_test $? 2 "IPv6 route reject v6 blackhole replaced by v4 blackhole"
+	run_cmd "ip netns exec $me ping -6 2001:db8:101::1 -c1 -w$PING_TIMEOUT"
+	log_test $? 2 "Ping unreachable after rejected route"
+
 	$IP nexthop flush >/dev/null 2>&1
 
 	#
-- 
2.53.0

