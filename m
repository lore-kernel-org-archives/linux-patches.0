Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F43513567;
	Wed, 30 Sep 2026 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785032; cv=none; b=lBjSAFnKmElRWgta7ZEm0FwFWGby/FZ91DXtq0GExnDAdhMX3L29cCQWtjrCjIprvFZey3bvR5rtfMXar46LUj67bMhiB3pQ4EwwFRS6VzGnvmPPkTmuBv5diobcQSCKdmJaaaTCIZXMsgp/d+RwuxbeHCHmvV6pTY+uGBdwUn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785032; c=relaxed/simple;
	bh=H1yy3PxsGzBMZiB4Dn5XsVMCzcIrotK6iAsD/Y+GT/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpezTQOsEt4z8NdDIz83LqDQ2OnzfiqbxfL5JketbsN7M08ZwAIBUGwTimr25A8MnSGqL1UEJ8fd3+dU71+4igX7QrZ80oYYHQIqVNBJ3tX4kbJOLW65J5zWMbkfD8ZUZjo3KGjkaIgrI7w2K4UuWS4uu0ucOTgqwCJ8SyEONws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/KmyEPe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/KmyEPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D926B1F00893;
	Wed, 30 Sep 2026 16:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785025;
	bh=ekGAaL64+gt7m8+2qgrVKL14zXcLr+Q+Y/zYXkaKT3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/KmyEPer8/3/0T1GGt30bPHczr2ki4lkaEELXVa+k803g5vFKmBsszBuCjG6KZ2c
	 MH6nB3eNACsKMQB1abzqTP4nLZH/bGs/hb/6Z9GkDFbFyGrzm5bxn0Q35zXcTh1bEN
	 ODHgLmr4gU9hRTfxFjcZHw2PD76AowsYzueIZMr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 364/982] btrfs: restore active device pointers after failed sprout
Date: Wed, 30 Sep 2026 17:18:20 +0200
Message-ID: <20260930152424.631196858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit e0b54613aabeb8e9da597f23b90c6a03d0981986 ]

btrfs_init_new_device() switches latest_dev and possibly s_bdev from the
seed device to the new sprout device before creating the first writable
chunks.

If chunk creation or the subsequent sprout setup fails, the error path
releases the new device without switching those pointers back.
btrfs_show_devname() can then dereference the freed latest_dev and crash.

Restore the active device pointers to the latest seed device before
removing and releasing the failed sprout device.

Fixes: b7cb29e666fe ("btrfs: update latest_dev when we create a sprout device")
Assisted-by: Codex:gpt-5
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cddc3d7908a4d..f44a3fc149711 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2893,6 +2893,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_sysfs:
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	if (seeding_dev)
+		btrfs_assign_next_active_device(device, seed_devices->latest_dev);
 	mutex_lock(&fs_info->chunk_mutex);
 	if (!list_empty(&device->post_commit_list))
 		list_del_init(&device->post_commit_list);
-- 
2.53.0



