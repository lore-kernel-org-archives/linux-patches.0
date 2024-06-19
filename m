Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF188146586;
	Wed, 19 Jun 2024 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802576; cv=none; b=OTIdtUVnWtn6t/1nGDeI7ATh1v2+7secDm4S8E9iO1NSF0t61AOvzKMABhHl0hf4JYGdUWotYayehuB6BhKjRYS0kV0gFxrpoTVQxULMESywG9moteqV6g9ebgbs1qFue06rY+zt8ltwUrBfr8UCGwLyc1qU1AMHBtopdHcBegs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802576; c=relaxed/simple;
	bh=XhvEhZAWaMaJ7hNbMByFFqkDHdrDlX0wYOgJ/BW7n2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMspx+Y19dOJ75kO9LjKHJIsbsacNqAEHJa0qdsY+BCj3eukXlUbqO+ISwXBqi0hCdPn4vUn+KYSuFs/8ySkDxurs1Mwshq5byksSjwEWrOsvtjl+UZha8NEnQDqBJcsFLp3IRDKUyJ4Ri+jCHmYax/3w7nX63/z7msThwtAkAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tj6t8cWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tj6t8cWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A06C2BBFC;
	Wed, 19 Jun 2024 13:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802576;
	bh=XhvEhZAWaMaJ7hNbMByFFqkDHdrDlX0wYOgJ/BW7n2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tj6t8cWRevuO9urilGE17uPvwF6szE9HLtaOZHyMpFVkFT6kPF9OacAJbihRkUVBR
	 6Wv+ger6yDGgoFlzOc8FG+R7+rMsKJKDk441myonucm2/px514AJqYLPRXruUdN3JA
	 VnCUfQtk+zemRte455Zsx5g3ikoRo8vUujdkdIs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Xu Yu <xuyu@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 243/267] mm/huge_memory: dont unpoison huge_zero_folio
Date: Wed, 19 Jun 2024 14:56:34 +0200
Message-ID: <20240619125615.649487666@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Miaohe Lin <linmiaohe@huawei.com>

commit fe6f86f4b40855a130a19aa589f9ba7f650423f4 upstream.

When I did memory failure tests recently, below panic occurs:

 kernel BUG at include/linux/mm.h:1135!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 9 PID: 137 Comm: kswapd1 Not tainted 6.9.0-rc4-00491-gd5ce28f156fe-dirty #14
 RIP: 0010:shrink_huge_zero_page_scan+0x168/0x1a0
 RSP: 0018:ffff9933c6c57bd0 EFLAGS: 00000246
 RAX: 000000000000003e RBX: 0000000000000000 RCX: ffff88f61fc5c9c8
 RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff88f61fc5c9c0
 RBP: ffffcd7c446b0000 R08: ffffffff9a9405f0 R09: 0000000000005492
 R10: 00000000000030ea R11: ffffffff9a9405f0 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: ffff88e703c4ac00
 FS:  0000000000000000(0000) GS:ffff88f61fc40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055f4da6e9878 CR3: 0000000c71048000 CR4: 00000000000006f0
 Call Trace:
  <TASK>
  do_shrink_slab+0x14f/0x6a0
  shrink_slab+0xca/0x8c0
  shrink_node+0x2d0/0x7d0
  balance_pgdat+0x33a/0x720
  kswapd+0x1f3/0x410
  kthread+0xd5/0x100
  ret_from_fork+0x2f/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 Modules linked in: mce_inject hwpoison_inject
 ---[ end trace 0000000000000000 ]---
 RIP: 0010:shrink_huge_zero_page_scan+0x168/0x1a0
 RSP: 0018:ffff9933c6c57bd0 EFLAGS: 00000246
 RAX: 000000000000003e RBX: 0000000000000000 RCX: ffff88f61fc5c9c8
 RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff88f61fc5c9c0
 RBP: ffffcd7c446b0000 R08: ffffffff9a9405f0 R09: 0000000000005492
 R10: 00000000000030ea R11: ffffffff9a9405f0 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: ffff88e703c4ac00
 FS:  0000000000000000(0000) GS:ffff88f61fc40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055f4da6e9878 CR3: 0000000c71048000 CR4: 00000000000006f0

The root cause is that HWPoison flag will be set for huge_zero_folio
without increasing the folio refcnt.  But then unpoison_memory() will
decrease the folio refcnt unexpectedly as it appears like a successfully
hwpoisoned folio leading to VM_BUG_ON_PAGE(page_ref_count(page) == 0) when
releasing huge_zero_folio.

Skip unpoisoning huge_zero_folio in unpoison_memory() to fix this issue.
We're not prepared to unpoison huge_zero_folio yet.

Link: https://lkml.kernel.org/r/20240516122608.22610-1-linmiaohe@huawei.com
Fixes: 478d134e9506 ("mm/huge_memory: do not overkill when splitting huge_zero_page")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2535,6 +2535,13 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
+	if (is_huge_zero_page(&folio->page)) {
+		unpoison_pr_info("Unpoison: huge zero page is not supported %#lx\n",
+				 pfn, &unpoison_rs);
+		ret = -EOPNOTSUPP;
+		goto unlock_mutex;
+	}
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);


