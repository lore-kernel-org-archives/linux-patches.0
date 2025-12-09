Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F85822256B;
	Tue,  9 Dec 2025 00:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239432; cv=none; b=YXf5ZxXgrUiousg1dMFhkC3ejgig2wgh7JAjU+lslefFPCiFaxAWnvzXTasuxBhia5S9JWgpSeJpz9hlxJ9dBhIsLt9MjEMknUOIDZ+zXVRD74/oCg5iQbSnDAuwJwxnCLPiG7adYSOL+YSOaGWcGXhIpzmzAhr0Lzq6bVkNvj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239432; c=relaxed/simple;
	bh=LWJ5PKBg/xFvkJoc9eCT1/JcOJDhRvKObYShTs+W9Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5g/Gh38sKYkSePsq48EAf9RjeBktHS7dx4nuets2z7sSQGkqEF9z+ICeQ9FKNdfPg2JVlZNhOytFwMvdsndW+JQc7SPu4GtwbsS5+WM6gB/qVmBIOssOQC2AZPVrD2+WP1I9zWqv4I0HK24hSMn7LDgRVALC4FZ2CvzDznfCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+dz7wOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+dz7wOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2789C4CEF1;
	Tue,  9 Dec 2025 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239432;
	bh=LWJ5PKBg/xFvkJoc9eCT1/JcOJDhRvKObYShTs+W9Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+dz7wOJ4pUZW9lWTIoiUIPcjCpfCr1F+8nU9PiXeg1m5VRQJNTpErQomKluD9dQm
	 vKyFysxT9lfzbJ6po2X7P+qFNeCnKtYGPPuyUj5t2v85Lh7z21+OpkHlAeWOfbR7xi
	 2lnfffzK8qW2dXWKKKshD21I776t5yApyO4RnQp/hf+/eNvtKZmLp0jPMpyGuya19g
	 PtwI54IIY5bxXPjs6A8OHY4AYtWmGDDoJOq8jAP7Wfviz8mT1fwVkla//CIAtNPrp+
	 gSaWo68y+RDdemHVNJ4lbNBG7QGkNkoOCOjN7kluXd9bl0snBRT2Ve8+2rWeB7wNDy
	 +6Z2Mb/eiz3lQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	mst@redhat.com,
	virtualization@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] virtio_blk: NULL out vqs to avoid double free on failed resume
Date: Mon,  8 Dec 2025 19:15:10 -0500
Message-ID: <20251209001610.611575-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Cong Zhang <cong.zhang@oss.qualcomm.com>

[ Upstream commit 0739c2c6a015604a7c01506bea28200a2cc2e08c ]

The vblk->vqs releases during freeze. If resume fails before vblk->vqs
is allocated, later freeze/remove may attempt to free vqs again.
Set vblk->vqs to NULL after freeing to avoid double free.

Signed-off-by: Cong Zhang <cong.zhang@oss.qualcomm.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. `kfree(NULL)` is safe - it does nothing. This is a well-known
C/Linux convention.

Now let me create my final comprehensive analysis:

## COMPLETE ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: `virtio_blk: NULL out vqs to avoid double free on failed
resume`

**Key points from commit message:**
- The `vblk->vqs` is released during freeze
- If resume fails before `vblk->vqs` is allocated, later freeze/remove
  may attempt to free vqs again
- Solution: Set `vblk->vqs` to NULL after freeing to avoid double free

**Acks/Reviews:**
- Acked-by: Jason Wang <jasowang@redhat.com> (virtio maintainer)
- Signed-off-by: Jens Axboe <axboe@kernel.dk> (block subsystem
  maintainer)

**Missing tags:**
- No `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag explicitly pointing to the bug-introducing commit

### 2. CODE CHANGE ANALYSIS

**Changes made:** Two modifications in `drivers/block/virtio_blk.c`:

#### Change 1: In `init_vq()` error path (lines 1029-1032)
**Before:**
```c
if (err)
    kfree(vblk->vqs);
return err;
```

**After:**
```c
if (err) {
    kfree(vblk->vqs);
    /*
     - Set to NULL to prevent freeing vqs again during freezing.
     */
    vblk->vqs = NULL;
}
return err;
```

#### Change 2: In `virtblk_freeze_priv()` (lines 1599-1600)
**Before:**
```c
vdev->config->del_vqs(vdev);
kfree(vblk->vqs);

return 0;
```

**After:**
```c
vdev->config->del_vqs(vdev);
kfree(vblk->vqs);
/*
 - Set to NULL to prevent freeing vqs again after a failed vqs
 - allocation during resume. Note that kfree() already handles NULL
 - pointers safely.
 */
vblk->vqs = NULL;

return 0;
```

### 3. BUG MECHANISM (Root Cause Analysis)

The double-free vulnerability occurs in the following scenario:

**Trigger Sequence:**
1. **virtblk_freeze_priv()** is called (suspend/PM freeze, or
   reset_prepare via FLR)
   - Frees `vblk->vqs` at line 1600
   - `vblk->vqs` **still points to the freed memory** (dangling pointer)

2. **virtblk_restore_priv()** is called (resume/PM restore, or
   reset_done)
   - Calls `init_vq(vblk)` at line 1610

3. **init_vq()** fails (e.g., `kmalloc_array()` fails or
   `virtio_find_vqs()` fails)
   - `init_vq()` allocates `vblk->vqs` at line 993
   - If allocation succeeds but later `virtio_find_vqs()` fails (line
     1016), the error path at line 1030 calls `kfree(vblk->vqs)`
   - But if allocation at line 993 fails, `vblk->vqs` is never
     reassigned and still points to the OLD freed memory from step 1
   - Error path at line 1030: `kfree(vblk->vqs)` - **FIRST FREE of the
     OLD pointer**

