Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636471946C8;
	Fri,  9 Jan 2026 12:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960149; cv=none; b=pIinKbzTAMUsPLuK4ZAJOeCpvIs/G7V2zqvXb4AbDb9CDVmTBAqq+BdG4oYEJECG0ORs/0T+FkcsBCQMqJ8l5AYbD5MYgcAV+tTqPHp6vXU6rwsbVYKoyRtMD1ewV0jswrZP7o6nhUHSWMizXTpYTPctFsAerY0wXafrbjgkjAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960149; c=relaxed/simple;
	bh=arTxFakQqJNAt2/PSRgWAmbrJSeeTOpIuQyH3lqpqHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2i5L2tN+6ChnSZctMHjPB7hTrP8BVd7TSFtUkt7V3FyHFWDFpkFWFrbZY5Ch7Kvpnbnv3rhu/hfNae04UwJBhsdP6J01COyx/wkCW2JQoj+vTywm66JIeTY0pZy1X8iYSd15ugvbGx98Y0+kGRLPB0vnxwkdMUq3QyUpmlWPMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ea6TxqMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ea6TxqMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7365C4CEF1;
	Fri,  9 Jan 2026 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960149;
	bh=arTxFakQqJNAt2/PSRgWAmbrJSeeTOpIuQyH3lqpqHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea6TxqMFocFhxgisFgQZYh1YI/LhEBQe9+RBbE4Pbydkq1eOBQpgY4I0ReXRnkHeN
	 mi93tr+jM7YiHa4ZVQsvhJzyN38Tp3rlpDfTSZDKTrMZ5lE7UtJ4ril9elvJTCtx0M
	 ppUeMMz4PtQPX0/zn28IlOeRRFRPcGHLmh8gLBM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/737] btrfs: fix memory leak of fs_devices in degraded seed device path
Date: Fri,  9 Jan 2026 12:37:21 +0100
Message-ID: <20260109112145.367564386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

[ Upstream commit b57f2ddd28737db6ff0e9da8467f0ab9d707e997 ]

In open_seed_devices(), when find_fsid() fails and we're in DEGRADED
mode, a new fs_devices is allocated via alloc_fs_devices() but is never
added to the seed_list before returning. This contrasts with the normal
path where fs_devices is properly added via list_add().

If any error occurs later in read_one_dev() or btrfs_read_chunk_tree(),
the cleanup code iterates seed_list to free seed devices, but this
orphaned fs_devices is never found and never freed, causing a memory
leak. Any devices allocated via add_missing_dev() and attached to this
fs_devices are also leaked.

Fix this by adding the newly allocated fs_devices to seed_list in the
degraded path, consistent with the normal path.

Fixes: 5f37583569442 ("Btrfs: move the missing device to its own fs device list")
Reported-by: syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eadd98df8bceb15d7fed
Tested-by: syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1eb543602ff12..8207b0b4c43a0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6966,6 +6966,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 
 		fs_devices->seeding = true;
 		fs_devices->opened = 1;
+		list_add(&fs_devices->seed_list, &fs_info->fs_devices->seed_list);
 		return fs_devices;
 	}
 
-- 
2.51.0



