Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC7212E1C9;
	Tue, 14 May 2024 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686691; cv=none; b=oXJOqvuWQpUALQFUuljtoTzKFCvq5hPJ5xP/ASLPdi7gqHZxeIkUBbwiTiqGzIwoya35CUFiFs9w3VbfRq0T3kA56RurGZx4oMzmIIDAYvNwIZ6dguFiougzBCnMdINONuZwuyqGHCY484dir19nrMv067Fo7argYD8IAMePop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686691; c=relaxed/simple;
	bh=Z4P2q9wc8hYhKjp5FEFdh8y2QvYV9OuVtWAW+h/0CtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1S3+wix4FDRAN4TnUxYNiYc7nTxcyaWcb3YaD/W16lSM+ScPCfiifQlRc48hPejv1eLONvxXbRLakEa3XnaWdiIwhwJsrwUVrAFj9h2jZoyYqskhd9c0yjRGPAxOfQO+egOyWl2JiH1fZpoHAe3cQQ2cRs2M1eIU9cOn7bnbPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r94IWaHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r94IWaHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3632C2BD10;
	Tue, 14 May 2024 11:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686691;
	bh=Z4P2q9wc8hYhKjp5FEFdh8y2QvYV9OuVtWAW+h/0CtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r94IWaHaI9RkjwAZrqbTOscu2r0ouF0nnM7cjxapVtYvj6YEJYqddTH6SZRx6iNbe
	 9uRMnkZKb8aSCRO4Y+l2WsvLVYbIK9sapjaSOn3HfFWuhl1cUxFfJ+iqBVy4TOLsEK
	 WSyzhcJJ1dAA6FzTS9EepLMAvw1wACv+ukCk4NjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zhang Yi <yi.zhang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 226/236] mm: use memalloc_nofs_save() in page_cache_ra_order()
Date: Tue, 14 May 2024 12:19:48 +0200
Message-ID: <20240514101028.937553122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 30153e4466647a17eebfced13eede5cbe4290e69 upstream.

See commit f2c817bed58d ("mm: use memalloc_nofs_save in readahead path"),
ensure that page_cache_ra_order() do not attempt to reclaim file-backed
pages too, or it leads to a deadlock, found issue when test ext4 large
folio.

 INFO: task DataXceiver for:7494 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:DataXceiver for state:D stack:0     pid:7494  ppid:1      flags:0x00000200
 Call trace:
  __switch_to+0x14c/0x240
  __schedule+0x82c/0xdd0
  schedule+0x58/0xf0
  io_schedule+0x24/0xa0
  __folio_lock+0x130/0x300
  migrate_pages_batch+0x378/0x918
  migrate_pages+0x350/0x700
  compact_zone+0x63c/0xb38
  compact_zone_order+0xc0/0x118
  try_to_compact_pages+0xb0/0x280
  __alloc_pages_direct_compact+0x98/0x248
  __alloc_pages+0x510/0x1110
  alloc_pages+0x9c/0x130
  folio_alloc+0x20/0x78
  filemap_alloc_folio+0x8c/0x1b0
  page_cache_ra_order+0x174/0x308
  ondemand_readahead+0x1c8/0x2b8
  page_cache_async_ra+0x68/0xb8
  filemap_readahead.isra.0+0x64/0xa8
  filemap_get_pages+0x3fc/0x5b0
  filemap_splice_read+0xf4/0x280
  ext4_file_splice_read+0x2c/0x48 [ext4]
  vfs_splice_read.part.0+0xa8/0x118
  splice_direct_to_actor+0xbc/0x288
  do_splice_direct+0x9c/0x108
  do_sendfile+0x328/0x468
  __arm64_sys_sendfile64+0x8c/0x148
  invoke_syscall+0x4c/0x118
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x4c/0x1f8
  el0t_64_sync_handler+0xc0/0xc8
  el0t_64_sync+0x188/0x190

Link: https://lkml.kernel.org/r/20240426112938.124740-1-wangkefeng.wang@huawei.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/readahead.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -504,6 +504,7 @@ void page_cache_ra_order(struct readahea
 	pgoff_t index = readahead_index(ractl);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
+	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
 
@@ -520,6 +521,8 @@ void page_cache_ra_order(struct readahea
 			new_order--;
 	}
 
+	/* See comment in page_cache_ra_unbounded() */
+	nofs = memalloc_nofs_save();
 	filemap_invalidate_lock_shared(mapping);
 	while (index <= limit) {
 		unsigned int order = new_order;
@@ -548,6 +551,7 @@ void page_cache_ra_order(struct readahea
 
 	read_pages(ractl);
 	filemap_invalidate_unlock_shared(mapping);
+	memalloc_nofs_restore(nofs);
 
 	/*
 	 * If there were already pages in the page cache, then we may have


