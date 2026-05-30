Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F633313E34;
	Sat, 30 May 2026 18:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166163; cv=none; b=eYXc0/vt0pKmCQVUdxGdlWCMQSRQoqseF21Y3zBAqdA7FbrJJV22TpSdrAvrgzP2J/z7u0LqDYEOACY8Ydq7g8tu1vL7MGSyCSQF3qsOBmXOOGuK3RayuYLu+MoHIOBzdcARvKOxiL9pxl4Mqo8AsQ16EwvdGjIhhyqOGibr0Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166163; c=relaxed/simple;
	bh=wAW80I95rKjErasPz7mP/R11sSKF+qOIZya2Q+ctUpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i19qwgGuzZurIhNop2pT56hTD6NEv1MTY87Qk/lJjmkp78q2Wgl8qGsmXTstiwxVIXwBNnvpc136SaT7BqqJvcBTsEr12yNJSibmNtem9PaVc92tf6Tnw8EuZXVb+we42jJDE9uch6dtOS0TVvGD9NSdN3RledCUjG2ZNwFIVYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJJ14Ru+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJJ14Ru+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF32F1F00893;
	Sat, 30 May 2026 18:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166162;
	bh=YWCB66azR2oFmFLxko47YO+fPRXm0+c99CYuMwrgKg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJJ14Ru+TxLhiWhTiotXPXBUi0/uCIKhh/X8GZEncLWXF9VPOYooZ5rW4r0QMHOF0
	 fVgpcx8ALA33dXiqrhWtKoNf3KOn/FfkHWyfp9ONfN22ME6XGiB9J7AK1qauxvzaWl
	 JdpLZuBEkjSHUgxnSoDt2bVZ90RGf8VF850qlQl0=
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
Subject: [PATCH 5.10 293/589] nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()
Date: Sat, 30 May 2026 18:02:54 +0200
Message-ID: <20260530160232.644400039@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 668c1b28a940e..e56e871927417 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -766,6 +766,12 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
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



