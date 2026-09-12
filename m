Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D7A345EA7;
	Sat, 12 Sep 2026 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228172; cv=none; b=rHdZVxMiYqgBFt4YfuVrPw9wsZmLV1aBQ/DGmmASi0xGekaOenCVdCT8vL24VlmOmKBaGt9glqVjjwCcSz4GLsZk3mxUj9LAEzR+56ZJYUZMPFBpxLuI0cFqAv9F1QqWnixubXwILx2ODgLrmzCJwfbsN/S02PBn8uc91Sza6+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228172; c=relaxed/simple;
	bh=TgB/W+sNaFdI6baVe96aLe3enfEEApkfi5sTlSVrBiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0Ph+P5YMhhgV4cQ6wiYrf74xGHbYHri0EC61wJj3ZtLVrW75KnXI3aXp0RCeaN5Jx7xXr9JEo7hIt/9pJXChPbr31dcoyXkJr5v79PLiRSaTHNlHigaXjdYyGPTN58b8YU30fGid7KpDu87wPuGpsC7OUYhlcElzXTYPrwqlYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVEN19V5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVEN19V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4231F000FF;
	Sat, 12 Sep 2026 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228170;
	bh=jS7V6cpzTXtf67oKPiip5AVXPe+dAfiltVKUkI1hegE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVEN19V5LZ8KDhKDF7sX3zQusoBimMfc28EuR+WtR4NuDT7f4SIr9Y8Vzc6jz69U9
	 Xvw1QT/ZSa0YHezbh40Es6XrwmY5n2Nz2OxCMYmuE+1d3UsCBqskHw4nwxjToKB2/t
	 z0TEmgMiWE9fz7wwNTOUHLxFGm5AYUyIQ54mS3/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0289/1191] dm: fix race when loading and unloading a table
Date: Sat, 12 Sep 2026 08:50:17 +0200
Message-ID: <20260912065554.723112971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5380c7f6335cc6d77eb77d065105e81155c4d9d3 upstream.

If the userspace calls two concurrent table load ioctls and one of them
succeeds and the other fails, there is a race condition because
dm_setup_md_queue walks &md->table_devices without any lock. If the walk
races with dm_table_destroy -> free_devices -> dm_put_table_device, there
is access to invalid memory.

Fix this race by extending the lock over the list walk.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2349,9 +2349,10 @@ int dm_setup_md_queue(struct mapped_devi
 	 */
 	mutex_lock(&md->table_devices_lock);
 	r = add_disk(md->disk);
-	mutex_unlock(&md->table_devices_lock);
-	if (r)
+	if (r) {
+		mutex_unlock(&md->table_devices_lock);
 		return r;
+	}
 
 	/*
 	 * Register the holder relationship for devices added before the disk
@@ -2362,18 +2363,21 @@ int dm_setup_md_queue(struct mapped_devi
 		if (r)
 			goto out_undo_holders;
 	}
+	mutex_unlock(&md->table_devices_lock);
 
 	r = dm_sysfs_init(md);
 	if (r)
-		goto out_undo_holders;
+		goto lock_out_undo_holders;
 
 	md->type = type;
+
 	return 0;
 
+lock_out_undo_holders:
+	mutex_lock(&md->table_devices_lock);
 out_undo_holders:
 	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
 		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
-	mutex_lock(&md->table_devices_lock);
 	del_gendisk(md->disk);
 	mutex_unlock(&md->table_devices_lock);
 	return r;


