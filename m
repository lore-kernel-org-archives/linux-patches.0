Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E204B308F24;
	Mon, 13 Oct 2025 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368624; cv=none; b=ubUy9Y5rqgz5yRHGJx0lq6R0+x+jF/VsbicCNa4cT/q2nRZQazmqQMB5JmFmZpop6/MMkHngtdwr1+k97hZ2/vqXeex/zkJl2OlXZDPDfGwTTZXon4bWd83m6rDal7o5/ZOCitObVyCWbD1FMtEelVJN97q9HF+3qlOUQ5M/Gew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368624; c=relaxed/simple;
	bh=Ss+M/2ILMZXyG0xx/sDJzX7DgSHQy6O5klgSDmZAFtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLvcfgEtNJ267v0ZGTrlJpje3WnzjPS78kxFmFTKmG/8BGqNE1jK2SHxPQlDpe7dezQoLubZyMFOEBBwJfXCOEDRa3UL7gls1tjb9ZTDMp8w6TzuIqrYH4BFTTrkrHRtYFAlQcfBEcIxe8lDUwCFh/tZzUbtxgSVrwUg8hnxbiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/XtU20Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/XtU20Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DEFC4CEE7;
	Mon, 13 Oct 2025 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368623;
	bh=Ss+M/2ILMZXyG0xx/sDJzX7DgSHQy6O5klgSDmZAFtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/XtU20Z2l+d7kjVqC4ZUMpHIwd4sfrDiItgrKdtbQ8MmNFN9Iy+xh6Ghi0fHqYKh
	 OYf7mYtaWaAmTTdLLJK4iFCg6vB3d+67/ZRMpBSLW7FxiM/9Tq9gHiFOJ/FW+8jiAY
	 aX+FquJFkovelHKMDrsEGhg1HNjPxbT3AGUq/Tak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Starks <jostarks@microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	Tianyu Lan <tiala@microsoft.com>
Subject: [PATCH 6.12 226/262] uio_hv_generic: Let userspace take care of interrupt mask
Date: Mon, 13 Oct 2025 16:46:08 +0200
Message-ID: <20251013144334.381673625@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit b15b7d2a1b09ef5428a8db260251897405a19496 upstream.

Remove the logic to set interrupt mask by default in uio_hv_generic
driver as the interrupt mask value is supposed to be controlled
completely by the user space. If the mask bit gets changed
by the driver, concurrently with user mode operating on the ring,
the mask bit may be set when it is supposed to be clear, and the
user-mode driver will miss an interrupt which will cause a hang.

For eg- when the driver sets inbound ring buffer interrupt mask to 1,
the host does not interrupt the guest on the UIO VMBus channel.
However, setting the mask does not prevent the host from putting a
message in the inbound ring buffer. So let’s assume that happens,
the host puts a message into the ring buffer but does not interrupt.

Subsequently, the user space code in the guest sets the inbound ring
buffer interrupt mask to 0, saying “Hey, I’m ready for interrupts”.
User space code then calls pread() to wait for an interrupt.
Then one of two things happens:

* The host never sends another message. So the pread() waits forever.
* The host does send another message. But because there’s already a
  message in the ring buffer, it doesn’t generate an interrupt.
  This is the correct behavior, because the host should only send an
  interrupt when the inbound ring buffer transitions from empty to
  not-empty. Adding an additional message to a ring buffer that is not
  empty is not supposed to generate an interrupt on the guest.
  Since the guest is waiting in pread() and not removing messages from
  the ring buffer, the pread() waits forever.

This could be easily reproduced in hv_fcopy_uio_daemon if we delay
setting interrupt mask to 0.

Similarly if hv_uio_channel_cb() sets the interrupt_mask to 1,
there’s a race condition. Once user space empties the inbound ring
buffer, but before user space sets interrupt_mask to 0, the host could
put another message in the ring buffer but it wouldn’t interrupt.
Then the next pread() would hang.

Fix these by removing all instances where interrupt_mask is changed,
while keeping the one in set_event() unchanged to enable userspace
control the interrupt mask by writing 0/1 to /dev/uioX.

Fixes: 95096f2fbd10 ("uio-hv-generic: new userspace i/o driver for VMBus")
Suggested-by: John Starks <jostarks@microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Cc: stable@vger.kernel.org
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Long Li <longli@microsoft.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Tested-by: Tianyu Lan <tiala@microsoft.com>
Link: https://lore.kernel.org/r/20250828044200.492030-1-namjain@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -98,7 +98,6 @@ static void hv_uio_channel_cb(void *cont
 	struct hv_device *hv_dev = chan->device_obj;
 	struct hv_uio_private_data *pdata = hv_get_drvdata(hv_dev);
 
-	chan->inbound.ring_buffer->interrupt_mask = 1;
 	virt_mb();
 
 	uio_event_notify(&pdata->info);
@@ -163,8 +162,6 @@ hv_uio_new_channel(struct vmbus_channel
 		return;
 	}
 
-	/* Disable interrupts on sub channel */
-	new_sc->inbound.ring_buffer->interrupt_mask = 1;
 	set_channel_read_mode(new_sc, HV_CALL_ISR);
 	ret = hv_create_ring_sysfs(new_sc, hv_uio_ring_mmap);
 	if (ret) {
@@ -207,9 +204,7 @@ hv_uio_open(struct uio_info *info, struc
 
 	ret = vmbus_connect_ring(dev->channel,
 				 hv_uio_channel_cb, dev->channel);
-	if (ret == 0)
-		dev->channel->inbound.ring_buffer->interrupt_mask = 1;
-	else
+	if (ret)
 		atomic_dec(&pdata->refcnt);
 
 	return ret;


