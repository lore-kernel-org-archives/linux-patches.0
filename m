Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989D11F890B;
	Mon, 21 Oct 2024 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507822; cv=none; b=UmRXyshx5VBt5wtWvO7pN+FvWTQ1EK/oOmDQ08PodfN1+wAyMXym6F2t5VwSZ8FaMFbwKbSlwuq2+VBfzCCXDdaFFZ4lGBuXesPCYWnp1WLb8d5EKty+7TrcNnhu3HfI3yLiHcFxBUAABjFHFtfKL7k28ceolYEl2vijwRp1tg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507822; c=relaxed/simple;
	bh=P5oG88NDWt1p3bor+uoh1NPxtcrvoA2J674II1jq2TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY+dOl9SmR6TeSkUvZi51j9b7ZuuXzBFcmgaTRsUUgRWYa81mKmHl+M4BDtwjeaibX9Mb9Kld4smQ0jDzQvmbGVcbv3Sqr/Wi+yyEWPF4l/71JWN1bS2plGsVaL3WzsbpECe0+QDY+hvna218VOrYLtw8lAzH7PMGbaFUL/OW4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erfhHQl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erfhHQl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16736C4CEC3;
	Mon, 21 Oct 2024 10:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507822;
	bh=P5oG88NDWt1p3bor+uoh1NPxtcrvoA2J674II1jq2TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erfhHQl7aY48NlRa3YzM/zXPIjFeF/L8laoM9ij/mvlNsD7i0lCeULhBF3vjGdDrx
	 D4sr82mSNGctQ/wkHc4hUH+3ITl7h2JKTYnIfzaADOsQJqJAiuaLiesKrpgN/rh1DN
	 OGerOi8pHBU1x1VNLvfKvbth1PcngKCd30jmvHm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 09/52] mm/swapfile: skip HugeTLB pages for unuse_vma
Date: Mon, 21 Oct 2024 12:25:30 +0200
Message-ID: <20241021102241.992379909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

commit 7528c4fb1237512ee18049f852f014eba80bbe8d upstream.

I got a bad pud error and lost a 1GB HugeTLB when calling swapoff.  The
problem can be reproduced by the following steps:

 1. Allocate an anonymous 1GB HugeTLB and some other anonymous memory.
 2. Swapout the above anonymous memory.
 3. run swapoff and we will get a bad pud error in kernel message:

  mm/pgtable-generic.c:42: bad pud 00000000743d215d(84000001400000e7)

We can tell that pud_clear_bad is called by pud_none_or_clear_bad in
unuse_pud_range() by ftrace.  And therefore the HugeTLB pages will never
be freed because we lost it from page table.  We can skip HugeTLB pages
for unuse_vma to fix it.

Link: https://lkml.kernel.org/r/20241015014521.570237-1-liushixin2@huawei.com
Fixes: 0fe6e20b9c4c ("hugetlb, rmap: add reverse mapping for hugepage")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2134,7 +2134,7 @@ static int unuse_mm(struct mm_struct *mm
 
 	mmap_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (vma->anon_vma) {
+		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type, frontswap,
 					fs_pages_to_unuse);
 			if (ret)


