Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39250466B4C;
	Tue, 16 Jun 2026 17:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631823; cv=none; b=DTKGbAPo6E41BEGm31Bqb+rTy21tXh94SidLOrg0yrqhAIUNDpP7uJnO2X+E9lp3UzCJe0A3QoS8LQ8Co3WD3duUuP267fXcOlRIo612yNpqUAoB1sKLEuyuxUNXzygzbTBI7nxmLJvPi6ear6F2AdsXS8z9II8kKtGGGotHXes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631823; c=relaxed/simple;
	bh=zCNqkHDmHffJFyLGSlS584g+tVOVCisS1o/sjfyo+0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX06xFTCwGpXFveh29rGaNs5BQPfSTeJSVRGrlgoX9BYPSjiEl+EbjaEoxVM0ch1gkQ9OIhZ0sTvXnx0LdwEnLfQPnAY2PajfqvdOupzmGflSGCewiuYu32KUAhFFVZDypArDcyyLj86wYei7/NSNe2ubG76leiFKhPrQHhzAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doKQKugy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doKQKugy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075EE1F000E9;
	Tue, 16 Jun 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631821;
	bh=7CaRqJoJ/MsLZJVQpBgZ7PU1uXu/6y7a9TSTUbbOdBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doKQKugyfXIY2w14DZqM/64uoMwF1Xy13EBZXxTW0TfywGfAD2EXyoctjh55cQXIs
	 I/QQCrpHgw3pGp64Xc3x99X9EF3/PodzU6LE2OEC53xDeamDKqX/jxmToaAaGJIBS3
	 rEC5QVia12oMAbj8HNBCGozdvlofQvOubTFhH09o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 294/522] fuse: reject fuse_notify() pagecache ops on directories
Date: Tue, 16 Jun 2026 20:27:21 +0530
Message-ID: <20260616145139.677319796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 9c954499d43aefac01c5dfb57a82b13d2dcf4b94 upstream.

The operations FUSE_NOTIFY_STORE and FUSE_NOTIFY_RETRIEVE allow the
FUSE daemon to actively write/read pagecache contents.

For directories with FOPEN_CACHE_DIR, the pagecache is used as
kernel-internal cache storage, and userspace is not supposed to have
direct access to this cache - in particular, fuse_parse_cache() will hit
WARN_ON() if the cache contains bogus data.

Reject FUSE_NOTIFY_STORE and FUSE_NOTIFY_RETRIEVE on anything other than
regular files with -EINVAL.

Fixes: 5d7bc7e8680c ("fuse: allow using readdir cache")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260519-fuse-dir-pagecache-v2-1-5428fa48e175@google.com
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1593,6 +1593,10 @@ static int fuse_notify_store(struct fuse
 	inode = fuse_ilookup(fc, nodeid,  NULL);
 	if (!inode)
 		goto out_up_killsb;
+	if (!S_ISREG(inode->i_mode)) {
+		err = -EINVAL;
+		goto out_iput;
+	}
 
 	mapping = inode->i_mapping;
 	index = outarg.offset >> PAGE_SHIFT;
@@ -1764,7 +1768,10 @@ static int fuse_notify_retrieve(struct f
 
 	inode = fuse_ilookup(fc, nodeid, &fm);
 	if (inode) {
-		err = fuse_retrieve(fm, inode, &outarg);
+		if (!S_ISREG(inode->i_mode))
+			err = -EINVAL;
+		else
+			err = fuse_retrieve(fm, inode, &outarg);
 		iput(inode);
 	}
 	up_read(&fc->killsb);


