Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC122641E9;
	Thu, 17 Apr 2025 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914828; cv=none; b=O6jPLHtJNB2HTaA1O9/4deGP5miTqE+AFj2pnX3TSiheoSjOWGT5YXs6+LaKUicGQ06m0aEYm+YmvowTl5v8i3OngyZnIhRbD8Cx9/BmQRXTM4LnjmOtV5YvUKocTwD+/A8x6JmxzU61btCm6xdfc6BRoDqqrkuvEUjBPS6Mxu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914828; c=relaxed/simple;
	bh=D2mMWXLyjuTeMmVKNoTPINSu2ZriaDOB/X+FXTcX4wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtA3oqqEjTOw+3JXO5AwMF3SLyoMwZazGRMENiniBAlihFkD+G6AtB7nIDMPaVyhxcCAEUGu3cvEehrIxvWI4ti1rFIvCOzEk0F+WqDHm8t+OnSKFHwFHTB6Zjuqt+1l1ksIFItRMemVuVSZgEcaVhUQJuwZs4CJ7vq7PLz5oxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOSm6Ft6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOSm6Ft6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB5C4CEE4;
	Thu, 17 Apr 2025 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914827;
	bh=D2mMWXLyjuTeMmVKNoTPINSu2ZriaDOB/X+FXTcX4wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOSm6Ft6Dr/n5hBm2p/BTBNgVnMYHENvQjY0369SMI6tYa3BkraYn4ZObQufQZy8j
	 VSTuiegxFhNZi/ycvhMiWZaYcwR1AKDjWZ/kpa4KjIHOvqHcCaKw+3URV9OgxvwuTr
	 AHrquCLCPM37iq3AZcVkJ8Mve+jnD0xaRzI1BO+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 315/414] btrfs: zoned: fix zone finishing with missing devices
Date: Thu, 17 Apr 2025 19:51:13 +0200
Message-ID: <20250417175124.104914508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 35fec1089ebb5617f85884d3fa6a699ce6337a75 upstream.

If do_zone_finish() is called with a filesystem that has missing devices
(e.g. a RAID file system mounted in degraded mode) it is accessing the
btrfs_device::zone_info pointer, which will not be set if the device
in question is missing.

Check if the device is present (by checking if it has a valid block device
pointer associated) and if not, skip zone finishing for it.

Fixes: 4dcbb8ab31c1 ("btrfs: zoned: make zone finishing multi stripe capable")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2275,6 +2275,9 @@ static int do_zone_finish(struct btrfs_b
 		struct btrfs_zoned_device_info *zinfo = device->zone_info;
 		unsigned int nofs_flags;
 
+		if (!device->bdev)
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 


