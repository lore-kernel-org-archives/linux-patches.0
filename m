Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0871865
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0B9C340E8;
	Wed, 23 Mar 2022 23:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076721;
	bh=+jo1fmUPf4yEgBUfvNYe1AyqvsEG4CNfjSzhwCPYegY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=WovkoyXSXyb8EJmNIK6djNY4JqS/Jh6XXOCHWSu5lq0rfDGuThI6xdJV0KlckC8Lx
	 fhfNZlun/RNYdU2mYQrVB05DviR/1YSk9SWpUZYrwoYDg1aDZWk2qWHYoqLC1IbTPi
	 RjD5KgWdbQHWY4thhuC6wBka2tU9yyPlQkOEIpnM=
Date: Wed, 23 Mar 2022 16:05:20 -0700
To: keescook@chromium.org,jamorris@linux.microsoft.com,christian.brauner@ubuntu.com,adobriyan@gmail.com,haolee.swjtu@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 01/41] proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks
Message-Id: <20220323230520.DD0B9C340E8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Hao Lee <haolee.swjtu@gmail.com>
Subject: proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks

It's not a standard approach that use __get_free_page() to alloc path
buffer directly.  We'd better use kmalloc and PATH_MAX.

	PAGE_SIZE is different on different archs. An unlinked file
	with very long canonical pathname will readlink differently
	because "(deleted)" eats into a buffer.	--adobriyan

[akpm@linux-foundation.org: remove now-unneeded cast]
Link: https://lkml.kernel.org/r/Ye1fCxyZZ0I5lgOL@localhost.localdomain
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks
+++ a/fs/proc/base.c
@@ -1764,25 +1764,25 @@ out:
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
-	char *tmp = (char *)__get_free_page(GFP_KERNEL);
+	char *tmp = kmalloc(PATH_MAX, GFP_KERNEL);
 	char *pathname;
 	int len;
 
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path(path, tmp, PAGE_SIZE);
+	pathname = d_path(path, tmp, PATH_MAX);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
-	len = tmp + PAGE_SIZE - 1 - pathname;
+	len = tmp + PATH_MAX - 1 - pathname;
 
 	if (len > buflen)
 		len = buflen;
 	if (copy_to_user(buffer, pathname, len))
 		len = -EFAULT;
  out:
-	free_page((unsigned long)tmp);
+	kfree(tmp);
 	return len;
 }
 
_
