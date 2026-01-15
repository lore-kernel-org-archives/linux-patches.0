Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526953BFE5F;
	Thu, 15 Jan 2026 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499240; cv=none; b=T3e/Ec5qf/wuqDPUi6QvK2wTWcYWs1K7Hq5AiNyONwWQd7cmwYyByba94qkAuaCcp83BuI3qd09rh98uxr7zucLP31AEzmr9pfquCHdqU2dBEl9CI3MKSrh95FrTuWeQn1+4qEgs1iDAscA1h+4z91GY7BW3kwNP8tD3vyua3Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499240; c=relaxed/simple;
	bh=vAcruV3qsmgntAAN3p1ReQUIA0M6HiDZZaVMd1Hqh24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quDsCOlvzMDJArXe3ZjUXDwYvq2GTpygT7xEI2YZBYrGljmVRi6o+tMGdjofomOx+iZ0RxW4HGwbqgbKra8JNYcLaK18Xkzu/P8TsRqdy3kICghgEbY3jUGfj+OeKEti3sCu7+W95Gv3TqPm9hGYOKGYy6yhsT1GCBGJka/IOAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rem5eMaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rem5eMaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D157AC16AAE;
	Thu, 15 Jan 2026 17:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499240;
	bh=vAcruV3qsmgntAAN3p1ReQUIA0M6HiDZZaVMd1Hqh24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rem5eMawWmkPUJdJZ8DtD/nVT+C8GBstjX5bv5zoC7cJcg5ciIdKt2fBOgy0HDTy/
	 vRRHlCyFnFyljnr2oriyxojvlxzugzoMHCZITPmNo53AprA01+8SS91gP082fg2lmI
	 tK5AIpMN1XiH70DmD0u2K+MSF6v6/QxBpMLU/gF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eadd98df8bceb15d7fed@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/451] btrfs: fix memory leak of fs_devices in degraded seed device path
Date: Thu, 15 Jan 2026 17:45:57 +0100
Message-ID: <20260115164236.556461436@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 9c1a7b3b84e42..2bba6e8d43740 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6899,6 +6899,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 
 		fs_devices->seeding = true;
 		fs_devices->opened = 1;
+		list_add(&fs_devices->seed_list, &fs_info->fs_devices->seed_list);
 		return fs_devices;
 	}
 
-- 
2.51.0



