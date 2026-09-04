Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3A26AC3;
	Fri,  4 Sep 2026 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498313; cv=none; b=CAA8W4DJeNYMJIjdXi0RUW/X1t5+f13Gbp18Ot0g41xZSJjfJ9R4MvNI8BO5onHbEBbdV4WuYG8cRHLm6Jc6l/KxT0GSAvr7DUKPUgSViKzlmfizCBi9xEK07cGNhJ/b7RLXjfHHbvWQNg+paNJ2U3d3n1Tn3NcbP+OHjIB2aBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498313; c=relaxed/simple;
	bh=p5jKm17pPX5GWv8XiKYhnF3YkJOP+SHx9Ba/T9yypH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czOjuKw6+HaBgV3R1qoz3Ca2f2b6/bFMhVYDjtG6bITqhu7HjVZEXY17HEErGirwmhXsMA/RytYtwiB2xgZt5eLdnmS4BBOFKOO25g4Th36KydP1/u75Zs62B7b2qniDbLYqUMr2C9HQQQb0onOwBdNlRcbNkOAZUYGWsFKfaiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqHwgxU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqHwgxU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4AA1F00A3D;
	Fri,  4 Sep 2026 05:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498312;
	bh=rCtXVFrW9onp1ZJqICQ8HZyZ56tCTOQWY5MwqYguifs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqHwgxU0eYII4LGSKXnl3nm9RNDwH0X6wyYDAA6xUQ7ni9wkbZLf51WT61HlU4H/7
	 CvR8HgFf67Uk1LWyQB5ELGfc+YqNPwX6ZuwGh1897zOORcyKtIxmy9KeQeOBEfvyBA
	 jG3mE5M70kXccVTEWIiJE0wMBff9EyU4Iwu1f8ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Paul Moore <paul@paul-moore.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 019/713] fs: fix user path of nested backing files
Date: Fri,  4 Sep 2026 06:49:47 +0200
Message-ID: <20260904045804.254662173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit f2381b546e7e6a35c9fcee0d0ccb6c042a9aeb5d upstream.

backing_file_open() derives the path to be stored in the new backing
file from user_file->f_path.  This is incorrect when user_file itself
is a backing file, which is the case for nested stacking filesystems,
e.g. overlayfs mounts where the lowerdir of one overlayfs is the merged
directory of another.  Since commit def3ae83da02 ("fs: store real path
instead of fake path in backing file f_path") the f_path of a backing
file holds the real path of the intermediate layer, not the path that
the user opened.

Commit 924577e4f6ca ("ovl: Fix nested backing file paths") fixed this
for such configurations by passing file_user_path() from
ovl_open_realfile().  However, commit 6af36aeb147a ("lsm: add
backing_file LSM hooks") changed the first argument of
backing_file_open() from the user path back to the user file and
derived the path from user_file->f_path again, silently re-introducing
the problem.

As a result, files mapped through a nested overlayfs show the wrong
path in /proc/<pid>/maps and in perf/ftrace mmap records.  For example,
with two nested overlayfs mounts:

  mkdir -p /ovl/{lower,upper,work,merged} /ovl/nested
  echo hello > /ovl/lower/foo
  mount -t overlay overlay \
	-o lowerdir=/ovl/lower,upperdir=/ovl/upper,workdir=/ovl/work \
	/ovl/merged
  # at least two lowerdirs are needed when upperdir is nonexistent
  mount -t overlay overlay \
	-o lowerdir=/ovl/merged:/ovl/lower /ovl/nested

mapping /ovl/nested/foo shows a disconnected path instead of the user
path:

  # readlink /proc/self/fd/3
  /ovl/nested/foo
  # grep foo /proc/self/maps
  7f6e2c100000-7f6e2c101000 r--s 00000000 00:24 15813027 /foo

The bogus path is derived from the f_path of the intermediate backing
file, whose mount is a private clone that d_path() cannot resolve.

Fix this by using file_user_path(), which returns the outermost
user-visible path for backing files and falls back to
&user_file->f_path for regular files.  This restores the behavior of
commit 924577e4f6ca ("ovl: Fix nested backing file paths") for
overlayfs and also fixes the same problem for the other
backing_file_open() callers, fuse passthrough and erofs ishare, when
their user file is itself a backing file.

backing_tmpfile_open() has the same pattern but is not affected: it is
only called by ovl_create_tmpfile() for the upper layer, and another
overlayfs is rejected as upperdir by the DCACHE_OP_REAL check in
ovl_mount_dir_check(), so its user_file can never be a backing file.

Fixes: 6af36aeb147a ("lsm: add backing_file LSM hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260804034204.3487077-1-libaokun@linux.alibaba.com
Tested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/backing-file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -35,7 +35,7 @@ struct file *backing_file_open(const str
 			       const struct path *real_path,
 			       const struct cred *cred)
 {
-	const struct path *user_path = &user_file->f_path;
+	const struct path *user_path = file_user_path(user_file);
 	struct file *f;
 	int error;
 


