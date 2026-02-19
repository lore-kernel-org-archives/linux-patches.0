Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC1272816;
	Thu, 19 Feb 2026 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466666; cv=none; b=qSzUpT0w8evRHaC5nMjOikQ6HwXBlthzVhtqdAdxWj0hfCXulXIYNp1EmKUDYNHzOiadBwVFwa2wymfkJQb3btz+1gTGRs87hK2TA4cb5ecQzpmqRIbWXX6WMt/KM5/mKGqjLA7EZaG/rFhiUJ6meIyhzscdDZd9Jes+9fzHDMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466666; c=relaxed/simple;
	bh=3Cnq1Fy3qpNRTF/CozJ2jkGNczha8sWbKV/3RTcH1pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO/XKRte68WTEkR5bcdPVBpcL2IyW3IJ3JFa1zAfpeHvmKPXMOx2JgJuvtuvl9UxHAc6l8HlontCaXn/k88pvFrv1PoNTKsXNCZCQ2Hej2A8HWopOIHlF5h8ghMp7aFPbIy2tNJviflnlZSXDDQdIrxwxqc/J+WZjrO1vd3L4xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfDRn+Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfDRn+Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B45C116D0;
	Thu, 19 Feb 2026 02:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466666;
	bh=3Cnq1Fy3qpNRTF/CozJ2jkGNczha8sWbKV/3RTcH1pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfDRn+BdbaOjbD3gZm/b/tVvhxbpwQLn+viIF4fJJjmKHMqaBKib0tSapuClq9Xts
	 ZSq+zQMG3J1i17oFcA0qFoVrapZoQXNHoVvbd42kINQFrlFMb6vc1Wq9JA2HdeDRSe
	 HXBYvpK7YXea5mbDF3ZsZ6CRIQnxx/qlCP691D0GKTEbQZ89mkwiRwx8WOXHVkuLDO
	 yIo46or7A+q9HRu0qWiRQ6l3ETTJLNUbUxzZjxdXBnZyzHdF78f6Y4Zzz8o1gwg18r
	 YDawQcrNMbrx6fscCh7bcIvYxQ99uRv8F/kvGkNP9fQc3lVnbKyb+dj6SudDmhqqCH
	 rWF35cOn26clg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Peter <mario.peter@leica-geosystems.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()
Date: Wed, 18 Feb 2026 21:03:38 -0500
Message-ID: <20260219020422.1539798-2-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Mario Peter <mario.peter@leica-geosystems.com>

[ Upstream commit cea2a1257a3b5ea3e769a445b34af13e6aa5a123 ]

The ChipIdea UDC driver can encounter "not page aligned sg buffer"
errors when a USB device is reconnected after being disconnected
during an active transfer. This occurs because _ep_nuke() returns
requests to the gadget layer without properly unmapping DMA buffers
or cleaning up scatter-gather bounce buffers.

Root cause:
When a disconnect happens during a multi-segment DMA transfer, the
request's num_mapped_sgs field and sgt.sgl pointer remain set with
stale values. The request is returned to the gadget driver with status
-ESHUTDOWN but still has active DMA state. If the gadget driver reuses
this request on reconnect without reinitializing it, the stale DMA
state causes _hardware_enqueue() to skip DMA mapping (seeing non-zero
num_mapped_sgs) and attempt to use freed/invalid DMA addresses,
leading to alignment errors and potential memory corruption.

The normal completion path via _hardware_dequeue() properly calls
usb_gadget_unmap_request_by_dev() and sglist_do_debounce() before
returning the request. The _ep_nuke() path must do the same cleanup
to ensure requests are returned in a clean, reusable state.

Fix:
Add DMA unmapping and bounce buffer cleanup to _ep_nuke() to mirror
the cleanup sequence in _hardware_dequeue():
- Call usb_gadget_unmap_request_by_dev() if num_mapped_sgs is set
- Call sglist_do_debounce() with copy=false if bounce buffer exists

This ensures that when requests are returned due to endpoint shutdown,
they don't retain stale DMA mappings. The 'false' parameter to
sglist_do_debounce() prevents copying data back (appropriate for
shutdown path where transfer was aborted).

Signed-off-by: Mario Peter <mario.peter@leica-geosystems.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260108165902.795354-1-mario.peter@leica-geosystems.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms:
1. `usb_gadget_unmap_request_by_dev()` at line 966 sets
   `req->num_mapped_sgs = 0` - this is exactly what's needed to clear
   the stale state
2. It also does `dma_unmap_sg()` at line 963 to properly unmap the DMA
   buffers
3. Without this call in `_ep_nuke()`, the request is given back with
   active DMA mappings and stale `num_mapped_sgs`

## 3. Assessment

### What the commit fixes:
- **DMA resource leak**: Requests returned via `_ep_nuke()` during
  disconnect have active DMA mappings that are never unmapped, leaking
  DMA resources
