Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E5223C51;
	Thu, 12 Dec 2024 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025704; cv=none; b=RyOHjldLcEqk2kXt7uLBI4WrDLzDiaoAiAt6kcEZ6Lj5sVa1+bJwEgEzsjyMmEGEx36/qleSGITcAK1vKnoGeSBOtapj7tqRhlBofawP+6ryvUmrpn2TjXOCioorvEl940VlJclVVhwN2+2ck2gqP2gmFhuNAcD4jVIhfgCccgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025704; c=relaxed/simple;
	bh=R9JsiXqWanI8JQHT6vdgqshz2Tv5ywGM/T+DQuhDLnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa5hTUrG0DaXeen93rcwWIipZrJIJvWM7JRYuzupqEzj2TTdX/dvwCsgpUHyAR3kgtappZSd1F4G3RemH/eS81lsuLHv4MGwCCmPwk/LGZw5sgU/zNYN6kP0YDRcsEnCuCoJImH8+pRhcEegyEXjpQkGIS/V9Aj91nZQqyRii+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0hducaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0hducaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7D4C4CEDE;
	Thu, 12 Dec 2024 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025704;
	bh=R9JsiXqWanI8JQHT6vdgqshz2Tv5ywGM/T+DQuhDLnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0hducaT+XPQU9m5a1l52T+r+qopxtCwvCuGFsk1xbLNr82TQ0XK7zOuPutjHXWAa
	 1DhrRQzBPG3gBWCvbH8hI9vbJB/0fkn8ln0Y4kjuyHyY/ctusjPz8iceFb7fHOc7d3
	 E5YzdCQycsIOB+9sP3G6PM9iDykAPJTnpHiUsm94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 259/321] nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
Date: Thu, 12 Dec 2024 16:02:57 +0100
Message-ID: <20241212144240.197583741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


