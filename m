Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202D3AE1A2;
	Tue, 17 Mar 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747186; cv=none; b=oPV0ZwvUzjUHc76loHBx6YSFo/2W4eV1V+fMwZXjt6SN1yatPPoFZmXwVI9mzmofr5LjVwt+5oxz9klvaxUGGNVLcXHGhhDtVcB25W3OFr9tFO9q6UOIPsUCYRacJoehXAVaSrPFWslfBSBt2IL2NrAsv84DEav/veZjHNz9aJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747186; c=relaxed/simple;
	bh=iUe5MH6DGp3rJV14U0Y5iVvgGFfkm2WLp8a6OaIr0N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgrZSr+7FL/7S5W4K3QgSxdVx1Y+cw2pl81vdIx8lwDvDo4hVqcR46GolYcNr8oShupF71/GJ9kblWA5TXQTd2Ed+DrwotaMcMJRgJiTPis6/eutwCG0ZSVIVp5rI97dHVPdl/PJ73U42LpXtLFvORG9cnAPL6dL/UPKRWVY3is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bv77rShU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bv77rShU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC24C2BCAF;
	Tue, 17 Mar 2026 11:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747186;
	bh=iUe5MH6DGp3rJV14U0Y5iVvgGFfkm2WLp8a6OaIr0N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bv77rShUsCZoaRkq2k9iI3PgqBOxkPvb++AYY1PdE/sbNvbh0m6MJKgVwc+0HsnwV
	 8sZMkSAovepaGSCi27rFIa3KSyIhGNpEtuwy6DtVCUgrbHJLK9+AZQJsA6DaDQC+kH
	 x+v1tBYz6HRkUdn4EaKlgIX9XCbLLVxNPhfSY5g+4ICb9bK13D6jGXq2eESXp3DOSR
	 yNWvWL2XArhCwk91SaE2Pe+SeicLh7+WxA4tjar0d0aJoOx/AYULiZck7UDAutyBFf
	 PJ68D9lmAGJdbC1P9YIHa3ZXlfBzg5Q9pI5sU+MpEeSoiAxK7BWQunw86TEP8hvX6w
	 KMGqBf5FoXclw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: zhidao su <soolaugust@gmail.com>,
	zhidao su <suzhidao@xiaomi.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] sched_ext: Use WRITE_ONCE() for the write side of dsq->seq update
Date: Tue, 17 Mar 2026 07:32:43 -0400
Message-ID: <20260317113249.117771-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: zhidao su <soolaugust@gmail.com>

[ Upstream commit 7a8464555d2e5f038758bb19e72ab4710b79e9cd ]

bpf_iter_scx_dsq_new() reads dsq->seq via READ_ONCE() without holding
any lock, making dsq->seq a lock-free concurrently accessed variable.
However, dispatch_enqueue(), the sole writer of dsq->seq, uses a plain
increment without the matching WRITE_ONCE() on the write side:

    dsq->seq++;
    ^^^^^^^^^^^
    plain write -- KCSAN data race

The KCSAN documentation requires that if one accessor uses READ_ONCE()
or WRITE_ONCE() on a variable to annotate lock-free access, all other
accesses must also use the appropriate accessor. A plain write leaves
the pair incomplete and will trigger KCSAN warnings.

Fix by using WRITE_ONCE() for the write side of the update:

    WRITE_ONCE(dsq->seq, dsq->seq + 1);

This is consistent with bpf_iter_scx_dsq_new() and makes the
concurrent access annotation complete and KCSAN-clean.

Signed-off-by: zhidao su <suzhidao@xiaomi.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need for the analysis.

## Analysis

### 1. Commit Message Analysis

The commit fixes a KCSAN data race annotation issue. `dsq->seq` is read
lock-free via `READ_ONCE()` in `bpf_iter_scx_dsq_new()` (line 6589), but
the write side in `dispatch_enqueue()` uses a plain `dsq->seq++` (line
1100). KCSAN requires that if one side uses
`READ_ONCE()`/`WRITE_ONCE()`, all accessors must also use the
appropriate annotation. The fix is a one-line change from `dsq->seq++`
to `WRITE_ONCE(dsq->seq, dsq->seq + 1)`.

