Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6BC213E97;
	Thu, 12 Dec 2024 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016313; cv=none; b=eCFCBvwhIDzaLxmmvcqAnu33DB4pW6YDoHx4V82LG/B5hQ2KtMz111TxfFDJIRRc6OYK84mu0YBN/RB7UP5GKIvD9DJFKiLiY0It3z3573toWtFFV76yljMDa6ONSlazknEP1k9JgDBgmKbilV/Xb8wKw2coqr8zkDpqSUE4ioY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016313; c=relaxed/simple;
	bh=f5+5hlzKu0AYsa+lEOx449azAQ2F6XKGDFBKSwTKpic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW7+pix/VpYVSadF4B8YP6SZrfPJpn+NiJXeXXih8X5Rlwva64E3K7ir1Zc+ApdP2nMbTEnsTeIwx10tpmFXLlVI+n3Gw07gEZmg+5QncBh1AXWqDpN8S4BkSou+yzQz6kETHmeB958f0VdQijvMibcC2aSpQEIKuputswpDo4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqaanaib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqaanaib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796D3C4CED4;
	Thu, 12 Dec 2024 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016313;
	bh=f5+5hlzKu0AYsa+lEOx449azAQ2F6XKGDFBKSwTKpic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqaanaiba14Ut8W/pmVKT+mw6vAJqFEag4EZxDP5NYx2iBQe9eQ87B2pyRSu10muB
	 hy9bPUGGq4Viax4Y/0TLeX5pGdeRsViH24z4CAXFT5VssNo7Lg5W51D9KkoEdQoc9Q
	 b60bQFG2L7++ap+jdugwt7MAAL2+AiWk5ICsJ+u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 155/466] nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
Date: Thu, 12 Dec 2024 15:55:24 +0100
Message-ID: <20241212144312.921700272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_s
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned int last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)


