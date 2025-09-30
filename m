Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C72236EB;
	Tue, 30 Sep 2025 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244895; cv=none; b=Tnv2bAdbRb8b6/zfQvtnp/nZAAFNFYpkrsJ13OR5D6X5TpXw/yv5IdGF22Drnom2Aps/8G5772ZNE4BKZpmsVjT8GuwGRQuD4gSgfWSYC2G7dJ42a3/lncuayKL2uh9c5aqGKvlPipGzeqhRHGTKBjr6kBARtCfcXjrtSPOrgwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244895; c=relaxed/simple;
	bh=b6JCTcztPLkR9mo6DpdInK+4yp/TuaR0YtcNwnNAemo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SlIwiejKKTN4vQpbv1e0LYmfjdX6E3RP28JatHKiX6uvbuyzNff74+4XCIkDy2l4jBRYcPc61O8OiZwvUy9s4DbVgTBTZHIlaOBrl6bnuMufcostUFx3isU+RcwLlwMaZQNBBcAs1kaOSOmtGLJoT9rJBbc75klIfRmghvFudlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5Wop2/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5Wop2/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FC3C4CEF0;
	Tue, 30 Sep 2025 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244895;
	bh=b6JCTcztPLkR9mo6DpdInK+4yp/TuaR0YtcNwnNAemo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5Wop2/9SlzALTyxdqtbI+7nvvSoouyPmLhIltDVupHsjoH1kx1/qAPohVFYBKMTj
	 gLddpXbSwSzJzizSlL8+xuPW/cD9+CTwX/Trb8qHHRn7Pgqste0zfhoPOF6JZj5Ovs
	 hj09QrrAK6lVBQXJWq1H+QLb/x23hze3O0o6QsSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Acs <acsjakub@amazon.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrei Vagin <avagin@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 126/143] fs/proc/task_mmu: check p->vec_buf for NULL
Date: Tue, 30 Sep 2025 16:47:30 +0200
Message-ID: <20250930143836.252535884@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Acs <acsjakub@amazon.de>

commit 28aa29986dde79e8466bc87569141291053833f5 upstream.

When the PAGEMAP_SCAN ioctl is invoked with vec_len = 0 reaches
pagemap_scan_backout_range(), kernel panics with null-ptr-deref:

[   44.936808] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
[   44.937797] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   44.938391] CPU: 1 UID: 0 PID: 2480 Comm: reproducer Not tainted 6.17.0-rc6 #22 PREEMPT(none)
[   44.939062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   44.939935] RIP: 0010:pagemap_scan_thp_entry.isra.0+0x741/0xa80

<snip registers, unreliable trace>

[   44.946828] Call Trace:
[   44.947030]  <TASK>
[   44.949219]  pagemap_scan_pmd_entry+0xec/0xfa0
[   44.952593]  walk_pmd_range.isra.0+0x302/0x910
[   44.954069]  walk_pud_range.isra.0+0x419/0x790
[   44.954427]  walk_p4d_range+0x41e/0x620
[   44.954743]  walk_pgd_range+0x31e/0x630
[   44.955057]  __walk_page_range+0x160/0x670
[   44.956883]  walk_page_range_mm+0x408/0x980
[   44.958677]  walk_page_range+0x66/0x90
[   44.958984]  do_pagemap_scan+0x28d/0x9c0
[   44.961833]  do_pagemap_cmd+0x59/0x80
[   44.962484]  __x64_sys_ioctl+0x18d/0x210
[   44.962804]  do_syscall_64+0x5b/0x290
[   44.963111]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

vec_len = 0 in pagemap_scan_init_bounce_buffer() means no buffers are
allocated and p->vec_buf remains set to NULL.

This breaks an assumption made later in pagemap_scan_backout_range(), that
page_region is always allocated for p->vec_buf_index.

Fix it by explicitly checking p->vec_buf for NULL before dereferencing.

Other sites that might run into same deref-issue are already (directly or
transitively) protected by checking p->vec_buf.

Note:
>From PAGEMAP_SCAN man page, it seems vec_len = 0 is valid when no output
is requested and it's only the side effects caller is interested in,
hence it passes check in pagemap_scan_get_args().

This issue was found by syzkaller.

Link: https://lkml.kernel.org/r/20250922082206.6889-1-acsjakub@amazon.de
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Penglei Jiang <superman.xpt@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2286,6 +2286,9 @@ static void pagemap_scan_backout_range(s
 {
 	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
 
+	if (!p->vec_buf)
+		return;
+
 	if (cur_buf->start != addr)
 		cur_buf->end = addr;
 	else


