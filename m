Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AC020A5EE;
	Thu, 12 Dec 2024 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024663; cv=none; b=GEFjhYA5LxctkatqvTFjYkscECCDCZy54UwnaooD0JerGoenG6oS765p1kqJWXjrdAqu84oPL9b1QYm7WzCCSMhEXkpkJOc/GtNsTbY69dhDxiawlgFFH/MS25t4Z07f3AAn+0otvxb5b84dVuMAl5UegYT/4/GGwNjwobWWsf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024663; c=relaxed/simple;
	bh=sGAqpHmElus80Jk/SmEQ+CBoy3N/KJuepRbq1bvh7dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQcdNYfrUVAvSbGXTyb6AZhH+OAJ1gf8oi4YGsHxQDzXz9AXQ7s5ISrfazw3Bb8zz8HU/lqtSe7g0iWyeIUZznoHtppkuj7VVNojlMxKVCFJOJ+f33DQyMblXKAdDjkiEfhxMq22V8geE/MWE4a8bkpk2flZCTPHafzPcsHCLOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lch5bgkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lch5bgkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA35C4CECE;
	Thu, 12 Dec 2024 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024663;
	bh=sGAqpHmElus80Jk/SmEQ+CBoy3N/KJuepRbq1bvh7dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lch5bgkx7A0avBzG+MOBeYxKpiRKUngvR0ZvOOPVNzkGSfsykO4XcVsrp1ZHjXYgG
	 Yegr6TSUUZ7NQwSJyDPj2H59JBZVIWbuUihpjkPXSyttN8Pd2Ia0tISKJXLxVrDtdo
	 tm0M+iYAMn95F593cOHLDe2YbuZ2pVI9G80dgw2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 370/459] nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
Date: Thu, 12 Dec 2024 16:01:48 +0100
Message-ID: <20241212144308.285270860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


