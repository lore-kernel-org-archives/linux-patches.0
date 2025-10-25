Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F19F3043B7;
	Sat, 25 Oct 2025 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409712; cv=none; b=Gtq0Ok+bUBbd4CAzCZASnpeAUEkAZvfpF9FkyE6qkyOExXgs9ctKbVmml/tW739xoL2uoJPViTrzHaEaxW4moLVRqZqVfFGTZ7w7Q5bkq/qaSan+N1LsCaH2u0x5TLDtO+oQpqBoHHx3M+4Yhs3vdDHKUSdtMJqiG7azdu7ZMK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409712; c=relaxed/simple;
	bh=D8Nbd0Uf19WsIu6RUTCrkEJFRO65F/k3bcyx0m49Gfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLQDTz/BFYtD0dIF/naEk4OKyoYros5iADMgYBsPrNPQQ5RR8k5qJkUqLHBxeAXf39xQovJBra1djS3Xzz5a384/y9Z1uPllOjLSwCInXDralnmWmwPmblj55ka/ew4REPfw6vAEaOp3eL8neU5/PkbZ31Fi3ZTGNZptG/I167o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aux/AYzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aux/AYzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A53DC113D0;
	Sat, 25 Oct 2025 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409712;
	bh=D8Nbd0Uf19WsIu6RUTCrkEJFRO65F/k3bcyx0m49Gfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aux/AYzpaJ0f1m70a5hKTSHZXxK6pOWrXSQkorSQUBh5IG5yae1UnscNXuaFlHwva
	 RlxLnoEJpHjiCnxC+R9PgFg/d8PVlyZvzDGYZO0eOCfCW/6KbknjHFvdWaxlmrB/57
	 2Eq/5/N53tZ6ccUmJGqK0tZosWx5xgYHqCnwq8yLDCZkBmzLHXEq/GzTSJzmKw2cUJ
	 Srew6T1ZKJjdDcjUsGN4iWS3njyhVS5Ksb4Y6MRHMc45T3cmO34gtY2LPcKm0LYXHn
	 puCkiS1Vl/Or/hbswekw1TlrY0JE7uigMoBzK1RuggwYuNAIlCtRD+DajsJVm6Dznv
	 b6lIRSpwpQQjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] selftests: Replace sleep with slowwait
Date: Sat, 25 Oct 2025 12:01:02 -0400
Message-ID: <20251025160905.3857885-431-sashal@kernel.org>
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

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 2f186dd5585c3afb415df80e52f71af16c9d3655 ]

Replace the sleep in kill_procs with slowwait.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-2-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Replaces a fixed delay with a condition-based wait in `kill_procs()`
    so test cleanup actually completes before proceeding:
    `tools/testing/selftests/net/fcnal-test.sh:192`.
  - Old behavior: `sleep 1` after `killall nettest ping ping6`.
  - New behavior: `slowwait 2 sh -c 'test -z "$(pgrep
    "^(nettest|ping|ping6)$")"'` to poll until those processes are gone,
    up to 2 seconds.

- Why it matters
  - `kill_procs()` is called at test start to ensure a clean slate:
    `tools/testing/selftests/net/fcnal-test.sh:161-166`. A fixed sleep
    can be too short on slower or loaded systems, leaving straggler
    `ping`/`ping6`/`nettest` processes that interfere with subsequent
    tests, causing flakiness or false failures. The condition-based wait
    removes that flakiness by verifying process exit.

- How `slowwait` works (and why it’s safe)
  - `slowwait()` is a common helper in net selftests that polls every
    100ms until a command succeeds or a timeout is hit:
    `tools/testing/selftests/net/lib.sh:105-110`. It uses `loopy_wait
    "sleep 0.1" ...`, causing no architectural or API changes, and only
    affects selftest behavior.
  - This is consistent with broader selftests usage (e.g.,
    `tools/testing/selftests/net/rtnetlink.sh:314`,
    `tools/testing/selftests/net/forwarding/lib.sh:566`), standardizing
    on proven patterns already used across the test suite.

- Scope and risk
  - Selftests-only change; no in-kernel code touched.
  - Small and contained; no interface changes.
  - Failure mode is limited: if the processes don’t exit, `slowwait`
    times out in 2s and `kill_procs()`’s non-zero exit code is not fatal
    in callers (no `set -e`); the tests proceed, but the added wait
    significantly lowers flakiness vs. a blind `sleep 1`.
  - The `pgrep` anchored regex `^(nettest|ping|ping6)$` targets the
    exact processes, avoiding false positives.

- Stable backport fit
  - Fixes a real test bug (flaky cleanup) that affects test reliability
    on stable trees.
  - Minimal risk, no architectural changes, not a new feature.
  - Improves determinism of selftests run against stable kernels,
    aligning with stable policy to accept selftest reliability fixes.

Conclusion: This is a low-risk, selftests-only robustness fix that
improves test reliability and should be backported.

 tools/testing/selftests/net/fcnal-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index cf535c23a959a..dfd368371fb3c 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -189,7 +189,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 set_ping_group()
-- 
2.51.0

