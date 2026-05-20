Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E0A17A2FC;
	Wed, 20 May 2026 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301822; cv=none; b=JsGoygF0GHQGkRhhozrJ4yehRqDks4sJV1yv+WD6Grr1Rk+90Jnn1xHSs5emb49e4c5hsgXaSG8PlfArJMBQmyJjepz2ZOBCOuREJmkzMldZfNfPZVbX33F27pGbxFKGUvWObaWsFwqETQoi528Vq9uAivRTeDfDwJAY3v4DMW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301822; c=relaxed/simple;
	bh=lvt+5E3N4/defTmYe3ix/GP3MdarMU/Xzcg4vW16Aws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZARTGx6VBR6rVHfu7CVDNOtMWSMA12CRjE7m2IAvpH3iV/7AMMFU5q4+ENTPUXwyPzlV06YKdOjOJjn0ufjhIPNvpazus3J8vhQkfdMD0N3ze0LilbS0o7FIbzwnQS3Jt1LI98Paxh7Hiw4MugnQpo7x9ymkILWOsJ8ich5jwnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aom/pO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aom/pO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32301F000E9;
	Wed, 20 May 2026 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301821;
	bh=uBWh4fnPw4VlsBy6E3Xfp3bL0GOqnC7IrD+TPKlKIfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aom/pO+G6YalUSFQ7rm+csA7qtiKBigX5zWQX0RB8rksxx1pnK3DQdnE6vPj36Gd
	 FFn77tLu6Fvh0GoLyo/cdC9ks5kpqqLOHDIaVUbyVrxegLY7fQyQqK89HBtXm6jpkA
	 7UssnFUzBLyB0YJ5ebCOTZ7KlPWexiCaeDXrKjvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com,
	Junjie Cao <junjie.cao@linux.dev>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/508] nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()
Date: Wed, 20 May 2026 18:17:08 +0200
Message-ID: <20260520162058.697024280@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit be3e5d10643d3be1cbac9d9939f220a99253f980 ]

nilfs_ioctl_mark_blocks_dirty() uses bd_oblocknr to detect dead blocks
by comparing it with the current block number bd_blocknr. If they differ,
the block is considered dead and skipped.

However, bd_oblocknr should never be 0 since block 0 typically stores the
primary superblock and is never a valid GC target block. A corrupted ioctl
request with bd_oblocknr set to 0 causes the comparison to incorrectly
match when the lookup returns -ENOENT and sets bd_blocknr to 0, bypassing
the dead block check and calling nilfs_bmap_mark() on a non-existent
block. This causes nilfs_btree_do_lookup() to return -ENOENT, triggering
the WARN_ON(ret == -ENOENT).

Fix this by rejecting ioctl requests with bd_oblocknr set to 0 at the
beginning of each iteration.

[ryusuke: slightly modified the commit message and comments for accuracy]

Fixes: 7942b919f732 ("nilfs2: ioctl operations")
Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=98a040252119df0506f8
Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0
Cc: Junjie Cao <junjie.cao@linux.dev>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 53022bfe0b72d..1a6868afa9143 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -751,6 +751,12 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 	int ret, i;
 
 	for (i = 0; i < nmembs; i++) {
+		/*
+		 * bd_oblocknr must never be 0 as block 0
+		 * is never a valid GC target block
+		 */
+		if (unlikely(!bdescs[i].bd_oblocknr))
+			return -EINVAL;
 		/* XXX: use macro or inline func to check liveness */
 		ret = nilfs_bmap_lookup_at_level(bmap,
 						 bdescs[i].bd_offset,
-- 
2.53.0



