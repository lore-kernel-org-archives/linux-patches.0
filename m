Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02D31A5BBB;
	Thu, 17 Apr 2025 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916034; cv=none; b=ezEcEbsVSm+E0M9BkUpcCBRbfe8+fq/AG722ln2K7dFyKJ8z4222/nuQlOojv5hvadxLhuJVs9lV3yFiiArHPVbkKv/vYxbklm8i8YUy5OR1fzgDhFxJWjqJ6Tuui5irHkwoApswh2/55V2CxOzLOOoeSp4GOnnYm0v/86cJ4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916034; c=relaxed/simple;
	bh=JC4bRWrQ8CVEbbQOaHh8hAJRzRd1GF76D02M+AdwsC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE2FqYHUHfK19ZDHny0Iz2YrWZ0idRz33lMLB7VKK6n6rqN17jeY893c2lEmARXjde1x//tX6Oqh9oewUOOldxs+1tf4gBo29tyuCLgnpWbErLFZJnR1/rZU4oP+WiYa1i1IWtFsUMCi9jHb1/hM95IDNnmdQzLFEIQfuDVk6Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLvs74Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLvs74Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C82C4CEE4;
	Thu, 17 Apr 2025 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916034;
	bh=JC4bRWrQ8CVEbbQOaHh8hAJRzRd1GF76D02M+AdwsC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLvs74ThPIVyy4DD0w8+XyPTvj4NRWC45NDPuCsSMCHREInbFqQJXQbqwklZTNT9e
	 5zqSVpIYsVRDDRxkKC3QQxXkZEsHMx87yto8E4dzKd4M+P3QljUgQzMgBj0CrF16F3
	 PV5xwwBsT+0UquVCFcWGqIyvNtgPWMuu/x2fIuQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 292/393] btrfs: zoned: fix zone activation with missing devices
Date: Thu, 17 Apr 2025 19:51:41 +0200
Message-ID: <20250417175119.358918688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2107,6 +2107,9 @@ bool btrfs_zone_activate(struct btrfs_bl
 		physical = map->stripes[i].physical;
 		zinfo = device->zone_info;
 
+		if (!device->bdev)
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 


