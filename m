Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73209101DE;
	Thu,  3 Jul 2025 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554112; cv=none; b=Thn+wgomxvLKLnJgCRYc1M/H+ZYMW2qHZis1IJcrDA7Acn6DzO/UlmFHe3ixEc68AqTjZ8UtM5wgBg3TC7Jg1f/9cQ9iecnHC4kxnWZYZKDwn+vpuhkhsoQhyxTzyXRDk6zyYi7Zy5DiJbAzLj+6XPB/X5M61KWGwDOkacq902Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554112; c=relaxed/simple;
	bh=FLUCEJtj0ujzUVqP2rJ7YrG2NDpJVOpIBN8mANWZVzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCuvvO984S69lq1Ey87pNe36hmwEMFITbuGuvOV5NiP7rtSZ1x3nweibae/c7yNhLUT4VnQWKbnBUwPH8t+YAWkzFg105C7L9aVV8V2/x1t1woT6dB5sItHBCVqKtH4xUfCvW4HkTS0WjQApCwxD7aiO2vf7xIZnNXZx4IfyAYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DD78r3qO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DD78r3qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DD6C4CEE3;
	Thu,  3 Jul 2025 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554112;
	bh=FLUCEJtj0ujzUVqP2rJ7YrG2NDpJVOpIBN8mANWZVzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DD78r3qO1mRiOW8pvfFhbPU3LMf2bEqlNiNzOcMBkaQKhx+vXjJTDrRNuomtcccTS
	 qcqh/+VBESrHqwf2fjmf+1R1OOiToyU0O5sUbj4t3IOJm0PUBFlGmb7STrKd+zvOQF
	 0TB225DDZJ+g9mxTWXIk6ROlO0uHn5EoY47jxiZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 084/218] fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio
Date: Thu,  3 Jul 2025 16:40:32 +0200
Message-ID: <20250703143959.302323493@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

commit 4a5e85f4eb8fd18b1266342d100e4f0849544ca0 upstream.

is_zero_pfn() does not work for the huge zero folio. Fix it by using
is_huge_zero_pmd().

This can cause the PAGEMAP_SCAN ioctl against /proc/pid/pagemap to
present pages as PAGE_IS_PRESENT rather than as PAGE_IS_PFNZERO.

Found by code inspection.

Link: https://lkml.kernel.org/r/20250617143532.2375383-1-david@redhat.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2155,7 +2155,7 @@ static unsigned long pagemap_thp_categor
 				categories |= PAGE_IS_FILE;
 		}
 
-		if (is_zero_pfn(pmd_pfn(pmd)))
+		if (is_huge_zero_pmd(pmd))
 			categories |= PAGE_IS_PFNZERO;
 		if (pmd_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;


