Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9983DB33D;
	Wed, 20 May 2026 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276054; cv=none; b=UdsILaTsuWd+xRomR4ceCF9hMIBmpDovB2x4slglzn9Uo0OtwUMEcLIoabpgquYDauosoZdqLt5ijUd8jiCB0y9x4TERhJCMFDK2fcWCWLbk+eXF5ePHyjP7FBhuDfnXgKCWuVYo/296NZRydJpeSt4Wrg92cYgUB7HdawwpuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276054; c=relaxed/simple;
	bh=XhAd41Z06wOuUxDQcx5PGrlK2cE7UQU8eKd6LyGCH2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbrXoNfkK8WlMwHSagNhwAJolwPUFQIqamK2ZdxfdwjgpyjvtlBoq7DVZjuGL2J1hDJgUvEvs4XQQ8NWX9YZSNjXsGt3tPzLIaDyQ8vSnozCjmGtG5lqvyOMAK97BkxuNMKPZXIAHdwBx6ubV/9QASKsIDMd54YM+dh0Qnf4E2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kqu6YLE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kqu6YLE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA201F00894;
	Wed, 20 May 2026 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276052;
	bh=UR8YaLfyNJTK2sII2DsNqJ1PeWNm2h21TvTZ8rrIw3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kqu6YLE2x1tz92HDazdRjYyh2dUd2nTtP8EBlbV6Rq0BiMCKz+Jb6P2Yjkpj4OcUk
	 MWvofruGUUZIM/kTmbaV9ca8TDVMR/CuG8E4/YRYDePOhLsw7aQsAM5bAdAfC8KdT1
	 HMJEBdUJU/brGl5Kf0329YdJhtV5M/k5f1M/pvA1VYHigiO/IVhxoLsc54fq3kk1rO
	 u6lupFfqfezIJMuzzpZj3Y0i+HW++54oyPUUBfhbeOOwqqWMIwrjW2wOOKw19MKGRi
	 cxXo4LccWs5KC8exjpBA8lF5mqoDH63lSJA/SCU09JXAShu4HqG8v7qDrO4Im5rHRe
	 MFl+H0j1tALLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amd/ras: Fix CPER ring debugfs read overflow
Date: Wed, 20 May 2026 07:19:19 -0400
Message-ID: <20260520111944.3424570-47-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 6bbede02dc62a1021aeeae87ab243bd7a93c61d2 ]

The legacy CPER debugfs reader can reach the payload path without a
valid pointer snapshot. The remaining user byte count is also treated as
the ring occupancy in dwords, so reads past the header can copy more than
requested.

Take the CPER lock before sampling pointers. Resample rptr/wptr for
payload reads, bound the payload copy by available dwords and the
remaining user size, and advance the file position for each dword copied.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1e40ef87ffdc291e05ccdade8b9170cc9c1c4249)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Records

Step 1.1 Record: Subsystem `drm/amd/ras`; action verb `Fix`; claimed
intent is preventing CPER ring debugfs read overflow.

