Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A28833C53A;
	Fri,  9 Jan 2026 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962046; cv=none; b=rRhQuZkpiCACYP+Ag7sPJckwYK5N5j8yttRVj/oL6PXbvw05hcdM2BEX4odJM25lCO+64jmTQiI8P5dqriMqVa9fqOs02+wMKSvHo1kPNEfIv3PMsEIQV6ZA+tkRqZlJXyumb18MHGw5AIeczld0F1RF5Ef1GNnqeHEHmC9L8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962046; c=relaxed/simple;
	bh=dMFmX7MtSQY7JG1TSWUstlM4+ar6xdtivTD1Pqo4bac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEuSCtSSNfng8DeQ5FI3kqGm6BRQqJnPwljXPAUInyBMUSsp+TmoS+WUkRd54XWbjBdSOcqxJTWYYPPXsjNqtHZRbnSWnT4+s4m4KiUa+atLvo5D+J+I7bpnj/RcFB4dm3eGzbZU4VxRzCmTzWxA2/D23Yk2duvV4zvcbJUaR3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ma0exD4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ma0exD4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245D9C4CEF1;
	Fri,  9 Jan 2026 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962046;
	bh=dMFmX7MtSQY7JG1TSWUstlM4+ar6xdtivTD1Pqo4bac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ma0exD4KElykSs+1E5zdLG5uihEngfzAFiqDBw6JFOixUOInC8ftfQ5Soa8/i9v73
	 75y4rBppztmT8lWJc3/oOmjMeubEEinD/aqqKm26UzahWdnQ3GReD6cZYHMCjTEwCx
	 koKufi2hkbpsSqXWuTEC6DavguJ94Am2aLWfIwg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/634] btrfs: fix memory leak of fs_devices in degraded seed device path
Date: Fri,  9 Jan 2026 12:38:25 +0100
Message-ID: <20260109112125.972286489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 628238493167f..366cf2e8c51cb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7416,6 +7416,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 
 		fs_devices->seeding = true;
 		fs_devices->opened = 1;
+		list_add(&fs_devices->seed_list, &fs_info->fs_devices->seed_list);
 		return fs_devices;
 	}
 
-- 
2.51.0



