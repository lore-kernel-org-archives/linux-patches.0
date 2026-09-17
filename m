Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AC54EF15B;
	Thu, 17 Sep 2026 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665426; cv=none; b=gUJHF1VnL61rbhj0lvMmEZsM+/KIooSKpKmFAiX47S5ChRMq5q/NVe6Qk8iocBAmf0JvzWXhhX7UXCYe2hvvu77hGr774er4TLGnmOQ7Himx5xkdHIEaBOLiF0XWW2RdyI5WTNZT0pxmZeugcx/LQWcwRLUCAyYdzACt/j6WXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665426; c=relaxed/simple;
	bh=x2MGvqyUKAqu5lMxFhRZWvzaDKoaudI82qRimtjfSKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al2TLY64xLbT0kzYc3SvV4HyemP5nfu5ZzvJOimSTP2Fvk7CiA9w3shAbxtyjADj2Dapl/5wttEd7OO5W44/9te1X0eRZbkmAVpJqdie85Dzsg/YFd3LD2AH+JcJ+Tx3GcpnroD0WeVOompBRyoeUCea9QHYYCNqz8cI96PFT8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD8fEBAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD8fEBAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2FA1F000FF;
	Thu, 17 Sep 2026 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665424;
	bh=rvRvNhwZIhGvZocJyIQyIJ4QDx5bVlQ7V4hQMnBSrm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BD8fEBApL18Sm5CWAN+9rZ4GO4NelOyRobbHo/9JqBqbQ2YB6pNMmOrc+GsZIg42F
	 +letMUq3V3/f7qcNQZQdvLcYbvZgc9RkNTylej6qYrlQPaeQ0kmkTiG9ngfCpq1PRE
	 iyyQPOCVyKX/lfVbPpPpw3iIYuxjJzYWmSWKXa7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0701/1250] btrfs: restore active device pointers after failed sprout
Date: Thu, 17 Sep 2026 16:08:16 +0100
Message-ID: <20260917151610.893261046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b76efe1856983..792818b66dc4b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3033,6 +3033,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



