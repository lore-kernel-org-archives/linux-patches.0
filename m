Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6551AAE38;
	Thu, 15 Aug 2024 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730947; cv=none; b=pNUkU/bIJQsDXTt3aIISgj2kmDyS/lsabrj3hf8ocEL8IraDWlLE0DwWG/ItCzN6kcniY4STjQmVo7W/wDlxDaNpPWMkOp8AHT553PjhgGbjJHi5S3pOtscZhv3Y80Rr/OTGtcoC7IWYUqYHT7f1n+gud9zo1QrKkUxi1qTa0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730947; c=relaxed/simple;
	bh=2YwUS8tsC2XSBmWKSfgW8NRL+tT/EaHHtoJzLZzArps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4P+dmQtyjaTMuWA4FnhS6WMwwYdeENHs7xPqMDTkgMVYy/0lN5dI8jiXPpyJhmQ/vfa9C2wh1tO9EpEql8o9bUEwwLjjWzVINBUvyy8NlFkdtFAteTj5UFhKNkSPnFiSI1cZ74RRSqe46JDh3rr5QQLus6gL4qLRoVQoFWRgnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SszHka/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SszHka/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4B7C32786;
	Thu, 15 Aug 2024 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730946;
	bh=2YwUS8tsC2XSBmWKSfgW8NRL+tT/EaHHtoJzLZzArps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SszHka/CiAcAX4uyhaaOs1Oy2InIDbZKrd7UGh1eAUkchYLnllHCNbLkYjrtRwAlg
	 dP/iGAQ0LkiYw1u9xdJ/qPt7ggIHj1XhD9Cp4Cne6RTR/WzPRVKIbdiEckVx7q7P0D
	 nO67HTBbdpc1F1Te3UtD/YL+6KD14v6B7y2f6FA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4139435cb1b34cf759c2@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 42/67] fs: Annotate struct file_handle with __counted_by() and use struct_size()
Date: Thu, 15 Aug 2024 15:25:56 +0200
Message-ID: <20240815131839.932956707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 68d6f4f3fbd9b1baae53e7cf33fb3362b5a21494 ]

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time via CONFIG_UBSAN_BOUNDS (for
array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

While there, use struct_size() helper, instead of the open-coded
version.

[brauner@kernel.org: contains a fix by Edward for an OOB access]
Reported-by: syzbot+4139435cb1b34cf759c2@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://lore.kernel.org/r/tencent_A7845DD769577306D813742365E976E3A205@qq.com
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZgImCXTdGDTeBvSS@neat
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fhandle.c       | 6 +++---
 include/linux/fs.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 99dcf07cfecfe..c361d7ff1b88d 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -40,7 +40,7 @@ static long do_sys_name_to_handle(const struct path *path,
 	if (f_handle.handle_bytes > MAX_HANDLE_SZ)
 		return -EINVAL;
 
-	handle = kzalloc(sizeof(struct file_handle) + f_handle.handle_bytes,
+	handle = kzalloc(struct_size(handle, f_handle, f_handle.handle_bytes),
 			 GFP_KERNEL);
 	if (!handle)
 		return -ENOMEM;
@@ -75,7 +75,7 @@ static long do_sys_name_to_handle(const struct path *path,
 	/* copy the mount id */
 	if (put_user(real_mount(path->mnt)->mnt_id, mnt_id) ||
 	    copy_to_user(ufh, handle,
-			 sizeof(struct file_handle) + handle_bytes))
+			 struct_size(handle, f_handle, handle_bytes)))
 		retval = -EFAULT;
 	kfree(handle);
 	return retval;
@@ -196,7 +196,7 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 		retval = -EINVAL;
 		goto out_err;
 	}
-	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_bytes,
+	handle = kmalloc(struct_size(handle, f_handle, f_handle.handle_bytes),
 			 GFP_KERNEL);
 	if (!handle) {
 		retval = -ENOMEM;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5ca9e859c042b..43e640fb4a7f7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1036,7 +1036,7 @@ struct file_handle {
 	__u32 handle_bytes;
 	int handle_type;
 	/* file identifier */
-	unsigned char f_handle[];
+	unsigned char f_handle[] __counted_by(handle_bytes);
 };
 
 static inline struct file *get_file(struct file *f)
-- 
2.43.0



