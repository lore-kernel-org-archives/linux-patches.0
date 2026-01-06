Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F084346FA4;
	Tue,  6 Jan 2026 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719763; cv=none; b=mYh+kthers+VEhfA6k+e9uG9KVGQF8RS7p7aapEwEQmi3QG+kYdoHeKOSLG5BF6aPztCthb94jCG+d+aKyEtGmO8329KLdMOXLIEjxIeGy6wdKibhyxKOaRXzfEgJtUgiMq7HACyqisYkGWv5zNvhhEgRkMz7F/fEdlUxgrWR1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719763; c=relaxed/simple;
	bh=KRWSfFNdTVpiwMw0C/H1DHpEb8/daeL/FPNHCLhQDjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3ON03sEV96x63fZI1etsnDY9+kWUwtCsefozINRQjtoYuYkntSeR8R0g3o9XHQ+F3iareGT1aC/agBjX3ZCW5+83FctCX8238ECmn8j8UMSuthePv0QQPTqIwq+3xzr+6nKDWL1/cYK20DVUzLp9vM9J0/gfYoZk5Ut3U/fba0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpkXYzNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpkXYzNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BEEC116C6;
	Tue,  6 Jan 2026 17:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719762;
	bh=KRWSfFNdTVpiwMw0C/H1DHpEb8/daeL/FPNHCLhQDjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpkXYzNw7GRemcJm06Rp7sSkMXuDSh99OlSWBrSAS/drr0n0XGiJl20BgEVhSYhcL
	 qfacjadf4IAf027dBfYhwCzGq3jPpxHWhZrQLIozi3jamDj6bF9xKjUkkq+M/Iv6PX
	 38KNoSxLmzzKO+g+EyO42Elkxe/v2nulo35ZM2B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/567] btrfs: fix memory leak of fs_devices in degraded seed device path
Date: Tue,  6 Jan 2026 17:56:26 +0100
Message-ID: <20260106170451.504439478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ce991a8390466..9c6e96f630132 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7071,6 +7071,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 
 		fs_devices->seeding = true;
 		fs_devices->opened = 1;
+		list_add(&fs_devices->seed_list, &fs_info->fs_devices->seed_list);
 		return fs_devices;
 	}
 
-- 
2.51.0



