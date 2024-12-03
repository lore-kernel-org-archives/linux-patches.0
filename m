Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC21F4704;
	Tue,  3 Dec 2024 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236469; cv=none; b=ecc8fo1oIqtciPnsKp77ZF7i+z3q/Lmt87Y+4TEUHtIP0558SeYyepuzTrwvW3qBq6JnYcLorGzF0zxie107ZAxnABAGDnP0CCjwt/uYDLH9JbkPE+FPZDYD0/QvbdrGusxIwCAd+xhxmPA1G4mzZwrFTSykdh0Xb8Y0EkLg+Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236469; c=relaxed/simple;
	bh=l3SSTw7sKger6gL8jC52YdKytIssH2zVNZIfTVcGQCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm5v5E6Elw+xlisonTi+ys/IIbwoDEzuJ/QXsT+5ln58i2Uu/+n0bPNZnTnVJ3LnG6FbKZRs+3KHdKSKqd54vAwqld77RN80UwCDrZtMFEV/MjZ3XoqYvrYUEs7xZpAf3VjC/Uw1WlhmKV/D78wRnDoHNHdoJFJWU1iseL8sR1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWLj6t+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWLj6t+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3BFC4CEDD;
	Tue,  3 Dec 2024 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236468;
	bh=l3SSTw7sKger6gL8jC52YdKytIssH2zVNZIfTVcGQCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWLj6t+cjsSohDem7EF6+wpU9yAsvivbpZ5IRINacTEww33ELZs7cNOWIzqVqY8Ix
	 6DcgTK2uHI+gLpRq/F8IQmNQiAWdXVOmyNv2oFGjHO8CFGm6cb7gCqUiq3alz9QBA1
	 CH+4hrZsljpQZtSMyI5tRyPEBtQgUCmQ8CVoDGKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Ubisectech Sirius <bugreport@valiantsec.com>,
	syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 003/138] nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
Date: Tue,  3 Dec 2024 15:30:32 +0100
Message-ID: <20241203141923.664304136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit cd45e963e44b0f10d90b9e6c0e8b4f47f3c92471 upstream.

Patch series "nilfs2: fix null-ptr-deref bugs on block tracepoints".

This series fixes null pointer dereference bugs that occur when using
nilfs2 and two block-related tracepoints.


This patch (of 2):

It has been reported that when using "block:block_touch_buffer"
tracepoint, touch_buffer() called from __nilfs_get_folio_block() causes a
NULL pointer dereference, or a general protection fault when KASAN is
enabled.

This happens because since the tracepoint was added in touch_buffer(), it
references the dev_t member bh->b_bdev->bd_dev regardless of whether the
buffer head has a pointer to a block_device structure.  In the current
implementation, the block_device structure is set after the function
returns to the caller.

Here, touch_buffer() is used to mark the folio/page that owns the buffer
head as accessed, but the common search helper for folio/page used by the
caller function was optimized to mark the folio/page as accessed when it
was reimplemented a long time ago, eliminating the need to call
touch_buffer() here in the first place.

So this solves the issue by eliminating the touch_buffer() call itself.

Link: https://lkml.kernel.org/r/20241106160811.3316-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20241106160811.3316-2-konishi.ryusuke@gmail.com
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Ubisectech Sirius <bugreport@valiantsec.com>
Closes: https://lkml.kernel.org/r/86bd3013-887e-4e38-960f-ca45c657f032.bugreport@valiantsec.com
Reported-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9982fb8d18eba905abe2
Tested-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/page.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -39,7 +39,6 @@ __nilfs_get_page_block(struct page *page
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
 	bh = nilfs_page_get_nth_block(page, block - first_block);
 
-	touch_buffer(bh);
 	wait_on_buffer(bh);
 	return bh;
 }


