Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD8126ED46;
	Sat, 12 Sep 2026 19:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242528; cv=none; b=ZkPISTAqZoIWaJO+GQS+o5k+XCXlMb3RJtpo9FQEDXLitpSk5WxX59vlMPdjBFrIlpuVHGw/ZL3XUXMlDzbwJwhIVjNh2Z1Ruus0HhlAsrKZIFmISsZGieqGADiWdsPcFnE99Y1pEJiJ69GrmVzxOSxDOcoYBSVmzWBWfrKosnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242528; c=relaxed/simple;
	bh=RcTPh44eYuQ8EIZBQkDS2/wakAc5tNoBVf3kWa0/1s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpxKut7A38ODtSXNllvDbwZjNVLws8TvlT4CtaGOBQme7pCXxGQ567dl+T1oIjXp/xA5HquZ6E3JYHIBNPpHi+4Rt8FbqF+OZKvkkI2Dzs1KpLeqEV9nBP2Q590nfSwlz+6UcWCFX/EbPtTgebt0Q0othKDKmVijLgAzjfm6HcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9+p7jW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9+p7jW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CC01F000FF;
	Sat, 12 Sep 2026 19:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242526;
	bh=5tUz7f7kLJNVZF/UIC3SHV/KMDR79Y7DbwuhJP54piU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9+p7jW+M6pKB5vGTyp6KBqvH8FMCV+W9RyWSxD+E1EWqCEBMW7FpUn+n+7eOSssL
	 qQ3aLCY9rme8BArx8Iyd5X0gIQ0rLR+RkKo/Uop4X6F+n6nDhvijxg6+Y7JLVfWHiD
	 R25dPJGgvFQYJtfH1sj0hF0lhQPWy0jzeHR6cbzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ira Weiny <ira.weiny@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/798] iov_iter: lift memzero_page() to highmem.h
Date: Sat, 12 Sep 2026 09:01:04 +0200
Message-ID: <20260912065527.135350774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit 28961998f858114e51d2ae862065b858afcfa2b2 ]

Patch series "btrfs: Convert kmap/memset/kunmap to memzero_user()".

Lifting memzero_user(), convert it to kmap_local_page() and then use it
in btrfs.

This patch (of 3):

memzero_page() can replace the kmap/memset/kunmap pattern in other
places in the code.  While zero_user() has the same interface it is not
the same call and its use should be limited and some of those calls may
be better converted from zero_user() to memzero_page().[1] But that is
not addressed in this series.

Lift memzero_page() to highmem.

[1] https://lore.kernel.org/lkml/CAHk-=wijdojzo56FzYqE5TOYw2Vws7ik3LEMGj9SPQaJJ+Z73Q@mail.gmail.com/

Link: https://lkml.kernel.org/r/20210309212137.2610186-1-ira.weiny@intel.com
Link: https://lkml.kernel.org/r/20210309212137.2610186-2-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 68d4d3e78150 ("isofs: fix out-of-bounds page array access on empty zisofs block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/highmem.h | 7 +++++++
 lib/iov_iter.c          | 8 +-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3f61ad5fddcd9..5f7cd58db4780 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -413,4 +413,11 @@ static inline void memcpy_to_page(struct page *page, size_t offset,
 	kunmap_atomic(to);
 }
 
+static inline void memzero_page(struct page *page, size_t offset, size_t len)
+{
+	char *addr = kmap_atomic(page);
+	memset(addr + offset, 0, len);
+	kunmap_atomic(addr);
+}
+
 #endif /* _LINUX_HIGHMEM_H */
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 6e30113303ba6..269e85ea1bb27 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -5,6 +5,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/uio.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/splice.h>
@@ -467,13 +468,6 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_init);
 
-static void memzero_page(struct page *page, size_t offset, size_t len)
-{
-	char *addr = kmap_atomic(page);
-	memset(addr + offset, 0, len);
-	kunmap_atomic(addr);
-}
-
 static inline bool allocated(struct pipe_buffer *buf)
 {
 	return buf->ops == &default_pipe_buf_ops;
-- 
2.53.0



