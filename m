Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F721DFC7;
	Wed,  3 Jul 2024 10:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003854; cv=none; b=EiyJkmFjhkaLlCOiwI1+3U0PAewvPmixqQXLkTepgeLaZIQ44HWlSshKS/raoa3EDuJqHdoJsqeFjaB0zkLYFfZfEQ5JD18dVtLMyCCyTZeJaMl6hvbq6srhgC4C2+vgLY6pmYg/utbOXwPx/zsn0xwSwLt0korYxwG+nChaXZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003854; c=relaxed/simple;
	bh=8AVJSyXmLz8qouher13quOl3RqY9s4SUHACa/O9z/Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzBZy6NgWxuUQzQ60KluDHaPfUr6Us0TA9oXlJgFOnMl6T5ZsI4FOwNd+2HtSbBvndKLCqeBvybamc7QS2c1d+K/fLD0UTGlSeoBQQNcwrUXK7L/F2ZdIjS8rVzGM8Khz/KWbAy1G4nasUzvGiCsGqZH9hs/NkmAqbwEE9R/3MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzY6AkOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzY6AkOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111B5C2BD10;
	Wed,  3 Jul 2024 10:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003854;
	bh=8AVJSyXmLz8qouher13quOl3RqY9s4SUHACa/O9z/Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzY6AkORSlgLy2gn7RyJ6VD31HZfxuFZ9fW8BnYmkBilTSpnzCCzo9ZEUTY5LQoL0
	 5+0dV9Kis0U6shin3gpUllWhVAr7u+JbOFaVHnQdByigG87UbxmBJg4MkYxWjGmq1n
	 w/3tFHHauU3haMb0/l9tBTCS8OcRcxT0D7w/eYb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/189] nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
Date: Wed,  3 Jul 2024 12:38:23 +0200
Message-ID: <20240703102843.100802133@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

[ Upstream commit 7373a51e7998b508af7136530f3a997b286ce81c ]

The error handling in nilfs_empty_dir() when a directory folio/page read
fails is incorrect, as in the old ext2 implementation, and if the
folio/page cannot be read or nilfs_check_folio() fails, it will falsely
determine the directory as empty and corrupt the file system.

In addition, since nilfs_empty_dir() does not immediately return on a
failed folio/page read, but continues to loop, this can cause a long loop
with I/O if i_size of the directory's inode is also corrupted, causing the
log writer thread to wait and hang, as reported by syzbot.

Fix these issues by making nilfs_empty_dir() immediately return a false
value (0) if it fails to get a directory folio/page.

Link: https://lkml.kernel.org/r/20240604134255.7165-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8166c541d3971bf6c87
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 22f1f75a90c1a..552234ef22fe7 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -627,7 +627,7 @@ int nilfs_empty_dir(struct inode *inode)
 
 		kaddr = nilfs_get_page(inode, i, &page);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);
-- 
2.43.0



