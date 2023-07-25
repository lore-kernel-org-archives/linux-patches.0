Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3D21EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3DDC433C7;
	Tue, 25 Jul 2023 10:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282137;
	bh=jplUyhcBfxZAne3W/LLK0tsKT3vr6FP3Fk8hUdI77c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9vBE+z8AU+ULeDe3mzMAY90TrI7SgU+Md/jEtvTmo8wTKQUOGZeZSShFd0IFqCWZ
	 3IrqglLFXTcK+nhrGk/B/JlzsoZGTSp7geKDNJJLgsGZg6SzWO7icsRrekHlc6g4Qw
	 Wl2mymhlal4nM0tWxxVnIXhTYqKEVrr3imm39qEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 021/227] btrfs: fix double iput() on inode after an error during orphan cleanup
Date: Tue, 25 Jul 2023 12:43:08 +0200
Message-ID: <20230725104515.677318290@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit b777d279ff31979add57e8a3f810bceb7ef0cfb7 upstream.

At btrfs_orphan_cleanup(), if we were able to find the inode, we do an
iput() on the inode, then if btrfs_drop_verity_items() succeeds and then
either btrfs_start_transaction() or btrfs_del_orphan_item() fail, we do
another iput() in the respective error paths, resulting in an extra iput()
on the inode.

Fix this by setting inode to NULL after the first iput(), as iput()
ignores a NULL inode pointer argument.

Fixes: a13bb2c03848 ("btrfs: add missing iputs on orphan cleanup failure")
CC: stable@vger.kernel.org # 6.4
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3618,6 +3618,7 @@ int btrfs_orphan_cleanup(struct btrfs_ro
 			if (inode) {
 				ret = btrfs_drop_verity_items(BTRFS_I(inode));
 				iput(inode);
+				inode = NULL;
 				if (ret)
 					goto out;
 			}


