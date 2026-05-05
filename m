Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DA0311975;
	Tue,  5 May 2026 09:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974716; cv=none; b=AzsrfOiU/XTA8PYp40tJ0rro1xz2q6r699W64PNKTy+Zoc0S5hZGMOB8zW+uVgnZ20lDZ84ycKpsgm3D/bECLXp+ZkTJLl+CZp6JlGhgnTeRaZnS88HrBzSwWaW7Ewg0Mjpxa9ZCT0RbSy3leY5kMrJp0ly8zSZKr2sgQtEi+D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974716; c=relaxed/simple;
	bh=rI1L3zFgAgB2+saSnTw+RFFHvhlWHtqJK38Mjq1Q+uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQF821vdpas1/WoQi6SL9ccgR6069xHMdTZ4wkmVhO4GKVWrTUUnZRPA/x931iTSbqoiUSfXR9UoTE8gUj8fbY7Ih/ikgWviX0BjudCediMhto5usSaeNyXqi7PczHpTd5/0K5RDtrPgMvgyC8hc33k3VJ1vzRMrBE28RHgcnR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwEnAlye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwEnAlye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCF5C2BCB4;
	Tue,  5 May 2026 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974716;
	bh=rI1L3zFgAgB2+saSnTw+RFFHvhlWHtqJK38Mjq1Q+uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwEnAlye4PYESOe0YjMdcItl9hj/lj5SEEX1VmDBJIVJDa57UItR67ylEW9K7v0Fa
	 VCKGe2WASseIxS2cIlPRR/yYUYP5ffz8oOIl5jhUhwI3Td8vJ0/MqQi3OgBBJdq13e
	 C0Q8Y43KRqcRRiKLo9mx7ghWI4ea0yOZSDkte149nVOCDnCyeBDfq8Lw48OIXZxMu+
	 0yqhLBMscejCUsRp9UdEmP7eEiuNe/b6Eoz2IP/VNkYtoMMkm1bgFVtnfBQwojLlpr
	 ZJL9WWq2lQBlSt+cooAGrSoaEMRvr6kfAbMGDZ6L1Gt3/YkGsUl1YSDMHM2Kke/64N
	 /5A4f8q2pC0nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shivam Kumar <kumar.shivam43666@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] nvmet-tcp: check INIT_FAILED before nvmet_req_uninit in digest error path
Date: Tue,  5 May 2026 05:51:18 -0400
Message-ID: <20260505095149.512052-2-sashal@kernel.org>
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

From: Shivam Kumar <kumar.shivam43666@gmail.com>

[ Upstream commit 4606467a75cfc16721937272ed29462a750b60c8 ]

In nvmet_tcp_try_recv_ddgst(), when a data digest mismatch is detected,
nvmet_req_uninit() is called unconditionally. However, if the command
arrived via the nvmet_tcp_handle_req_failure() path, nvmet_req_init()
had returned false and percpu_ref_tryget_live() was never executed. The
unconditional percpu_ref_put() inside nvmet_req_uninit() then causes a
refcount underflow, leading to a WARNING in
percpu_ref_switch_to_atomic_rcu, a use-after-free diagnostic, and
eventually a permanent workqueue deadlock.

