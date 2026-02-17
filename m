Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C896A8D2;
	Tue, 17 Feb 2026 20:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360881; cv=none; b=eVRXzwLZtx3eMqOkRNADroljhKPQqprbK4WU5ykUJkmvxB9+1QzXiZP6KipJAAOhjtxq4zX1iH3AkKxhZ+xgKIdO3D8/2BmOMC/nLWflML5SAYkolxP4lJhoPa2+TnCDuqkOFtbfJiVRLhKmfHXzUhn5F1KV9vLmVT79ZRRbUAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360881; c=relaxed/simple;
	bh=+01dTYHepQh1aYaeBzbuHiCiFDIfRHTVovEXwgadCNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjZ4nYCD3q9U9TkwBJ4LYM+7BZ0+8/IN47b+Cpazgkm87a1c8TADlEgt6JzPW6zpIsBpZJAvWyi9PJyvDqCACIQKLbltjP98lPFiIgFIYlhnqBxMOD+QKJqi0oRc3tr8488QCD1ieLb/azdDQdWSome32vNzo9pv00naCAKrXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QN06LlOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QN06LlOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D627C19425;
	Tue, 17 Feb 2026 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360881;
	bh=+01dTYHepQh1aYaeBzbuHiCiFDIfRHTVovEXwgadCNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QN06LlOCKqCBciQofcF0WSQoJAjCsQu4rxHHUoWiBBH7joLYthrtjZozqXbth1UfA
	 /GrLyHtUsGWnTqdov2i4Ul2OZ4nuYJ/nmxnhNlRnzFTnSzJwHCjXVhKtnCvlV9Pqu+
	 FEbS+dzvw1l6M2k5+KYcfg9GwsphpviZkXnnTwkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c4e33e12283d9437c25@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/39] romfs: check sb_set_blocksize() return value
Date: Tue, 17 Feb 2026 21:30:33 +0100
Message-ID: <20260217200004.660356555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

[ Upstream commit ab7ad7abb3660c58ffffdf07ff3bb976e7e0afa0 ]

romfs_fill_super() ignores the return value of sb_set_blocksize(), which
can fail if the requested block size is incompatible with the block
device's configuration.

This can be triggered by setting a loop device's block size larger than
PAGE_SIZE using ioctl(LOOP_SET_BLOCK_SIZE, 32768), then mounting a romfs
filesystem on that device.

When sb_set_blocksize(sb, ROMBSIZE) is called with ROMBSIZE=4096 but the
device has logical_block_size=32768, bdev_validate_blocksize() fails
because the requested size is smaller than the device's logical block
size. sb_set_blocksize() returns 0 (failure), but romfs ignores this and
continues mounting.

The superblock's block size remains at the device's logical block size
(32768). Later, when sb_bread() attempts I/O with this oversized block
size, it triggers a kernel BUG in folio_set_bh():

    kernel BUG at fs/buffer.c:1582!
    BUG_ON(size > PAGE_SIZE);

Fix by checking the return value of sb_set_blocksize() and failing the
mount with -EINVAL if it returns 0.

Reported-by: syzbot+9c4e33e12283d9437c25@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9c4e33e12283d9437c25
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260113084037.1167887-1-kartikey406@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/romfs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index b1bdfbc211c3c..82975173dcb04 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -467,7 +467,10 @@ static int romfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 #ifdef CONFIG_BLOCK
 	if (!sb->s_mtd) {
-		sb_set_blocksize(sb, ROMBSIZE);
+		if (!sb_set_blocksize(sb, ROMBSIZE)) {
+			errorf(fc, "romfs: unable to set blocksize\n");
+			return -EINVAL;
+		}
 	} else {
 		sb->s_blocksize = ROMBSIZE;
 		sb->s_blocksize_bits = blksize_bits(ROMBSIZE);
-- 
2.51.0



