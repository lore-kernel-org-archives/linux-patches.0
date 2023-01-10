Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF2A6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530CCC433F0;
	Tue, 10 Jan 2023 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374669;
	bh=C0j+hwubaVzbBy2zsflSWNv6PYZpDP0K3kDviiz78Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0IfuUao4eiDuX95uVvniug4YOLhOKkxxWCS5kzYWG3FeqjD+eh0TYWfJcDX2hqXP
	 Z5nAFUdThwr26erEUgjxPc263LEprU2y+orTvVK3IAwiL2UGfDtkkQMZmncFF9/YbW
	 u2soMvtqVFPvezkjN8P/rAPlmJPN5V27Uydq6q4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+bed15dbf10294aa4f2ae@syzkaller.appspotmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/159] fs/ntfs3: dont hold ni_lock when calling truncate_setsize()
Date: Tue, 10 Jan 2023 19:04:01 +0100
Message-Id: <20230110180021.257462804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 0226635c304cfd5c9db9b78c259cb713819b057e ]

syzbot is reporting hung task at do_user_addr_fault() [1], for there is
a silent deadlock between PG_locked bit and ni_lock lock.

Since filemap_update_page() calls filemap_read_folio() after calling
folio_trylock() which will set PG_locked bit, ntfs_truncate() must not
call truncate_setsize() which will wait for PG_locked bit to be cleared
when holding ni_lock lock.

Link: https://lore.kernel.org/all/00000000000060d41f05f139aa44@google.com/
Link: https://syzkaller.appspot.com/bug?extid=bed15dbf10294aa4f2ae [1]
Reported-by: syzbot <syzbot+bed15dbf10294aa4f2ae@syzkaller.appspotmail.com>
Debugged-by: Linus Torvalds <torvalds@linux-foundation.org>
Co-developed-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 4f2ffc7ef296..f31c0389a2e7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -486,10 +486,10 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
 
-	ni_lock(ni);
-
 	truncate_setsize(inode, new_size);
 
+	ni_lock(ni);
+
 	down_write(&ni->file.run_lock);
 	err = attr_set_size(ni, ATTR_DATA, NULL, 0, &ni->file.run, new_size,
 			    &new_valid, ni->mi.sbi->options->prealloc, NULL);
-- 
2.35.1



