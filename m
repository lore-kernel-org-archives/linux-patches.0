Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759166AA0;
	Tue,  5 Dec 2023 03:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+whDd08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D7CC433C8;
	Tue,  5 Dec 2023 03:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746544;
	bh=3rGckHRthjYww+836mEwhU2G4ybjBf6J80IwymTpmKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+whDd08kvy+KMaMiA9MDrj+CxIed4FCJVNAJXMhxql7DJyxOWZWnR0+m4TkrygLN
	 Cw9QTBbCHIqGmO9RnybKeKypxrfLrXUv++dxoGrEGSoJwhgoAT/lQdd72v/8i55E6/
	 Si+y1dWeN5oCvvWKrqO6qeOc1rYgEi6VUpzumqU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 064/134] btrfs: add dmesg output for first mount and last unmount of a filesystem
Date: Tue,  5 Dec 2023 12:15:36 +0900
Message-ID: <20231205031539.609009762@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qu Wenruo <wqu@suse.com>

commit 2db313205f8b96eea467691917138d646bb50aef upstream.

There is a feature request to add dmesg output when unmounting a btrfs.
There are several alternative methods to do the same thing, but with
their own problems:

- Use eBPF to watch btrfs_put_super()/open_ctree()
  Not end user friendly, they have to dip their head into the source
  code.

- Watch for directory /sys/fs/<uuid>/
  This is way more simple, but still requires some simple device -> uuid
  lookups.  And a script needs to use inotify to watch /sys/fs/.

Compared to all these, directly outputting the information into dmesg
would be the most simple one, with both device and UUID included.

And since we're here, also add the output when mounting a filesystem for
the first time for parity. A more fine grained monitoring of subvolume
mounts should be done by another layer, like audit.

Now mounting a btrfs with all default mkfs options would look like this:

  [81.906566] BTRFS info (device dm-8): first mount of filesystem 633b5c16-afe3-4b79-b195-138fe145e4f2
  [81.907494] BTRFS info (device dm-8): using crc32c (crc32c-intel) checksum algorithm
  [81.908258] BTRFS info (device dm-8): using free space tree
  [81.912644] BTRFS info (device dm-8): auto enabling async discard
  [81.913277] BTRFS info (device dm-8): checking UUID tree
  [91.668256] BTRFS info (device dm-8): last unmount of filesystem 633b5c16-afe3-4b79-b195-138fe145e4f2

CC: stable@vger.kernel.org # 5.4+
Link: https://github.com/kdave/btrfs-progs/issues/689
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/super.c   |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3197,6 +3197,7 @@ int __cold open_ctree(struct super_block
 		goto fail_alloc;
 	}
 
+	btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
 	/*
 	 * Verify the type first, if that or the checksum value are
 	 * corrupted, we'll find out
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -79,7 +79,10 @@ static int btrfs_remount(struct super_bl
 
 static void btrfs_put_super(struct super_block *sb)
 {
-	close_ctree(btrfs_sb(sb));
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+
+	btrfs_info(fs_info, "last unmount of filesystem %pU", fs_info->fs_devices->fsid);
+	close_ctree(fs_info);
 }
 
 enum {


