Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471E6336897;
	Thu,  2 Jul 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010885; cv=none; b=Nuc9CY4BO53BVJlZV0rVw70HyQ4F9UpLJ/4U6adrQltcjs83xAYvIrObGykLnskJ8NxcTEjSMu09OZwE3DXFuL8X/op9NgMJOQfDzXYi969EpimXCkWoNwSH4++NAo/I0t37ubZZaBi30L7SqubsR7OZO5kQChWGnz4QKX0bEqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010885; c=relaxed/simple;
	bh=fzc9Wzoi1wNVi1npjUW23x5LtgvuZJV2iUfExCSMJAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+D8sT7Lf8LGmVXqNVrFZrukw0utnNlXGcGwSsWuasf2TQypAaz0gtMSLc5kLsyPrYp/U0o8z+SeeT7t+DIgbhhuYid0DnpoRDN63HnERHDK3Rqvrb7pej+mt9eqVuANKwDtRKIi/xAZn+qMHHtn1zHRkLoHasXfCMCd0/3wLHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJt1WP3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJt1WP3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDDC1F000E9;
	Thu,  2 Jul 2026 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010884;
	bh=5bf3TJYuGbVrqncmF/Jpk/Fufm6URnvdIvkg1U+K4YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJt1WP3Adqu+KUYt91GFsu3h4c3M+5ZB0P34MjZKFH6poZdP4Mjz+bV08/2IZrKJo
	 OSf0ixVI2sUDjvDwuJ67fvEJchtDns6K+/zqGIRvH7MG0SiJrcUwS5lYFcIvgkmP9V
	 /1y9Ixd0QQeem6iGaDdvCQPewGZmJOjNS/uhX+F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Bombo?= <abombo@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Greg Kurz <gkurz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 074/175] virtiofs: fix UAF on submount umount
Date: Thu,  2 Jul 2026 18:19:35 +0200
Message-ID: <20260702155117.349778277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 06b41351779e9289e8785694ade9042ae85e41ea upstream.

iput() called from fuse_release_end() can Oops if the super block has
already been destroyed.  Normally this is prevented by waiting for
num_waiting to go down to zero before commencing with super block shutdown.

This only works, however, for the last submount instance, as the wait
counter is per connection, not per superblock.

Revert to using synchronous release requests for the auto_submounts case,
which is virtiofs only at this time.

Reported-by: Aurélien Bombo <abombo@microsoft.com>
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Greg Kurz <gkurz@redhat.com>
Closes: https://github.com/kata-containers/kata-containers/issues/12589
Fixes: 26e5c67deb2e ("fuse: fix livelock in synchronous file put from fuseblk workers")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kurz <gkurz@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -357,8 +357,14 @@ void fuse_file_release(struct inode *ino
 	 * aio and closes the fd before the aio completes.  Since aio takes its
 	 * own ref to the file, the IO completion has to drop the ref, which is
 	 * how the fuse server can end up closing its clients' files.
+	 *
+	 * Exception is virtio-fs, which is not affected by the above (server is
+	 * on host, cannot close open files in guest).  Virtio-fs needs sync
+	 * release, because the num_waiting mechanism to wait for all requests
+	 * before commencing with fs shutdown doesn't work if submounts are
+	 * used.
 	 */
-	fuse_file_put(ff, false);
+	fuse_file_put(ff, ff->fm->fc->auto_submounts);
 }
 
 void fuse_release_common(struct file *file, bool isdir)


