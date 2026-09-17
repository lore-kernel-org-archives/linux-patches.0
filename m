Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0534D4897;
	Thu, 17 Sep 2026 15:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659251; cv=none; b=YTKyOKhUVMFoBwRojkL63txyDwfZ/AN99iwpzW5s9v/q/7O4A9fndJJ1GkAumMywmUcuEm/xxMY/9Kfxi7l3pze+dxkI7Ix6fHSZHp0BEks5tgeZDa/D1+JWVIBK1fJsKLwIuToOm282dFKMUqGl+ccga7JOFdxf6yxNkN1fdvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659251; c=relaxed/simple;
	bh=cwf9373YsAJtPP0cjRZGOTGujOQQ5Bqkm2M5GaytsMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tzlfw/M4Z/OmXDuxYHCjROSoBAKlzr3TTMPtWtb17pUyBQVMD8w4918CsAJT/Sg7zDQ4wUR03ququmWdsglLnK03f+r3ks2UOx6yyZBPuXis1JgBj2g71+hDXAcMNVBW9xXPQkx0QNyFWPp7Gmht5gAE5QNDvP8I2V/eiW/a6eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7hJYymN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7hJYymN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ADC1F00899;
	Thu, 17 Sep 2026 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659242;
	bh=WCbGtUFwifFmW3vLKHRujurRlIXmmu7YEof4Gkc0KWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7hJYymNiWtkwVZz+ZmYIpKI1ABDhGrSH8R/8T0ovrb9JV38VbO/8PFbY7yNFEEkQ
	 zXQno0U872jVHhOaumUptrFCIgVbAJ6sEfPbIpGsOY2zxW2g1ZtUl1lDwnVGSlxTXT
	 W6FWwbRGLy3X7aOIYj7RKjgLK+hQ+wKHg0tn1xTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 164/733] btrfs: detach failed sprout device from transaction update list
Date: Thu, 17 Sep 2026 16:07:52 +0100
Message-ID: <20260917151355.168896210@linuxfoundation.org>
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
index 6eab4cc73ce44..556d8a60a5ec9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3071,6 +3071,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



