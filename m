Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C4C15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B36C43391;
	Wed, 20 Sep 2023 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213556;
	bh=MWn8rNWEXCBI3dmlx4PY9Qp5TCptfbIg5BHviAx/sP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVz7RlOvmReIGOvwmQpEEVW7AWlx4bToFAyYUNZN36ZjbdzSE8VQdhA+9jMA5Inia
	 Ve9H9RatUxqt9lIgR3vp7iV1OUPBjBzHWynOBPNdrkd5KQSmdkdjElqe3O7ad7m9O4
	 vsVQBe/aNCbBSCj7XyCmLotYzT2URX+eWwV8KPXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanmeisi <ruan.meisi@zte.com.cn>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 281/367] fuse: nlookup missing decrement in fuse_direntplus_link
Date: Wed, 20 Sep 2023 13:30:58 +0200
Message-ID: <20230920112905.837442296@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ruanmeisi <ruan.meisi@zte.com.cn>

commit b8bd342d50cbf606666488488f9fea374aceb2d5 upstream.

During our debugging of glusterfs, we found an Assertion failed error:
inode_lookup >= nlookup, which was caused by the nlookup value in the
kernel being greater than that in the FUSE file system.

The issue was introduced by fuse_direntplus_link, where in the function,
fuse_iget increments nlookup, and if d_splice_alias returns failure,
fuse_direntplus_link returns failure without decrementing nlookup
https://github.com/gluster/glusterfs/pull/4081

Signed-off-by: ruanmeisi <ruan.meisi@zte.com.cn>
Fixes: 0b05b18381ee ("fuse: implement NFS-like readdirplus support")
Cc: <stable@vger.kernel.org> # v3.9
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/readdir.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -238,8 +238,16 @@ retry:
 			dput(dentry);
 			dentry = alias;
 		}
-		if (IS_ERR(dentry))
+		if (IS_ERR(dentry)) {
+			if (!IS_ERR(inode)) {
+				struct fuse_inode *fi = get_fuse_inode(inode);
+
+				spin_lock(&fi->lock);
+				fi->nlookup--;
+				spin_unlock(&fi->lock);
+			}
 			return PTR_ERR(dentry);
+		}
 	}
 	if (fc->readdirplus_auto)
 		set_bit(FUSE_I_INIT_RDPLUS, &get_fuse_inode(inode)->state);


