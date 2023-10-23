Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6051F4FE
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CHeGHSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22311C433C7;
	Mon, 23 Oct 2023 11:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059462;
	bh=wJ7pUbV84HiffUVhOn+ycNrRDqskNchTw9sMiOWTrWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CHeGHScdgXNC9lXgpxYkx1Nty+PPbrYE8zeRoVauzz79Fb/SqOd/8guBIvuX3PTa
	 wp4lt3gIgxyiP0Krwt7K9//q/FvOOgnT061waPJTg8DF5DSlwfRd04kPKRdBeYylnA
	 4SL9t1IMYNFXo3uRx3fSQLvoE5/5n1BU4/uiL0vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.5 186/241] fanotify: limit reporting of event with non-decodeable file handles
Date: Mon, 23 Oct 2023 12:56:12 +0200
Message-ID: <20231023104838.416246576@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 97ac489775f26acfd46a8a60c2f84ce7cc79fa4b upstream.

Commit a95aef69a740 ("fanotify: support reporting non-decodeable file
handles") merged in v6.5-rc1, added the ability to use an fanotify group
with FAN_REPORT_FID mode to watch filesystems that do not support nfs
export, but do know how to encode non-decodeable file handles, with the
newly introduced AT_HANDLE_FID flag.

At the time that this commit was merged, there were no filesystems
in-tree with those traits.

Commit 16aac5ad1fa9 ("ovl: support encoding non-decodable file handles"),
merged in v6.6-rc1, added this trait to overlayfs, thus allowing fanotify
watching of overlayfs with FAN_REPORT_FID mode.

In retrospect, allowing an fanotify filesystem/mount mark on such
filesystem in FAN_REPORT_FID mode will result in getting events with
file handles, without the ability to resolve the filesystem objects from
those file handles (i.e. no open_by_handle_at() support).

For v6.6, the safer option would be to allow this mode for inode marks
only, where the caller has the opportunity to use name_to_handle_at() at
the time of setting the mark. In the future we can revise this decision.

Fixes: a95aef69a740 ("fanotify: support reporting non-decodeable file handles")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20231018100000.2453965-2-amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify_user.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index f69c451018e3..62fe0b679e58 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1585,16 +1585,25 @@ static int fanotify_test_fsid(struct dentry *dentry, __kernel_fsid_t *fsid)
 }
 
 /* Check if filesystem can encode a unique fid */
-static int fanotify_test_fid(struct dentry *dentry)
+static int fanotify_test_fid(struct dentry *dentry, unsigned int flags)
 {
+	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
+	const struct export_operations *nop = dentry->d_sb->s_export_op;
+
+	/*
+	 * We need to make sure that the filesystem supports encoding of
+	 * file handles so user can use name_to_handle_at() to compare fids
+	 * reported with events to the file handle of watched objects.
+	 */
+	if (!nop)
+		return -EOPNOTSUPP;
+
 	/*
-	 * We need to make sure that the file system supports at least
-	 * encoding a file handle so user can use name_to_handle_at() to
-	 * compare fid returned with event to the file handle of watched
-	 * objects. However, even the relaxed AT_HANDLE_FID flag requires
-	 * at least empty export_operations for ecoding unique file ids.
+	 * For sb/mount mark, we also need to make sure that the filesystem
+	 * supports decoding file handles, so user has a way to map back the
+	 * reported fids to filesystem objects.
 	 */
-	if (!dentry->d_sb->s_export_op)
+	if (mark_type != FAN_MARK_INODE && !nop->fh_to_dentry)
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -1812,7 +1821,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		if (ret)
 			goto path_put_and_out;
 
-		ret = fanotify_test_fid(path.dentry);
+		ret = fanotify_test_fid(path.dentry, flags);
 		if (ret)
 			goto path_put_and_out;
 
-- 
2.42.0



