Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCEB3375AB;
	Mon, 18 Aug 2025 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526297; cv=none; b=JHGochB6ry8kdjj3oILqI8C9lzUTwwkZm5i43aNsWMYJs0vNQO/kALsd5wSc81vrDHxJMMhemokpCCOHO4LQeWUQ8XwxZWBadt/MzhuJCIVrTNzNRYv+1lJyFLmD++9Uo7FR/YTpSNIJSfrsTN0aqKEmoVmk0pYd3LsesIdZObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526297; c=relaxed/simple;
	bh=7NQVLw/wNZbmyX9kZCupsPwZJLv8iENYSXQG16mLdwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxttZd0F2/cyhaOLKAJ21A7aCpIDXlxLuSC0YJJx7A/A3uLdKU1VIg/gode86HdvVwfsiHjKGbVKaKMXHh1gTQHi3rQs1iqopmLvi4XjlRDgRThQfJmJMbnvUvgJpmAnUxXPPLIjW/Lu2Erqix+f0n887vdlXMU4dJGmpTH6MQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEPUkGld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEPUkGld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9676C4CEEB;
	Mon, 18 Aug 2025 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526296;
	bh=7NQVLw/wNZbmyX9kZCupsPwZJLv8iENYSXQG16mLdwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEPUkGldkX2RbYcgErezAbcwJWMeamxiWFEVtjEziI03L4emw1RUhRUB8pOWjIPrK
	 tNpv8QHrHSQCWrxqe/iTG0FmcdlfQCyKfhV+bcwtZYB441PVKC1WSYa7gj84GwvuD3
	 j7/x14qff0KYOsnJpOqQa82AIMC1nNXxSr7MsMbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 512/570] btrfs: zoned: use filesystem size not disk size for reclaim decision
Date: Mon, 18 Aug 2025 14:48:19 +0200
Message-ID: <20250818124525.580371709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 55f7c65b2f69c7e4cb7aa7c1654a228ccf734fd8 upstream.

When deciding if a zoned filesystem is reaching the threshold to reclaim
data block groups, look at the size of the filesystem not to potentially
total available size of all drives in the filesystem.

Especially if a filesystem was created with mkfs' -b option, constraining
it to only a portion of the block device, the numbers won't match and
potentially garbage collection is kicking in too late.

Fixes: 3687fcb0752a ("btrfs: zoned: make auto-reclaim less aggressive")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2523,8 +2523,8 @@ bool btrfs_zoned_should_reclaim(const st
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
+	u64 total = btrfs_super_total_bytes(fs_info->super_copy);
 	u64 used = 0;
-	u64 total = 0;
 	u64 factor;
 
 	ASSERT(btrfs_is_zoned(fs_info));
@@ -2537,7 +2537,6 @@ bool btrfs_zoned_should_reclaim(const st
 		if (!device->bdev)
 			continue;
 
-		total += device->disk_total_bytes;
 		used += device->bytes_used;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);


