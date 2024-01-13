Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C05D15AF;
	Sat, 13 Jan 2024 09:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWEBm+2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF94C433F1;
	Sat, 13 Jan 2024 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139674;
	bh=sT2J39qvPqqS2iz+wh5QZAQZKdkY7fOJ2qIjRQ/jAyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWEBm+2asp129xHEiiwk7RWbzQGe0cgBK/cXtClG1c5GjuXVsq0WObX+VVzD+hRLr
	 /RHaR/Mb1lmLw2SQQ7N6IQmmomfeUtcmHhURNM3McbYkPJ/nl89D6Q3O8GUIeVYwo6
	 HlEhB6WBXCTGYQMPFBo0huJX9pzI1nCpCSdTkEkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanmeisi <ruan.meisi@zte.com.cn>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 18/25] fuse: nlookup missing decrement in fuse_direntplus_link
Date: Sat, 13 Jan 2024 10:49:59 +0100
Message-ID: <20240113094205.613285965@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094205.025407355@linuxfoundation.org>
References: <20240113094205.025407355@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 fs/fuse/dir.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1314,8 +1314,16 @@ retry:
 			dput(dentry);
 			dentry = alias;
 		}
-		if (IS_ERR(dentry))
+		if (IS_ERR(dentry)) {
+			if (!IS_ERR(inode)) {
+				struct fuse_inode *fi = get_fuse_inode(inode);
+
+				spin_lock(&fc->lock);
+				fi->nlookup--;
+				spin_unlock(&fc->lock);
+			}
 			return PTR_ERR(dentry);
+		}
 	}
 	if (fc->readdirplus_auto)
 		set_bit(FUSE_I_INIT_RDPLUS, &get_fuse_inode(inode)->state);


