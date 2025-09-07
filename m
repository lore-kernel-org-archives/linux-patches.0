Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882915C158;
	Sun,  7 Sep 2025 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277137; cv=none; b=Brt1n1s3hFjc53bXKuC4yyoqYRDyXeIl4xOYpf+r0RX5dSbjV+i2XB5xLY6jyjZpsKZcT9+2DZrrkLXUzKJDFOLryHh/KuNkBzD8he+DlPjdNIKjqpR31k1iDCyhJWn0NtLReFYA7XcYuuYlcrohAWh3L8Wx4RjVlPnXcMmVAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277137; c=relaxed/simple;
	bh=ms/G8cy6+Xzgtlwl7VKzqe1fuTvfIs0fYA/jjrTtCZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpO0gqWtc+DYj7jSeOHeFRao6Q1Cv/kSvq2AaZd/+xYtzbev/lgUbafiqwxX8l3hciw5MumBKkDugePRjbeWp7Pr7Ic4bGY1m0MXoi1IVFMb/2tYJmP/MOrlRjEHTwWR15/lhsocZC4Usat8L/p8aiwZk43JbmoeB+tbjhSLVLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USxSAr1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USxSAr1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD84BC4CEF9;
	Sun,  7 Sep 2025 20:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277137;
	bh=ms/G8cy6+Xzgtlwl7VKzqe1fuTvfIs0fYA/jjrTtCZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USxSAr1q0g+6kPLEsSrb2OcYOk1AY4W9RP6eQsdpfsgyZjnqCZQ1K2/LhZKApKg4O
	 /lk9RB8xI5mITWLaPDl9zoY2fli4Rd3ExMlq3OZ7DUmu0GrH18mWrubXhZDbrwQGLW
	 quBBTe12KQckpGNm0WcYujFRC8ERZF41T+3Lt0U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 098/175] mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE
Date: Sun,  7 Sep 2025 21:58:13 +0200
Message-ID: <20250907195617.167690906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit 9614d8bee66387501f48718fa306e17f2aa3f2f3 upstream.

With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
kmap_local_page(), which requires unmapping in Last-In-First-Out order.

The current code maps dst_pte first, then src_pte, but unmaps them in the
same order (dst_pte, src_pte), violating the LIFO requirement.  This
causes the warning in kunmap_local_indexed():

  WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
  addr \!= __fix_to_virt(FIX_KMAP_BEGIN + idx)

Fix this by reversing the unmap order to respect LIFO ordering.

This issue follows the same pattern as similar fixes:
- commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
- commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")

Both of which addressed the same fundamental requirement that kmap_local
operations must follow LIFO ordering.

Link: https://lkml.kernel.org/r/20250731144431.773923-1-sashal@kernel.org
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1432,10 +1432,15 @@ out:
 		folio_unlock(src_folio);
 		folio_put(src_folio);
 	}
-	if (dst_pte)
-		pte_unmap(dst_pte);
+	/*
+	 * Unmap in reverse order (LIFO) to maintain proper kmap_local
+	 * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
+	 * first, then src_pte, so we must unmap src_pte first, then dst_pte.
+	 */
 	if (src_pte)
 		pte_unmap(src_pte);
+	if (dst_pte)
+		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
 	if (si)
 		put_swap_device(si);


