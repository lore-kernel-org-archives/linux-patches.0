Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA09731B114;
	Tue,  5 May 2026 09:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974749; cv=none; b=DUttp/QdKhFnPMIU8VomGKAqbiiKi+2PvAUk7llQAcrvvXlajSn2kDuP9R3L6dSA8lJT2dnqJbupKYFDt8c3uUGtL05l9mFPNeX7znVb6K/f7hAXfe16yY3myURwOS3WuxBX2+IAppO1/xE7lR1H8cpLjuRKKwGpVGfcCzLmcgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974749; c=relaxed/simple;
	bh=isJRYgHxU3ZQEttWWsxaLVzmrb2M1BTo3KcQYugq81o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJW+NUQZY/CzaGYclHKmDwOfuyxoYbg2nJlxkTaxDfewzf07gCG0kXDftUdiKlnnHvJGYkLPAS/lKQB7BUsJ19d2E5L3Z0xaTQXB3wFSOMs5eR+0DyOuyzpBmiCFtTZGZIl1B72AubYIkzMgmPpFOXidNEI+IKbq0RVByOxPfkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBQ642V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBQ642V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7EDC2BCF7;
	Tue,  5 May 2026 09:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974749;
	bh=isJRYgHxU3ZQEttWWsxaLVzmrb2M1BTo3KcQYugq81o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBQ642V1y+a/UJOfjCSQA2rkWC1fUl8rxPps6X6MbxDhdVh2kp6UO3ZTXPVuCHf0+
	 8Pnny9DRhf/0n2CiJmg+aMTW8p70lbcVeppqTPIKdEZSeQcHv+TTMU8yD1I0jOQMln
	 cndHA66nT2+uX8SzneFUDc2DApPN4PAoPGBH1GIIv10dddJhWn3Qkw23RMtr1qC8CA
	 EBQ4q/W29VqLCJ1TAuMLrGXSogV9uL27CkMMgPm5Qz8QMdFM8ijqw7bhuzKiYStf3k
	 LybQBnjAF+EUuYV7BpdQz19ufjMzYNH7/mLv+etPDYrvgmW07+CgC63e06mFQgOGYw
	 kgMtWYVEj0RfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alistair Francis <alistair.francis@wdc.com>,
	Chris Leech <cleech@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] nvmet-tcp: Don't clear tls_key when freeing sq
Date: Tue,  5 May 2026 05:51:28 -0400
Message-ID: <20260505095149.512052-12-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 5fc422951c962cc01e654950fc043ebd8fadd865 ]

Curently after the host sends a REPLACETLSPSK we free the TLS keys as
part of calling nvmet_auth_sq_free() on success. This means when the
host sends a follow up REPLACETLSPSK we return CONCAT_MISMATCH as the
check for !nvmet_queue_tls_keyid(req->sq) fails.

A previous attempt to fix this involed not calling nvmet_auth_sq_free()
on successful connections, but that results in memory leaks. Instead we
should not clear `tls_key` in nvmet_auth_sq_free(), as that was
incorrectly wiping the tls keys which are used for the session.

This patch ensures we correctly free the ephemeral session key on
connection, yet we don't free the TLS key unless closing the connection.

Reviewed-by: Chris Leech <cleech@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem `nvmet-tcp` / NVMe target TCP; action verb
“Don’t clear”; intent is to stop `nvmet_auth_sq_free()` from wiping
`sq->tls_key` during authentication cleanup.

Step 1.2 Record: tags in upstream commit `5fc422951c962`: `Reviewed-by:
Chris Leech <cleech@redhat.com>`, `Reviewed-by: Hannes Reinecke
<hare@suse.de>`, `Signed-off-by: Alistair Francis
<alistair.francis@wdc.com>`, `Signed-off-by: Keith Busch
<kbusch@kernel.org>`. No `Fixes:`, no `Reported-by:`, no `Cc: stable`.

Step 1.3 Record: the described bug is deterministic: after a host sends
`REPLACETLSPSK`, successful auth cleanup calls `nvmet_auth_sq_free()`,
which clears `sq->tls_key`; a later `REPLACETLSPSK` then fails the
`!nvmet_queue_tls_keyid(req->sq)` check and returns `CONCAT_MISMATCH`.
The commit also states the earlier approach of not calling
`nvmet_auth_sq_free()` leaked memory.

Step 1.4 Record: this is not a hidden cleanup; it is an explicit
correctness fix for broken TLS PSK replacement and for preserving the
key until connection close.

