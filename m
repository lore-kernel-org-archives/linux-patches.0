Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C5B4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2C0C433D7;
	Mon, 14 Nov 2022 13:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431259;
	bh=MeCjzb52SQGnpXmUF4DJkH+20o75kCKcTeZqrYUcdkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GP1fuU2r8KZkm5JDyNkgbj3IPbuICZ2wSvMcdWnAuBOWZ11MdNMpssqsVBJo6iuuS
	 2ZftoWgF901XmeMVHWvxPmnsvWTvg+1tMm3jCau9BRW6w1wkhkyxp1hwvsH8QZlgup
	 pDCbFEAO/QAgKtyjeChDx9LwbnJnqfxifGkk3IS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	syzbot+6087eafb76a94c4ac9eb@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 159/190] mm/damon/dbgfs: check if rm_contexts input is for a real context
Date: Mon, 14 Nov 2022 13:46:23 +0100
Message-Id: <20221114124505.767347534@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: SeongJae Park <sj@kernel.org>

commit 1de09a7281edecfdba19b3a07417f6d65243ab5f upstream.

A user could write a name of a file under 'damon/' debugfs directory,
which is not a user-created context, to 'rm_contexts' file.  In the case,
'dbgfs_rm_context()' just assumes it's the valid DAMON context directory
only if a file of the name exist.  As a result, invalid memory access
could happen as below.  Fix the bug by checking if the given input is for
a directory.  This check can filter out non-context inputs because
directories under 'damon/' debugfs directory can be created via only
'mk_contexts' file.

This bug has found by syzbot[1].

[1] https://lore.kernel.org/damon/000000000000ede3ac05ec4abf8e@google.com/

Link: https://lkml.kernel.org/r/20221107165001.5717-2-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: syzbot+6087eafb76a94c4ac9eb@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>	[5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/dbgfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -882,6 +882,7 @@ out:
 static int dbgfs_rm_context(char *name)
 {
 	struct dentry *root, *dir, **new_dirs;
+	struct inode *inode;
 	struct damon_ctx **new_ctxs;
 	int i, j;
 	int ret = 0;
@@ -897,6 +898,12 @@ static int dbgfs_rm_context(char *name)
 	if (!dir)
 		return -ENOENT;
 
+	inode = d_inode(dir);
+	if (!S_ISDIR(inode->i_mode)) {
+		ret = -EINVAL;
+		goto out_dput;
+	}
+
 	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
 			GFP_KERNEL);
 	if (!new_dirs) {


