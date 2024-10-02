Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF4C1D04B8;
	Wed,  2 Oct 2024 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880085; cv=none; b=WUTS1EW7amjo5Bn2tl4+u36OIlkmgL0+bmmUITbAsJ7ypd6Zo4enZnzaGcSWxd3XPMRu/6sa/k0pqMegceV14vpnhV/VOk3lijKMqwxXzQl5NstJqKkTfPkAE3VRJaTyBz4OY80BRAEZj6OIvK9Yz1Lf2f1kQGwzbC73PXqpj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880085; c=relaxed/simple;
	bh=jw+p8tug60tD2/pKrKmnuSjk0H6Y/Pl7tGh2FBI32/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0pk0J2wKBRTF05J69V/C/0LURRhAo8QMjqH8cwDAbGSFjUCVOP2djU60bCGj1EgI05TVVWKfQBBZ8Rl/uZX+RHbbhDXuyCkhbFWY5gIvnf+AxOHN3m7GdwBK4Q2cLiVnqtAAQeOKDTiRlY2KpEW51qQ08y1sUh7nfHO2f7O2dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0FRzOxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0FRzOxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63899C4CEC2;
	Wed,  2 Oct 2024 14:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880084;
	bh=jw+p8tug60tD2/pKrKmnuSjk0H6Y/Pl7tGh2FBI32/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0FRzOxPqE4C+7UzDOwm0CjKWOo5U6OpuLLG+TSCExzz4T/UtU8FNWTlOigttjDBG
	 +2paCihrGUL0jmawzp/fMmsfL2gq984OhRy11pcoHrCQu451WMck4UV9fqCDg+3KWn
	 uIARGTLCcdJaGikBhYfICDzE5S+2NxiB+nAT9exw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 339/538] f2fs: atomic: fix to truncate pagecache before on-disk metadata truncation
Date: Wed,  2 Oct 2024 14:59:38 +0200
Message-ID: <20241002125805.812305978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit ebd3309aec6271c4616573b0cb83ea25e623070a ]

We should always truncate pagecache while truncating on-disk data.

Fixes: a46bebd502fe ("f2fs: synchronize atomic write aborts")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e04f4dcb76d1f..2f08bf7f29621 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2161,6 +2161,10 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		F2FS_I(fi->cow_inode)->atomic_inode = inode;
 	} else {
 		/* Reuse the already created COW inode */
+		f2fs_bug_on(sbi, get_dirty_pages(fi->cow_inode));
+
+		invalidate_mapping_pages(fi->cow_inode->i_mapping, 0, -1);
+
 		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
 		if (ret) {
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-- 
2.43.0



