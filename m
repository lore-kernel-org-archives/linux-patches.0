Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7998D3A5422;
	Sat, 12 Sep 2026 11:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213109; cv=none; b=H0stMPGVLbvlxxeyHxYi/Hld633i1NCFzVE+HyvvG9+qyXq69u1kyJ76st9Tl7jDXQ6FCwLZyDdXhv85LymAwYrobxQ4dqpmyyP7vx9frZ9Pe5YTP6Y6JKJPUVMUtxBqk7TMjBcZQfYZfXd+Xbu2PPbW+XK3provCtGWtpk/H40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213109; c=relaxed/simple;
	bh=6ioQOADs4REn3mkz6T1d15idw3xH9jeDwYJ26eWfNy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUxpwUWko3DFemvSWinEMlxBx94Ep1W+rxUGFEwir0jty8WjZ3tnfVKRxKIB6WPTK7N+tpvYTzSMOjLcKR0Eu/GEh/IVhzgwEmJGaGr5xVvmym/2+TRHxivP6aPRDtZX9y+9ViOZ9td9+OWGOFd+Anu0Gy9y9iyWlR9k36lgOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIRdC0G4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIRdC0G4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0741B1F00893;
	Sat, 12 Sep 2026 11:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213106;
	bh=y8zefYyiukrxrM25FHI/wAP3lGRXB80VJhmBfF0mI5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIRdC0G4M8g+Ru9SOiqoJshNbSCmUKOAxwn257Sp5SFIVSRbUXlfAC8jJEkwZ+t6I
	 i7PEtLPkCziWzefNpwte8QkR+IxMbOefOznXpTEvWFDqrWB8BydYXKMlD6LKCO1s8q
	 pKnSWFLaDTB0wBrN6OjQgkdDrF+4kJ2XSg7BDTB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 0055/1376] dm: fix race when loading and unloading a table
Date: Sat, 12 Sep 2026 08:41:21 +0200
Message-ID: <20260912065608.784965614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -2608,9 +2608,10 @@ int dm_setup_md_queue(struct mapped_devi
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
@@ -2621,18 +2622,21 @@ int dm_setup_md_queue(struct mapped_devi
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


