Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F218023
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp8yFjtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEFAC433C8;
	Mon, 23 Oct 2023 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061799;
	bh=E6kqcn5oFxARWAyDgyxmtzSTswCjTKYGKyzi3SMv2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp8yFjtp2lsv+MT3Zzo6r0hivig+7h3OlUwjZ+HAB3z+p9UBRDyQELRM2F68Gjgh9
	 s2fTm8VU3VLEojziDdvlg1r6aVp78Yl7L6BjO4N3Krt16whw7JGtjoBfG3IwUdiXSi
	 mK4Cfw76rSE2V7Wcoq7fq3P+wVqlM6EVa5JgyI/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/202] btrfs: fix some -Wmaybe-uninitialized warnings in ioctl.c
Date: Mon, 23 Oct 2023 12:57:56 +0200
Message-ID: <20231023104831.426705120@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 9147b9ded499d9853bdf0e9804b7eaa99c4429ed ]

Jens reported the following warnings from -Wmaybe-uninitialized recent
Linus' branch.

  In file included from ./include/asm-generic/rwonce.h:26,
		   from ./arch/arm64/include/asm/rwonce.h:71,
		   from ./include/linux/compiler.h:246,
		   from ./include/linux/export.h:5,
		   from ./include/linux/linkage.h:7,
		   from ./include/linux/kernel.h:17,
		   from fs/btrfs/ioctl.c:6:
  In function ‘instrument_copy_from_user_before’,
      inlined from ‘_copy_from_user’ at ./include/linux/uaccess.h:148:3,
      inlined from ‘copy_from_user’ at ./include/linux/uaccess.h:183:7,
      inlined from ‘btrfs_ioctl_space_info’ at fs/btrfs/ioctl.c:2999:6,
      inlined from ‘btrfs_ioctl’ at fs/btrfs/ioctl.c:4616:10:
  ./include/linux/kasan-checks.h:38:27: warning: ‘space_args’ may be used
  uninitialized [-Wmaybe-uninitialized]
     38 | #define kasan_check_write __kasan_check_write
  ./include/linux/instrumented.h:129:9: note: in expansion of macro
  ‘kasan_check_write’
    129 |         kasan_check_write(to, n);
	|         ^~~~~~~~~~~~~~~~~
  ./include/linux/kasan-checks.h: In function ‘btrfs_ioctl’:
  ./include/linux/kasan-checks.h:20:6: note: by argument 1 of type ‘const
  volatile void *’ to ‘__kasan_check_write’ declared here
     20 | bool __kasan_check_write(const volatile void *p, unsigned int
	size);
	|      ^~~~~~~~~~~~~~~~~~~
  fs/btrfs/ioctl.c:2981:39: note: ‘space_args’ declared here
   2981 |         struct btrfs_ioctl_space_args space_args;
	|                                       ^~~~~~~~~~
  In function ‘instrument_copy_from_user_before’,
      inlined from ‘_copy_from_user’ at ./include/linux/uaccess.h:148:3,
      inlined from ‘copy_from_user’ at ./include/linux/uaccess.h:183:7,
      inlined from ‘_btrfs_ioctl_send’ at fs/btrfs/ioctl.c:4343:9,
      inlined from ‘btrfs_ioctl’ at fs/btrfs/ioctl.c:4658:10:
  ./include/linux/kasan-checks.h:38:27: warning: ‘args32’ may be used
  uninitialized [-Wmaybe-uninitialized]
     38 | #define kasan_check_write __kasan_check_write
  ./include/linux/instrumented.h:129:9: note: in expansion of macro
  ‘kasan_check_write’
    129 |         kasan_check_write(to, n);
	|         ^~~~~~~~~~~~~~~~~
  ./include/linux/kasan-checks.h: In function ‘btrfs_ioctl’:
  ./include/linux/kasan-checks.h:20:6: note: by argument 1 of type ‘const
  volatile void *’ to ‘__kasan_check_write’ declared here
     20 | bool __kasan_check_write(const volatile void *p, unsigned int
	size);
	|      ^~~~~~~~~~~~~~~~~~~
  fs/btrfs/ioctl.c:4341:49: note: ‘args32’ declared here
   4341 |                 struct btrfs_ioctl_send_args_32 args32;
	|                                                 ^~~~~~

This was due to his config options and having KASAN turned on,
which adds some extra checks around copy_from_user(), which then
triggered the -Wmaybe-uninitialized checker for these cases.

Fix the warnings by initializing the different structs we're copying
into.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 930126b094add..cffd149faf639 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3518,7 +3518,7 @@ static void get_block_group_info(struct list_head *groups_list,
 static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
 				   void __user *arg)
 {
-	struct btrfs_ioctl_space_args space_args;
+	struct btrfs_ioctl_space_args space_args = { 0 };
 	struct btrfs_ioctl_space_info space;
 	struct btrfs_ioctl_space_info *dest;
 	struct btrfs_ioctl_space_info *dest_orig;
@@ -4858,7 +4858,7 @@ static int _btrfs_ioctl_send(struct file *file, void __user *argp, bool compat)
 
 	if (compat) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
-		struct btrfs_ioctl_send_args_32 args32;
+		struct btrfs_ioctl_send_args_32 args32 = { 0 };
 
 		ret = copy_from_user(&args32, argp, sizeof(args32));
 		if (ret)
-- 
2.40.1



