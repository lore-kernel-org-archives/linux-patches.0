Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAC7FE
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEAmxlqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F99C433C8;
	Mon, 23 Oct 2023 11:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060211;
	bh=8OlAJz0uf7gOgeaSTmDCzQwx3wnWCnZUh+DSCIEN8Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEAmxlqWKcYf9lJ4zoOdZDinYcrgEWQtl8qBJlFWrrUHPylIVUoCbC1L/aaob+X99
	 KGvD5CIQJwMmoTkoMmwB9j09OW7tu58nfKvbKTu4edsgtoxmOs/mBSKLx029ZM3NW3
	 7rWVR/USjUv9ZPJQ5OmGHzeMpn2GFS1m9IMUtXps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/196] btrfs: initialize start_slot in btrfs_log_prealloc_extents
Date: Mon, 23 Oct 2023 12:56:01 +0200
Message-ID: <20231023104831.243090259@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b4c639f699349880b7918b861e1bd360442ec450 ]

Jens reported a compiler warning when using
CONFIG_CC_OPTIMIZE_FOR_SIZE=y that looks like this

  fs/btrfs/tree-log.c: In function ‘btrfs_log_prealloc_extents’:
  fs/btrfs/tree-log.c:4828:23: warning: ‘start_slot’ may be used
  uninitialized [-Wmaybe-uninitialized]
   4828 |                 ret = copy_items(trans, inode, dst_path, path,
	|                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   4829 |                                  start_slot, ins_nr, 1, 0);
	|                                  ~~~~~~~~~~~~~~~~~~~~~~~~~
  fs/btrfs/tree-log.c:4725:13: note: ‘start_slot’ was declared here
   4725 |         int start_slot;
	|             ^~~~~~~~~~

The compiler is incorrect, as we only use this code when ins_len > 0,
and when ins_len > 0 we have start_slot properly initialized.  However
we generally find the -Wmaybe-uninitialized warnings valuable, so
initialize start_slot to get rid of the warning.

Reported-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c03ff6a5a7f6b..7c33b28c02aeb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4767,7 +4767,7 @@ static int btrfs_log_prealloc_extents(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	int slot;
 	int ins_nr = 0;
-	int start_slot;
+	int start_slot = 0;
 	int ret;
 
 	if (!(inode->flags & BTRFS_INODE_PREALLOC))
-- 
2.40.1



