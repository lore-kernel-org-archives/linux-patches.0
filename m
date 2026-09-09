Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9848A25783C;
	Wed,  9 Sep 2026 13:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961902; cv=none; b=SxmjmWWu4SaatD53hUOkmBQe6VHBUUZ+KKjrkJL/KzaKOCKi/mq1kxSUcMti+m9eLR3jfDjb75tmxF8+zr+E4k+wEot/ZjR5nI6fdYAjOvnb79BuADtzUSvU5AiT8kHJibzgo7u4X5QH+4Gqr14vOylXmeJ0zlf4QY0graVj8p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961902; c=relaxed/simple;
	bh=8Hy4x/lV9JCuWFDCY53FjKtvkdsrogteBlUvxJzuxaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz1cSRQrlToUgBbXmzp1dxoHGGTCeJFrd/pqYmDoCAPFlg5mXSOWHwrhvlBNcg1ZApoJAwIOB9INJeTL6O3qzmJIKYPH+fCT+tU0mc9CFImCphsPgQ6Vbx8rvC4a3CWaLSqXgU0qYGFN86u45z7t4GIrzyhNqc6l7lUr0jdFYnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBOG/t1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBOG/t1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FEA1F00A3A;
	Wed,  9 Sep 2026 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961901;
	bh=LDd4ZT2690op/4Z5Zfxqhrv09mFFCOasg8j973kNBzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBOG/t1SSncW2SAE4T2htnb7kJ0CYbODPICPYm2v9YsKNULjnK4/iK+VABTFDAntY
	 6PC3FzixJkYWtLy8do70Lrq0Ibnm4+D/yPgMAJYyMnsjAZu0PpzO9M7xtEsTdQqjO4
	 F4WE62pmA8UanrP81Rnm1EvxXfwKfj6Ot00wxfkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 105/556] dm: fix race when loading and unloading a table
Date: Wed,  9 Sep 2026 15:36:25 +0200
Message-ID: <20260909134234.186520770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -2630,9 +2630,10 @@ int dm_setup_md_queue(struct mapped_devi
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
@@ -2643,18 +2644,21 @@ int dm_setup_md_queue(struct mapped_devi
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


