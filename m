Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB763DDDBE;
	Thu, 17 Sep 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668944; cv=none; b=ZT1s3C1uRvfuSEowv9f2nNyTmnIb6dg5ygOL0qxekIel+wB0i0vnNQp018yia60on548a4Jo2+SBYrCjg9KZ3FS36e9lsQVsE0KTpXQ4GL7dJh/Vb2ECGH5kUNiHGD/RgL1xKHvHRVHVezQlRcMGHjnPI276S0FpjZtkU71o+3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668944; c=relaxed/simple;
	bh=DCLXQzCCu9Lni6DuXpbQQFXA0BIz6a9zMUjjcvJC1BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwfSgPJq2YvNFzbjdRM+K9vmvGAsbYKSXOiOjB4tdGS+TNlnKn+YMu3dusKgVZZ0kMk3LTIniy/nNJ6u6xHdSjMMCMMRFpVGYEB0E9VYzjR5zRbumB2AuIgeo1rDaBJpaGKPicQsSlD5A6CvkUnktnakgajhEZFccfqI8s6Q1kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBCKHIr0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBCKHIr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9133F1F000FF;
	Thu, 17 Sep 2026 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668943;
	bh=4DMFZXqJsPJikbuWKh6vDQEnGhhM9UeRkrtE9OUoszU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBCKHIr0zYAHGCwVgQE6j3LksdVAcdjKGF2V4eUwaaK5Or09yUgPAJXWpxxmMnbzh
	 thLmAgIdaMU4G/IU7pO2gToAmMMdLYTvkTC8T3h6sKN9r83mc4zwe8FoI3/Y54ko3F
	 dh0/fr27CfdIqfqZBkyti78KgWvpwbLT4ZBhW3g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0591/1102] btrfs: detach failed sprout device from transaction update list
Date: Thu, 17 Sep 2026 16:08:54 +0100
Message-ID: <20260917151554.810116400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index df8ab91d3151f..5966fc4162b48 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2889,6 +2889,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