- **Stale state causing corruption**: The `num_mapped_sgs` field remains
  non-zero, causing `_hardware_enqueue()` to skip DMA mapping on reuse
  and instead use freed/invalid DMA addresses
- **Memory corruption**: Invalid DMA addresses lead to "not page aligned
  sg buffer" errors and potential memory corruption
- **Bounce buffer leak**: SG bounce buffers (`sgt.sgl`) allocated via
  `sglist_do_bounce()` are never freed, leaking memory

### Stable kernel criteria:
1. **Obviously correct**: The fix mirrors exactly what
   `_hardware_dequeue()` (line 886-891) and `ep_dequeue()` (line
   1738-1741) already do. It's a well-established pattern within the
   same file.
2. **Fixes a real bug**: DMA corruption and resource leaks on USB
   disconnect during active transfer.
3. **Important issue**: Memory corruption, stale DMA addresses,
   potential data corruption.
4. **Small and contained**: Only 6 lines added, all within a single
   function in a single file.
5. **No new features**: Pure bug fix.

### Risk assessment:
- **Very low risk**: The added code calls well-known cleanup functions
  that are already called in the two other completion paths
  (`_hardware_dequeue` and `ep_dequeue`). The `false` parameter to
  `sglist_do_debounce` is appropriate as no data needs to be copied back
  during shutdown.
- The `usb_gadget_unmap_request_by_dev()` call is safe even if no DMA
  was mapped (it checks `req->length == 0`, `sg_was_mapped`, and
  `num_mapped_sgs` before doing anything).

### Dependency consideration:
- The `sglist_do_debounce()` function was introduced in v6.13 (commit
  edfcc455c85cc). For stable trees older than 6.13, only the
  `usb_gadget_unmap_request_by_dev()` line would apply (the
  `sglist_do_debounce` part would need to be dropped). However, the DMA
  unmap portion is independently valuable.
- The `usb_gadget_unmap_request_by_dev()` function has existed for a
  long time and is available in all active stable trees.

### Reviews/Acks:
- Reviewed-by: Xu Yang (NXP engineer, author of the bounce buffer code)
- Acked-by: Peter Chen (ChipIdea UDC subsystem maintainer)
- Applied by: Greg Kroah-Hartman (USB maintainer)

## Verification

- **Verified** `_hardware_dequeue()` at lines 886-891 performs the same
  cleanup (DMA unmap + sglist debounce) - confirmed by reading the file
- **Verified** `ep_dequeue()` at lines 1738-1741 also performs the same
  cleanup pattern - confirmed by reading the file
- **Verified** `usb_gadget_unmap_request_by_dev()` in
  `drivers/usb/gadget/udc/core.c:956-972` clears `num_mapped_sgs` to 0
  (line 966) and unmaps DMA - confirmed by reading the source
- **Verified** `_ep_nuke()` is called from multiple paths: disconnect
  (line 1108), endpoint reset (lines 1326-1327), endpoint disable (line
  1615) - confirmed by grep
- **Verified** `sglist_do_debounce()` was introduced in commit
  `edfcc455c85cc` which first appeared in v6.13 - confirmed via `git tag
  --contains`
- **Verified** the commit is self-contained: no other patches needed for
  the fix to work in trees with v6.13+
- **Verified** commit has proper review: Reviewed-by (Xu Yang, bounce
  buffer author), Acked-by (Peter Chen, subsystem maintainer)
- **Verified** `_hardware_enqueue()` at line 708 checks `num_mapped_sgs`
  to decide whether to skip DMA mapping - this is the code path that
  breaks when stale state remains

## Conclusion

This is a textbook stable backport candidate:
- Fixes a real, user-triggerable bug (USB disconnect during active
  transfer)
- Causes memory corruption and DMA errors
- Small, surgical fix (6 lines added)
- Mirrors existing cleanup patterns already in the same file
- Reviewed and acked by subsystem experts
- Very low regression risk
- Affects real hardware users (ChipIdea UDC is used in NXP i.MX SoCs,
  common in embedded/IoT)

**YES**

 drivers/usb/chipidea/udc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 64a421ae0f05b..c8d931d9d4330 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -931,6 +931,13 @@ __acquires(hwep->lock)
 		list_del_init(&hwreq->queue);
 		hwreq->req.status = -ESHUTDOWN;
 
+		/* Unmap DMA and clean up bounce buffers before giving back */
+		usb_gadget_unmap_request_by_dev(hwep->ci->dev->parent,
+					&hwreq->req, hwep->dir);
+
+		if (hwreq->sgt.sgl)
+			sglist_do_debounce(hwreq, false);
+
 		if (hwreq->req.complete != NULL) {
 			spin_unlock(hwep->lock);
 			usb_gadget_giveback_request(&hwep->ep, &hwreq->req);
-- 
2.51.0

