Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCE3288C34;
	Thu, 19 Feb 2026 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466702; cv=none; b=UnHAa4u1O7ISdzdQXAkraVwZxP8WTJ/GSN5Hb7PIDg48dGDHGaLTnl/kmKbFwU5AjN+5mFU7f7kO6OyvJ27f9FLAtPvOTCsvCgg9B8ZiHwxQrNtyU93w0Ww/i3HnjpFqAFOO1PYWUHXTFGksbBHtZ1UoIgfJjRwB/PAxk4uwVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466702; c=relaxed/simple;
	bh=C7k2nygNZOWnv4rXq1W6kueUUUbb8ONRpDHVKcqXh+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOCjn6mO6eeP8GIohZD1dr+xqG8ZKOLT57TyDOe0mfpqcFpjMqWzfqfRf1vCR+k4QN+VReWQyCE9/jWs7T1MHQl0A5GpfL40K/C0QtoteXe0IECvU6IzhPYsE6mjtQYAo5Kv7wFjfgbKnx5RpoZGEkgw7mqgQHpGzn37bQRytss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRABJ1or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRABJ1or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE37C19424;
	Thu, 19 Feb 2026 02:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466702;
	bh=C7k2nygNZOWnv4rXq1W6kueUUUbb8ONRpDHVKcqXh+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRABJ1orBrSnQBOyvOPV3YmMtRFMH5aanPyVwTk4ZwLV1bA1ojbvp+DDYH5pA4OoJ
	 4ZMQQ0ZrPq8Ea4Fxj4oLCwOzrD7miEASBkF9bpoAKKx4NRQEni1uN+qEKQGTpzazJr
	 8gM98t0/gSMwrIZu1q9MZfGBDPpN0rZm7GbpVH0okdS56sL25yrrCA8+r9mATKpMHY
	 DpmppMR5tvt4Gv0MznOEC/waAxH0nOVW50bz5E0+TCGpxv85ZYj/nv06q1uvIfC7KC
	 rdyL/BedcXc2NeZ+ZUOomITWGycjDBivuLpi6JzG7kJE13lbvnMk5DPHCxZkE10LsS
	 sl3Yf4ItuHB8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sam Day <me@samcday.com>,
	David Heidelberg <david@ixit.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] usb: gadget: f_fs: fix DMA-BUF OUT queues
Date: Wed, 18 Feb 2026 21:04:06 -0500
Message-ID: <20260219020422.1539798-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam Day <me@samcday.com>

[ Upstream commit 0145e7acd29855dfba4a2f387d455b5d9a520f0e ]

Currently, DMA_FROM_DEVICE is used when attaching DMABUFs to IN
endpoints and DMA_TO_DEVICE for OUT endpoints. This is inverted from
how it should be.

The result is IOMMU read-only mappings placed on OUT queues,
triggering arm-smmu write faults.

Put differently, OUT endpoints flow data from host -> gadget, meaning
the UDC peripheral needs to have write access to the buffer to fill it
with the incoming data.

This commit flips the directions and updates the implicit-sync helpers
so IN endpoints act as readers and OUT endpoints as writers.

Signed-off-by: Sam Day <me@samcday.com>
Tested-by: David Heidelberg <david@ixit.cz>  # OnePlus 6T on sdm845-next-20251119
Link: https://patch.msgid.link/20260108-ffs-dmabuf-ioctl-fix-v1-2-e51633891a81@samcday.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Wait — I see the code at line 1512 still shows the **old** (buggy)
direction. This means the fix commit hasn't been applied yet to this
tree. Let me verify this is the pre-fix state, and confirm the
correctness of the fix.

The key insight about USB gadget directions:

- **IN endpoint** (`epfile->in == true`): Data flows from gadget **to**
  host. The UDC reads from the buffer → `DMA_TO_DEVICE` (device reads
  the memory)
- **OUT endpoint** (`epfile->in == false`): Data flows from host **to**
  gadget. The UDC writes to the buffer → `DMA_FROM_DEVICE` (device
  writes to memory)

The current code has it backwards:
- `epfile->in ? DMA_FROM_DEVICE : DMA_TO_DEVICE` — **WRONG**
- Should be: `epfile->in ? DMA_TO_DEVICE : DMA_FROM_DEVICE` —
  **CORRECT**

This is consistent with the DMA-BUF perspective where DMA direction
refers to the device's perspective relative to memory.

Similarly for the reservation fences:
- IN endpoint (read from buffer to send to host) → the fence should be
  `DMA_RESV_USAGE_READ` (reading from the buffer)
- OUT endpoint (write incoming data to buffer) → the fence should be
  `DMA_RESV_USAGE_WRITE` (writing to the buffer)

The current code has:
- `epfile->in ? DMA_RESV_USAGE_WRITE : DMA_RESV_USAGE_READ` — **WRONG**
- Should be: `epfile->in ? DMA_RESV_USAGE_READ : DMA_RESV_USAGE_WRITE` —
  **CORRECT**

And for the `dma_resv_wait_timeout`:
- `dma_resv_usage_rw(epfile->in)` means: if IN, wait for both
  read+write; if OUT, wait for write only
