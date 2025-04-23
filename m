Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9C57C9F;
	Wed, 23 Apr 2025 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422291; cv=none; b=Yqa6+HLn2OTR+CtJyDa4brIWXfgwCaQ96mHGEW9w6KV88l249kp/jF+6mxj0thR8dJcJOWxlZx10lwMI9CbHstq+v2a+4Zyxciu0lFSjJ2vzIYPpKRoYI1ZQ5394L5xEPnfWDfV5bhN9H95pV279JkwWpp1SzxyqhgaM20r9siY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422291; c=relaxed/simple;
	bh=gCd6lIL7DBqNvoY0ZeUC6zeNJ/yzlHtnNOwVdC8ebO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkWIHdY33XOsdP+PODQBQB5IpYTOG8quygdLhGMjJQMmozvl8w9HVFAeEvT9FT1KnCAOYJ2C/HReZZHKJRQNG5N66qeN0RhSwcoJf3uB1qTl31lJHdEjUOVeBrpKGdbW3hXJP7XmsCSFpmhZBHDZRpMVGLmaWmvBadnjbkOtTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QV5TfdAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QV5TfdAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA966C4CEE2;
	Wed, 23 Apr 2025 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422291;
	bh=gCd6lIL7DBqNvoY0ZeUC6zeNJ/yzlHtnNOwVdC8ebO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QV5TfdAdYcqHT6338V8fLHiBQ+N8hHpfucPkbu8DtvKtm0Sq+2YDmcVaKIkDx6FOs
	 TgKvd4/kjOkEz65yRGxFZ/tyzLC27wokouk9OfND+M1EAaJrEWngh89lyfmsSsIiJM
	 Z+np5dWaYfuBoERsDhM8P5GtLZpd8X03K3c7qRWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 271/291] btrfs: zoned: fix zone finishing with missing devices
Date: Wed, 23 Apr 2025 16:44:20 +0200
Message-ID: <20250423142635.493423860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2055,6 +2055,9 @@ static int do_zone_finish(struct btrfs_b
 		struct btrfs_device *device = map->stripes[i].dev;
 		const u64 physical = map->stripes[i].physical;
 
+		if (!device->bdev)
+			continue;
+
 		if (device->zone_info->max_active_zones == 0)
 			continue;
 


