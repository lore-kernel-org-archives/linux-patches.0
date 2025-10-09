Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5459F2ED843;
	Thu,  9 Oct 2025 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025540; cv=none; b=Ym8HqWZA8T9TC+gciDLTtkJ2PryMm2mlqPfZdRZQuJ/dbYv7lK6wo0fyHcAP+hjOPR2TWSyZFRL5N7U9J3oHJ6/PcpawGBH56P8xzeeFG/ut4XQd/YZMz76ssaiVfY/eTFBI4gqAcmhcPj2fzY0hAqUf2PRQpLE9kZSA5Y3SrsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025540; c=relaxed/simple;
	bh=MyXbhpaWCEbYHpNBn6JwcVoHWuO1jSmHlVixq2fqEvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k5AnnhN9pllmoGsF1DlEVHFsLuFowa60em8suSVrnGNgcnoUR3Ejv7JBJFz6Vk7Z+++5rFPOaAkaO0R3aVRmQdooSUAWSXuKiFBWW0CHvbLDBPeIlihvPM1pP9KN3mRchW1qqMQZ+MpXXV+FkXjh9fA1pCEx19COvBA+I6g5k80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv8G2vwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv8G2vwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612D6C4CEE7;
	Thu,  9 Oct 2025 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025540;
	bh=MyXbhpaWCEbYHpNBn6JwcVoHWuO1jSmHlVixq2fqEvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mv8G2vwq7KmZPAwRRqIb5uvQdFdTn+JH3VXzHdBDXoo8CbF47DQESpI1+3zlVvfPT
	 OElhtFFqUpkUee+jeNb9myHGCexhUY8JI6enYIYcMxkvfeaz+VQ5dVsAuASQeNrRYf
	 Wxzemt8mc+IacZf7jnglInhYOX8fHQgRTCBZm0kZwisFJFd5XahuL5YmFpyLQJgQIL
	 7MsYNDmW1/NbN7VS/Fb1RjoNzq819HwV3s42hFvsh5e3nCO7mst4ywkSAYz+m9Y8dK
	 9W3S0RTHK20FndKG1sD5eNU9m7QKilSmbT8tFyVKuTmgh8sF1ZakFY0TxAgO4QU+Fa
	 uwgUS8u3lb1fA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.16] selftests: ublk: fix behavior when fio is not installed
Date: Thu,  9 Oct 2025 11:55:03 -0400
Message-ID: <20251009155752.773732-37-sashal@kernel.org>
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

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit a3835a44107fcbf05f183b5e8b60a8e4605b15ea ]

Some ublk selftests have strange behavior when fio is not installed.
While most tests behave correctly (run if they don't need fio, or skip
if they need fio), the following tests have different behavior:

