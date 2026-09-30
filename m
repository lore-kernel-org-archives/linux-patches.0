Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76150403B1B;
	Wed, 30 Sep 2026 19:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795085; cv=none; b=busmTo4+HhaxZ61v5gfyjSgDCHaBmkiWVGb282KVbyDSv1x3MQDp8NMVyvhVa9Fc4wQlnSdNDMwqIl46aOlQl9PqcnCQRuoUVYR6wU9Fgbw83jNeZa5E1R/8S+L+zdwMjJLcZLmnoW+VW9sjP+fnwJUBZt6mGaEMdY0RrB+wobc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795085; c=relaxed/simple;
	bh=8TFFAZBtunwoM8WfM32vGmlD6zsFo18py78Lm9QoXjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDJ+eakv4ONXQgW6jra7OIvqXnWWRLeoLkcfE0y1/UQViFv/xs9bKXB9igHDhnTmuYhTsSwDw0sLORXblekcYrZ5x4axKDYtyGuRUWBNB0d51OFNNaSqb3WSHs/RIkKPJsXVeA1rQ5yZQrLgGNUdQVVNGH7SSKGCLAsQxhZRjTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iB9PNBk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iB9PNBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372261F00A0F;
	Wed, 30 Sep 2026 19:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795082;
	bh=wZKRn6qpC6gMvnGq7pw4wpxFZA1d1nA7sp6TJvuESlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iB9PNBktoF2A7R11/L5yBCI6WAeOprKz/tGPjCWYFkU07X82rettGWeCEAWN2Nm1
	 lFOI7M9hK6UpnznFmSuIey1EaDniwW6ZVrVo5JmusDYNnMgbz964XCqKBIg7HGhyiQ
	 4UKrrNlnhWWnzZ47p6fDB9eQEof2m2g3V7dl9Ilo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0438/1193] btrfs: restore active device pointers after failed sprout
Date: Wed, 30 Sep 2026 17:18:42 +0200
Message-ID: <20260930152443.918472733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44abd64ffd3aa..da9b08afdddda 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2864,6 +2864,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



