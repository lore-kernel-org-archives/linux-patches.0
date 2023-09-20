Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0263830F80
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C37BC433C8;
	Wed, 20 Sep 2023 12:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213792;
	bh=vqvy3iGwvXbxtUXufCuyRgvlGk8A3osXCg67paFsBmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRsheqGcxH267nPv6rzULpbomE/eP6rqUpYlsWzQkdMlXMv3UrdME/G2e/r9a5jv9
	 ydWlMg7ss9zul73l5hb6RfKsNTQAtLzzV4xjwtb8w3xK4tWNEyuLjUbJkVPte41xW1
	 l7ANF1n9ZfGPy49OA9dMWKzs45XH+ob1LcQlfLW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 353/367] btrfs: compare the correct fsid/metadata_uuid in btrfs_validate_super
Date: Wed, 20 Sep 2023 13:32:10 +0200
Message-ID: <20230920112907.625348550@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 6bfe3959b0e7a526f5c64747801a8613f002f05a ]

The function btrfs_validate_super() should verify the metadata_uuid in
the provided superblock argument. Because, all its callers expect it to
do that.

Such as in the following stacks:

  write_all_supers()
   sb = fs_info->super_for_commit;
   btrfs_validate_write_super(.., sb)
     btrfs_validate_super(.., sb, ..)

  scrub_one_super()
	btrfs_validate_super(.., sb, ..)

And
   check_dev_super()
	btrfs_validate_super(.., sb, ..)

However, it currently verifies the fs_info::super_copy::metadata_uuid
instead.  Fix this using the correct metadata_uuid in the superblock
argument.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a02fa6c07087c..b4ed11b5f1480 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2487,13 +2487,11 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
-	if (btrfs_fs_incompat(fs_info, METADATA_UUID) &&
-	    memcmp(fs_info->fs_devices->metadata_uuid,
-		   fs_info->super_copy->metadata_uuid, BTRFS_FSID_SIZE)) {
+	if (memcmp(fs_info->fs_devices->metadata_uuid, btrfs_sb_fsid_ptr(sb),
+		   BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
 "superblock metadata_uuid doesn't match metadata uuid of fs_devices: %pU != %pU",
-			fs_info->super_copy->metadata_uuid,
-			fs_info->fs_devices->metadata_uuid);
+			  btrfs_sb_fsid_ptr(sb), fs_info->fs_devices->metadata_uuid);
 		ret = -EINVAL;
 	}
 
-- 
2.40.1