- test_null_01, test_null_02, test_generic_01, test_generic_02, and
  test_generic_12 try to run fio without checking if it exists first,
  and fail on any failure of the fio command (including "fio command
  not found"). So these tests fail when they should skip.
- test_stress_05 runs fio without checking if it exists first, but
  doesn't fail on fio command failure. This test passes, but that pass
  is misleading as the test doesn't do anything useful without fio
  installed. So this test passes when it should skip.

Fix these issues by adding _have_program fio checks to the top of all of
these tests.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fix intent: Corrects kselftest behavior when `fio` is absent so tests
  skip rather than fail or (worse) falsely pass. Only touches selftests;
  no kernel/runtime code.

- Scope and change size: Minimal, contained additions of `_have_program
  fio` guards at the top of six shell tests:
  - tools/testing/selftests/ublk/test_generic_01.sh:13
  - tools/testing/selftests/ublk/test_generic_02.sh:13
  - tools/testing/selftests/ublk/test_generic_12.sh:13
  - tools/testing/selftests/ublk/test_null_01.sh:9
  - tools/testing/selftests/ublk/test_null_02.sh:9
  - tools/testing/selftests/ublk/test_stress_05.sh:8

- Behavior fixed, per file:
  - generic_01, generic_02, generic_12: Previously ran `fio`
    unconditionally and treated any `fio` failure (including “command
    not found”) as test failure. Now skip early if `fio` is missing.
    - Example: tools/testing/selftests/ublk/test_generic_01.sh:13 adds:
      - `if ! _have_program fio; then`
      - `exit "$UBLK_SKIP_CODE"`
  - null_01, null_02: Previously ran `fio` unconditionally and set
    `ERR_CODE` to `fio`’s exit status, causing failures when `fio` is
    not installed. Now skip.
    - Example: tools/testing/selftests/ublk/test_null_01.sh:9 (same
      guard).
  - stress_05: Previously ran `fio` without checking for existence but
    didn’t propagate `fio` failure, so the test could pass without doing
    IO. Now skip if `fio` is absent.
    - Example: tools/testing/selftests/ublk/test_stress_05.sh:8 (same
      guard).

- Correct integration with test framework:
  - Skip code path uses `UBLK_SKIP_CODE=4` which matches kselftest
    conventions and test harness handling
    (tools/testing/selftests/ublk/test_common.sh:4, and `_show_result`
    prints “[SKIP]” for code 4).
  - `_have_program` is already defined and used throughout ublk
    selftests (tools/testing/selftests/ublk/test_common.sh:6).

- Consistency with other ublk tests:
  - Many existing ublk selftests already guard on `fio` (e.g.,
    tools/testing/selftests/ublk/test_stress_01.sh includes the guard),
    so this change brings the remaining outliers into line.

- Risk assessment:
  - No architectural changes, no runtime code touched, only selftests
    updated.
  - Behavior when `fio` is present is unchanged; when `fio` is absent,
    tests now skip instead of failing/passing spuriously.
  - Extremely low regression risk.

- Stable applicability:
  - These specific tests exist in stable 6.17.y and currently lack the
    guards (e.g., remotes/stable/linux-
    6.17.y:tools/testing/selftests/ublk/test_generic_01.sh shows no
    `fio` check at top), so backport provides immediate benefit for
    accurate test results.
  - Older stable lines (e.g., 6.6.y, 6.1.y) don’t contain these test
    files, so the change is not applicable there.
  - No “Cc: stable” tag, but stable routinely accepts small, low-risk
    selftest fixes that correct test behavior.

Given the above, this is a textbook stable backport: a small, selftests-
only bugfix that improves test correctness with negligible risk.

 tools/testing/selftests/ublk/test_generic_01.sh | 4 ++++
 tools/testing/selftests/ublk/test_generic_02.sh | 4 ++++
 tools/testing/selftests/ublk/test_generic_12.sh | 4 ++++
 tools/testing/selftests/ublk/test_null_01.sh    | 4 ++++
 tools/testing/selftests/ublk/test_null_02.sh    | 4 ++++
 tools/testing/selftests/ublk/test_stress_05.sh  | 4 ++++
 6 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/ublk/test_generic_01.sh b/tools/testing/selftests/ublk/test_generic_01.sh
index 9227a208ba531..21a31cd5491aa 100755
--- a/tools/testing/selftests/ublk/test_generic_01.sh
+++ b/tools/testing/selftests/ublk/test_generic_01.sh
@@ -10,6 +10,10 @@ if ! _have_program bpftrace; then
 	exit "$UBLK_SKIP_CODE"
 fi
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "sequential io order"
 
 dev_id=$(_add_ublk_dev -t null)
diff --git a/tools/testing/selftests/ublk/test_generic_02.sh b/tools/testing/selftests/ublk/test_generic_02.sh
index 3e80121e3bf5e..12920768b1a08 100755
--- a/tools/testing/selftests/ublk/test_generic_02.sh
+++ b/tools/testing/selftests/ublk/test_generic_02.sh
@@ -10,6 +10,10 @@ if ! _have_program bpftrace; then
 	exit "$UBLK_SKIP_CODE"
 fi
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "sequential io order for MQ"
 
 dev_id=$(_add_ublk_dev -t null -q 2)
diff --git a/tools/testing/selftests/ublk/test_generic_12.sh b/tools/testing/selftests/ublk/test_generic_12.sh
index 7abbb00d251df..b4046201b4d99 100755
--- a/tools/testing/selftests/ublk/test_generic_12.sh
+++ b/tools/testing/selftests/ublk/test_generic_12.sh
@@ -10,6 +10,10 @@ if ! _have_program bpftrace; then
 	exit "$UBLK_SKIP_CODE"
 fi
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "do imbalanced load, it should be balanced over I/O threads"
 
 NTHREADS=6
diff --git a/tools/testing/selftests/ublk/test_null_01.sh b/tools/testing/selftests/ublk/test_null_01.sh
index a34203f726685..c2cb8f7a09fe3 100755
--- a/tools/testing/selftests/ublk/test_null_01.sh
+++ b/tools/testing/selftests/ublk/test_null_01.sh
@@ -6,6 +6,10 @@
 TID="null_01"
 ERR_CODE=0
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "basic IO test"
 
 dev_id=$(_add_ublk_dev -t null)
diff --git a/tools/testing/selftests/ublk/test_null_02.sh b/tools/testing/selftests/ublk/test_null_02.sh
index 5633ca8766554..8accd35beb55c 100755
--- a/tools/testing/selftests/ublk/test_null_02.sh
+++ b/tools/testing/selftests/ublk/test_null_02.sh
@@ -6,6 +6,10 @@
 TID="null_02"
 ERR_CODE=0
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 _prep_test "null" "basic IO test with zero copy"
 
 dev_id=$(_add_ublk_dev -t null -z)
diff --git a/tools/testing/selftests/ublk/test_stress_05.sh b/tools/testing/selftests/ublk/test_stress_05.sh
index 566cfd90d192c..274295061042e 100755
--- a/tools/testing/selftests/ublk/test_stress_05.sh
+++ b/tools/testing/selftests/ublk/test_stress_05.sh
@@ -5,6 +5,10 @@
 TID="stress_05"
 ERR_CODE=0
 
+if ! _have_program fio; then
+	exit "$UBLK_SKIP_CODE"
+fi
+
 run_io_and_remove()
 {
 	local size=$1
-- 
2.51.0

