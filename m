Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913B12566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA4C433EF;
	Tue, 18 Apr 2023 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821343;
	bh=4LD7iXfuJUT2Ceh6yNOBhQePjbyUxZoOLy1Xyk9v5pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcApTXDo0KkRmmdqyVBOUe9Y3hNvEIU2DJUBVp+KLBJ+f8cBtRLtsxMRuPSFE2CyR
	 e2K51NRDgCT0diK5eVz+jDghPsMcZR8vE0P2i+VHtsFjcsXMPfJ4YVr71OimSga3Xy
	 x8b9ChSo2ETSyKuSvvNRyW3RP448CMLupxYU+9sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 062/124] btrfs: fix fast csum implementation detection
Date: Tue, 18 Apr 2023 14:21:21 +0200
Message-Id: <20230418120312.109659440@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 68d99ab0e9221ef54506f827576c5a914680eeaf upstream.

The BTRFS_FS_CSUM_IMPL_FAST flag is currently set whenever a non-generic
crc32c is detected, which is the incorrect check if the file system uses
a different checksumming algorithm.  Refactor the code to only check
this if crc32c is actually used.  Note that in an ideal world the
information if an algorithm is hardware accelerated or not should be
provided by the crypto API instead, but that's left for another day.

CC: stable@vger.kernel.org # 5.4.x: c8a5f8ca9a9c: btrfs: print checksum type and implementation at mount time
CC: stable@vger.kernel.org # 5.4.x
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   14 ++++++++++++++
 fs/btrfs/super.c   |    2 --
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2246,6 +2246,20 @@ static int btrfs_init_csum_hash(struct b
 
 	fs_info->csum_shash = csum_shash;
 
+	/*
+	 * Check if the checksum implementation is a fast accelerated one.
+	 * As-is this is a bit of a hack and should be replaced once the csum
+	 * implementations provide that information themselves.
+	 */
+	switch (csum_type) {
+	case BTRFS_CSUM_TYPE_CRC32:
+		if (!strstr(crypto_shash_driver_name(csum_shash), "generic"))
+			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
+		break;
+	default:
+		break;
+	}
+
 	btrfs_info(fs_info, "using %s (%s) checksum algorithm",
 			btrfs_super_csum_name(csum_type),
 			crypto_shash_driver_name(csum_shash));
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1692,8 +1692,6 @@ static struct dentry *btrfs_mount_root(s
 	} else {
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		btrfs_sb(s)->bdev_holder = fs_type;
-		if (!strstr(crc32c_impl(), "generic"))
-			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
 		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (!error)