### 2. Code Change Analysis

The change is trivially small and correct:
- **Before**: `dsq->seq++` — plain write, incomplete KCSAN annotation
- **After**: `WRITE_ONCE(dsq->seq, dsq->seq + 1)` — properly annotated
  write

The read side at line 6589 already uses `READ_ONCE(kit->dsq->seq)`,
confirming this is a lock-free concurrent access pattern. The write side
holds a lock (dispatch queue lock), but the reader does not, making the
`WRITE_ONCE()`/`READ_ONCE()` pair necessary for correctness under the
KCSAN/C11 memory model.

### 3. Subsystem: sched_ext

**Critical factor**: `sched_ext` was introduced in **v6.12**. The
current stable kernel trees are:
- 6.12.y (contains sched_ext)
- 6.6.y (does NOT contain sched_ext)
- 6.1.y (does NOT contain sched_ext)
- 5.15.y, 5.10.y, etc. (do NOT contain sched_ext)

This means the commit can only apply to **6.12.y** (and later, 6.19.y
once it becomes a stable tree).

### 4. Bug Severity

This is a KCSAN annotation completeness fix. It:
- Fixes a real data race (writer uses plain store while reader uses
  `READ_ONCE()`)
- Prevents KCSAN warnings
- The practical impact on most architectures (especially x86) is minimal
  since `dsq->seq` is a `u64` and the write is already atomic in
  practice on 64-bit platforms
- However, on some architectures (32-bit), a plain write to a 64-bit
  value could be torn, potentially causing the reader to see a
  partially-updated value

### 5. Risk Assessment

- **One-line change**: Minimal risk
- **Obviously correct**: `WRITE_ONCE()` is the standard annotation for
  this pattern
- **No behavioral change**: Same value is written, just with proper
  annotation
- **Well-tested pattern**: `WRITE_ONCE(x, x + 1)` is used extensively
  throughout the kernel

### 6. Stable Criteria Assessment

- **Fixes a real bug**: Yes — data race (KCSAN violation), and
  potentially a real torn-write issue on 32-bit
- **Obviously correct**: Yes — standard `WRITE_ONCE()` pattern
- **Small and contained**: Yes — one line changed
- **No new features**: Correct
- **Tested**: Accepted by maintainer (Tejun Heo)

While this is a legitimate fix, the severity is quite low. It primarily
silences KCSAN warnings and ensures correctness of the annotation pair.
On 64-bit architectures (where sched_ext is primarily used), the plain
store was already effectively atomic. The practical user impact is
minimal.

### Verification

- Verified `sched_ext` was introduced in v6.12 via `git log --diff-
  filter=A -- kernel/sched/ext.c` (commit `f0e1a0643a59b`)
- Verified no commits to `kernel/sched/ext.c` exist in `v6.10..v6.11`
  range (file didn't exist before 6.12)
- Confirmed `READ_ONCE(kit->dsq->seq)` exists at line 6589 of
  `kernel/sched/ext.c` (the reader)
- Confirmed `dsq->seq++` exists at line 1100 (the writer being fixed)
- The write occurs under a lock (dispatch queue lock held in
  `dispatch_enqueue`), but the read in `bpf_iter_scx_dsq_new()` is lock-
  free
- Verified this is a one-line change with no dependencies

### Decision

This is a valid but low-severity KCSAN data race annotation fix. It's a
one-line change that is obviously correct and fixes a real (if minor)
data race. It only applies to 6.12.y stable since sched_ext doesn't
exist in older trees. The fix is small, surgical, and meets stable
kernel criteria — it prevents KCSAN warnings and ensures proper memory
access semantics for concurrent access to `dsq->seq`.

**YES**

 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 0bb8fa927e9e9..413b9f9336fe9 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1097,7 +1097,7 @@ static void dispatch_enqueue(struct scx_sched *sch, struct scx_dispatch_q *dsq,
 	}
 
 	/* seq records the order tasks are queued, used by BPF DSQ iterator */
-	dsq->seq++;
+	WRITE_ONCE(dsq->seq, dsq->seq + 1);
 	p->scx.dsq_seq = dsq->seq;
 
 	dsq_mod_nr(dsq, 1);
-- 
2.51.0