## Phase 2: Diff Analysis

Step 2.1 Record: one file changed, `drivers/nvme/target/auth.c`;
upstream diff is 3 deletions. Modified function: `nvmet_auth_sq_free()`.
Scope: single-file surgical fix.

Step 2.2 Record: before, `nvmet_auth_sq_free()` canceled auth timeout
work, cleared `sq->tls_key`, then freed DH-CHAP ephemeral buffers.
After, it still cancels work and frees `dhchap_c1`, `dhchap_c2`, and
`dhchap_skey`, but no longer clears the TCP TLS key.

Step 2.3 Record: bug category is logic/resource lifetime.
`nvmet_tcp_tls_key_lookup()` stores a key from `nvme_tls_key_lookup()`
into `queue->nvme_sq.tls_key`; `key_lookup()` increments the key
refcount. `nvmet_sq_put_tls_key()` later does `key_put()` only if
`sq->tls_key` is still set. Clearing the pointer in
`nvmet_auth_sq_free()` both breaks later `REPLACETLSPSK` validation and
prevents the normal close path from seeing the key pointer.

Step 2.4 Record: fix quality is high. The patch removes only incorrect
ownership cleanup from the per-auth cleanup helper. Regression risk is
low because the verified TCP queue release path calls
`nvmet_sq_put_tls_key()` before `nvmet_sq_destroy()`, and non-TCP
transports do not populate `sq->tls_key`.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` on the changed area shows `sq->tls_key`
handling was introduced by `fa2e0f8bbc689` (“nvmet-tcp: support secure
channel concatenation”), first contained at `v6.15-rc1~166^2^2~13`;
`sq->tls_key = NULL` was later style-adjusted by `b1efcc470eb30`. The
older `nvmet_auth_sq_free()` DH-CHAP cleanup itself dates to the
original auth code around v6.0, but the TLS-specific bug begins with
`fa2e0f8bbc689`.

Step 3.2 Record: no `Fixes:` tag is present. I manually inspected the
likely introducing commit `fa2e0f8bbc689`, which added secure channel
concatenation, `sq->tls_key`, `nvmet_queue_tls_keyid()`,
`nvmet_sq_put_tls_key()`, and the clear in `nvmet_auth_sq_free()`.

Step 3.3 Record: recent related upstream history includes
`2e6eb6b277f59` (“Don’t free SQ on authentication success”),
`f920ebd03cd13` reverting that due to leaks, and this commit
`5fc422951c962`. This commit was submitted as patch 2/2 after the
revert. On the checked stable branches, `2e6eb6b277f59` is not an
ancestor, so this patch can apply standalone there.

Step 3.4 Record: Alistair Francis has multiple recent NVMe target
auth/TLS commits in this subsystem, including `ecf4d2d883515`,
`2e6eb6b277f59`, `f920ebd03cd13`, `5fc422951c962`, and `5d10069e1a169`.

Step 3.5 Record: dependencies are minimal. The patch depends on
`sq->tls_key` and `nvmet_auth_sq_free()` existing, which local stable
refs show in `6.15.y` and newer. If a target stable tree had already
taken `2e6eb6b277f59`, then the paired revert `f920ebd03cd13` would also
be needed; in the local stable refs checked, that prerequisite is not
needed.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c 5fc422951c962...` found the original
submission at `https://patch.msgid.link/20260417004809.2894745-2-
alistair.francis@wdc.com`. `b4 dig -a` found only a v1 two-patch series.
The committed version is the reviewed/applied version.

Step 4.2 Record: `b4 dig -w` showed the patch was sent to the expected
NVMe/block audience: Hannes Reinecke, Christoph Hellwig, Sagi Grimberg,
Chaitanya Kulkarni, Keith Busch, linux-nvme, linux-block, linux-kernel,
Yi Zhang, Maurizio Lombardi, and Shinichiro Kawasaki. Lore replies show
`Reviewed-by` from Hannes Reinecke and Chris Leech, and Keith Busch
replied that patches 1 and 2 were applied to `nvme-7.1`.

Step 4.3 Record: no direct bug-report link is in this commit. The paired
revert references a kmemleak report from Yi Zhang during blktests
(`nvme/041`, `nvme/042`, `nvme/043`, `nvme/044`, `nvme/045`, `nvme/051`,
`nvme/052`), confirming the earlier “don’t call cleanup” approach leaked
DH-CHAP allocations.

