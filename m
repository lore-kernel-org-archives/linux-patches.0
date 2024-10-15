Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57061D8DEA;
	Tue, 15 Oct 2024 12:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993698; cv=none; b=oEQx1ttNFG3H7rQ7EJkWEq2+Cq6XiAv06tlzy5/IEXkBLRUBS01PiGKNETZ2qR9ARQnyK7GmfTa+vCgnUbkx8ORDD6FPyyjawEKglbKV3Nn3zRoMdEh+iE7APgLzJVC2SdTNBPFSav3Wm0QO2JIkQSA8Z9ZSUgshNVp5YAhRKSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993698; c=relaxed/simple;
	bh=tGcdgTqgVxl6mcv6otN08uaJ2m65Jog2TqYNPQ8HAVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg0qMpeTNTxfsTusChKSi3m8dXI3zdf/kouwfuLnNak/rYXFZxsAiQHVeg51nApM1aRSZa1ilNgFYEwcnEctbOIkhagfmgMAJ8rHnCzCNLADSHQjBFEn0Zwxn96wLAkBqYH7KHvilE/TiA7AZlzdm+QK9HvHifi8JHa2EFxrRTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbgrY0dW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbgrY0dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D02AC4CECE;
	Tue, 15 Oct 2024 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993698;
	bh=tGcdgTqgVxl6mcv6otN08uaJ2m65Jog2TqYNPQ8HAVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbgrY0dWDCt3bAbVe0CIJCiUmt08dydT0yok2FuCVgcQFE8/u5fQG4ivSYHuVLDBF
	 0NkHsefk9QlWMcey1jakOe8k44i9HU0bpnsSlqnDXvDgnzalXwhxVeCV8E5tr+qfOo
	 VOk2g7eE6jERLkyDWH1wntdfaRIgHqofdF/EYH/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/691] jfs: Fix uninit-value access of new_ea in ea_buffer
Date: Tue, 15 Oct 2024 13:26:45 +0200
Message-ID: <20241015112458.486804057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

[ Upstream commit 2b59ffad47db1c46af25ccad157bb3b25147c35c ]

syzbot reports that lzo1x_1_do_compress is using uninit-value:

=====================================================
BUG: KMSAN: uninit-value in lzo1x_1_do_compress+0x19f9/0x2510 lib/lzo/lzo1x_compress.c:178

...

Uninit was stored to memory at:
 ea_put fs/jfs/xattr.c:639 [inline]

...

Local variable ea_buf created at:
 __jfs_setxattr+0x5d/0x1ae0 fs/jfs/xattr.c:662
 __jfs_xattr_set+0xe6/0x1f0 fs/jfs/xattr.c:934

=====================================================

The reason is ea_buf->new_ea is not initialized properly.

Fix this by using memset to empty its content at the beginning
in ea_get().

Reported-by: syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=02341e0daa42a15ce130
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 8ef8dfc3c1944..76b89718fd526 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -434,6 +434,8 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
 	int rc;
 	int quota_allocation = 0;
 
+	memset(&ea_buf->new_ea, 0, sizeof(ea_buf->new_ea));
+
 	/* When fsck.jfs clears a bad ea, it doesn't clear the size */
 	if (ji->ea.flag == 0)
 		ea_size = 0;
-- 
2.43.0



