Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55416FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2743AC433C8;
	Sun, 17 Sep 2023 19:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980491;
	bh=OK9WXkOgRGl9Uful20CKEUGkkAhVq09DtD5w3qWrJkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjkvV4mXvnmcbeiphUCTG4Ueb5gZGddP1wrhUTNOGFNQY2m++2Y1L5QN7wEScTXfh
	 8dHJEaKWX6f6X41US+udlIHhyj/e/xMrBiJ8kky0mn/15rry0pmfAci/5UaYRU1DSr
	 3emhQUSHQnIoVMlK6zyqQA31soLiOWTTm2pZEvpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 208/285] btrfs: use the correct superblock to compare fsid in btrfs_validate_super
Date: Sun, 17 Sep 2023 21:13:28 +0200
Message-ID: <20230917191058.772757807@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <anand.jain@oracle.com>

commit d167aa76dc0683828588c25767da07fb549e4f48 upstream.

The function btrfs_validate_super() should verify the fsid in the provided
superblock argument. Because, all its callers expect it to do that.

Such as in the following stack:

   write_all_supers()
       sb = fs_info->super_for_commit;
       btrfs_validate_write_super(.., sb)
         btrfs_validate_super(.., sb, ..)

   scrub_one_super()
	btrfs_validate_super(.., sb, ..)

And
   check_dev_super()
	btrfs_validate_super(.., sb, ..)

However, it currently verifies the fs_info::super_copy::fsid instead,
which is not correct.  Fix this using the correct fsid in the superblock
argument.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2384,11 +2384,10 @@ int btrfs_validate_super(struct btrfs_fs
 		ret = -EINVAL;
 	}
 
-	if (memcmp(fs_info->fs_devices->fsid, fs_info->super_copy->fsid,
-		   BTRFS_FSID_SIZE)) {
+	if (memcmp(fs_info->fs_devices->fsid, sb->fsid, BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
 		"superblock fsid doesn't match fsid of fs_devices: %pU != %pU",
-			fs_info->super_copy->fsid, fs_info->fs_devices->fsid);
+			  sb->fsid, fs_info->fs_devices->fsid);
 		ret = -EINVAL;
 	}
 


