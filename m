Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D2057D208;
	Wed,  9 Sep 2026 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963407; cv=none; b=A6Qwxjg21PI3aQxRhw+BnvydsWqcn73PlXRG1XKYJq+BIRCLc7DtEZBg8zxHwNQahlfvnxzLE34Ennt8tckDVoGNARLRA/PttF5p4mB0eJYlMWd+CW8s6e44x2z/n1PmJY5oeBrAUK4K3JfAIYdRUQWPs1pfq63mm9orPQgFp4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963407; c=relaxed/simple;
	bh=OQ3lnaYkeHEF/hBBvvNMutMK05oxAJ6ChNS3UJ1WdTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OppkOUDttu/OECIXDUCnhDclAmTY5KdOfYnpsGf2zsWs7ftMatehSBVGJAwkYatA2xdhxbYXNc1spRZxQKkV15GycrcCoWK65ppDqPCkVlmdRSVJ6E6gnaxap3Btpsd5ZJ+yJil3mbClRBZq0tyGCsYRWHBxOgTf1m2Dpt+4T1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfqvBEc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfqvBEc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C841F00A3A;
	Wed,  9 Sep 2026 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963406;
	bh=0u8rRy/CigAZPuASzbFO5aOrIEw9JQqbchDMHNjh7yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfqvBEc66Pfp9cdxOK2Grp5/ERPCgzJuQoCO6czbIR4ozQSG9KMbaTqdtjtntVvBO
	 budiX9fAP017GYXSJOxZVyMYbC9RoGRLpoXw8KKd3scVaEDawKIRTBUY34XbPH4H/m
	 +h0K7+ct+W5Bah8+Pz46hDa+JZ4QhQCDab4v3Uf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 067/583] dm: fix race when loading and unloading a table
Date: Wed,  9 Sep 2026 15:35:52 +0200
Message-ID: <20260909134240.390700133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -2615,9 +2615,10 @@ int dm_setup_md_queue(struct mapped_devi
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
@@ -2628,18 +2629,21 @@ int dm_setup_md_queue(struct mapped_devi
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


