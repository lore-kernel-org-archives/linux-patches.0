Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B3F320CAD;
	Sat, 30 May 2026 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163872; cv=none; b=l60duCyad4Hkjxg4m6TB3dJgkjBqmbAzWM6eVjH87mt73pHjkTBr9gavb571nJ56OrVtzyEK1Sx/tYuzY6T+X+/VOR5MnLd0NMjfP2lKTxGfpX71N3WypRZSuG/YMuB2HcmqfHiEehSyaqO7O/1mXUHPEaneLuxQ/sIeeZ5TMCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163872; c=relaxed/simple;
	bh=dVK6fRvS9Y/7iF8u0bIKM2cNr7T9Q3TCb3qjx0avZyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7zEttAvCT9m8kNiu1HOzlh3ClddoeKnzDnx6WrXXzaSP9dCyJ1lFH3gDhkG56U+yghL2iXDYfl5bbUpO75ICGcsXMe5O5fiAX1YdyuRDlQEBWXjAl4BF9PQ+zyFmVO73cVp4u4aJe8oTdSvr5GBpLTXTMEEdHTo0i6+RfG+eOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BouWSTOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BouWSTOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A5C1F00893;
	Sat, 30 May 2026 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163871;
	bh=VziR8lAYdY9JiCcR4xiFIzydivVo0vpWR0/SB3OtdRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BouWSTOEybaQzALEaJ60+2r5LKKfIWxNcBYyXWtuontbzdqKQfEi5/Olm3132Zx9O
	 x0ppClFG40+7qln33HXLbrnkpEwXxgPpPVTM/zEXca46a9IpiFhk/opkOhufZwLWSO
	 pkresX15uOr176V9o3StGAOLw+HbwfF/nEc8Uo9s=
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
Subject: [PATCH 5.15 387/776] nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()
Date: Sat, 30 May 2026 18:01:41 +0200
Message-ID: <20260530160250.505310752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a2f779e0bad4..77e6bae7d5c97 100644
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



