Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A73480329;
	Mon, 20 Apr 2026 13:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691882; cv=none; b=rRhea6IF5gJ4daxcBP0vURzCU6Bi8aL1BpBU2ktU9zUHEMFFoLsLAvR7c1p3hRs3aTLW/RaxyaGSHXExPJ2fuUGfAytCtiJQPF7U/W8PNdncbGMmlW9UrP7EiG7kn2UB8MJGe97/xHMcCXlJMql7G34KEYOosnSqEgdYfXJpyeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691882; c=relaxed/simple;
	bh=Sh6nHMW1lqcujGl74gmy3RQhs0M329c5k/19w5sLhmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJUbzJE7r6bRGA67yKrvYUH4Zd1jn6YjB6kAPhAG+a2BJ+cr53XDBfNso4+XiMTVoeDkinX2Tszo8yfKqzeRBawCn3A18HHxgJML1y1Fk+OF2dlAGAPv9J0o4BSE6qxKY8OAlPdiRmQqORAj10aCqAquLBFDOJ7wDx173T+uD0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIB87Hh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIB87Hh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89284C2BCB8;
	Mon, 20 Apr 2026 13:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691881;
	bh=Sh6nHMW1lqcujGl74gmy3RQhs0M329c5k/19w5sLhmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIB87Hh9yNQublZNwi9NtQFl4tw60RI4phUIpHY+eU5NhW9DB8RtxTlAhUwWPIBrd
	 q4bEYJdERykBVLt42h97Jo4C07eY+oe3PYXm8Aqi6thU4I98mFiF6G583K8t0n+EIg
	 QWtiHImxuONhN9rUtPPQFJ5CA57RgKTWUTMzeS7jgHYtkxH15aAUaTxO02c6iYRDEn
	 rEvTi5GYZV9NeVWKlUaau+utJdJ7XAE2E6Kq40uT/BzS0J61Xk5ecwnTdHHt96alB8
	 S6PajvIlihjpLZrZftf+WiW6R1cFJw8XPWzy31Lwfjc0MjTKQi/2GGQe1qZinMnJos
	 6OR3U2ttzQscw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alistair Francis <alistair.francis@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] nvmet-tcp: Don't free SQ on authentication success
Date: Mon, 20 Apr 2026 09:20:43 -0400
Message-ID: <20260420132314.1023554-249-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 2e6eb6b277f593b98f151ea8eff1beb558bbea3b ]

Curently after the host sends a REPLACETLSPSK we free the TLS keys as
part of calling nvmet_auth_sq_free() on success. This means when the
host sends a follow up REPLACETLSPSK we return CONCAT_MISMATCH as the
check for !nvmet_queue_tls_keyid(req->sq) fails.

This patch ensures we don't free the TLS key on success as we might need
it again in the future.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `nvmet-tcp` (NVMe target, TCP transport)
- Action verb: "Don't free" (preventing incorrect cleanup = bug fix)
- Summary: Prevent freeing SQ authentication state on success to
  preserve TLS key for future REPLACETLSPSK

**Step 1.2: Tags**
- Reviewed-by: Christoph Hellwig, Hannes Reinecke (original auth
  author), Wilfred Mallawa, Sagi Grimberg (NVMe-oF maintainer)
- Signed-off-by: Keith Busch (NVMe maintainer, committer)
- No Fixes: tag, no Cc: stable (expected for autosel candidates)
- No Reported-by (discovered during development/testing rather than user
  report)

**Step 1.3: Commit Body**
The bug: after a successful NEWTLSPSK authentication,
`nvmet_auth_sq_free()` is called which sets `sq->tls_key = NULL`. When
the host sends a follow-up REPLACETLSPSK, the check
`!nvmet_queue_tls_keyid(req->sq)` fails (returns 0 because key is NULL),
and the target returns CONCAT_MISMATCH.

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly a bug fix - the "Don't free" phrasing indicates
fixing incorrect behavior.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/nvme/target/fabrics-cmd-auth.c`
- Approx +5/-5 lines (very small)
- Functions modified: `nvmet_execute_auth_send()`,
  `nvmet_execute_auth_receive()`

**Step 2.2: Code Flow Changes**

Hunk 1 (`nvmet_execute_auth_send`, lines ~398-401):
- Before: `nvmet_auth_sq_free()` was called for BOTH SUCCESS2 and
  FAILURE2 final states
- After: `nvmet_auth_sq_free()` is called ONLY for FAILURE2

Hunk 2 (`nvmet_execute_auth_receive`, lines ~577-582):
- Before: `nvmet_auth_sq_free()` was called for BOTH SUCCESS2 and
  FAILURE1
- After: `nvmet_auth_sq_free()` is called ONLY for FAILURE1

**Step 2.3: Bug Mechanism**
This is a **logic/correctness bug**. The `nvmet_auth_sq_free()` function
(in `auth.c:239-251`) performs:

```239:251:drivers/nvme/target/auth.c
void nvmet_auth_sq_free(struct nvmet_sq *sq)
{
        cancel_delayed_work(&sq->auth_expired_work);
#ifdef CONFIG_NVME_TARGET_TCP_TLS
        sq->tls_key = NULL;
#endif
        kfree(sq->dhchap_c1);
        sq->dhchap_c1 = NULL;
        kfree(sq->dhchap_c2);
        sq->dhchap_c2 = NULL;
        kfree(sq->dhchap_skey);
        sq->dhchap_skey = NULL;
}
```

The critical line `sq->tls_key = NULL` discards the TLS key on success.
The `nvmet_queue_tls_keyid()` function checks this:

```876:879:drivers/nvme/target/nvmet.h
static inline key_serial_t nvmet_queue_tls_keyid(struct nvmet_sq *sq)
{
        return sq->tls_key ? key_serial(sq->tls_key) : 0;
}
```

And the REPLACETLSPSK negotiation code at line 58-60 requires the key to
exist:

```58:60:drivers/nvme/target/fabrics-cmd-auth.c
                case NVME_AUTH_SECP_REPLACETLSPSK:
                        if (!nvmet_queue_tls_keyid(req->sq))
                                return
NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
```

So after a successful auth that clears the key, REPLACETLSPSK always
fails.

**Step 2.4: Fix Quality**
- Obviously correct: the fix simply restricts `nvmet_auth_sq_free` to
  failure-only paths
- Minimal/surgical: ~10 lines changed, single file
- Regression risk: Very low. The SQ will still be properly freed during
  SQ destruction (`core.c:972` calls `nvmet_auth_sq_free`)

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The buggy code in auth_send (line 399) was introduced by
  `db1312dd95488b` (Hannes Reinecke, 2022-06-27) - the original auth
  implementation
- The `sq->tls_key = NULL` line in `nvmet_auth_sq_free` was added by
  `fa2e0f8bbc689` (Hannes Reinecke, 2025-02-24) - the secure channel
  concatenation feature
- The bug: calling `nvmet_auth_sq_free` on success was harmless before
  `fa2e0f8bbc689` (no TLS key existed), but became a bug after TLS key
  handling was added to the function

**Step 3.2: Fixes Target**
No explicit Fixes: tag, but the bug was introduced by `fa2e0f8bbc689`
"nvmet-tcp: support secure channel concatenation", which first appeared
in **v6.15-rc1** (`v6.15-rc1~166^2^2~13`).

**Step 3.3: File History**
Only one commit has touched this file since v6.15: `159de7a825aea`
("nvmet-auth: update sc_c in target host hash calculation") by the same
author, which is a different fix.

**Step 3.4: Author**
Alistair Francis (WDC) has authored 3 NVMe auth fixes in this subsystem.
He's a contributor focused on NVMe-TCP/TLS.

**Step 3.5: Dependencies**
The patch is standalone. It only modifies the conditions under which
`nvmet_auth_sq_free()` is called, with no new functions or structural
changes.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:** Lore search was blocked by Anubis anti-bot protection.
However, `b4 dig` found the related commit `159de7a825aea` at `https://p
atch.msgid.link/20251106231711.3189836-1-alistair.francis@wdc.com`. The
4 reviewer tags (Christoph Hellwig, Hannes Reinecke, Wilfred Mallawa,
Sagi Grimberg) demonstrate thorough review by the NVMe subsystem's key
developers.

**Step 4.3-4.5:** Could not access lore due to bot protection. The
commit's review coverage is excellent though.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.2: Callers**
`nvmet_execute_auth_send` and `nvmet_execute_auth_receive` are assigned
as `req->execute` handlers in `fabrics-cmd.c` for
`nvme_fabrics_type_auth_send` and `nvme_fabrics_type_auth_receive`
commands (when `CONFIG_NVME_TARGET_AUTH` is enabled). These are called
during the NVMe-oF authentication flow on both admin and I/O queue
setup.

**Step 5.3-5.4: Call Chain**
The auth commands are triggered by the NVMe host during connection
setup. This is a standard NVMe-oF protocol path, reachable whenever a
host connects to a target with authentication enabled.

**Step 5.5: Similar Patterns**
`nvmet_auth_sq_free` is also called from `core.c:972` during SQ
destruction, which is the correct final cleanup point and is unaffected
by this change.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code Existence**
The buggy code (`sq->tls_key = NULL` in `nvmet_auth_sq_free` plus
calling it on success) was introduced by `fa2e0f8bbc689` in
**v6.15-rc1**. It exists in stable trees: **6.15.y, 6.16.y, 6.17.y,
6.18.y, 6.19.y** (and 7.0).

**Step 6.2: Backport Complications**
Since v6.15, only `159de7a825aea` has touched this file (adding 1 line
to a different function). The patch should apply cleanly to all affected
stable trees.

**Step 6.3: Related Fixes**
Two related fixes to `fa2e0f8bbc689` already exist: `b1efcc470eb30`
(sparse warning fix) and `8edb86b2ed1d6` (memory leak fix). Neither
addresses the REPLACETLSPSK issue.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** NVMe target, TCP transport. Criticality: **IMPORTANT** -
NVMe-oF/TCP is widely used in storage infrastructure. The auth subsystem
is critical for security.

**Step 7.2:** Actively developed - secure channel concatenation was
added in v6.15 with ongoing fixes.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users of NVMe-TCP with DH-HMAC-CHAP authentication and secure channel
concatenation (TLS PSK replacement).

**Step 8.2: Trigger Conditions**
Triggered whenever a host sends a REPLACETLSPSK request after a
successful initial NEWTLSPSK authentication. This is a standard protocol
flow per NVMe Base Spec 2.1 section 8.3.4.3. The trigger is
deterministic, not timing-dependent.

**Step 8.3: Failure Mode**
Authentication fails with CONCAT_MISMATCH error. Severity: **MEDIUM-
HIGH** - the REPLACETLSPSK feature is completely broken, rendering the
secure channel concatenation TLS key rotation inoperable. This is a
functionality regression, not a crash.

**Step 8.4: Risk-Benefit**
- **Benefit:** HIGH - fixes a completely broken protocol feature
  (REPLACETLSPSK)
- **Risk:** VERY LOW - 10-line change, restricts cleanup to failure
  paths only, SQ destruction still properly cleans up

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes a real, deterministic bug making REPLACETLSPSK unusable
- Small, surgical, obviously correct fix (10 lines, 1 file)
- 4 expert reviewers including NVMe-oF maintainer (Sagi Grimberg)
- Standalone patch, no dependencies
- Clean application expected on all affected stable trees

AGAINST backporting:
- Affects a relatively new feature (v6.15+), limiting the number of
  stable trees
- No explicit Fixes: or Cc: stable tag (expected for autosel candidates)
- No user bug reports (Reported-by)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - 4 reviewers, straightforward
   logic change
2. Fixes a real bug? **YES** - REPLACETLSPSK is completely broken
3. Important issue? **YES** - broken protocol feature, though not
   crash/security/corruption
4. Small and contained? **YES** - 10 lines, single file
5. No new features? **YES** - purely fixes existing behavior
6. Applies to stable? **YES** - for 6.15.y and later

**Step 9.3: Exceptions** - N/A

**Step 9.4: Decision**
This is a clear, well-reviewed bug fix for a broken NVMe-TCP protocol
feature. The fix is minimal, obviously correct, and standalone.

## Verification

- [Phase 1] Parsed tags: 4 Reviewed-by (Christoph Hellwig, Hannes
  Reinecke, Wilfred Mallawa, Sagi Grimberg), SOB by Keith Busch
  (maintainer)
- [Phase 2] Diff analysis: ~10 lines changed in 2 functions, restricts
  `nvmet_auth_sq_free()` to failure paths only
- [Phase 2] Verified `nvmet_auth_sq_free()` clears `sq->tls_key = NULL`
  (auth.c:243)
- [Phase 2] Verified `nvmet_queue_tls_keyid()` returns 0 when `tls_key`
  is NULL (nvmet.h:876-879)
- [Phase 2] Verified REPLACETLSPSK check requires non-zero key (fabrics-
  cmd-auth.c:59-60)
- [Phase 3] git blame: buggy cleanup code from db1312dd95488b (2022),
  TLS key clearing added by fa2e0f8bbc689 (2025)
- [Phase 3] git describe: fa2e0f8bbc689 first appears at
  v6.15-rc1~166^2^2~13
- [Phase 3] git log v6.15..v7.0: only 1 other commit touched this file
  (159de7a825aea)
- [Phase 3] Confirmed SQ destruction at core.c:972 still calls
  nvmet_auth_sq_free for final cleanup
- [Phase 4] b4 dig: found related author thread. Lore blocked by Anubis.
- [Phase 5] Callers: both functions registered as req->execute handlers
  for auth commands in fabrics-cmd.c
- [Phase 6] Bug exists in stable trees 6.15.y through 6.19.y
- [Phase 6] Clean apply expected - minimal churn since v6.15
- [Phase 8] Deterministic trigger: every REPLACETLSPSK after successful
  NEWTLSPSK fails
- UNVERIFIED: Could not access lore discussion for stable nomination
  signals or NAKs

**YES**

 drivers/nvme/target/fabrics-cmd-auth.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 5946681cb0e32..96c85579150dd 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -396,9 +396,10 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		goto complete;
 	}
 	/* Final states, clear up variables */
-	nvmet_auth_sq_free(req->sq);
-	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE2)
+	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
+		nvmet_auth_sq_free(req->sq);
 		nvmet_ctrl_fatal_error(ctrl);
+	}
 
 complete:
 	nvmet_req_complete(req, status);
@@ -574,9 +575,7 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 	status = nvmet_copy_to_sgl(req, 0, d, al);
 	kfree(d);
 done:
-	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2)
-		nvmet_auth_sq_free(req->sq);
-	else if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
+	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
 		nvmet_auth_sq_free(req->sq);
 		nvmet_ctrl_fatal_error(ctrl);
 	}
-- 
2.53.0

