Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C666AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C695C340EE;
	Wed, 23 Mar 2022 23:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076787;
	bh=u8NikUXS3lKhEPGBMZz34AzW0dMm+xyst10stuZzfes=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=19H5erTVx/m2WAsNRfXfBdJJG1aqs0Wr/asUdzwnsMhhZ2ob2BCn6HtlKf1T5EXAy
	 +W45FfC37SpMRk7m6L46yFcaSEJ9YKdqceTDwV8lW5dTa9osclNHsswfD9iPI8ixM8
	 1oMhInodKY5Br0vf0GUjHXYMGiOVvLOBk4HFGEv0=
Date: Wed, 23 Mar 2022 16:06:26 -0700
To: schwab@linux-m68k.org,hirofumi@mail.parknet.co.jp,David.Laight@aculab.com,deller@gmx.de,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 23/41] fat: use pointer to simple type in put_user()
Message-Id: <20220323230627.6C695C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Helge Deller <deller@gmx.de>
Subject: fat: use pointer to simple type in put_user()

The put_user(val,ptr) macro wants a pointer to a simple type, but in
fat_ioctl_filldir() the d_name field references an "array of chars".  Be
more accurate and explicitly give the pointer to the first character of
the d_name[] array.

I noticed that issue while trying to optimize the parisc put_user() macro
and used an intermediate variable to store the pointer.  In that case I
got this error:

In file included from include/linux/uaccess.h:11,
                 from include/linux/compat.h:17,
                 from fs/fat/dir.c:18:
fs/fat/dir.c: In function `fat_ioctl_filldir':
fs/fat/dir.c:725:33: error: invalid initializer
  725 |                 if (put_user(0, d2->d_name)                     ||         \
      |                                 ^~
include/asm/uaccess.h:152:33: note: in definition of macro `__put_user'
  152 |         __typeof__(ptr) __ptr = ptr;                            \
      |                                 ^~~
fs/fat/dir.c:759:1: note: in expansion of macro `FAT_IOCTL_FILLDIR_FUNC'
  759 | FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_dirent)

Andreas Schwab <schwab@linux-m68k.org> suggested to use
   __typeof__(&*(ptr)) __ptr = ptr;
instead. This works, but nevertheless it's probably reasonable to
fix the original caller too.

Link: https://lkml.kernel.org/r/Ygo+A9MREmC1H3kr@p100
Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: David Laight <David.Laight@aculab.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/dir.c~fat-use-pointer-to-simple-type-in-put_user
+++ a/fs/fat/dir.c
@@ -722,7 +722,7 @@ static int func(struct dir_context *ctx,
 		if (name_len >= sizeof(d1->d_name))			   \
 			name_len = sizeof(d1->d_name) - 1;		   \
 									   \
-		if (put_user(0, d2->d_name)			||	   \
+		if (put_user(0, &d2->d_name[0])			||	   \
 		    put_user(0, &d2->d_reclen)			||	   \
 		    copy_to_user(d1->d_name, name, name_len)	||	   \
 		    put_user(0, d1->d_name + name_len)		||	   \
_
