Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8969D4F85C5;
	Wed, 30 Sep 2026 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783042; cv=none; b=Z3Es46vr5oZKJx3D3gWs46b3L3FDim0oCOUZfiEUIGQSbdKwWJRB4rlC5hM6Sn8Zk3qv78RtTBaOprM0GnunWdXrtTNAHRcO+Y2EhuuyGqPgtnPfqBwzfDvqD2ZKoUkfPqz9jmTANo76p3t8zZtQg6hCzH8TV49aiaT4wNqEYIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783042; c=relaxed/simple;
	bh=jWgqNWkAcdIujD0xfXdY4A+4OdRuRlFKXP35ANtG3W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4NjTVswtf/RJZDp1uuvOWUayqkM9gAi0nARulfaB9sUbstjonhL0EEcgSICCukmCMsGbg/WiHwQMPpPW+SHLvvjm2vytOX2Q7VcVPL9rwCcsSn+K27eLAD5ACZ58qmgnwte9fms1qNgwP1r7ukSfEpgvNIlGOY2Q6IFCFh800M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqVcNEtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqVcNEtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D431F00893;
	Wed, 30 Sep 2026 15:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783038;
	bh=0vcVS6BvQND9ZC6kPRLwVr3n2PR0nZxW0uCwM7cEsZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqVcNEtc888ur39ybhOosFqLkj4skzUbZkwzRj96rCWVlWAPjoMeEppR3y2Il6aAO
	 0tFdgCTofDkIZ7k7CTEnNxKiQYdbWIk+AAjxcaJ4WwlnAZXkjgb/S0lNTUwZMivOmz
	 5TnlQ7n0pQsKgckq4YuT+t50ogHyz9Utou3fDgm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/595] btrfs: detach failed sprout device from transaction update list
Date: Wed, 30 Sep 2026 17:21:46 +0200
Message-ID: <20260930152352.314750517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit c93b3c43df561cd9f592cee20ae058b563f9e5b6 ]

When creating the first metadata chunk for a sprout filesystem,
create_chunk() adds the new device to the transaction dev_update_list
through device->post_commit_list.

If the subsequent system chunk creation fails, btrfs_init_new_device()
aborts the transaction and releases the device while post_commit_list is
still linked. This triggers a warning in btrfs_free_device() and leaves
the transaction list referencing freed memory.

Detach the device while holding chunk_mutex before releasing it.

Fixes: bbbf7243d62d ("btrfs: combine device update operations during transaction commit")
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
index f08b6310e0d67..a36a816696f53 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2821,6 +2821,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
+	if (!list_empty(&device->post_commit_list))
+		list_del_init(&device->post_commit_list);
 	list_del_rcu(&device->dev_list);
 	list_del(&device->dev_alloc_list);
 	fs_info->fs_devices->num_devices--;
-- 
2.53.0



