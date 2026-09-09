Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F4156855E;
	Wed,  9 Sep 2026 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963433; cv=none; b=ASUwpFze/O5oNHGJNLTwVrGADFkua/FR8n+2HLPicTpob2Roq5j7zArrc6/ruNGO7zEJXnvofCOari3uGJBWY/EgsuGKHKSkwTwn++iS2WHyQivcrYoAEhSsQm0u7e7lYej+aKMqjVgSizBFnipSfxSI59+0LnWKq9Vj6A4S1po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963433; c=relaxed/simple;
	bh=EK2E4eOB0sduWfzDcSTU3PCflwAW0czDdb5pltuQX7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkBp1C9Eln60TihHond2pU7OcU/DplFoT0ezIz44rmlbsEMpd/axZFwowJswgU+p5Jy5VSw6zUYR7Vq3y6f1W/5QSRjuaSgV5Zm+kV32EgLXscfAknV0cVDhyAdZ0WIxTPf3qiyRAnUlcEQx1iviPcmVMyUgxL15CJOGkclYtJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8MZe5BT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8MZe5BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C531F00A3A;
	Wed,  9 Sep 2026 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963432;
	bh=OJcmK1/XrIG4avOmOQaNNK34zxDLfFTMnLBcKIKD7II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8MZe5BT3xXsraOrK8TyfE7gxb/hxT8ULv2VUXeIydKBizzib+hkREG9F1TBUglh1
	 /bIEdiHMs+3oCJt0XotAkZXFuIfunXMYgeyYHEpDN3bjAQR61nPVPNNIY6YJdq7SnT
	 GEI4OCo/+FdJN17tp3GJ2ghYryZvS5rTnNBUVQHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 038/583] ublk: clear VM_MAYWRITE on read-only ublk char device mmap
Date: Wed,  9 Sep 2026 15:35:23 +0200
Message-ID: <20260909134239.238580405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1862,6 +1862,12 @@ static int ublk_ch_mmap(struct file *fil
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


