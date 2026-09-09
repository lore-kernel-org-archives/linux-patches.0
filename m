Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348FB353A82;
	Wed,  9 Sep 2026 13:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961767; cv=none; b=Pm0pPH5FnFGYUA7c9ZsNika056Qshll0Z18jj59kXB+15Cn6WNBi+ERuIU8dsV0Ica2WYhTbjRXs+2yAKGXOtzyfWND9HMQ2blPF2bAfnmyhN6aiIJis6/fNNLqb3PgT47G/6UfO2B5gTCe13n0iopwjGITmVuJNS5X58e1AIQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961767; c=relaxed/simple;
	bh=+S/MjG/UwStx3Yy6ovJFklcUTtSR5Dc1RuSCGZG/CX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc79qGT/F4I/UOMU7IZb0Ognp1BlAT3tI2/buX5i7kZRtL2a8zVgpXgsSOpgyHjJgc1wPWXQleGTuEMAgPlxCOkGjLvafhaDOGONCScQ2CyOnkBUv5fbRz2MCSpU0DfxVpQAK9MWK6tMoUF5B4ah78pfc0wybKBXYFHqvdaITkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY2zqyiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY2zqyiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285A21F00A3A;
	Wed,  9 Sep 2026 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961765;
	bh=RjX+Kk2jFB1l9vxpz5R0Rrx2bl1Ish6NRXQTWEHimV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QY2zqyiwiymUK6afNFrlBsYMXXEglCdVXILUkjvaJVr9jGxLhGROG3nGx7ZacBP3J
	 4eOzO8Ad3w/rOITLq3ziv675uycZ/ovlNUjO+ZRrrJ7Wyk5fb5l1a3FzTyysIXbQq6
	 FRsYoI5jvmFhVmIMxAAn4t3darC4L9GfWPZdWUzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 060/556] ublk: clear VM_MAYWRITE on read-only ublk char device mmap
Date: Wed,  9 Sep 2026 15:35:40 +0200
Message-ID: <20260909134232.579621688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanishka De Silva <kpskanna1915@gmail.com>

commit 6e2b571b0a54755b06e092501913e1dfefe75d6c upstream.

ublk_ch_mmap() rejects mmap requests with VM_WRITE set, but never
clears VM_MAYWRITE on the resulting read-only mapping. This allows
a userspace daemon to mmap the per-queue command buffer PROT_READ,
then upgrade it to PROT_WRITE via mprotect(), since VM_MAYWRITE was
never cleared.

The command buffer holds struct ublksrv_io_desc entries that are
kernel-written ABI; a writable mapping lets an unprivileged daemon
process corrupt fields such as addr, op_flags, nr_sectors, and
start_sector.

Same bug class as the drm/panthor and drm/vc4 VM_MAYWRITE fixes, and
the 2026-08-13 ptp/vmclock fix (a5edadbae57e).

Verified via mprotect() PoC: before the fix, a PROT_READ mapping can
be upgraded to PROT_READ|PROT_WRITE and a write into the command
buffer corrupts io_desc fields (confirmed under KASAN). After the
fix, mprotect() returns -EACCES.

Fixes: 3fee8d7599e1 ("ublk_drv: add io_uring based userspace block driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kanishka De Silva <kpskanna1915@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260830070133.559-1-kpskanna1915@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2651,6 +2651,12 @@ static int ublk_ch_mmap(struct file *fil
 	if (vma->vm_flags & VM_WRITE)
 		return -EPERM;
 
+	/*
+	 * The per-queue command buffer is kernel-written ABI; prevent
+	 * the daemon from upgrading to writable via mprotect().
+	 */
+	vm_flags_clear(vma, VM_MAYWRITE);
+
 	end = UBLKSRV_CMD_BUF_OFFSET + ub->dev_info.nr_hw_queues * max_sz;
 	if (phys_off < UBLKSRV_CMD_BUF_OFFSET || phys_off >= end)
 		return -EINVAL;


