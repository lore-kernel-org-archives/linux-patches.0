Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642991A2567;
	Wed, 20 Nov 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107607; cv=none; b=XfFLn3cY7FQVkRLOqnkR4Et1IAmElRs37iNk1XvRDU9//09Vk/s3fap9N/9ds+7HMzgMxSfovo1uS4iiYzTw5jQnjOWDGtuZnXQQ1pcKlE4Nk2P8xji+8MNE/vk2y2hyhweZcfddveC2cQkPyyUpRbfM6TlUUnOtA1hphoQW/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107607; c=relaxed/simple;
	bh=Db+j9w9+vn34e2stwH2tk/8i+ewMNvADcoNHS9CH+1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGKGFuFbCa338c0qNRgWfa0kuGsxE3Bvsl0/TqPrfLmGMnqnfRuGwtqHIKeX6YPgmuXApcMVE89jD4V7neNPiAMiXgKenoNjQFW9me5nNUJ3vOFPRt2lp0uSOoC/tI2azc7DuZhLye6SlbR069ogJSIUS7Iqq4+LRCdmsz1h4ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d40zKLrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d40zKLrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A36BC4CED1;
	Wed, 20 Nov 2024 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107607;
	bh=Db+j9w9+vn34e2stwH2tk/8i+ewMNvADcoNHS9CH+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d40zKLrTqyaPZNny6rVYUlg9U3LQehj0SpW+slVO1q5ETuXJI/gRTaloYQ8JW3UOS
	 NR8EfMFAq7hNC58n32wOknWhw4Taz1rBCbv62xy6JEEGSb2Mvx9qlZjtrjg8rg7Iwb
	 R6pLzA7S0sqCRa/NeDnRYCg83jC72zbt3+3+Fy88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hajime Tazaki <thehajime@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 40/82] nommu: pass NULL argument to vma_iter_prealloc()
Date: Wed, 20 Nov 2024 13:56:50 +0100
Message-ID: <20241120125630.516241559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -584,7 +584,7 @@ static int delete_vma_from_mm(struct vm_
 	VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_start);
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
-	if (vma_iter_prealloc(&vmi, vma)) {
+	if (vma_iter_prealloc(&vmi, NULL)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;