Check cmd->flags & NVMET_TCP_F_INIT_FAILED before calling
nvmet_req_uninit(), matching the existing pattern in
nvmet_tcp_execute_request().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
Phase 1 Record:
Subject subsystem/action is `nvmet-tcp`, action `check`, intent: avoid
calling `nvmet_req_uninit()` after failed request initialization in the
data-digest error path. Tags found: `Reviewed-by: Christoph Hellwig
<hch@lst.de>`, `Signed-off-by: Shivam Kumar`, `Signed-off-by: Keith
Busch`. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable` tag in the committed version I verified. The body describes a
real refcount bug: `nvmet_req_init()` can fail before
`percpu_ref_tryget_live()`, while `nvmet_req_uninit()` always does
`percpu_ref_put()`. Hidden bug fix: yes, it prevents refcount underflow,
UAF diagnostics, and a workqueue deadlock.

Phase 2 Record:
One file changed: `drivers/nvme/target/tcp.c`, 2 insertions and 1
deletion, only in `nvmet_tcp_try_recv_ddgst()`. Before: a data digest
mismatch always called `nvmet_req_uninit(&cmd->req)`. After: it skips
that call when `cmd->flags & NVMET_TCP_F_INIT_FAILED`. Bug category:
reference-counting bug with severe follow-on failure. Fix quality:
small, surgical, matches the existing `nvmet_tcp_execute_request()`
handling of `NVMET_TCP_F_INIT_FAILED`; regression risk is very low
because it only suppresses an invalid put on a command whose init
failed.

Phase 3 Record:
`git blame` showed the current direct `nvmet_req_uninit()` line came
from `0700542a823b` (`nvmet-tcp: remove nvmet_tcp_finish_cmd`), but
older stable trees had the same underlying behavior through
`nvmet_tcp_finish_cmd()`. `git describe --contains` places the original
nvmet-tcp code at `v5.0-rc1` and the direct-inline refactor at
`v6.1-rc1`. The init-failure flag and execute-path guard were already
present in stable versions I checked. Recent history contains other
nvmet-tcp fixes, but `git apply --check` confirmed this candidate
applies to the current 7.0.y tree without prerequisites. Author has at
least one other nvmet target fix in the local history; review/commit
path is stronger signal here than author history.

Phase 4 Record:
`b4 dig -c 4606467a75cfc` found the original lore submission at `https:/
/patch.msgid.link/20260318225658.1760759-1-kumar.shivam43666@gmail.com`.
`b4 dig -a` showed only v1, no superseding revision. `b4 dig -w` showed
recipients included `gregkh`, `security@kernel.org`, Christoph Hellwig,
Sagi Grimberg, Keith Busch, and `linux-nvme`. The infradead archive copy
matched the diff exactly. Christoph replied “Looks good to me” and gave
`Reviewed-by`, while noting he would prefer someone more familiar with
TCP code also look. I found no NAK. A stable lore query via `WebFetch`
was blocked by Anubis; web search did not reveal separate stable-
specific discussion.

Phase 5 Record:
Modified function: `nvmet_tcp_try_recv_ddgst()`. Call chain verified
locally: socket callbacks queue `nvmet_tcp_io_work()`, which calls
`nvmet_tcp_try_recv()`, then `nvmet_tcp_try_recv_one()`, then
`nvmet_tcp_try_recv_ddgst()` when `rcv_state == NVMET_TCP_RECV_DDGST`.
The failing path is reachable by NVMe/TCP target receive processing when
data digest is enabled and a write command with failed
`nvmet_req_init()` still has inline data to drain. Callees verified:
`nvmet_req_uninit()` unconditionally calls
`percpu_ref_put(&req->sq->ref)`, and `nvmet_req_init()` only takes that
ref after earlier validation and parsing succeeds.

Phase 6 Record:
Stable-code checks show the vulnerable pattern exists in `v5.4`,
`v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.18`, `v6.19`, and `v7.0`,
though `v5.x` uses `nvmet_tcp_finish_cmd()` so those trees need a small
backport adjustment. For `v6.1+`, the same flag, execute-path guard, and
unconditional digest-error uninit pattern are present. Current 7.0.y
accepts the candidate patch with `git apply --check`.

Phase 7 Record:
Subsystem is NVMe target over TCP: storage/network transport driver,
important for systems exporting NVMe-oF targets. Activity level is
active; recent local `block-next` history includes several nvmet-tcp
fixes around the same file.

Phase 8 Record:
Affected users are systems running `nvmet-tcp` targets with data digest
enabled. Trigger requires a command init failure path plus later data
digest mismatch while stale write data is being drained, so not
universal, but reachable through remote NVMe/TCP protocol traffic.
Failure mode is high to critical: verified commit text and code
mechanism support refcount underflow from unmatched `percpu_ref_put()`,
with reported consequences of warning, UAF diagnostic, and permanent
workqueue deadlock. Benefit is high for affected targets; risk is very
low due to a two-line guard on an error path.

Phase 9 Record:
Evidence for backporting: real refcounting bug, severe hang/deadlock
failure mode, small fix, reviewed by Christoph Hellwig, applies cleanly
to 7.0.y, and the vulnerable pattern exists across active stable lines.
Evidence against: no `Fixes:`/`Cc: stable`/`Reported-by`, no `Tested-
by`, local `master` did not contain the commit while `block-next` did,
and `v5.x` needs an adjusted backport around `nvmet_tcp_finish_cmd()`.
Stable checklist: obviously correct yes; fixes a real bug yes; important
issue yes; small and contained yes; no new feature/API yes; applies
cleanly to 7.0.y and likely minor/manual adjustment for older stable
trees.

## Problem And Stable Value
The commit prevents `nvmet_req_uninit()` from dropping a request
reference that was never acquired. The code verifies that
`nvmet_req_init()` only does `percpu_ref_tryget_live()` after
validation/parsing succeeds, while `nvmet_req_uninit()` always calls
`percpu_ref_put()`. On the `NVMET_TCP_F_INIT_FAILED` path, calling
uninit is therefore invalid.

This matters for stable because the failure is not cosmetic: the
described and mechanically verified outcome is refcount underflow, with
potential UAF diagnostics and permanent workqueue deadlock in an
NVMe/TCP target. The change is as small as this kind of fix gets and
mirrors an existing guard in the same driver.

## Risk / Benefit
Benefit is high for affected NVMe/TCP target deployments, especially
because a transport-level bad digest/error path should not be able to
wedge the target workqueue. Risk is very low: it changes only an error
path and only skips cleanup that is invalid when init failed. Buffer
cleanup and fatal error handling still run.

## Verification
- Phase 1: `git show 4606467a75cfc` verified commit message, tags,
  author, committer, and exact diff.
- Phase 2: Diff analysis verified only `drivers/nvme/target/tcp.c`
  changes, 2 insertions/1 deletion in `nvmet_tcp_try_recv_ddgst()`.
- Phase 3: `git blame` verified the direct uninit line came from
  `0700542a823b`; `git show 0700542a823b` verified it was a helper
  removal preserving the same uninit/free behavior.
- Phase 3: `git describe --contains` verified relevant code ancestry:
  original nvmet-tcp code in `v5.0-rc1`, direct inline refactor in
  `v6.1-rc1`.
- Phase 4: `b4 dig -c 4606467a75cfc`, `-a`, and `-w` verified lore
  match, single v1 revision, and original recipients.
- Phase 4: WebFetch of infradead patch and reply verified patch contents
  and Christoph Hellwig’s Reviewed-by plus caveat.
- Phase 5: `rg` and file reads verified the receive call chain and
  `nvmet_req_init()`/`nvmet_req_uninit()` reference behavior.
- Phase 6: Stable tag checks verified vulnerable patterns in `v5.4`,
  `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.18`, `v6.19`, and
  `v7.0`.
- Phase 6: `git apply --check` verified the candidate patch applies to
  the current 7.0.y tree.
- Unverified: I could not verify a separate stable-mailing-list
  discussion because the lore stable query was blocked by Anubis.

**YES**

 drivers/nvme/target/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index acc71a26733f9..a456dd2fd8bd1 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1310,7 +1310,8 @@ static int nvmet_tcp_try_recv_ddgst(struct nvmet_tcp_queue *queue)
 			queue->idx, cmd->req.cmd->common.command_id,
 			queue->pdu.cmd.hdr.type, le32_to_cpu(cmd->recv_ddgst),
 			le32_to_cpu(cmd->exp_ddgst));
-		nvmet_req_uninit(&cmd->req);
+		if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED))
+			nvmet_req_uninit(&cmd->req);
 		nvmet_tcp_free_cmd_buffers(cmd);
 		nvmet_tcp_fatal_error(queue);
 		ret = -EPROTO;
-- 
2.53.0

