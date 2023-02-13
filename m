Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AE88F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CECC4339B;
	Mon, 13 Feb 2023 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300396;
	bh=vkq/d11vp0t2z8M6ldoge9CimALDu5Qb1amyUjVxfCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+d7UgkFuUC2+FlOdU7NkX8hBQnJ5sOU6GjHTxG045EQ0rQASe32ytLpJV9zqZjUV
	 iKpIGYmylEtDFTbWMy2Xil71Zp7qpQ8wZ3mpQeLzXdSoKXCsybqO6+N4DAv9Z6UKXO
	 7EHQJnYYFcBRzak4xroLat0EmvD26mnqno0qB4zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Chunwei Chen <david.chen@nutanix.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 63/67] Fix page corruption caused by racy check in __free_pages
Date: Mon, 13 Feb 2023 15:49:44 +0100
Message-Id: <20230213144735.393429059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Chen <david.chen@nutanix.com>

commit 462a8e08e0e6287e5ce13187257edbf24213ed03 upstream.

When we upgraded our kernel, we started seeing some page corruption like
the following consistently:

  BUG: Bad page state in process ganesha.nfsd  pfn:1304ca
  page:0000000022261c55 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x1304ca
  flags: 0x17ffffc0000000()
  raw: 0017ffffc0000000 ffff8a513ffd4c98 ffffeee24b35ec08 0000000000000000
  raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
  page dumped because: nonzero mapcount
  CPU: 0 PID: 15567 Comm: ganesha.nfsd Kdump: loaded Tainted: P    B      O      5.10.158-1.nutanix.20221209.el7.x86_64 #1
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
  Call Trace:
   dump_stack+0x74/0x96
   bad_page.cold+0x63/0x94
   check_new_page_bad+0x6d/0x80
   rmqueue+0x46e/0x970
   get_page_from_freelist+0xcb/0x3f0
   ? _cond_resched+0x19/0x40
   __alloc_pages_nodemask+0x164/0x300
   alloc_pages_current+0x87/0xf0
   skb_page_frag_refill+0x84/0x110
   ...

Sometimes, it would also show up as corruption in the free list pointer
and cause crashes.

After bisecting the issue, we found the issue started from commit
e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages"):

	if (put_page_testzero(page))
		free_the_page(page, order);
	else if (!PageHead(page))
		while (order-- > 0)
			free_the_page(page + (1 << order), order);

So the problem is the check PageHead is racy because at this point we
already dropped our reference to the page.  So even if we came in with
compound page, the page can already be freed and PageHead can return
false and we will end up freeing all the tail pages causing double free.

Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
Link: https://lore.kernel.org/lkml/BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com/
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chunwei Chen <david.chen@nutanix.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5490,9 +5490,12 @@ EXPORT_SYMBOL(get_zeroed_page);
  */
 void __free_pages(struct page *page, unsigned int order)
 {
+	/* get PageHead before we drop reference */
+	int head = PageHead(page);
+
 	if (put_page_testzero(page))
 		free_the_page(page, order);
-	else if (!PageHead(page))
+	else if (!head)
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
 }


