Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307F43E490;
	Tue, 16 Jun 2026 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629653; cv=none; b=AKIknemI//NkTL8NgD2DHSUC051qFAbI2XeLDyQ2j5P9hlICAlVgqaQi7y9dMOL2vTj/K/tkejjto3dvLV7JZ2KJDB6lwgnq/v/YURkvulqVGCa+teHzmSUkqMItnF+NRvXwDQKq3QnSbMdfElqu0EKmDP2ki+83dsMTUzQA0j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629653; c=relaxed/simple;
	bh=LlpwodpF0Uo3rNvMLoJyXNQUQnSCPom3Jj+rPBalqxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDg2UyNUhi4XYFlmwcrk12r/yANvrrXgB1LWZ5ajv/Ig690E/yUIqpEKyA5vdc222Sdh/vmt3CsOh08u5QjzxKNo5AUBNBBYbo8JCWh/mEycRPKPi/B0AR3sqkxc4Seags7TW0P8emREKEKXOhJZ2Yg0yQYIUimvOTCdQMITtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBtnyW0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBtnyW0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F8D1F000E9;
	Tue, 16 Jun 2026 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629652;
	bh=a9sfZw4TwSdY5nlpG66i3VZmci3DNS5t3l10LPzaZak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBtnyW0dfBswHOUFuXb379VsdFWy65KyBFryk5ISVH7J+1RskVCU/BYwjZCZxTe53
	 zyjbPI6yrNPZBGUK9YLdcNF+A9a1sHJB99D8q6PsbIPEXrT+cPVch0/FcYYbeMM3gy
	 VzzjFpkaxshloYEeExqa6P3MS74i0b+yU9q25sHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 326/452] fuse: reject fuse_notify() pagecache ops on directories
Date: Tue, 16 Jun 2026 20:29:13 +0530
Message-ID: <20260616145134.530683771@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1597,6 +1597,10 @@ static int fuse_notify_store(struct fuse
 	inode = fuse_ilookup(fc, nodeid,  NULL);
 	if (!inode)
 		goto out_up_killsb;
+	if (!S_ISREG(inode->i_mode)) {
+		err = -EINVAL;
+		goto out_iput;
+	}
 
 	mapping = inode->i_mapping;
 	index = outarg.offset >> PAGE_SHIFT;
@@ -1768,7 +1772,10 @@ static int fuse_notify_retrieve(struct f
 
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


