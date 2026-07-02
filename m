Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61A33F583;
	Thu,  2 Jul 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009575; cv=none; b=OVw2W660FkUp0P4h8EWYK37dM0Ggpgf3mUALNRHwAIcTnYpfFidQyEVwLofA1mcK2kiYEQF9nUImCrdmqSXb9DEvVd7Hy5/Kj9D9S5Oi41cHJNCtL6K0T9oT7QCVqGxVXQc2YFGlcduDkT4d5Kiy1EilrptX2/vOeyBWb9n4TCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009575; c=relaxed/simple;
	bh=DuYPMW7FyGgAm9hNcVx3UyOXY/UxH/ojU1g7WBBJVhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2hVxWMYPHHcpfP4pE/c4FCWY3cM+PEwf4cKJlsTvZwHuDGqBV6w/IDejTUEwmkTus30RjgF4pfYIPMKCAmQO9mBSgY33OKY5u5cV0RRChZkGERJESnWBEkK3xXuoOWVe8nf4ikoDx9TRlxS3Htu3IspQZfNgVQoJvDEUFlGT50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmHl3Vd0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmHl3Vd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BBA1F000E9;
	Thu,  2 Jul 2026 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009573;
	bh=8tW9JlWH0WVAee+xdE828J9jn71t/P8UhzJxF+zBt1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmHl3Vd0NKMEd60w2aJFQPeaqlfYa0M5Va3Tm8UjqDv6107DMlbbRd4Wcxuc8ERur
	 Pn0bXs97dY0O//8Y/Ti5gbKpu23raibDwdFXE2qhjxFbKAhyQ1rHRN5PmME4k2TFu0
	 OiXOvj+t0knWJfWCEtDNNzJc0mtf79POfv4I6MOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aur=C3=A9lien=20Bombo?= <abombo@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Greg Kurz <gkurz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 96/96] virtiofs: fix UAF on submount umount
Date: Thu,  2 Jul 2026 18:20:28 +0200
Message-ID: <20260702155110.999408812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 06b41351779e9289e8785694ade9042ae85e41ea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -330,8 +330,14 @@ void fuse_release_common(struct file *fi
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
-	fuse_file_put(ff, false, isdir);
+	fuse_file_put(ff, ff->fm->fc->auto_submounts, isdir);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)


