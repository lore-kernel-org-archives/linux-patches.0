Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9225031AF14;
	Mon, 18 Aug 2025 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522693; cv=none; b=GPeDHbsAUJrfe7C70ZfPmzJ2xxHcVWrFHm7ylO28gDTP3Pxtd8xz10gw1F1aTSIDpxo+j8qjxc4DzYbqhnsSzhC8ZZJhn+ofQIJeZLBz+Q75qKItNBkG5ybXs2hAPeg6uQWf+NJcK1IXNw8FfrijM+S0vJFDntXP6Iqkb4AVjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522693; c=relaxed/simple;
	bh=5qwHO6oPUbP30q/LAb81p949hlNUDvpl95pLULMiKa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzlDxoYboFqrPdDANKW+w+hSiUZjI66W7vyJ+RNkWDOQ/Y5FScHYZjxVWRIU2tZp9xM91ceMYycv2UWIrlCYQwvQYEqCbLky3ymEsa2r0hOq9iuvlPHB9gnh6ONzxndVMilEFfGGEsucnhOMiEJRLKy4Lx9h0mP02JvK+yZEsCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmdmShBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmdmShBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BC7C4CEEB;
	Mon, 18 Aug 2025 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522693;
	bh=5qwHO6oPUbP30q/LAb81p949hlNUDvpl95pLULMiKa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmdmShBJjIwHlV66AiQZIG1KXQxZVyaQjXhQYERJzd506YCN7bLirysaCWBumFu1C
	 75WvjymnMI+utwwqGJfLCwz/nq9eiQ9iM5Dx5PVhVLAWecvTxDlqBtyX99uqq8SScR
	 eu71SYRwvN/FgiD8U91bkZH1EnQH5Rg3iYOhCxhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 391/444] btrfs: zoned: use filesystem size not disk size for reclaim decision
Date: Mon, 18 Aug 2025 14:46:57 +0200
Message-ID: <20250818124503.574779012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
@@ -2456,8 +2456,8 @@ bool btrfs_zoned_should_reclaim(const st
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
+	u64 total = btrfs_super_total_bytes(fs_info->super_copy);
 	u64 used = 0;
-	u64 total = 0;
 	u64 factor;
 
 	ASSERT(btrfs_is_zoned(fs_info));
@@ -2470,7 +2470,6 @@ bool btrfs_zoned_should_reclaim(const st
 		if (!device->bdev)
 			continue;
 
-		total += device->disk_total_bytes;
 		used += device->bytes_used;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);


