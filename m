Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79673502A0;
	Fri, 21 Nov 2025 13:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732785; cv=none; b=qGiQja+E9QBcNkYdDeRkYpc5l2zOqbI4rcw2hUs+JiYyZZuJzuoV6dEiJBt4cXRv6Jx/2JoFxxZUEt4KIP9F48EB+Nil9p7VKbOvgc0yRyz2NWRc4Te0xQ/WhTtQ675EICrE+RpmLKbf29bQUcy+Zxeiz2UInihaS/zkxRZyzWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732785; c=relaxed/simple;
	bh=jOBTDxxXaRL1RHlhTA99opZDml7nYxo3dlxr7YDUVhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7Ncu67UnNAnpCAYrd/S/IFHYawvGonL7Ixzu/oht2dlBZbtUAwYTa2qboZxfma3m/YgyVvvtUPsP65C/qD6hfp8GPdc6wBATqtSWrU6aHfNGJLD/3acSH9KFX1Xy239xmaYapq1KhyehPCAZcdwowp9D7ODzwTuRpWI+V2LsUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM0Lhro+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM0Lhro+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD19C116C6;
	Fri, 21 Nov 2025 13:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732785;
	bh=jOBTDxxXaRL1RHlhTA99opZDml7nYxo3dlxr7YDUVhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM0Lhro+ZnwlkacK9cvLrp+HMXtZQ4PjmRSY3Z3OsxY99zO7MPNlkX9qQBcmHJDbM
	 hxYkr/NU5eT5e/iAkTYdQ0xJk7X2JiScpGff+gAmuPbh1oIcAjIuVTbBDjV0xE24F9
	 FOo9L7vSlC+CansHiQE6JCxyMgDKXnipjSiU9xuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/529] ntfs3: pretend $Extend records as regular files
Date: Fri, 21 Nov 2025 14:08:28 +0100
Message-ID: <20251121130238.453407921@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 4e8011ffec79717e5fdac43a7e79faf811a384b7 ]

Since commit af153bb63a33 ("vfs: catch invalid modes in may_open()")
requires any inode be one of S_IFDIR/S_IFLNK/S_IFREG/S_IFCHR/S_IFBLK/
S_IFIFO/S_IFSOCK type, use S_IFREG for $Extend records.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0150a22102098..a967babea8a59 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -464,6 +464,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		   fname->home.seq == cpu_to_le16(MFT_REC_EXTEND)) {
 		/* Records in $Extend are not a files or general directories. */
 		inode->i_op = &ntfs_file_inode_operations;
+		mode = S_IFREG;
 	} else {
 		err = -EINVAL;
 		goto out;
-- 
2.51.0



