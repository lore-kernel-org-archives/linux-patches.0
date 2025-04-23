Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4322BCF5E;
	Wed, 23 Apr 2025 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421489; cv=none; b=DqSHUnTsa93ofJsOKTqNEL4xqkkbj0O//j+BDLqAP2a+zPLZgdW745PhFiqcxOUWDtdGM78OuUmNK4MisYtor1M1catxscGtAkGMN5DWoFeJ5Wk0nNguBKRuVqo0q4GzfjC5sgdsf0j7n0tBR2YMxU9yGljbsjl79jLqYnYyBvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421489; c=relaxed/simple;
	bh=+/yhXDksgDgmuiyd97c5LVAVgciw+KMCgkBpFpvYQaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbYj6VK96wV4MJXaAgFCbscoxDuoQM6GUjO95roFIyt3ZPjcQfM+pcohFZ2dzmAda9n9up1+iwc71sRZ5pnuatQg1wQzFRJCt++qa3aGpXdm6/tq1b+2yufDkRO+v8cqdK+vN8JX5zuxY5+EQdDkjXk3HfVLArKHGSEC6rAGyj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWYm3qEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWYm3qEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EEEC4CEE2;
	Wed, 23 Apr 2025 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421489;
	bh=+/yhXDksgDgmuiyd97c5LVAVgciw+KMCgkBpFpvYQaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWYm3qEeKtRWW+JTMaJ8mSlDw+S9v+7OAP/o1Sfe79V48exnfkAXergewuOE/tfKd
	 YWOELzcZ67MnfjWLqw5mENoep3eS9hQJcRY7yyjTFQ/vMf87/Ci/6PuWAPwOjumTfT
	 K0orzubdRKHogO2e56Lae9R6yuTHDiE2kvQ9RGSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 184/393] btrfs: zoned: fix zone activation with missing devices
Date: Wed, 23 Apr 2025 16:41:20 +0200
Message-ID: <20250423142650.978889191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 2bbc4a45e5eb6b868357c1045bf6f38f6ba576e0 upstream.

If btrfs_zone_activate() is called with a filesystem that has missing
devices (e.g. a RAID file system mounted in degraded mode) it is accessing
the btrfs_device::zone_info pointer, which will not be set if the device in
question is missing.

Check if the device is present (by checking if it has a valid block
device pointer associated) and if not, skip zone activation for it.

Fixes: f9a912a3c45f ("btrfs: zoned: make zone activation multi stripe capable")
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
@@ -2006,6 +2006,9 @@ bool btrfs_zone_activate(struct btrfs_bl
 		physical = map->stripes[i].physical;
 		zinfo = device->zone_info;
 
+		if (!device->bdev)
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 


