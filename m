Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319C51CF51;
	Wed, 30 Sep 2026 16:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785030; cv=none; b=hj/HMPO/sWsFye4PDlQ3AjpY1AQwMLxyFVAqJz0xbkvrD5g1t6ZByY39jlHFs0dUxMXgBElqRG/utr+ahAfafW62AFmbcwjVqwMX7yFQmtzAJdttP9clE6yj2N03eWSg4wk9qVuVa0FwjhxKp9o2abCDEZUds1TMZ5bj19i8DMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785030; c=relaxed/simple;
	bh=oLspaOQ+1OA+GxgJJl/Aind9a1QSTV2gPGgB9QKr0TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=go4p3s9Qn5FTuyK5jICtXNpeChUys17qfEsa0PteOwUd6bWeA+Lp9Mvm7vRgqRdWcP8KcvO55/ycIehEKkBifjOBnQpir2nzWKbgcx1l+kwQRl/2akN9FpBBbvu0uNmvGqyRk/KVqpz+LQz7rL92puwg6tF/avB4fq70C3elMlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDtJwmAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDtJwmAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B041F000FF;
	Wed, 30 Sep 2026 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785022;
	bh=a5pJUqh7pAsVDnKXh+eFSwccFuDaO9sx+OtacEPi8+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDtJwmAVweiFdYAYAg8vsUgExVgzgJl3Vttq9sOpPBMN2Af0Z0uTSq0QIylxREViY
	 8ghOcCufEZkm9kCZF328pLGQUw0Wo1lzgeX1pdxObfUbtDP2SlLU+P9arh3o9Spp7t
	 1GTVveNTW0e01yN4O+22yLt3vWjjW42EHg+PoSOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 363/982] btrfs: detach failed sprout device from transaction update list
Date: Wed, 30 Sep 2026 17:18:19 +0200
Message-ID: <20260930152424.609662836@linuxfoundation.org>
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
index e0a310bd0421f..cddc3d7908a4d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2894,6 +2894,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



