Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063235;
	b=rJY8p/xbDzj8i6Of5vAkGeaNIX42lcJDf9dMBxovDkbw20BtkdAzJ/lv+f0lXU193t86
	 LBM7O+qT6zFmwnJ33itAb2rV2MAg2f67NZMTSeKXBr2LdF8jdcamwOec75/8Qg8fghQ1Z
	 i6XMuZpnqACNq7D9TQBG5p0yBqTyV3y4NUKvv6CNu9++6d045puDZJRcmBgRfnPSmKDM5
	 M07j0guO7+RLqeRC38tPl62W8t8c6sAiGrBIYSq1vVnx2q77pSSF0tBUjzfvU0WUwGEB5
	 bJpvn7I8jDB4acZRalQUWyB3n1FZY+0Bzi22xafeQs4sdyxu2eHC9vOxvjlmpftpMpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8QKRCJyZMekr29nEp4h08ObjIr+Wm2vpqqRIlimz1FY=;
	b=mAWqidwRIHSG4RKGsafnLSjBCNZ24DHTJ/4SHG+Q/ugx8Eu74D+sqh8TMJeMCL6pyZa/
	 N1ZR/IUGNdzcoj8zgLjqcMa93YVlzPiVUSGos5tuXYQyg0MQn8978o1yJ4MSULzkYuNit
	 Pegt6dFgCf0p+gmPhsTdqDdFFcdhWsoCureX/lbU7w81J+whczEL5zKUoj5elBCBfGF+F
	 WBoY7oi/SivC/OoWlaulWKCrlku3lZX4h3PaU4tA207yC3Qi4XEoKPQqALRfX5YH0jJSQ
	 um4QY4ydHAX+dSUpbTU57+8zkGVaiKPoueyxal4Y6G9Ld7lwYtKfIZlwtLCYU06Ddsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2o6b5lu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBA0606D833;
	Sat,  7 Nov 2026 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2o6b5lu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F260E1F0089F;
	Sat,  7 Nov 2026 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063235;
	bh=8QKRCJyZMekr29nEp4h08ObjIr+Wm2vpqqRIlimz1FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2o6b5lu0LY8EFfYWzbWgI4p6oOEdq8Yej/J6Gexs7n1PSkDDbdt5/1V1fNKA/Lr4V
	 ekFPSfgrsJPQPOIedzv86mxHgE00h6x6apfId+cIeSFTy6vxRlU8B9rwJV7X4Po2CN
	 ROyT9ceu+8gFv3cZxrNtRwy1KcJ2qB17+PEzt+PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/869] xen/gntdev: prevent private mappings from becoming writable
Date: Sat,  7 Nov 2026 08:51:56 -0500
Message-ID: <20261107134908.514371240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1e21b75114e5e..02ebbdba86101 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1072,6 +1072,13 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	if ((vma->vm_flags & VM_WRITE) && !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
+	/*
+	 * Private mappings of foreign grant pages must never become
+	 * writable: they would take the COW path on granted pages.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		vm_flags_clear(vma, VM_MAYWRITE);
+
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
 		 index, count, vma->vm_start, vma->vm_pgoff);
 
-- 
2.53.0



