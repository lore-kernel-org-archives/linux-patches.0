Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79299134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB09CC433C0;
	Mon, 26 Jun 2023 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803421;
	bh=IFvrlRWs1UJ2iW8MJn34ABE2QNzACP3cr/sArKr+Jb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvQri62eDk+y/ID2xjJHpPwgFr7xAYmxn28rrZjFoLDrQnkMLcrTw3ibdSEev3mXp
	 Fph3oEZ0nTEMvMRkxR+P0ET9vBitLYXsszC1rKhnblku6HMRl/yj3KRrv2BE2puODn
	 l2EArZK8dT8hjfXam1LzmglXf+cvu6rWU+bXpsEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+53369d11851d8f26735c@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 055/199] nilfs2: prevent general protection fault in nilfs_clear_dirty_page()
Date: Mon, 26 Jun 2023 20:09:21 +0200
Message-ID: <20230626180807.981548604@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 782e53d0c14420858dbf0f8f797973c150d3b6d7 upstream.

In a syzbot stress test that deliberately causes file system errors on
nilfs2 with a corrupted disk image, it has been reported that
nilfs_clear_dirty_page() called from nilfs_clear_dirty_pages() can cause a
general protection fault.

In nilfs_clear_dirty_pages(), when looking up dirty pages from the page
cache and calling nilfs_clear_dirty_page() for each dirty page/folio
retrieved, the back reference from the argument page to "mapping" may have
been changed to NULL (and possibly others).  It is necessary to check this
after locking the page/folio.

So, fix this issue by not calling nilfs_clear_dirty_page() on a page/folio
after locking it in nilfs_clear_dirty_pages() if the back reference
"mapping" from the page/folio is different from the "mapping" that held
the page/folio just before.

Link: https://lkml.kernel.org/r/20230612021456.3682-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+53369d11851d8f26735c@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000da4f6b05eb9bf593@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/page.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -370,7 +370,15 @@ void nilfs_clear_dirty_pages(struct addr
 			struct folio *folio = fbatch.folios[i];
 
 			folio_lock(folio);
-			nilfs_clear_dirty_page(&folio->page, silent);
+
+			/*
+			 * This folio may have been removed from the address
+			 * space by truncation or invalidation when the lock
+			 * was acquired.  Skip processing in that case.
+			 */
+			if (likely(folio->mapping == mapping))
+				nilfs_clear_dirty_page(&folio->page, silent);
+
 			folio_unlock(folio);
 		}
 		folio_batch_release(&fbatch);


