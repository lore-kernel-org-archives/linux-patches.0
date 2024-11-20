Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE9E1991AA;
	Wed, 20 Nov 2024 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107528; cv=none; b=e6dH9YHzd/o608jODNFsAqLn9ZUmmUuDQucycEY8M1pieonOKX/Lmt8Z87JynFf7Ca3JdAtAKX+MmEeXAaUJGattps12GzP/qGG5TH++fj3jlde4KQQPcpJPouxxXIwccV5A4FB9hAVoWpHhWWlpqLBbDAa4vfN9mB9r/zfCjps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107528; c=relaxed/simple;
	bh=ZVixMvBaA5q6U9S/NnbEXFemwLgDIama0mAOgyhI79M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8GIEO/FQmUtebxNE3qa29k7OjNRGHsr0J3RR35oHc6FqWZmMFySL9REK5pHqqWQi31gq7SJRYjfdzI7wlubS63/uSa84R/iKr5UZ+lAphXvd1gvgt3HuwFzokZ1dmilVkdRcpW4FvRoNAO6ovo1O8y3g8FzLMcQn76Dlb1hneg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeCwR2yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeCwR2yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63565C4CECD;
	Wed, 20 Nov 2024 12:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107527;
	bh=ZVixMvBaA5q6U9S/NnbEXFemwLgDIama0mAOgyhI79M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeCwR2yzLZ5F0tX7zLqkDTFphNnjUVJ8d8bsTmebsF9/10cD5kTKO8AWQeBzjj3ur
	 Gz5nlYO8T7UZ8l9mBoYIOyNJhV3bhtioloE0fR8e8lGUUn9zXrRreFcdNya5QMLyJ/
	 FSZgSMY2KhLd8wUjuRj7kSZk7+jWd62upL5W9P88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hajime Tazaki <thehajime@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 059/107] nommu: pass NULL argument to vma_iter_prealloc()
Date: Wed, 20 Nov 2024 13:56:34 +0100
Message-ID: <20241120125631.008527525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hajime Tazaki <thehajime@gmail.com>

commit 247d720b2c5d22f7281437fd6054a138256986ba upstream.

When deleting a vma entry from a maple tree, it has to pass NULL to
vma_iter_prealloc() in order to calculate internal state of the tree, but
it passed a wrong argument.  As a result, nommu kernels crashed upon
accessing a vma iterator, such as acct_collect() reading the size of vma
entries after do_munmap().

This commit fixes this issue by passing a right argument to the
preallocation call.

Link: https://lkml.kernel.org/r/20241108222834.3625217-1-thehajime@gmail.com
Fixes: b5df09226450 ("mm: set up vma iterator for vma_iter_prealloc() calls")
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -568,7 +568,7 @@ static int delete_vma_from_mm(struct vm_
 	VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_start);
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
-	if (vma_iter_prealloc(&vmi, vma)) {
+	if (vma_iter_prealloc(&vmi, NULL)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;


