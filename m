Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725682F7F11;
	Thu, 25 Jun 2026 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393078; cv=none; b=kariHRhC1oSsuT2WroMaUoukagFh5ogI1kxYFnlGnoYB6uqug2FyZZCMRlQftmAHGTkfh/HgL3JTw1ScmNj/xQoa/7GXwngU6mphzfD4g9UW32ieTQt16HnmQYVoUmry0+JtwEZHY/gWm4Mow4EXW5kPaU/Dp275TZD6caCt6RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393078; c=relaxed/simple;
	bh=ZdHpO1qBC84ikQizAh3JB3oETDka25BD8Qcfh1SMZx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbKSBY5JtqRPxodUpvb8fd/vSXHCVOGFaF/CiDQeNOqVE2H8tsjBa28q+DoiIqTaB4J2SONJZNwsfFQywRO4ls+d71+KZlFSO35q6io0dg0NHEeYPEv9BqRPaKv+TFzwwbcduT7cDFVhVzaD7n5Q8m4eUT6RJ+yMzlaj4WzeZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/U5/j2t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/U5/j2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFDA1F00A3D;
	Thu, 25 Jun 2026 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393074;
	bh=62jP5sarm0v3GEOiRJCCzgpExNbvG/eiDVhbFHAnX3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/U5/j2tdboHij/XGQlhr6jew5zsVpo3GzhkdaLbmqHBZ+Y83wpYRU/nHrcEw93yb
	 Imk0BeBsLSw1SYwy7dfb+X3xmcwY8SVfxReAXWzjQDK+7RIIDhTOCxxh1cLZ75HwIo
	 8OCaua34Lm6AzlFZkKxCU1wNPXzFa2sUXjmpYCaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Bombo?= <abombo@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Greg Kurz <gkurz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.0 49/49] virtiofs: fix UAF on submount umount
Date: Thu, 25 Jun 2026 14:04:01 +0100
Message-ID: <20260625125644.441881535@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -374,8 +374,14 @@ void fuse_file_release(struct inode *ino
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


