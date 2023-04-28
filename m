Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5250290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279D1C433EF;
	Fri, 28 Apr 2023 11:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681353;
	bh=hvxjM5f5q1niMWOteYyz2Zsd9iMhBDHR9DuvG+0DBkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDQkMJmSMo+rlAbPPm7pifMiXrX0NHV+dg4eoUWNr4GFL/Bc5Hi+vxyv44efZfGew
	 aSkM/X7u7lDM8Iihw6kIHFz8fRpftg8fRpdGRmj21r6s3eK/RTl55hQAW+LJkisSTf
	 VdEZklF0eZAL5P4/VkqvuN/tYpJpWDOeuKf/S76E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	k2ci <kernel-bot@kylinos.cn>,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH 6.1 11/16] btrfs: fix uninitialized variable warnings
Date: Fri, 28 Apr 2023 13:28:03 +0200
Message-Id: <20230428112040.427041572@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
References: <20230428112040.063291126@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Genjian Zhang <zhanggenjian@kylinos.cn>

commit 8ba7d5f5ba931be68a94b8c91bcced1622934e7a upstream.

There are some warnings on older compilers (gcc 10, 7) or non-x86_64
architectures (aarch64).  As btrfs wants to enable -Wmaybe-uninitialized
by default, fix the warnings even though it's not necessary on recent
compilers (gcc 12+).

../fs/btrfs/volumes.c: In function ‘btrfs_init_new_device’:
../fs/btrfs/volumes.c:2703:3: error: ‘seed_devices’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
 2703 |   btrfs_setup_sprout(fs_info, seed_devices);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

../fs/btrfs/send.c: In function ‘get_cur_inode_state’:
../include/linux/compiler.h:70:32: error: ‘right_gen’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
   70 |   (__if_trace.miss_hit[1]++,1) :  \
      |                                ^
../fs/btrfs/send.c:1878:6: note: ‘right_gen’ was declared here
 1878 |  u64 right_gen;
      |      ^~~~~~~~~

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c    |    2 +-
 fs/btrfs/volumes.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1658,7 +1658,7 @@ static int get_cur_inode_state(struct se
 	int left_ret;
 	int right_ret;
 	u64 left_gen;
-	u64 right_gen;
+	u64 right_gen = 0;
 	struct btrfs_inode_info info;
 
 	ret = get_inode_info(sctx->send_root, ino, &info);
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2631,7 +2631,7 @@ int btrfs_init_new_device(struct btrfs_f
 	struct super_block *sb = fs_info->sb;
 	struct rcu_string *name;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-	struct btrfs_fs_devices *seed_devices;
+	struct btrfs_fs_devices *seed_devices = NULL;
 	u64 orig_super_total_bytes;
 	u64 orig_super_num_devices;
 	int ret = 0;


