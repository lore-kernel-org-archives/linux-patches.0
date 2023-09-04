Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9C1C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA938C433C7;
	Mon,  4 Sep 2023 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852539;
	bh=zAJW/SxoWYwTqQ4K1Vldor7Wd1uFEmmw7Us1REv4Q/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHNgCjOpNSVa305LUtK2b4H202FpvJ93AyCmdrURt/RHhSIWUBdrX/JtgyeEqwN+e
	 1/REBSVGsmWj+xGZIm6hK+A2xBJ+8hh9L2cWGzL0SxFgb4jV+KOKLjvy2MIA/Cs+Er
	 rSw7qwxgpWfTfs0+u/cTKTfyxtkAtqQJkNbkhb7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+0ad741797f4565e7e2d2@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 28/31] nilfs2: fix general protection fault in nilfs_lookup_dirty_data_buffers()
Date: Mon,  4 Sep 2023 19:30:36 +0100
Message-ID: <20230904182948.345158641@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit f83913f8c5b882a312e72b7669762f8a5c9385e4 upstream.

A syzbot stress test reported that create_empty_buffers() called from
nilfs_lookup_dirty_data_buffers() can cause a general protection fault.

Analysis using its reproducer revealed that the back reference "mapping"
from a page/folio has been changed to NULL after dirty page/folio gang
lookup in nilfs_lookup_dirty_data_buffers().

Fix this issue by excluding pages/folios from being collected if, after
acquiring a lock on each page/folio, its back reference "mapping" differs
from the pointer to the address space struct that held the page/folio.

Link: https://lkml.kernel.org/r/20230805132038.6435-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+0ad741797f4565e7e2d2@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000002930a705fc32b231@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
fs/nilfs2/segment.c | 5 +++++
 fs/nilfs2/segment.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -725,6 +725,11 @@ static size_t nilfs_lookup_dirty_data_bu
 		struct page *page = pvec.pages[i];
 
 		lock_page(page);
+		if (unlikely(page->mapping != mapping)) {
+			/* Exclude pages removed from the address space */
+			unlock_page(page);
+			continue;
+		}
 		if (!page_has_buffers(page))
 			create_empty_buffers(page, i_blocksize(inode), 0);
 		unlock_page(page);