Step 1.2 Record: Tags present: `Signed-off-by: Xiang Liu
<xiang.liu@amd.com>`, `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>`,
`Signed-off-by: Alex Deucher <alexander.deucher@amd.com>`, and a cherry-
pick line. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable`.

Step 1.3 Record: Commit body describes two concrete bugs: CPER payload
reads can proceed without a valid rptr/wptr snapshot, and byte `size` is
treated as dword ring occupancy, allowing copies beyond the requested
read count.

Step 1.4 Record: Not hidden; this is an explicit memory-safety/user-copy
bounds fix.

Step 2.1 Record: One file changed,
`drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c`; one function changed,
`amdgpu_debugfs_ring_read`; roughly +13/-? surgical single-function
change.

Step 2.2 Record: Before, CPER locking and pointer sampling happened only
when `*pos < 12`; payload-only reads used uninitialized `early[]`.
Before, payload loop copied one dword while decrementing `size` by one,
although `size` is bytes. After, CPER reads lock before sampling,
resample pointers for payload, compute available dwords separately, cap
reads by `size >> 2`, and advance `*pos`.

Step 2.3 Record: Bug category is memory safety / bounds correctness plus
synchronization. Mechanism: debugfs `read()` could return/copy more
bytes than requested and could use invalid CPER ring pointers on reads
starting past the header.

Step 2.4 Record: Fix quality is good: small, local, no API change.
Regression risk is low; it only changes CPER debugfs reads. Holding
`cper.ring_lock` for payload-only reads matches the existing intent to
serialize with `amdgpu_cper_ring_write`.

Step 3.1 Record: `git blame` shows the CPER payload reader came from
`5a1428242952f2` (`drm/amdgpu: read CPER ring via debugfs`), first
contained by `v6.15-rc1`; the partial CPER lock came from
`8652920d2c0024`.

Step 3.2 Record: No `Fixes:` tag to follow. I inspected the introducing
commits manually: `5a1428242952f2` added the affected CPER payload
reader; `8652920d2c0024` added the existing CPER ring mutex but only
around the header path.

Step 3.3 Record: Related history includes `4d614ce8ffd75` adding the
CPER ring buffer, `a6d9d192903ea` adding CPER writes, `d6f9bbce18762`
fixing CPER ring remaining-size computation, and `93c19634f72fb` fixing
a separate uniras CPER debugfs user-buffer overflow.

Step 3.4 Record: Xiang Liu has multiple AMDGPU/RAS CPER commits in this
area. Alex Deucher committed the patch per the commit tags and is the
AMDGPU maintainer path in local history.

Step 3.5 Record: Dependencies are the existing CPER ring/debugfs code.
The affected code exists in this v7.0.y checkout and in tags `v6.15`
through `v7.0`; it is absent from `v6.14` by pattern check.

Step 4.1 Record: `b4 dig -c 1e40ef...` failed because the commit object
is not present locally. Web searches did not find the exact target
subject/body; they found related AMDGPU CPER debugfs patches and the
uniras buffer-overflow bug report.

Step 4.2 Record: `b4 dig -w` also failed for the same reason. Commit
tags still show AMDGPU review by Tao Zhou and commit by Alex Deucher.

Step 4.3 Record: No direct bug report found for this exact patch.
Related Dan Carpenter report verified a similar CPER debugfs user-buffer
overflow in `amdgpu_ras_cper_debugfs_read`, not this legacy reader.

Step 4.4 Record: Related CPER series context verified on freedesktop
archives: CPER debugfs read and CPER mutex patches were part of a v2
AMDGPU CPER series.

Step 4.5 Record: No stable-specific discussion found for the exact
target terms.

Step 5.1 Record: Modified function: `amdgpu_debugfs_ring_read`.

Step 5.2 Record: Callers are debugfs file operations:
`amdgpu_debugfs_ring_fops.read` and, for SR-IOV,
`amdgpu_debugfs_virt_ring_read`, which calls `amdgpu_debugfs_ring_read`.

Step 5.3 Record: Key callees are `amdgpu_ring_get_rptr`,
`amdgpu_ring_get_wptr`, `put_user`, and CPER lock operations. CPER
writes use `amdgpu_cper_ring_write`, which takes the same
`cper.ring_lock`.

Step 5.4 Record: Reachability is via
`/sys/kernel/debug/dri/*/amdgpu_ring_cper`, created by
`amdgpu_debugfs_ring_init` for registered rings. `amdgpu_ring_init`
registers rings in `adev->rings`, and `amdgpu_debugfs_init` iterates
those rings.

Step 5.5 Record: Similar pattern found: separate uniras CPER reader
overflow fixed by `93c19634f72fb`.

Step 6.1 Record: Buggy legacy CPER debugfs reader exists in `v6.15`,
`v6.16`, `v6.17`, `v6.18`, `v6.19`, and `v7.0`; not found in `v6.14`.

Step 6.2 Record: Expected backport difficulty is low for trees
containing the CPER reader. I could not complete a meaningful `git apply
--check` because my hand-built check patch was malformed, but the
current file matches the relevant pre-fix logic.

Step 6.3 Record: Related uniras fix exists locally, but it does not fix
the legacy `amdgpu_debugfs_ring_read` CPER path.

Step 7.1 Record: Subsystem is AMDGPU DRM/RAS driver code. Criticality is
driver-specific, not core kernel-wide.

Step 7.2 Record: Subsystem is active; local history shows multiple
CPER/RAS changes around v6.15-v6.19.

Step 8.1 Record: Affected users are AMDGPU systems with CPER ring
enabled and debugfs CPER ring reads.

Step 8.2 Record: Trigger is reading the CPER ring debugfs file,
especially payload reads past the 12-byte header or small/count-limited
reads. Unprivileged triggerability depends on debugfs mount permissions
and was not verified.

Step 8.3 Record: Failure mode is user-copy beyond requested read size
and possible invalid ring indexing from missing pointer snapshot.
Severity: HIGH for memory-safety correctness, reduced by debugfs-only
exposure.

Step 8.4 Record: Benefit is meaningful for affected AMDGPU debugfs users
because it prevents incorrect user copies and invalid CPER ring reads.
Risk is low: small, contained, no feature/API change.

## Stable Rules

1. Obviously correct and tested: mostly yes by inspection and maintainer
   review tag; no explicit `Tested-by`.
2. Fixes a real bug: yes, byte count vs dword count and missing pointer
   snapshot are verified in the code.
3. Important issue: yes, memory-safety/user-copy overflow from a
   readable debugfs file.
4. Small and contained: yes, one function in one driver file.
5. No new features/APIs: yes.
6. Can apply to stable: yes for v6.15+ trees containing the CPER debugfs
   reader; not applicable to v6.14 and older.

## Verification

- Phase 1: Parsed provided commit message and tags; no `Fixes`,
  `Reported-by`, `Link`, or stable tag present.
- Phase 2: Compared provided diff with current
  `amdgpu_debugfs_ring_read` implementation; verified `size` is bytes
  and old CPER loop decrements it as dwords.
- Phase 3: Ran `git blame` on the affected function; identified
  `5a1428242952f2` and `8652920d2c0024`.
- Phase 3: Ran `git show` on related commits `4d614ce8ffd75`,
  `5a1428242952f2`, `8652920d2c0024`, `d6f9bbce18762`, `527e3d40339b`,
  `93c19634f72fb`, and `a91d91b600479`.
- Phase 4: Ran `b4 dig`; it failed because the target commit object is
  unavailable in this checkout.
- Phase 4: Web searched exact subject/body; no direct target lore found.
  Fetched related freedesktop CPER series and Dan Carpenter uniras
  overflow report.
- Phase 5: Used repo search/read to trace debugfs fops, ring debugfs
  creation, CPER writer locking, and ring registration.
- Phase 6: Checked tags `v6.14` through `v7.0`; verified affected code
  starts at `v6.15`.
- Phase 8: Verified debugfs exposure through
  `debugfs_create_file_size(..., 0444, ...)`; did not verify system
  mount permissions, so unprivileged exploitability remains unverified.

This is a small, well-scoped memory-safety fix for code present in
stable trees starting at v6.15. It should be backported to affected
stable trees.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 29 +++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 4638a686a84e7..bebd72178cc13 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -572,8 +572,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
 	struct amdgpu_ring *ring = file_inode(f)->i_private;
-	uint32_t value, result, early[3];
+	u32 value, result, early[3] = { 0 };
 	uint64_t p;
+	u32 avail_dw, start_dw, read_dw;
 	loff_t i;
 	int r;
 
@@ -585,10 +586,10 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 
 	result = 0;
 
-	if (*pos < 12) {
-		if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
-			mutex_lock(&ring->adev->cper.ring_lock);
+	if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
+		mutex_lock(&ring->adev->cper.ring_lock);
 
+	if (*pos < 12) {
 		early[0] = amdgpu_ring_get_rptr(ring) & ring->buf_mask;
 		early[1] = amdgpu_ring_get_wptr(ring) & ring->buf_mask;
 		early[2] = ring->wptr & ring->buf_mask;
@@ -620,13 +621,24 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 			*pos += 4;
 		}
 	} else {
+		early[0] = amdgpu_ring_get_rptr(ring) & ring->buf_mask;
+		early[1] = amdgpu_ring_get_wptr(ring) & ring->buf_mask;
+
 		p = early[0];
 		if (early[0] <= early[1])
-			size = (early[1] - early[0]);
+			avail_dw = early[1] - early[0];
 		else
-			size = ring->ring_size - (early[0] - early[1]);
+			avail_dw = ring->buf_mask + 1 - (early[0] - early[1]);
 
-		while (size) {
+		start_dw = (*pos > 12) ? ((*pos - 12) >> 2) : 0;
+		if (start_dw >= avail_dw)
+			goto out;
+
+		p = (p + start_dw) & ring->ptr_mask;
+		avail_dw -= start_dw;
+		read_dw = min_t(u32, avail_dw, size >> 2);
+
+		while (read_dw) {
 			if (p == early[1])
 				goto out;
 
@@ -639,9 +651,10 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 
 			buf += 4;
 			result += 4;
-			size--;
+			read_dw--;
 			p++;
 			p &= ring->ptr_mask;
+			*pos += 4;
 		}
 	}
 
-- 
2.53.0

