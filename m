Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062260;
	b=sBNIlZF1A9TD08ouJ5clcU4qKqRMJCCmAecC22fZ9xm9SLUrZYPGmOJqPHAXsWHuQkJE
	 NUNz+b7wioL6hvkBqZJrLfF5JckZlsivyBxOoQ4l6iAb6xuFJ9Qwm1GUWXf4wFSyHW9V0
	 iYXbFMxyyjSUCSH0DUyKJytdlCserqrqGtvD38SceiUR5ku85yJtyMxe9vCBvtQB2WX4W
	 +pZG7UfYcWtVtCI8+IM6cl5O38hDHE/Br0zhGb5wZ4p/fD+FksUSKubSEMO/1/xfZxjXS
	 P6IYCCRQG+wpTFD3Ot4e9ROwLN05FPbbN5hcOGb3zDZESNWuU8gKkYstkq/TjBI36nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RzkHUaAEfzns9VrCQd3La2g/XQGwzgvHNff14zMHTsU=;
	b=pYSCz3OwPtjDpX5RpVOkvTW/tGEAPASFrv8jE7PDtJQOggng9hgzbsTP5SGTm+gPezwr
	 LTccPmt611pIgXiIdF+fmQq3ziGIGUny1ecUm0lZwjl1OA8MDVxXQQlMiGmZzPQuHFUEm
	 b3DOFa9GU/CgyG/eNzL4HvzTZSG0UEeh8RzHNaWOtrbiteKq2aHKBkJYg/TA8ydwKVDDP
	 0SY7KHCYDeR7rfqk4+XGd1Lmb0XcScWB8JgUOR5VSwbNlYgqVvxgtJB+w0W3UguSAI8Ge
	 DaRpB8Wsb+X+p8kvXCR00f0WefMtNsqF9ub6BXisArj/nS0il3xOlGMwh6dZuWD339w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thwJunEv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271F4606EE82;
	Sat,  7 Nov 2026 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thwJunEv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BAD1F0089F;
	Sat,  7 Nov 2026 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062260;
	bh=RzkHUaAEfzns9VrCQd3La2g/XQGwzgvHNff14zMHTsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thwJunEvVHciNrQEi6VBVSRpHR7kWGl/r+qEZZ/6i4XhMOrN1XPZnkJUi39GWeX2I
	 A3OUcPgvTuy4+JvHY8/+ZwOJYkNaFpny9rZSCDuDNwsTZ5OJoEUB2/JLoox0S4kFcH
	 +NCfYkfCZWWV+xEHa+taiv2A/L0etVoov65lw5Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1204/1536] xen/gntdev: prevent private mappings from becoming writable
Date: Sat,  7 Nov 2026 08:53:40 -0500
Message-ID: <20261107135031.566729444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



