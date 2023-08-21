Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A421171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5ECC433C8;
	Mon, 21 Aug 2023 20:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648253;
	bh=S5WcrngwKR/88kGSzBqyf7XxVbNuMO7K6YDhiPKl1eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wtuCSxsH4llDmXoAvhOrY0r3cAEWMyyfZ8VbhDPAfDasz1PTDyy4gW5QomjUKn4M
	 MmO2fvRaQX0TNegGNKoYJrc0O1OnPZHpBtAT8CSTo9cJYicW7OVt1CYcs/nyNJaxpT
	 6LsXKzYwIQzbyDSiH98r0sCMRsUC0xwYaKVz4wHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 110/234] btrfs: fix replace/scrub failure with metadata_uuid
Date: Mon, 21 Aug 2023 21:41:13 +0200
Message-ID: <20230821194133.674138608@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anand Jain <anand.jain@oracle.com>

commit b471965fdb2daa225850e5972d86600992fa398e upstream.

Fstests with POST_MKFS_CMD="btrfstune -m" (as in the mailing list)
reported a few of the test cases failing.

The failure scenario can be summarized and simplified as follows:

  $ mkfs.btrfs -fq -draid1 -mraid1 /dev/sdb1 /dev/sdb2 :0
  $ btrfstune -m /dev/sdb1 :0
  $ wipefs -a /dev/sdb1 :0
  $ mount -o degraded /dev/sdb2 /btrfs :0
  $ btrfs replace start -B -f -r 1 /dev/sdb1 /btrfs :1
    STDERR:
    ERROR: ioctl(DEV_REPLACE_START) failed on "/btrfs": Input/output error

  [11290.583502] BTRFS warning (device sdb2): tree block 22036480 mirror 2 has bad fsid, has 99835c32-49f0-4668-9e66-dc277a96b4a6 want da40350c-33ac-4872-92a8-4948ed8c04d0
  [11290.586580] BTRFS error (device sdb2): unable to fix up (regular) error at logical 22020096 on dev /dev/sdb8 physical 1048576

As above, the replace is failing because we are verifying the header with
fs_devices::fsid instead of fs_devices::metadata_uuid, despite the
metadata_uuid actually being present.

To fix this, use fs_devices::metadata_uuid. We copy fsid into
fs_devices::metadata_uuid if there is no metadata_uuid, so its fine.

Fixes: a3ddbaebc7c9 ("btrfs: scrub: introduce a helper to verify one metadata block")
CC: stable@vger.kernel.org # 6.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -655,7 +655,8 @@ static void scrub_verify_one_metadata(st
 			      btrfs_stack_header_bytenr(header), logical);
 		return;
 	}
-	if (memcmp(header->fsid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE) != 0) {
+	if (memcmp(header->fsid, fs_info->fs_devices->metadata_uuid,
+		   BTRFS_FSID_SIZE) != 0) {
 		bitmap_set(&stripe->meta_error_bitmap, sector_nr, sectors_per_tree);
 		bitmap_set(&stripe->error_bitmap, sector_nr, sectors_per_tree);
 		btrfs_warn_rl(fs_info,


