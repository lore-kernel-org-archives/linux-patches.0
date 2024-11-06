Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0931DFDB5;
	Wed,  6 Nov 2024 12:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896379; cv=none; b=MdO4kE0aDR0rVT2+4/g10tfy7CsMOZxiK1TPdQhFJf2p/0JkEgZOujYj92H9fdImDZNR4wlC+s1ramRQIwX9rZDDXaMW2JU5fxpB7BTqCmXtbx9AfYOFhJ4Kk+Rfqjln6hTnmswo8qGikjLi3WCjbQst6KcBnn4FifonEn4vDSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896379; c=relaxed/simple;
	bh=teo7DbgcZy6LaE2/WHOyV02lACcqZjBlqhaNyYhI3Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7tFtdLe50NCNEVmKmSGHTUI+ZN6/7XSg4Rne32T4ERi9z0LIl+JhNSDoRMHt308bhr3LoXKjvgAOWkI7GOcfwHGprgnSW8BTF82Dfu06+pzSq8wK/GAJxeH2Zyp3C8ijYlYAVwWmCtj3CcvsaNE0cGMepJp4W9YxMXkYxX3sG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYGJytvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYGJytvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9F4C4CECD;
	Wed,  6 Nov 2024 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896379;
	bh=teo7DbgcZy6LaE2/WHOyV02lACcqZjBlqhaNyYhI3Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYGJytvpqK+1NH4C+Nch8ddb2gJYo2Ag+8v9TOnphrqaT+++ohenZ081+qAldM0k2
	 pSFullOxpn8zznrML9dml9ru0RCdzKPu/iykCormieS390fmJqjP25Z3n3uyGakMz9
	 UGy782vC7rBhtlcJ+rB+oP2YfY1WKI0H6KVACu5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 182/245] btrfs: fix use-after-free of block device file in __btrfs_free_extra_devids()
Date: Wed,  6 Nov 2024 13:03:55 +0100
Message-ID: <20241106120323.719955148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit aec8e6bf839101784f3ef037dcdb9432c3f32343 ]

Mounting btrfs from two images (which have the same one fsid and two
different dev_uuids) in certain executing order may trigger an UAF for
variable 'device->bdev_file' in __btrfs_free_extra_devids(). And
following are the details:

1. Attach image_1 to loop0, attach image_2 to loop1, and scan btrfs
   devices by ioctl(BTRFS_IOC_SCAN_DEV):

             /  btrfs_device_1 → loop0
   fs_device
             \  btrfs_device_2 → loop1
2. mount /dev/loop0 /mnt
   btrfs_open_devices
    btrfs_device_1->bdev_file = btrfs_get_bdev_and_sb(loop0)
    btrfs_device_2->bdev_file = btrfs_get_bdev_and_sb(loop1)
   btrfs_fill_super
    open_ctree
     fail: btrfs_close_devices // -ENOMEM
	    btrfs_close_bdev(btrfs_device_1)
             fput(btrfs_device_1->bdev_file)
	      // btrfs_device_1->bdev_file is freed
	    btrfs_close_bdev(btrfs_device_2)
             fput(btrfs_device_2->bdev_file)

3. mount /dev/loop1 /mnt
   btrfs_open_devices
    btrfs_get_bdev_and_sb(&bdev_file)
     // EIO, btrfs_device_1->bdev_file is not assigned,
     // which points to a freed memory area
    btrfs_device_2->bdev_file = btrfs_get_bdev_and_sb(loop1)
   btrfs_fill_super
    open_ctree
     btrfs_free_extra_devids
      if (btrfs_device_1->bdev_file)
       fput(btrfs_device_1->bdev_file) // UAF !

Fix it by setting 'device->bdev_file' as 'NULL' after closing the
btrfs_device in btrfs_close_one_device().

Fixes: 142388194191 ("btrfs: do not background blkdev_put()")
CC: stable@vger.kernel.org # 4.19+
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219408
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fcedc43ef291a..0485143cd75e0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1103,6 +1103,7 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 	if (device->bdev) {
 		fs_devices->open_devices--;
 		device->bdev = NULL;
+		device->bdev_file = NULL;
 	}
 	clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	btrfs_destroy_dev_zone_info(device);
-- 
2.43.0