Step 4.4 Record: series context is important: patch 1 reverts the
earlier workaround that skipped `nvmet_auth_sq_free()` on success; patch
2, this commit, fixes the root cause by keeping cleanup but no longer
clearing `tls_key`.

Step 4.5 Record: stable-specific web search through
`lore.kernel.org/stable` was blocked by Anubis; the `yhbt.net` stable
path returned 404. I found an AUTOSEL posting for the earlier
`2e6eb6b277f59` workaround, but did not use that as selection evidence.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified function is `nvmet_auth_sq_free()`.

Step 5.2 Record: callers found by `rg`: `nvmet_execute_auth_send()`,
`nvmet_execute_auth_receive()`, and `nvmet_sq_destroy()`. Auth
send/receive are assigned as handlers for `nvme_fabrics_type_auth_send`
and `nvme_fabrics_type_auth_receive` in `fabrics-cmd.c`.

Step 5.3 Record: key callees around the affected flow include
`nvmet_queue_tls_keyid()`, `nvmet_auth_insert_psk()`,
`nvmet_tcp_tls_key_lookup()`, `nvme_tls_key_lookup()`, `key_lookup()`,
`nvmet_sq_put_tls_key()`, and `key_put()`.

Step 5.4 Record: reachability is verified through the NVMe/TCP receive
path: `nvmet_tcp_done_recv_pdu()` initializes a request, assigns/uses
the fabrics auth execute handler, and runs `req->execute()`. This is
reachable to an NVMe-oF host using target auth/TLS, not a theoretical
internal path.

Step 5.5 Record: similar lifetime pattern found: the only proper TCP TLS
SQ key release helper is `nvmet_sq_put_tls_key()`, called from
`nvmet_tcp_release_queue_work()`. `nvmet_auth_sq_free()` is a DH-CHAP
ephemeral cleanup helper and should not own the TLS key.

## Phase 6: Cross-Referencing And Stable Tree Analysis

Step 6.1 Record: local stable refs show `sq->tls_key = NULL` in
`nvmet_auth_sq_free()` exists in `stable/linux-6.15.y`, `6.16.y`,
`6.17.y`, `6.18.y`, `6.19.y`, and `7.0.y`; it is absent from `6.14.y`,
`6.13.y`, `6.12.y`, `6.6.y`, and `6.1.y`.

Step 6.2 Record: `git apply --check` of the candidate patch succeeds on
local `stable/linux-6.15.y` through `stable/linux-7.0.y`, and fails on
`6.14.y` because the buggy TLS key clearing code is not there. Expected
backport difficulty: clean for affected local refs.

Step 6.3 Record: bounded related-history searches found no existing
equivalent fix in `stable/linux-7.0.y`. Upstream has the earlier
attempted fix `2e6eb6b277f59`, its revert `f920ebd03cd13`, and this
final fix.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: subsystem is NVMe target over TCP, with authentication
and TLS secure channel concatenation. Criticality: IMPORTANT, because it
affects networked storage authentication/TLS behavior, though not a
universal core-kernel path.

Step 7.2 Record: subsystem is active. Recent history in
`drivers/nvme/target` includes multiple auth/TLS fixes and refactors,
including secure concatenation support and follow-up fixes through the
6.15 to 7.1 development window.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: affected users are systems using NVMe target TCP with
`CONFIG_NVME_TARGET_AUTH` and `CONFIG_NVME_TARGET_TCP_TLS`, specifically
secure channel concatenation / TLS PSK replacement.

Step 8.2 Record: trigger is a host sending a follow-up `REPLACETLSPSK`
after successful authentication on a TLS-enabled admin queue. The
failure is deterministic from the verified code path. I did not verify
that an unprivileged local user can trigger it; this is a
remote/protocol operation by an NVMe host with access to the target.

Step 8.3 Record: failure mode is protocol/authentication failure with
`CONCAT_MISMATCH`, breaking TLS PSK replacement/key rotation.
Additionally, because `key_lookup()` increments the key refcount and the
close path only `key_put()`s if `sq->tls_key` remains set, clearing the
pointer early risks leaking the key reference. Severity: HIGH for
affected NVMe/TCP secure-channel users; not a crash/data-corruption fix.

Step 8.4 Record: benefit is high for affected users because it fixes a
broken authenticated TLS key replacement flow and restores the verified
close-time key release path. Risk is very low: 3 deleted lines, no new
API, no new feature, no locking changes, no cross-subsystem behavior
change.

## Phase 9: Final Synthesis

