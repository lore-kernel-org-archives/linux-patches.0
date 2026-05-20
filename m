Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D84C2DC76C;
	Wed, 20 May 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297384; cv=none; b=LlR4XOOspSX9+lR/NTlalf6IDBgOdMRiLVe7CqdibqM4c5jDGVGIMh4gOvd9yiNFtj8s4duKGcm31wIbCXKtVk6pyt+4KBLDzrkKtCqoJIwb8HugWJ2WK6Z9PVSlxgNkdcp7lFf+N05PH0N084mJXeAS5ZHMh5QO/4ScKQNER/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297384; c=relaxed/simple;
	bh=++w6rkFOKzk4WGDu8Ks6cN0Dnz4EdYRO4K7KDWWFBSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4snX8HKyvTnH1LboOIcwIMyN+pDS8VxGuE2yxA0pjy4jGZ2jFtMiqn5qjvpMfCUcNZww9mDko8T1U/cDLdFlIH1C24Q6xct3SNbKmRME03poDz5kiuLj9SIM1/El5obW4D/lFprfccI0FNrkmSqMvOwz7+oSbjVKkrXZOXzzS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDBhjTH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDBhjTH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B171F000E9;
	Wed, 20 May 2026 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297383;
	bh=VqXry6+3/5gKGqtogtdZuLCDPSbCh8TVwqlwBx/gMIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDBhjTH7xqZyG4iO6k7fenIDlPGiqZ2/jdVt3bEd5fWgiM9QAdvlHiuBMxID256tz
	 TQa/Q11ogu7DVwf76XY4GeVnY6V0yQo4p1XCJmK4bs+fuNtognxjirXvFvzr+g6mg+
	 yHH5UsZcw9d3yhwbCY/suW2iB9HAip/8Eobc598E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/957] md: fix array_state=clear sysfs deadlock
Date: Wed, 20 May 2026 18:08:15 +0200
Message-ID: <20260520162134.827080254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 2aa72276fab9851dbd59c2daeb4b590c5a113908 ]

When "clear" is written to array_state, md_attr_store() breaks sysfs
active protection so the array can delete itself from its own sysfs
store method.

However, md_attr_store() currently drops the mddev reference before
calling sysfs_unbreak_active_protection(). Once do_md_stop(..., 0)
has made the mddev eligible for delayed deletion, the temporary
kobject reference taken by sysfs_break_active_protection() can become
the last kobject reference protecting the md kobject.

That allows sysfs_unbreak_active_protection() to drop the last
kobject reference from the current sysfs writer context. kobject
teardown then recurses into kernfs removal while the current sysfs
node is still being unwound, and lockdep reports recursive locking on
kn->active with kernfs_drain() in the call chain.

Reproducer on an existing level:
1. Create an md0 linear array and activate it:
   mknod /dev/md0 b 9 0
   echo none > /sys/block/md0/md/metadata_version
   echo linear > /sys/block/md0/md/level
   echo 1 > /sys/block/md0/md/raid_disks
   echo "$(cat /sys/class/block/sdb/dev)" > /sys/block/md0/md/new_dev
   echo "$(($(cat /sys/class/block/sdb/size) / 2))" > \
	/sys/block/md0/md/dev-sdb/size
   echo 0 > /sys/block/md0/md/dev-sdb/slot
   echo active > /sys/block/md0/md/array_state
2. Wait briefly for the array to settle, then clear it:
   sleep 2
   echo clear > /sys/block/md0/md/array_state

The warning looks like:

  WARNING: possible recursive locking detected
  bash/588 is trying to acquire lock:
  (kn->active#65) at __kernfs_remove+0x157/0x1d0
  but task is already holding lock:
  (kn->active#65) at sysfs_unbreak_active_protection+0x1f/0x40
  ...
  Call Trace:
   kernfs_drain
   __kernfs_remove
   kernfs_remove_by_name_ns
   sysfs_remove_group
   sysfs_remove_groups
   __kobject_del
   kobject_put
   md_attr_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write

Restore active protection before mddev_put() so the extra sysfs
kobject reference is dropped while the mddev is still held alive. The
actual md kobject deletion is then deferred until after the sysfs
write path has fully returned.

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20260330055213.3976052-1-yukuai@fnnas.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 92ec4be20db85..7560e98dc35b3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6032,10 +6032,16 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	}
 	spin_unlock(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
-	mddev_put(mddev);
 
+	/*
+	 * For "array_state=clear", dropping the extra kobject reference from
+	 * sysfs_break_active_protection() can trigger md kobject deletion.
+	 * Restore active protection before mddev_put() so deletion happens
+	 * after the sysfs write path fully unwinds.
+	 */
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
+	mddev_put(mddev);
 
 	return rv;
 }
-- 
2.53.0



