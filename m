Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE63326927;
	Sat, 12 Sep 2026 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221501; cv=none; b=O0+12K3rp97/ANUNymswT2xlKvnKH/PUr3XBfwBRbNobbAgt+dwbO7rklnOK79Q2e8ohr+gu0i72bxO0lI5B62/vLRlxje1Ps8hAfQh/kd5uurpH6OzU2gerqggtmyMpF3Iqason+dcHjEuGq+qMQkqTx6ZRM7jJJNXJUGTTeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221501; c=relaxed/simple;
	bh=7DhydBqQazsfZIMW1gIOacLcv2IdjZ21DsxacsoJGzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5PIakp++TKmoZR07hoMw8BT+QFfIMOivSJds20wwY7xeJFcVUoGBP5eohohvjlXJqtiACAgWOJmGNULMhU0+kwcUY7kDPQOcoPxNUgBIUcN3xtCT3gWeGiLcNIl12tFzr1X+Jv8Y/H6uEyyfh2otbmK2fb+kiw//gaQsRzfTJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmjjt4bM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmjjt4bM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09271F000FF;
	Sat, 12 Sep 2026 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221499;
	bh=13CegHbdp+MCN3jMimkM0jtojFV0vmYNyDui9YpojV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmjjt4bMRto24rYuVZn8q7v2Vu0FT9DBDA9ntvwkK8gtGfaHp4BPg7FgH11a7BidY
	 auyoIJaTvSlM6ypaP4483Y9XtmqHtonqVw9PiKoTXELdp6kGPhvbgTWKa+8XBk25Rd
	 DL05l/k5wwxgyxs2AaK9E+W3mKUIVqDJ0FD2FXbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 0352/1424] dm: fix race when loading and unloading a table
Date: Sat, 12 Sep 2026 08:46:24 +0200
Message-ID: <20260912065615.172105144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -2369,9 +2369,10 @@ int dm_setup_md_queue(struct mapped_devi
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
@@ -2382,18 +2383,21 @@ int dm_setup_md_queue(struct mapped_devi
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


