Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8231DB34C;
	Tue, 27 May 2025 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366139; cv=none; b=maptAlJ6PpIH0dpYRGTt3WpqqBbJ4V7gj+gN2hhJrz/4/yq0Q8TZgkr4PhdNSmp3/b7BCbBYcYVJ33UCM7paPQZMQHQ9p5dFCnps6mxoYnvCirEm6sI17VtRHiBLflIyf8fQexDMO7ngftu/s0FMr087tG1Vv7Ut/euyOv9w8/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366139; c=relaxed/simple;
	bh=SY6e4pn38EE+o/7MFced7T8f5pfGw/SYY4dxDBtz7YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwBy47M9/p2rblmNbHP84JLQRzUArHLPi3vZLYKJpbZREyDUn4k5/XLNclx6rgsT7RGcz70dEFcOLXKpVOzAY+DdWbEEhn05SwMoyw8GmA+9mzkExvUml904AlA0Gm9eSQ8Ppl3cUbRDoja9FqZtga4LAy17iQLqpA3kIzhpQV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylubLGSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylubLGSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E2DC4CEE9;
	Tue, 27 May 2025 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366139;
	bh=SY6e4pn38EE+o/7MFced7T8f5pfGw/SYY4dxDBtz7YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylubLGSmG+jIc7T7fxQvVq7sUOXB/HjYj2SxF261txdNFGikf7FSSeLoH4IEKAd+9
	 1PmL3zGugKqjthc2p+rzOe1Zc5BpfNLtKer2lT3NyFCkCy3AWwW83qHexJWAfVXHab
	 9yzFi2B4f/AtZmi1IJfyyG+u0iqtBFYoJMQepWNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com,
	syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 603/626] nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
Date: Tue, 27 May 2025 18:28:16 +0200
Message-ID: <20250527162509.497368790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit fb881cd7604536b17a1927fb0533f9a6982ffcc5 upstream.

After commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") was merged, set_blocksize() called by sb_set_blocksize() now locks
the inode of the backing device file.  As a result of this change, syzbot
started reporting deadlock warnings due to a circular dependency involving
the semaphore "ns_sem" of the nilfs object, the inode lock of the backing
device file, and the locks that this inode lock is transitively dependent
on.

This is caused by a new lock dependency added by the above change, since
init_nilfs() calls sb_set_blocksize() in the lock section of "ns_sem".
However, these warnings are false positives because init_nilfs() is called
in the early stage of the mount operation and the filesystem has not yet
started.

The reason why "ns_sem" is locked in init_nilfs() was to avoid a race
condition in nilfs_fill_super() caused by sharing a nilfs object among
multiple filesystem instances (super block structures) in the early
implementation.  However, nilfs objects and super block structures have
long ago become one-to-one, and there is no longer any need to use the
semaphore there.

So, fix this issue by removing the use of the semaphore "ns_sem" in
init_nilfs().

Link: https://lkml.kernel.org/r/20250503053327.12294-1-konishi.ryusuke@gmail.com
Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
Tested-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Reported-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f30591e72bfc24d4715b
Tested-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/the_nilfs.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -693,8 +693,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	int blocksize;
 	int err;
 
-	down_write(&nilfs->ns_sem);
-
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		nilfs_err(sb, "unable to set blocksize");
@@ -767,7 +765,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
-	up_write(&nilfs->ns_sem);
 	return err;
 
  failed_sbh:


