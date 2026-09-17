Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E04484884;
	Thu, 17 Sep 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659287; cv=none; b=bvEltnInxTpTpmb8MJSE3Sz0lWa7bsB/igWZji9RQdnrYUYwxLp1ewUag4Yujw5m60nCivzvSdCjGKrMv+RMzqPE/dYXadmx6nLKY7yCyTRuKTKMxm+DYrCdHXqpSatGdjNr1dUzDmBVDeiNy5FaZa0jW2D97SNRr77tgzskbTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659287; c=relaxed/simple;
	bh=i+fPaVSUCvnbfdA7On8vayVv969axqxf6+NTcNmOETM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIzs5bd1BL6g31nmZ+6HrnJ2RYfSQJF+g2IrG2z+PvjDwF8KQZjIomazgGAuGKilBeKWFdqCQvinctk54ibaDlYaiExDuf3JRGqrjTgCnOD45CriEImMY2kDhzYUgS2M9vQTMpA8vN7WmqFFWUANEEPzULn1O6oL97DivWbjdQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6ZfGDm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6ZfGDm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164031F00898;
	Thu, 17 Sep 2026 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659276;
	bh=78lFOSAEepdUJLJf5W5AF/NcS6hz3RfgRKqrcsN+s/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6ZfGDm0BwGz7VCs9BtejvgvGVyXXaSYCsFJnzIxOVg9O9Q1FBHWHH7CIhwWq2Fzj
	 uYpqsVzPVaUvRyd3+Z+OAXXhWrOL0xQx+lYYzxWjl9R5peVzcrbE/h59RmIwf4tcnp
	 SAWdwvHSHB8HBlbIMH2wMYmpJketosXZdpa6z2as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 165/733] btrfs: restore active device pointers after failed sprout
Date: Thu, 17 Sep 2026 16:07:53 +0100
Message-ID: <20260917151355.195561822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 556d8a60a5ec9..b90cbd1e3ebe3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3070,6 +3070,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



