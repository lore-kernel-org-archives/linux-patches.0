Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A8A143873;
	Wed, 19 Jun 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802087; cv=none; b=i0B9e+h7Bhxcf9PFMabgqWZNWpAZ7RCmQd7yG5JLUEm33ZzsnEruNAgqeyhd6U60LW9HqZqgXs31zaok6mi4DDoyAumbiyX41BziJ/uG05cOeKAAJQD+9d5tV0TkHcrOAhxK8r+KYcNLCsVV2Ws3gK3lCZmX1uPFcYEYCi++tkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802087; c=relaxed/simple;
	bh=YKK5CR3KuQqA/5lqDFU7RzK49ua/fYMJ6YaNjWH7BAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDQiG2gC12+m0jpu+/PzyfiP45U31ZDkMOWLywoujnN8+UvqyglRRihwrTD2tQdRKEspiUb06tQwqoL+sFh24ImV8rSPhqAtEeuyQl7z2S+2pxa2uBJsJx2LAq06hoq6xs5KTHNl8VTQ+wSrSrLycM5VqVaWG4I6yf+9AiwZzTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClbB+r2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClbB+r2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EF1C2BBFC;
	Wed, 19 Jun 2024 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802086;
	bh=YKK5CR3KuQqA/5lqDFU7RzK49ua/fYMJ6YaNjWH7BAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClbB+r2CQZr7yXBYrz7Ukm6scL4d2kklo13h9L88NP6HvAuFvmQLXkZEccXdiz8rH
	 gQVlV5UPqntSGtBkv/QxJctVGVqzETMLmUQEOWV4Ukq7awx9bnXk+GtI0eJNEbK6ZQ
	 PqDb79nY6d183/0Wep1uBf0L1hCBn68mK+aTmc7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/267] nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
Date: Wed, 19 Jun 2024 14:53:48 +0200
Message-ID: <20240619125609.310208882@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index c6b88be8a9d73..23a8357f127bc 100644
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



