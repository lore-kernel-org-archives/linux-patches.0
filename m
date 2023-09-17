Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002366FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583E8C433C7;
	Sun, 17 Sep 2023 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980573;
	bh=JCfKoVL7XCImyp9xBhwFHJ5phPA68pbyU4XIZ7//244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziLNA4+Z21REX/AgsESX6CwI8Ivnb59dcI0CF082zzaVaK5zBXfiZy8yUq6peziOk
	 6kEEC4Fl9/u25GH1prk8dnH64E/4SOrO/Sqp2HG76YG7U9KzEL/po3/TsSTfLxVcyv
	 ZCEH7IGq/Qd23AMheNa6IIHKAiNd5LORLtgpyyv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanmeisi <ruan.meisi@zte.com.cn>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.5 201/285] fuse: nlookup missing decrement in fuse_direntplus_link
Date: Sun, 17 Sep 2023 21:13:21 +0200
Message-ID: <20230917191058.539277400@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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
@@ -243,8 +243,16 @@ retry:
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


