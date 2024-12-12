Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81E222EA0A;
	Thu, 12 Dec 2024 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021127; cv=none; b=N3nbpdmHwnoKk1kgEPbWnHBR/GNT1zO+LGh9DpfEKGHMxceVcOgodvnTq14w+Z1GV2nJFqocJM0QamV8GteIuJvFHChPG2u763mWaeB0qsE73gfdjfEYXbFqvgrGO+dtBF9ef6wCX48UW3YxxNqzsU4sPnaabbQvGvT6czpHxT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021127; c=relaxed/simple;
	bh=bsJaaKjcuf5wE894BCs6t1gw4f9sSRv8WBQzuCgoFls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRBEKEYfQmH0eSmhCOhT8JC5TK8RcmWsDACeviO36XFFx+Nh2Ds52X71HPvdPd7c7LGsL2l6vZ7E8PBC9NSvv0YxhEii43VUFS3lFdF+0axJG1bwM2sKIkpVjGN0QmDRN888tNGGyE//idC9Qg54C9JXxfoGH/fco7lb8FyJUYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOUGQabo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOUGQabo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D6FC4CECE;
	Thu, 12 Dec 2024 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021127;
	bh=bsJaaKjcuf5wE894BCs6t1gw4f9sSRv8WBQzuCgoFls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOUGQabo/aHs2fvLVlQVmY/0ZtbmurK8J3GRJnDxmebMrqGxXrCCJZF15GCcHgDH0
	 trFPLOaVg3Gi1fgFAF6SekT70vhC98S0wkv2coFlWXnugpF41PjTBTSBKUk0FAWSKA
	 4SpYEI207Agkrs9PyVNgzF5g2WIT/pFLA5SGp+1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 623/772] nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
Date: Thu, 12 Dec 2024 15:59:28 +0100
Message-ID: <20241212144415.666105962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

commit 985ebec4ab0a28bb5910c3b1481a40fbf7f9e61d upstream.

Syzbot reported that when searching for records in a directory where the
inode's i_size is corrupted and has a large value, memory access outside
the folio/page range may occur, or a use-after-free bug may be detected if
KASAN is enabled.

This is because nilfs_last_byte(), which is called by nilfs_find_entry()
and others to calculate the number of valid bytes of directory data in a
page from i_size and the page index, loses the upper 32 bits of the 64-bit
size information due to an inappropriate type of local variable to which
the i_size value is assigned.

This caused a large byte offset value due to underflow in the end address
calculation in the calling nilfs_find_entry(), resulting in memory access
that exceeds the folio/page size.

Fix this issue by changing the type of the local variable causing the bit
loss from "unsigned int" to "u64".  The return value of nilfs_last_byte()
is also of type "unsigned int", but it is truncated so as not to exceed
PAGE_SIZE and no bit loss occurs, so no change is required.

Link: https://lkml.kernel.org/r/20241119172403.9292-1-konishi.ryusuke@gmail.com
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
Tested-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -76,7 +76,7 @@ static inline void nilfs_put_page(struct
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned int last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)


