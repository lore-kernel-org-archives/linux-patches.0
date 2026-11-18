Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053678;
	b=io+VuHuyQSocAQeDAT+seDrPHc9i7a+/mZxraXXW3W/MdmBLHzx5dGtbV9g1OpRHsRBN
	 c9ZlOpZZCCqWo+PBN+fNVHP5Zafux/q9PyVPL9JXjHH9/pEsn2yQc4C/qb5R1g3B4PVSM
	 1dfSg9/UJHAERkhEEzdsPuYzagzmjvysiL4mDtoQwFY9yHfqKDkyJbx+lqKLmwg0VDV+7
	 nGmqRBnr9SlJ+/4vPWZlhrZgvWQSvLrKgWjMJT93t/+L4xrgrgMGvkVCbPd33nigG31MG
	 UWzR3caxyQhIXDyesHJ/MG1AJk0CtemAhJ0ATuN9IQIjBeAM40i0xI/L2ajD+lnaYOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VcAC6Cwbb2s9JhffpsTC2NlpuAk2k0YQDqBFxysQqjo=;
	b=nkePMkk5OMFoxODfPvnapZpgtBCURNbEXlKIw/DPj3MHL4AHyKprRcsRNPMYWKSxIwhB
	 cr0+sUx+vRamYmaAc94+KHZb0yi8j8Z8wiBjbUdX35ap6P7fYFJ+QDaOqtTmw6+BLorpj
	 47zLhEZ9IS1BSCcDLk/u/VahlK70SFL8ECHn207ClPDlohL6Ou4n3Pkepbiq4XGk8tLJs
	 uAr+kBCGW2pnybXkGNTTQrCXBYOhYX6mzGT8/dg2vGfLtEGzO59ITx0ydlQMzmDaLLGP9
	 TocBLcaoCHn3js+2nHHzrIbd0iTUQQJyrATE45F5Rw5emzxNULhTaR6Tmr2thh1XyDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxCKU26q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B5E606A31C;
	Thu, 19 Nov 2026 02:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxCKU26q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397871F000C4;
	Thu, 19 Nov 2026 02:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053678;
	bh=VcAC6Cwbb2s9JhffpsTC2NlpuAk2k0YQDqBFxysQqjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxCKU26qkjpf+V6AwYB8wjNhNWsy0TTqaP0Kjs5VM/HsrPC6wmroCSA66kQEidaPf
	 bJ0BrWgjXzPNbODZwWK/KRIjjlz5bGXgfrGNLtme+wXO6fcM7Rn6VgDKXS2iZ+yd/+
	 p9OPhHVNSrvQNDppRdbakkZe81Rofc2+gIXQDTK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1004/2214] xen/gntdev: prevent private mappings from becoming writable
Date: Wed, 18 Nov 2026 15:44:40 +0100
Message-ID: <20261118150052.566489916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 2176dea8d8c19cb43a9b3651bfa1cb21eab1b31a ]

gntdev_mmap() rejects writable private (non-shared) mappings of foreign
grant pages, because a private writable mapping takes the COW path on
pages that have no proper struct-page backing.  However, VM_MAYWRITE is
left set, so userspace can map the grant read-only and then upgrade the
mapping to writable with mprotect(), hitting the same COW path the
check was written to prevent.

Clear VM_MAYWRITE for private mappings, as i915 does for its read-only
objects and as fixed in drm/vc4 (CVE-2026-68445) and drm/panthor
(CVE-2024-53071) and ptp: vmclock (commit
a5edadbae57e2298a56cf7a4e774a027905a331f).

Fixes: ab31523c2fcac ("xen/gntdev: allow usermode to map granted pages")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

Message-ID: <20260819084217.1577-1-suruurism@gmail.com>
[ sashal: Replaced vm_flags_clear() with direct vma->vm_flags bit clearing because the helper is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 6c6e264c6f11d..6b538c3c7bab7 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1074,6 +1074,13 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	if ((vma->vm_flags & VM_WRITE) && !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
+	/*
+	 * Private mappings of foreign grant pages must never become
+	 * writable: they would take the COW path on granted pages.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		vma->vm_flags &= ~VM_MAYWRITE;
+
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
 		 index, count, vma->vm_start, vma->vm_pgoff);
 
-- 
2.53.0



