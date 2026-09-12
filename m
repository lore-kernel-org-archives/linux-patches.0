Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAA3374A12;
	Sat, 12 Sep 2026 09:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204906; cv=none; b=FM/yMkvsIxgrkjCu6h0tv1iQTjaIuVCYkEQ39neOqrUTlTMGBdfj0c1xkAQ99GYvroezOohow2WjboUi9W3/gUbqjMyHviczX85OGSiFU9OTibclqoUK+FiNP9HsZrq4+MQBiP/9XvKVjeua0GG1jWZ8fGjx1tuzRH3svU87pxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204906; c=relaxed/simple;
	bh=oMkN3II1tnqd7IiT2BKhyLrI6/gUwcQuSx6F46ARYnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBDcvWc5HaH0VgFtuKpHBzH6WGm0WYtS1Y8pOSEpZvz7odQlw7lGEO/H5RVHNIq+BtzeBkVYgN6dYJw++ItsMb1gS5K/tAd7ToIZVMf9zb573BBtlbh10uFDFzM0PwqwA3Vo3M1wlcdiSBoBO+L/xqND3MBoKOCaTAMbefvIvF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aO6e2KNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aO6e2KNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FFA1F000FF;
	Sat, 12 Sep 2026 09:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204905;
	bh=4XaaFogjBSrgEhUlFXw7cQ7FolB+r1ih68kaFbh7Nvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aO6e2KNTBQJbfmcrWnmUSY9lYodC21Vsc5XS1VYNnxQwLMPraPjqd310mm/zVIiKC
	 Wki5Ug/20qrOu5JfkqHWVvw/lAhqmtFmjyyiythjAP6JI4EkXtPxF/alZYLa9doYm1
	 USRCyDqMHKPMp5jnlCv+AFVb/5G7I/iUEBmmvOto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1710/1815] fuse: use release/acquire for fch->initialized
Date: Sat, 12 Sep 2026 08:57:40 +0200
Message-ID: <20260912065729.121502330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 4ef7c8cc9894fccc7aa5fdaf6b39faa45c58c23e ]

fuse_chan_set_initialized() sets values for the connection state and
then sets fch->initialized to true, but lockless readers read
fch->initialized and if true, go to read the connection state values,
without using any barriers.

There are a few instances where this happens (fuse_uring_cmd() before
dispatching register / commit-and-fetch cmds, fuse_dev_do_wriite() for
handling notify retrieves, etc).

To make this as simple as possible, use release/acquire semantics for
writing/reading fch->initialized. Add the missing read barriers.
This is not marked for stable as these are not realistically reachable
on a well-behaved server, and buggy/malicious servers who trigger this
path fail benignly rather than crash or deadlock the kernel.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 1f59015e9581 ("fuse: Fix the condition to enable over-io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/cuse.c      |  3 ++-
 fs/fuse/dev.c       | 14 ++++++--------
 fs/fuse/dev_uring.c |  4 +++-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 1c71783ca5a51..4079cf8e5974a 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -530,7 +530,8 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
 
 	INIT_LIST_HEAD(&cc->list);
 
-	cc->fc.chan->initialized = 1;
+	/* Pairs with smp_load_acquire() readers of fch->initialized */
+	smp_store_release(&cc->fc.chan->initialized, 1);
 	rc = cuse_send_init(cc);
 	if (rc) {
 		fuse_dev_put(fud);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index e7da62a7293dc..a82cf763f50db 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -80,20 +80,17 @@ void fuse_chan_set_initialized(struct fuse_chan *fch, struct fuse_chan_param *pa
 			fuse_uring_conn_init(fch);
 	}
 
-	/* Make sure stores before this are seen on another CPU */
-	smp_wmb();
-	fch->initialized = 1;
+	/* Pairs with smp_load_acquire() readers of fch->initialized */
+	smp_store_release(&fch->initialized, 1);
 	wake_up_all(&fch->blocked_waitq);
 }
 
 static bool fuse_block_alloc(struct fuse_chan *fch, bool for_background)
 {
-	if (!fch->initialized)
+	/* Pairs with smp_store_release() in fuse_chan_set_initialized() */
+	if (!smp_load_acquire(&fch->initialized))
 		return true;
 
-	/* Pairs with smp_wmb() in fuse_chan_set_initialized() */
-	smp_rmb();
-
 	return (for_background && fch->blocked) ||
 	       (fch->io_uring && fch->connected && !fuse_uring_ready(fch));
 }
@@ -1891,7 +1888,8 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 		 * initialized and connected state
 		 */
 		err = -EINVAL;
-		if (!fch->initialized || !fch->connected)
+		/* Pairs with smp_store_release() in fuse_chan_set_initialized() */
+		if (!smp_load_acquire(&fch->initialized) || !fch->connected)
 			goto copy_finish;
 
 		/* Don't try to move folios (yet) */
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 82da15a9cc787..bda2b2cda190e 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1251,8 +1251,10 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	/*
 	 * fuse_uring_register() needs the ring to be initialized,
 	 * we need to know the max payload size
+	 *
+	 * Pairs with smp_store_release() in fuse_chan_set_initialized()
 	 */
-	if (!fch->initialized)
+	if (!smp_load_acquire(&fch->initialized))
 		return -EAGAIN;
 
 	switch (cmd_op) {
-- 
2.53.0



