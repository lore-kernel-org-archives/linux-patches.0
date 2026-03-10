Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCD43CEC5;
	Tue, 10 Mar 2026 09:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133311; cv=none; b=gBj1ILJDvYJXILl1WyPAihVU9NJlliJOpS+oWPf0xDVYA8pSiUgRr8GGKaFiDM3EuNIXB5T7GDxgYZvm+QLB4jcedhBk8/BQZ2njkDAVC0TToPaMqs+KlCHa0Wcvtw830SGnTOhVtuiUA4XO5uYlJqfzwQhAOM3G9LJ/n2mhrWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133311; c=relaxed/simple;
	bh=+cfoQq3+yYX+oAMEWpnY6cOB2jPh6FRS3epwT+PJtnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3F6b7HWUrRZwtq4buoos/5WYOXfMJzThCEGKV5rIpm8vp0vUftIPaghgFbDRX7GDCz5kA+r+cO0AhrY27vGuzl6o/wNXQuSdRhGs0MDCElMDwyBBQ5+8uYdTVH3WhJmXR31FYO0AGDN0C/Pk9x5ZbGj1r/TfGstKWI3T0S9oxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRm+MzK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRm+MzK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BFCC2BC86;
	Tue, 10 Mar 2026 09:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133311;
	bh=+cfoQq3+yYX+oAMEWpnY6cOB2jPh6FRS3epwT+PJtnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRm+MzK2Bk1QogcEFc+R8MqOedfdKMYmEkDWnfqJXCNQP0gaSy+dqImOVH9jW6tqk
	 MgV3SG2OPNsastzRvs6iX3s/MiTl4fw/VDPr22WJahU0Z/Jl26yfaYQn/eKIPlGobV
	 3gKdyIaDUeVNKm/teB8/U4G4amVA0dIu6vg1NlReNWwiQQ/xo2RZjvB5LnSUxYrrME
	 1naRkSPIYyGe/Ocns8Q93pzNk4o4pAMvRhCvTwNstvmbG3whUG003QT0Ryj07QngQM
	 sX8kBheiTYkjf68RL6xBF+BlSyyh476zMLz+NJNOJrP67eDPSOCZkeLkSILAyAzKVQ
	 7VofanJr10Ctg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] nvme-pci: ensure we're polling a polled queue
Date: Tue, 10 Mar 2026 05:01:03 -0400
Message-ID: <20260310090145.2709021-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 166e31d7dbf6aa44829b98aa446bda5c9580f12a ]

A user can change the polled queue count at run time. There's a brief
window during a reset where a hipri task may try to poll that queue
before the block layer has updated the queue maps, which would race with
the now interrupt driven queue and may cause double completions.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for my analysis.

## Analysis

### 1. Commit Message Analysis

The commit message clearly describes a **race condition** that can cause
**double completions**:
- A user can change the polled queue count at runtime
- During a controller reset, there's a window where a hipri task may
  poll a queue that has transitioned from polled to interrupt-driven
- Both the polling path and the interrupt handler could complete the
  same I/O, causing double completions

Double completions in the block layer are a serious bug — they can lead
to use-after-free (the request is freed after the first completion, then
accessed again during the second completion), data corruption, or kernel
crashes.

### 2. Code Change Analysis

The fix is minimal — a single additional check in `nvme_poll()`:

```c
- if (!nvme_cqe_pending(nvmeq))
+       if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+           !nvme_cqe_pending(nvmeq))
                return 0;
```

Before polling the completion queue, verify the queue is actually still
a polled queue via `test_bit(NVMEQ_POLLED, ...)`. If the queue has
transitioned to interrupt-driven mode (the NVMEQ_POLLED bit was cleared
in `nvme_suspend_queue()`), skip the poll and return 0.

This is a 2-line change in a single file. The risk of regression is
extremely low.

### 3. Classification

- **Race condition fix** — prevents concurrent polling and interrupt-
  driven completion of the same queue
- **Prevents double completions** — which are a serious kernel bug
  (potential UAF, crashes)
- Authored by Keith Busch (NVMe maintainer), reviewed by Christoph
  Hellwig and Kanchan Joshi

### 4. Scope and Risk

- **1 file changed, 2 insertions, 1 deletion** — extremely small and
  contained
- The added check is a fast bit test that simply returns early if the
  queue isn't polled
- No functional changes to the normal code path — polled queues still
  poll as before
- Only affects the edge case of runtime queue configuration changes

### 5. Dependencies

The `NVMEQ_POLLED` flag has existed since kernel v5.2 (commit
7c349dde26b7, March 2019). The `test_bit(NVMEQ_POLLED, ...)` pattern is
already used elsewhere in the same file (e.g., `nvme_poll_irqdisable()`,
`nvme_suspend_queue()`). This fix is fully self-contained and applies
cleanly without any prerequisites.

The commit appears alongside two related commits (`44b798a6fd680` "cap
queue creation" and `02bfc966463a7` "do not try to add queue maps at
runtime"), but this fix is independent — it guards against an already-
existing race in `nvme_poll()` regardless of the other changes.

### 6. User Impact

NVMe is one of the most widely used storage interfaces in modern
systems. Any system using polled I/O queues (common for high-performance
storage workloads) and changing queue configuration at runtime could hit
this race. Double completions can cause kernel panics, data corruption,
or use-after-free.

### Verification

- Verified upstream commit is `166e31d7dbf6` which appeared in
  `v7.0-rc3`
- Confirmed `NVMEQ_POLLED` flag was introduced in commit `7c349dde26b7`
  (v5.2), so it exists in all current stable trees
- Confirmed the fix is a 2-line change modifying only
  `drivers/nvme/host/pci.c`
- Confirmed the code pattern (`test_bit(NVMEQ_POLLED, ...)`) is already
  used elsewhere in the same file, particularly in
  `nvme_poll_irqdisable()` at line 1631
- Verified the commit is reviewed by Christoph Hellwig and Kanchan Joshi
- Confirmed the fix is self-contained — no dependency on the two
  companion commits

### Conclusion

This is a textbook stable backport candidate: a tiny, surgical fix for a
race condition that can cause double completions (potential UAF/crash),
in a critical subsystem (NVMe storage), authored and reviewed by
subsystem maintainers, with zero risk of regression.

**YES**

 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 74aca8846fffe..3f4af341474e1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1499,7 +1499,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0

