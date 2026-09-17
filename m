Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7646B4EF150;
	Thu, 17 Sep 2026 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665422; cv=none; b=kV/E3sES35icbW70Sv0M0rh+SnaAivMnUsrY2lAFAmcAc7g+XTyzoSbFsr21GXMDD/7D3MwEqiLc48KGOsqzAmwFswpwnzuJkdzXWEHVmlqbvB685yns6sE72q4RK+oYg0wtJYOdpNcy3GXYhq8HLh8vsxrH6QTTsmg14gBSjRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665422; c=relaxed/simple;
	bh=bhEVhXPvDEn9xl3DTBxG4m3zGxvQhq0cwl5NSOskz1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ht7pFKgIENgzN2DB1HfEhs+w7j4vUDLMWjNzUT9FHmZ/3zX9SSFPRD/BROD0H231TKs5H3iLJvPgxdmc6SR83yfLhag6IQEBFq0jRk21ZF9d6tyK84dLNi1UGBWZ4bXogRzXHQZ5CbXOH7eaJzzGEHQdFIL+hWl6L5WuIxN4f30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvOW5LHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvOW5LHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFD91F000FF;
	Thu, 17 Sep 2026 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665421;
	bh=h2YrUnzdkdZcDeGqyo+l94HfAfaiU2+bkqD4/eWLhxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvOW5LHCeB710RHRrPYNiRI/rwAGEqkhJj3V5jxm/wKAU7C4LKKvikCR/YVlml8GN
	 +8+1pz32qUrFLSnWiI/yCZ2vg3Ln/Rv6hYP+fgUVFrc3unfepNryJA2Cl9XvI0qf49
	 /dvmQKYdZZCAEruvKSWP5TgKuKwg/UZNWiktAcNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0700/1250] btrfs: detach failed sprout device from transaction update list
Date: Thu, 17 Sep 2026 16:08:15 +0100
Message-ID: <20260917151610.864841789@linuxfoundation.org>
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
index fe81ff417c0d8..b76efe1856983 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3034,6 +3034,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