4. **Second freeze/remove attempt:**
   - If another freeze cycle or `virtblk_remove()` is called
   - `kfree(vblk->vqs)` is called again - **SECOND FREE of the same
     memory = DOUBLE FREE**

**Alternative scenario:**
- Even in `init_vq()` success path, if `vqs_info` or `vqs` temp
  allocation fails before line 997-999, and the error `goto out` is hit,
  the same dangling pointer issue occurs.

### 4. CLASSIFICATION

- **Type**: Bug fix (memory safety - double-free vulnerability)
- **Security relevance**: Potentially exploitable memory corruption bug
- **Category**: Does NOT fall into exceptions (device IDs, quirks, DT,
  build fixes)
- **Impact area**: virtio-blk block device driver, PM suspend/resume and
  transport reset recovery

### 5. SCOPE AND RISK ASSESSMENT

**Lines changed**: ~10 lines (including comments)
**Files touched**: 1 file (`drivers/block/virtio_blk.c`)
**Complexity**: Very low - simple NULL assignment after kfree

**Subsystem**: virtio-blk - a mature, widely-used block device driver
for virtual machines
- Used in QEMU/KVM guests
- Used in cloud VM instances (AWS, GCP, Azure etc.)
- Used in container environments

**Risk assessment**: **VERY LOW**
- The fix is trivial: just setting pointer to NULL after free
- `kfree(NULL)` is explicitly safe (no-op)
- No behavioral change in normal operation
- Only affects error recovery paths
- Cannot introduce new bugs

### 6. USER IMPACT

**Who is affected:**
- Users using virtio-blk devices in virtual machines
- Systems that undergo suspend/resume cycles
- Systems using PCI Function Level Reset (FLR) on virtio devices
- Particularly affects systems with constrained memory where allocation
  might fail

**Severity if bug hits:**
- Double-free can cause kernel panic/crash
- Potential memory corruption
- Potential security vulnerability (though exploitation would be
  difficult)

**Trigger conditions:**
- Requires PM suspend/resume OR transport reset (FLR)
- AND memory allocation failure during resume
- Relatively rare in practice but can happen under memory pressure

### 7. STABILITY INDICATORS

**Positive indicators:**
- Acked-by: Jason Wang (virtio maintainer)
- Signed-off-by: Jens Axboe (block maintainer)
- The fix is obviously correct and minimal
- Follows the standard kernel pattern of NULLing after free

**Negative indicators:**
- No `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag
- No `Tested-by:` tag

### 8. DEPENDENCY CHECK

**Dependencies:**
- Requires commit `5820a3b089879` ("virtio_blk: Add support for
  transport error recovery") which introduced `virtblk_freeze_priv()`
  and `virtblk_restore_priv()` as shared functions
- This commit (`5820a3b089879`) was merged in v6.14-rc1

**Earlier bug introduction:**
- The original bug was introduced in `b71ba22e7c6c6` ("virtio-blk: Fix
  memory leak among suspend/resume procedure") in v5.14-rc1
- That commit added `kfree(vblk->vqs)` in freeze without NULLing it

**For stable backport:**
- For kernels v6.14+: should apply cleanly
- For kernels v5.14 to v6.13: would need different backport (the code
  structure is different)
- The `virtblk_freeze_priv` function only exists starting from v6.14

### 9. CONCLUSION

**This commit SHOULD be backported to stable trees** because:

1. **Fixes a real bug**: Double-free is a serious memory safety bug that
   can cause crashes and potentially be exploited

2. **Obvious correctness**: Setting pointer to NULL after free is the
   standard kernel idiom and cannot introduce new bugs

3. **Small and contained**: Only ~10 lines changed, very localized to
   two specific error handling paths

4. **No new features**: Pure bug fix with no behavioral changes in
   normal operation

5. **Affects important infrastructure**: virtio-blk is used extensively
   in cloud/virtualization environments

6. **Low risk**: The fix is trivial and follows standard patterns;
   `kfree(NULL)` is explicitly safe

**Caveats for backporting:**
- The fix in its current form is ONLY applicable to v6.14+ kernels where
  `virtblk_freeze_priv()` exists
- For older stable kernels (v5.14 to v6.13), a different (simpler)
  backport would be needed that just NULLs `vblk->vqs` in
  `virtblk_freeze()` directly
- The maintainers did not explicitly tag this for stable (`Cc:
  stable@vger.kernel.org`), which might indicate they didn't consider
  backporting, or the bug wasn't seen as critical

The fix is small, surgical, obviously correct, and addresses a real
memory safety bug. It meets all stable kernel criteria.

**YES**

 drivers/block/virtio_blk.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index f061420dfb10c..746795066d7f5 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1026,8 +1026,13 @@ static int init_vq(struct virtio_blk *vblk)
 out:
 	kfree(vqs);
 	kfree(vqs_info);
-	if (err)
+	if (err) {
 		kfree(vblk->vqs);
+		/*
+		 * Set to NULL to prevent freeing vqs again during freezing.
+		 */
+		vblk->vqs = NULL;
+	}
 	return err;
 }
 
@@ -1598,6 +1603,12 @@ static int virtblk_freeze_priv(struct virtio_device *vdev)
 
 	vdev->config->del_vqs(vdev);
 	kfree(vblk->vqs);
+	/*
+	 * Set to NULL to prevent freeing vqs again after a failed vqs
+	 * allocation during resume. Note that kfree() already handles NULL
+	 * pointers safely.
+	 */
+	vblk->vqs = NULL;
 
 	return 0;
 }
-- 
2.51.0