Step 9.1 Record: evidence for backporting: real deterministic protocol
failure; possible key-ref lifetime leak; tiny one-function patch;
reviewed by relevant NVMe/TLS people; applied by NVMe maintainer;
cleanly applies to affected stable refs; affects released stable
branches from 6.15.y onward. Evidence against: affects a relatively
specialized NVMe/TCP TLS configuration and needs no backport before
6.15.y. Unresolved: I could not access `lore.kernel.org/stable` directly
due Anubis, and I did not run runtime blktests.

Step 9.2 Stable rules checklist: obviously correct and reviewed: yes.
Fixes a real bug: yes. Important issue: yes for NVMe/TCP TLS key
replacement and key lifetime. Small and contained: yes, 3 deleted lines
in one function. No new features/APIs: yes. Applies to stable trees: yes
for local `6.15.y` through `7.0.y`; not applicable to older checked
branches.

Step 9.3 Exception category: not a device ID, quirk, DT, build, or
documentation exception.

Step 9.4 Decision: backport to stable trees that contain `fa2e0f8bbc689`
/ the `sq->tls_key` clearing code, namely local refs `6.15.y` and newer.
Do not apply to older trees where the code is absent. If a target branch
contains the earlier workaround `2e6eb6b277f59`, include/reconcile the
paired revert `f920ebd03cd13`; otherwise this commit stands alone.

## Verification

- Phase 1: Found upstream commit `5fc422951c962` with `git log
  origin/master --grep`.
- Phase 1: Parsed commit tags from `git show --format=fuller --stat
  --patch 5fc422951c962`.
- Phase 2: Verified the diff removes only the
  `CONFIG_NVME_TARGET_TCP_TLS` block clearing `sq->tls_key`.
- Phase 2: Verified `nvmet_queue_tls_keyid()` returns 0 when
  `sq->tls_key` is NULL.
- Phase 2: Verified `REPLACETLSPSK` returns `CONCAT_MISMATCH` when
  `nvmet_queue_tls_keyid(req->sq)` is false.
- Phase 2: Verified `nvmet_sq_put_tls_key()` calls `key_put()` and NULLs
  the key on TCP queue release.
- Phase 2: Verified `nvme_tls_key_lookup()` uses `key_lookup()`, and
  `key_lookup()` increments the key refcount.
- Phase 3: Ran `git blame` on `auth.c`; TLS key clearing originates from
  `fa2e0f8bbc689`/`b1efcc470eb30`.
- Phase 3: Ran `git describe --contains fa2e0f8bbc689`; first contained
  at `v6.15-rc1`.
- Phase 3: Inspected `fa2e0f8bbc689`, `b1efcc470eb30`, `2e6eb6b277f59`,
  `f920ebd03cd13`, and `ecf4d2d883515`.
- Phase 4: Ran `b4 dig -c`, `b4 dig -a`, and `b4 dig -w`; found v1 two-
  patch lore series and recipient list.
- Phase 4: Fetched lore mirror thread; verified Hannes Reinecke and
  Chris Leech reviewed, Keith Busch applied patches 1 and 2.
- Phase 4: Fetched Yi Zhang kmemleak report linked by the paired revert.
- Phase 5: Used `rg` and file reads to trace auth command handlers, TCP
  receive execution, TLS key lookup, and queue release.
- Phase 6: Checked local stable refs with scripted `git show`; buggy
  code exists in `6.15.y` through `7.0.y`, absent in older checked
  stable refs.
- Phase 6: Ran `git apply --check` against local stable worktrees; clean
  for `6.15.y` through `7.0.y`, not applicable to `6.14.y`.
- Phase 7: Reviewed recent `drivers/nvme/target` history showing active
  auth/TLS development.
- Phase 8: Verified trigger and failure path from
  `nvmet_auth_negotiate()` and auth send/receive call flow.
- Unverified: no runtime blktests were run.
- Unverified: direct `lore.kernel.org/stable` search was blocked by
  Anubis; the mirror stable search path returned 404.

**YES**

 drivers/nvme/target/auth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 2eadeb7e06f26..3a905124afdee 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -239,9 +239,6 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq)
 void nvmet_auth_sq_free(struct nvmet_sq *sq)
 {
 	cancel_delayed_work(&sq->auth_expired_work);
-#ifdef CONFIG_NVME_TARGET_TCP_TLS
-	sq->tls_key = NULL;
-#endif
 	kfree(sq->dhchap_c1);
 	sq->dhchap_c1 = NULL;
 	kfree(sq->dhchap_c2);
-- 
2.53.0