- Should be `dma_resv_usage_rw(!epfile->in)`: if OUT, wait for both
  read+write; if IN, wait for write only

This logic is also inverted and the fix correctly flips it.

## Summary Assessment

### What problem does this commit solve?

This fixes an inverted DMA direction mapping for DMA-BUF operations in
the USB gadget FunctionFS driver. The bug causes:
1. **IOMMU write faults** (arm-smmu) on OUT endpoints because buffers
   are mapped read-only when they need write access
2. Incorrect implicit-sync fence semantics (readers treated as writers
   and vice versa)

This is a **correctness bug** that makes DMA-BUF OUT transfers
completely non-functional on systems with an IOMMU (which includes most
modern ARM SoCs).

### Does it meet stable kernel rules?

1. **Obviously correct**: Yes — the DMA direction semantics are well-
   defined and the fix is a straightforward inversion of three boolean
   conditions
2. **Fixes a real bug**: Yes — DMA-BUF OUT transfers cause IOMMU faults
   on ARM platforms
3. **Important issue**: Yes — hardware fault/crash-level issue that
   prevents a feature from working
4. **Small and contained**: Yes — 3 lines changed in a single file
5. **No new features**: Correct — pure bug fix
6. **Tested**: Yes — "Tested-by: David Heidelberg" on OnePlus 6T
   (sdm845)

### Risk vs Benefit

- **Risk**: Very low — the change is mechanical (flip three booleans),
  touches only DMA-BUF code paths in f_fs, and cannot affect non-DMA-BUF
  USB operations
- **Benefit**: High — fixes broken DMA-BUF OUT transfers that cause
  IOMMU faults

### Concerns

- **Affected versions**: The DMA-BUF support was introduced in commit
  `7b07a2a7ca02a` during the v6.9 development cycle. Only stable trees
  from v6.9 onward need this fix (the code doesn't exist in older
  kernels).
- **Dependencies**: None — the fix is self-contained and touches only
  the three lines with the bug
- **Backport risk**: Clean application expected since the surrounding
  code has not changed significantly

### Verification

- `git log -S "ffs_dmabuf_attach" master` confirmed the DMA-BUF
  interface was introduced in commit `7b07a2a7ca02a` (v6.9 cycle,
  2024-01-30)
- `git merge-base --is-ancestor 7b07a2a7ca02a master` confirmed the
  buggy code is in master
- Read of `f_fs.c` at lines 1490-1549 verified the current (pre-fix)
  code shows the inverted `DMA_FROM_DEVICE`/`DMA_TO_DEVICE` direction
- Grep for `epfile->in` confirmed three locations needing the fix (lines
  1512, 1642, 1687) matching the patch
- Line 2442 shows `epfile->in = usb_endpoint_dir_in(ep->ep->desc)`
  confirming `epfile->in` is true for IN endpoints (data to host)
- USB DMA direction convention verified: IN endpoint = device reads
  buffer = `DMA_TO_DEVICE`; OUT endpoint = device writes buffer =
  `DMA_FROM_DEVICE`. The original code has these inverted.
- `git tag --contains 7b07a2a7ca02a` shows the commit is in `p-6.12`,
  `p-6.15`, `p-6.16` branches, confirming the buggy code exists in
  multiple stable trees
- Commit has "Tested-by: David Heidelberg" and was merged by Greg Kroah-
  Hartman (USB maintainer), indicating quality review

This is a clear, small, well-tested fix for a real hardware fault that
makes DMA-BUF OUT transfers completely broken on IOMMU-enabled
platforms. It meets all stable kernel criteria.

**YES**

 drivers/usb/gadget/function/f_fs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index fa467a40949d2..928f51fddc64e 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1509,7 +1509,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
 		goto err_dmabuf_detach;
 	}
 
-	dir = epfile->in ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	dir = epfile->in ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 
 	err = ffs_dma_resv_lock(dmabuf, nonblock);
 	if (err)
@@ -1639,7 +1639,7 @@ static int ffs_dmabuf_transfer(struct file *file,
 	/* Make sure we don't have writers */
 	timeout = nonblock ? 0 : msecs_to_jiffies(DMABUF_ENQUEUE_TIMEOUT_MS);
 	retl = dma_resv_wait_timeout(dmabuf->resv,
-				     dma_resv_usage_rw(epfile->in),
+				     dma_resv_usage_rw(!epfile->in),
 				     true, timeout);
 	if (retl == 0)
 		retl = -EBUSY;
@@ -1684,7 +1684,7 @@ static int ffs_dmabuf_transfer(struct file *file,
 	dma_fence_init(&fence->base, &ffs_dmabuf_fence_ops,
 		       &priv->lock, priv->context, seqno);
 
-	resv_dir = epfile->in ? DMA_RESV_USAGE_WRITE : DMA_RESV_USAGE_READ;
+	resv_dir = epfile->in ? DMA_RESV_USAGE_READ : DMA_RESV_USAGE_WRITE;
 
 	dma_resv_add_fence(dmabuf->resv, &fence->base, resv_dir);
 	dma_resv_unlock(dmabuf->resv);
-- 
2.51.0

