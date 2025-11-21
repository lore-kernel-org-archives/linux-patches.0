Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A5331578E;
	Fri, 21 Nov 2025 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731315; cv=none; b=vAsMc7Z6WCftIFt3bgi+odLYp9D41RPQkgR8UNkXQX4oDiChcdT1aY0kXtNk+fJLU23DE2/U5VHQPWEYqY8+aoxGrkiyEPWOWVWaV2eihWrOYu6/cYWv6DxUc/28G10SuMh0eF0wQQKQdcjKMk3nzCCUa9iTfg9hoLPPLtzkQvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731315; c=relaxed/simple;
	bh=CMyQH4Bbu35X8Z0Gm+MEgrXACK+JzmxqH1JPQgRP+L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3mPT6tg6RHUGTdp2ftMA/ZbgCUqAHGqwjgwajjtN/koVza307zsh+pJxjhQNE8YlhYp+GzHeRzyG+guwCxRVHUR/GomD6YS0ip/wjYyfgpZ3y+FDGOebYc5S3+oJ0fnDnbMi9dnUSl72YZGJ3PSec3wfkLOu61eh/cbhoAcWDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9pNA9jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9pNA9jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5ADC4CEF1;
	Fri, 21 Nov 2025 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731315;
	bh=CMyQH4Bbu35X8Z0Gm+MEgrXACK+JzmxqH1JPQgRP+L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9pNA9jcIu6HDJpYpBSxihI/S8LF7xSHOsJL2cPY95zVKmUchuIr6yCDMeRv3ziwN
	 H5MFDexIblJYxbY0s1SrETU1vJuDh+maeRCfGlLgH5knpFPVDdl8dT3IiBFrcSJQGb
	 aZU1HdKxKC2is29QLyHI/HiLi5gXryZW5RttjyN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>,
	Christian Brauner <brauner@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 166/247] kho: allocate metadata directly from the buddy allocator
Date: Fri, 21 Nov 2025 14:11:53 +0100
Message-ID: <20251121130200.679088434@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

commit fa759cd75bce5489eed34596daa53f721849a86f upstream.

KHO allocates metadata for its preserved memory map using the slab
allocator via kzalloc().  This metadata is temporary and is used by the
next kernel during early boot to find preserved memory.

A problem arises when KFENCE is enabled.  kzalloc() calls can be randomly
intercepted by kfence_alloc(), which services the allocation from a
dedicated KFENCE memory pool.  This pool is allocated early in boot via
memblock.

When booting via KHO, the memblock allocator is restricted to a "scratch
area", forcing the KFENCE pool to be allocated within it.  This creates a
conflict, as the scratch area is expected to be ephemeral and
overwriteable by a subsequent kexec.  If KHO metadata is placed in this
KFENCE pool, it leads to memory corruption when the next kernel is loaded.

To fix this, modify KHO to allocate its metadata directly from the buddy
allocator instead of slab.

Link: https://lkml.kernel.org/r/20251021000852.2924827-4-pasha.tatashin@soleen.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Matlack <dmatlack@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/gfp.h     |    3 +++
 kernel/kexec_handover.c |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -7,6 +7,7 @@
 #include <linux/mmzone.h>
 #include <linux/topology.h>
 #include <linux/alloc_tag.h>
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 
 struct vm_area_struct;
@@ -463,4 +464,6 @@ static inline struct folio *folio_alloc_
 /* This should be paired with folio_put() rather than free_contig_range(). */
 #define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
 
+DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
+
 #endif /* __LINUX_GFP_H */
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -102,7 +102,7 @@ static void *xa_load_or_alloc(struct xar
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	void *elm __free(free_page) = (void *)get_zeroed_page(GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
@@ -266,9 +266,9 @@ static_assert(sizeof(struct khoser_mem_c
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
+	struct khoser_mem_chunk *chunk __free(free_page) = NULL;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	chunk = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 


