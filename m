Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036403;
	b=qb3AAZf0zpEOVFAHGyMOL0wv+O4R+EsRN1Fke3wjMQBlwlrUWo6ENpKB5sfw08vxl5oc
	 ytSrvKxmezaxsKwtWzkoVjzDAssllwrrssltj0WjKuQV/nIZpkehr645axXaUhTpeNkjw
	 YaTOqo3V1u2MhXm2S22K33fn5Mq/oFGYNa/3syA4kMgJWUKWrExY3DxWUEkhWAXYdHXff
	 ADgDHOLZibhEG0allfUqpeeUc9n8YXbR5eDOe0C1Djv4TA7DBeej7q73u5RQwQb2guMcK
	 Fe5hDHeLFDMfFsrC1tRw9zgJYxiIydfl1EQw6SORyeR7bvUgjLGPJPqGlMtJhdWbXKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NeeGxRihwOrNuObE8w72penezkd+b5t95G8Grt0Q+AQ=;
	b=0ldC9eB+XwUpxN+MRtX2cr2VikuUhbG/R5Rh4HwxpfPCiu41FtrxrCDV3jdTEkdoOMmS
	 MQFlZbsnKU1iVMY7aGcoZrW6eP2+tLsrADZdMknVxlODtXKW0eeM1uO8AgcpygHMOqU2y
	 lwsgIvXWHi1KTRMo8RXZtQjzxXr0EqKOAcLvfMxLndrm46eijbVWmeYRlrNqCs5DoTn3D
	 4RprnNKcvZnBgeQATS96YKSNP709+jFOB6TdPWUlKDtra6OMJ28CoCOPQFOdAghcJ3MCG
	 uSBgGya2BCyzQwBSmf7LFtglMFxftiOQCz3oSgmHlCAiEsqUqo8JuL9qhv//0DMg7nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4VVgrw6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5767E606A331;
	Wed, 18 Nov 2026 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4VVgrw6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76211F000C4;
	Wed, 18 Nov 2026 21:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036403;
	bh=NeeGxRihwOrNuObE8w72penezkd+b5t95G8Grt0Q+AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4VVgrw6O9Jbl1u6PrAcCMKipqR6gqi+Mumj6Srgxs1IzDRAOfbO8SKlmqnPsLSqE
	 UMDVVpmrIpBjdrxZfwJZsW6vxDCkX93TaCUqxcoskr9b/iX/xdHt76/aDT3hHRHhBR
	 l8jIwWDhQDDXBgdOO5Sfxr5CJkgoWrOXyR57Sl0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1046/3318] xen/gntdev: prevent private mappings from becoming writable
Date: Wed, 18 Nov 2026 15:27:48 +0100
Message-ID: <20261118150351.298184769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16af955c5ea59..97ac558f26fda 100644
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
+		vm_flags_clear(vma, VM_MAYWRITE);
+
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
 		 index, count, vma->vm_start, vma->vm_pgoff);
 
-- 
2.53.0



