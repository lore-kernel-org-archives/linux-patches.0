Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E434A235340;
	Mon, 10 Mar 2025 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627455; cv=none; b=prdCyADNkcr2Ri8Et3yvkmHmR0TYU75n7OzpgcS+/lUSePIUWGJ6k/NBUUJYGR8UGFBFtXVneU/vrUsZjVhWKQ8VgubBK4SY9iM16P1p1dMBPtI/l0toeIB/Ldylnpnt0C8ViUH0HInWtZVvZyQqLg6dd5wfQo/0Vk2CaicTfhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627455; c=relaxed/simple;
	bh=vr14tTuSAh9fwq/I8PE9CB4k7HdiZTpjFZe4vcbZyvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfRret7chJq7X36RtDfFwiGBkU5BD7e3YF+06cLzDq3VGPLKOogwEabiVZEhrQmJj4HbPbh0rhr6sbRlE9ncFlD3NQ8UnMuXImdpnQjY/H/OeiUlHFS98m8jN3WtzDQ4+DG4E0NjGHtZycqzOI/tqxRvGJiHvrOTsCVvSrfLTCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6IuR8nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6IuR8nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEB0C4CEE5;
	Mon, 10 Mar 2025 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627454;
	bh=vr14tTuSAh9fwq/I8PE9CB4k7HdiZTpjFZe4vcbZyvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6IuR8nn9rFs1sVKtVK59KS1oPax2Ql96ENVtwJjUKZAafps1N360vgSHj0VV68eB
	 qzAx2Aijo/E0AxQ7cHKsI6+geL6T8dYjSbPL0DG1J4zige4ONJZGgVVWVXx/hSQfUW
	 T0qRbLn9Zh+8Z/9kKAB1ZPGDHFHWADH0APlmY1H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cfd5e38e96a5596f2b6@syzkaller.appspotmail.com,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 134/269] mm/page_alloc: fix uninitialized variable
Date: Mon, 10 Mar 2025 18:04:47 +0100
Message-ID: <20250310170503.065150515@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Hao Zhang <zhanghao1@kylinos.cn>

commit 8fe9ed44dc29fba0786b7e956d2e87179e407582 upstream.

The variable "compact_result" is not initialized in function
__alloc_pages_slowpath().  It causes should_compact_retry() to use an
uninitialized value.

Initialize variable "compact_result" with the value COMPACT_SKIPPED.

BUG: KMSAN: uninit-value in __alloc_pages_slowpath+0xee8/0x16c0 mm/page_alloc.c:4416
 __alloc_pages_slowpath+0xee8/0x16c0 mm/page_alloc.c:4416
 __alloc_frozen_pages_noprof+0xa4c/0xe00 mm/page_alloc.c:4752
 alloc_pages_mpol+0x4cd/0x890 mm/mempolicy.c:2270
 alloc_frozen_pages_noprof mm/mempolicy.c:2341 [inline]
 alloc_pages_noprof mm/mempolicy.c:2361 [inline]
 folio_alloc_noprof+0x1dc/0x350 mm/mempolicy.c:2371
 filemap_alloc_folio_noprof+0xa6/0x440 mm/filemap.c:1019
 __filemap_get_folio+0xb9a/0x1840 mm/filemap.c:1970
 grow_dev_folio fs/buffer.c:1039 [inline]
 grow_buffers fs/buffer.c:1105 [inline]
 __getblk_slow fs/buffer.c:1131 [inline]
 bdev_getblk+0x2c9/0xab0 fs/buffer.c:1431
 getblk_unmovable include/linux/buffer_head.h:369 [inline]
 ext4_getblk+0x3b7/0xe50 fs/ext4/inode.c:864
 ext4_bread_batch+0x9f/0x7d0 fs/ext4/inode.c:933
 __ext4_find_entry+0x1ebb/0x36c0 fs/ext4/namei.c:1627
 ext4_lookup_entry fs/ext4/namei.c:1729 [inline]
 ext4_lookup+0x189/0xb40 fs/ext4/namei.c:1797
 __lookup_slow+0x538/0x710 fs/namei.c:1793
 lookup_slow+0x6a/0xd0 fs/namei.c:1810
 walk_component fs/namei.c:2114 [inline]
 link_path_walk+0xf29/0x1420 fs/namei.c:2479
 path_openat+0x30f/0x6250 fs/namei.c:3985
 do_filp_open+0x268/0x600 fs/namei.c:4016
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_openat fs/open.c:1459 [inline]
 __se_sys_openat fs/open.c:1454 [inline]
 __x64_sys_openat+0x2a1/0x310 fs/open.c:1454
 x64_sys_call+0x36f5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable compact_result created at:
 __alloc_pages_slowpath+0x66/0x16c0 mm/page_alloc.c:4218
 __alloc_frozen_pages_noprof+0xa4c/0xe00 mm/page_alloc.c:4752

Link: https://lkml.kernel.org/r/tencent_ED1032321D6510B145CDBA8CBA0093178E09@qq.com
Reported-by: syzbot+0cfd5e38e96a5596f2b6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0cfd5e38e96a5596f2b6
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4243,6 +4243,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
+	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();


