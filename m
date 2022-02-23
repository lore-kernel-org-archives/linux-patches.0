Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4AAC9E
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 16:58:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6123A1F43E
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 16:58:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 42CFF13D9A
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 16:58:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id edXcDrBnFmLTFQAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 16:58:24 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Wed, 23 Feb 2022 17:58:23 +0100
Resent-Message-ID: <5ae25351-9609-aa56-828d-92efb023511f@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id gKZxDf1ZFmKnbgAAMHmgww
	(envelope-from <willy@infradead.org>)
	for <vbabka>; Wed, 23 Feb 2022 15:59:57 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id WOGRDP1ZFmKjKAAApTUePA
	(envelope-from <willy@infradead.org>)
	for <vbabka@imap.suse.de>; Wed, 23 Feb 2022 15:59:57 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 2B796A3B83;
	Wed, 23 Feb 2022 15:59:57 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: 0.59
X-Spam-Level:
X-Spam-Status: No, score=0.59 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lei0MtNinlNS; Wed, 23 Feb 2022 15:59:51 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 7E4B2A3B8D;
	Wed, 23 Feb 2022 15:59:48 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id 5D3E5AA55;
	Wed, 23 Feb 2022 15:59:48 +0000 (UTC)
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nMu3D-003tMu-EB; Wed, 23 Feb 2022 15:59:35 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kirill.shutemov@linux.intel.com,
	Song Liu <songliubraving@fb.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Adam Majer <amajer@suse.com>,
	Dirk Mueller <dmueller@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] mm/filemap: Fix handling of THPs in generic_file_buffered_read()
Date: Wed, 23 Feb 2022 15:59:18 +0000
Message-Id: <20220223155918.927140-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a THP is present in the page cache, we can return it several times,
leading to userspace seeing the same data repeatedly if doing a read()
that crosses a 64-page boundary.  This is probably not a security issue
(since the data all comes from the same file), but it can be interpreted
as a transient data corruption issue.  Fortunately, it is very rare as
it can only occur when CONFIG_READ_ONLY_THP_FOR_FS is enabled, and it can
only happen to executables.  We don't often call read() on executables.

This bug is fixed differently in v5.17 by commit 6b24ca4a1a8d
("mm: Use multi-index entries in the page cache").  That commit is
unsuitable for backporting, so fix this in the clearest way.  It
sacrifices a little performance for clarity, but this should never
be a performance path in these kernel versions.

Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Cc: stable@vger.kernel.org # v5.15, v5.16
Link: https://lore.kernel.org/r/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
Analyzed-by: Adam Majer <amajer@suse.com>
Analyzed-by: Dirk Mueller <dmueller@suse.com>
Bisected-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 82a17c35eb96..1293c3409e42 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2354,8 +2354,12 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			break;
 		if (PageReadahead(head))
 			break;
-		xas.xa_index = head->index + thp_nr_pages(head) - 1;
-		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
+		if (PageHead(head)) {
+			xas_set(&xas, head->index + thp_nr_pages(head));
+			/* Handle wrap correctly */
+			if (xas.xa_index - 1 >= max)
+				break;
+		}
 		continue;
 put_page:
 		put_page(head);
-- 
2.34.1

