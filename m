Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABBEC8CD
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BD7C433C8;
	Mon, 19 Jun 2023 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172356;
	bh=t6BM1ispRrrUdWx8WNvPLixKSPnfmDzRY+ZEq6s6z9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glOIyHoU+0YYaPNK17bQ8POG0pIgjlG60mp+13EnPkuWxn/yKzRD6i8nygqePk3jd
	 BxFrhwx5Si5Sc1w+3spiA1/60/8KArgBZH364UikIzec79QurcW+1VZbADLIK2BTQ6
	 oJCA7wzwRS14FZ+jMSAykJqbfGgM7tp8cBN5prD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+b0a35a5c1f7e846d3b09@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 039/107] nilfs2: fix incomplete buffer cleanup in nilfs_btnode_abort_change_key()
Date: Mon, 19 Jun 2023 12:30:23 +0200
Message-ID: <20230619102143.382429029@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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

commit 2f012f2baca140c488e43d27a374029c1e59098d upstream.

A syzbot fault injection test reported that nilfs_btnode_create_block, a
helper function that allocates a new node block for b-trees, causes a
kernel BUG for disk images where the file system block size is smaller
than the page size.

This was due to unexpected flags on the newly allocated buffer head, and
it turned out to be because the buffer flags were not cleared by
nilfs_btnode_abort_change_key() after an error occurred during a b-tree
update operation and the buffer was later reused in that state.

Fix this issue by using nilfs_btnode_delete() to abandon the unused
preallocated buffer in nilfs_btnode_abort_change_key().

Link: https://lkml.kernel.org/r/20230513102428.10223-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b0a35a5c1f7e846d3b09@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000d1d6c205ebc4d512@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/btnode.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -285,6 +285,14 @@ void nilfs_btnode_abort_change_key(struc
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		xa_erase_irq(&btnc->i_pages, newkey);
 		unlock_page(ctxt->bh->b_page);
-	} else
-		brelse(nbh);
+	} else {
+		/*
+		 * When canceling a buffer that a prepare operation has
+		 * allocated to copy a node block to another location, use
+		 * nilfs_btnode_delete() to initialize and release the buffer
+		 * so that the buffer flags will not be in an inconsistent
+		 * state when it is reallocated.
+		 */
+		nilfs_btnode_delete(nbh);
+	}
 }


