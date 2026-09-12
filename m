Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587722D0C94;
	Sat, 12 Sep 2026 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221232; cv=none; b=G2oFydffmeBWJTEn01/OSzMxNSfDCAZLkwqW7OKV+hq8thYt4CaWpunGQbfOLnpEoLn/3cm9K9wHQk2RZfjZzJ6m3iqkuLsiXDzUC0jzlUwGMVnHtC76o2zNNmZqAOM9xng4RJ5spGXc0JWbc6VyqQzkW6TX7evAgS3KlkqRw5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221232; c=relaxed/simple;
	bh=BTsq98QBynlr0q7a1LAubP+KCEIIjnBUoOr1lV6M+uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVPuDKJDu9LAyRLYCxNFbARc1eMlr4f0Hjk+TxbzHOo6Y5EuvrLI7r6TRnF7V4vEF8YiQngZp+pXlrF6ZnsrvDL6ATh7h02LCECVFtOTCCM91Y2T1ID8Kte7O15it1ccHB3Kbt7QB1Ke5jbuF2ITIJ6D8gQ7/q82ZgjbTrjVu/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTEuAswt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTEuAswt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF80A1F000FF;
	Sat, 12 Sep 2026 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221231;
	bh=x4+jowEEixlH612SDL90ZHHTa7hqLJ7MqZC5+ZoV3Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTEuAswt6wkYPldseYo1615FLc6W0+XTr8j8mLo5/gzyLmV2Q7a8bucrt/SUhK5gc
	 h00EP84O98B+Rx0gO8zh5mFKBHvUYXncrqnPtgJIK0imSXFcCDgYftJY3Tqpx4pbxP
	 hb04w+bT960SENsgBfrfK0qtcZAK9ovVEjeYtuqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0338/1424] ublk: clear VM_MAYWRITE on read-only ublk char device mmap
Date: Sat, 12 Sep 2026 08:46:10 +0200
Message-ID: <20260912065614.854935827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1437,6 +1437,12 @@ static int ublk_ch_mmap(struct file *fil
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


