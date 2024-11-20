Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6421B0109;
	Wed, 20 Nov 2024 12:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107599; cv=none; b=XPtbCVrxmo2kAKGfu9C5bztyLfrEVjpk5cy73JTPzw9cmmf4c7T2Pex5p02N+RCKLksgeZXsrl72SOmV8LzyoEF3gb31Igo7uoFLzyez4x8d8tx3950+1HK+FbSh/qwHzC5jZICgSEtyAKplZ82oIqlYOQ90aZHctpwkas8ejS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107599; c=relaxed/simple;
	bh=2VcO19Q9HcwXQXMuMCEgtJqY+qt7b/NrAHviBceylVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQhM3efWJgzvwQwKizELO7vWvoENluX3PnaKuJcUquROKH9sWPdRNAZZvTpR4AjOWsV5upm/ELuyv7KORpPUN2yjux5E9iq1WXzgvHA5bBDryDiD7ftM2puqzthffaP3kMuJa/XS7mwyQaqXr+cH8Ot8UYzUnOlEFUtTA/9KOUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbbmQLD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbbmQLD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A1BC4CECD;
	Wed, 20 Nov 2024 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107598;
	bh=2VcO19Q9HcwXQXMuMCEgtJqY+qt7b/NrAHviBceylVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbbmQLD83m+Z87ShX9GR5YtGnI1QC8QUaLkDSYS7hegAhsZ/M8hyyIBQiwPBxTWLA
	 kb/BNwVOOnCHeNPvGVKxeF19K+FYxHlKIu9hrsNUfRcYWWFYA6UGzFENNUUkUlb/3u
	 /Xr4SfjAB6rbg9COrRKElzPQH8uS6pHP0FoFm40E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Ubisectech Sirius <bugreport@valiantsec.com>,
	syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 39/82] nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
Date: Wed, 20 Nov 2024 13:56:49 +0100
Message-ID: <20241120125630.493661035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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


