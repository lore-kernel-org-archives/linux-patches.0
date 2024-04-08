Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9787D3FE;
	Mon,  8 Apr 2024 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584844; cv=none; b=XQfyVowq/q1QocBWdparxWoKrcBXXUattZMPvjV3XHHCXMsXmO9moAA62+B0zTWxJt7lXH9Sz/TcdFBCmzu8yMwdAkC0ahXjxk2BroNT16S26w4M/FgFNXDYPkSf+V0e5jPlPXIdMsIaW90PiqFsEhj4x8YSag5E+NviQt6Bd58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584844; c=relaxed/simple;
	bh=ea8aiDlL4oIE2vsqvWd1mxRa6jomX9pvUdgOEUiFRWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWidVUwLKpJTyI4K7aN8jnb/bVnpibs70O6Y6Szn14W5mwZfLDDyfgSmWOHJSCDwIRrm1G/8pOdgouuqz56SZJ3mpIF/WEp2ejo2wRjYasdRyj9k3IRoDZQ/Sz/XhXF/a5KDqyrxrr+qCIesTmpZSYVDt/alKghhm0NnUzTWsCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgWvmD3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgWvmD3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45039C433F1;
	Mon,  8 Apr 2024 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584844;
	bh=ea8aiDlL4oIE2vsqvWd1mxRa6jomX9pvUdgOEUiFRWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgWvmD3QHqV84/KypMUCeZMCUpTi4Rs4sa9Xrcs3nZeQQYjOWvqOChjVtfK8uTzxG
	 x7z4hDkXrsUfsOGGpsZrh9LYgVneAAfa4GpXomywjYaFeAja2wlMT0qlwYzaPUwXfh
	 ReDKAimif5T8hC15vUtUMCyDwqNLjJgIY8DDGrgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 549/690] NFSD: fix possible oops when nfsd/pool_stats is closed.
Date: Mon,  8 Apr 2024 14:56:55 +0200
Message-ID: <20240408125419.518748990@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 88956eabfdea7d01d550535af120d4ef265b1d02 ]

If /proc/fs/nfsd/pool_stats is open when the last nfsd thread exits, then
when the file is closed a NULL pointer is dereferenced.
This is because nfsd_pool_stats_release() assumes that the
pointer to the svc_serv cannot become NULL while a reference is held.

This used to be the case but a recent patch split nfsd_last_thread() out
from nfsd_put(), and clearing the pointer is done in nfsd_last_thread().

This is easily reproduced by running
   rpc.nfsd 8 ; ( rpc.nfsd 0;true) < /proc/fs/nfsd/pool_stats

Fortunately nfsd_pool_stats_release() has easy access to the svc_serv
pointer, and so can call svc_put() on it directly.

Fixes: 9f28a971ee9f ("nfsd: separate nfsd_last_thread() from nfsd_put()")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfssvc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index ee5713fca1870..2a1dd580dfb94 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -1084,11 +1084,12 @@ int nfsd_pool_stats_open(struct inode *inode, struct file *file)
 
 int nfsd_pool_stats_release(struct inode *inode, struct file *file)
 {
+	struct seq_file *seq = file->private_data;
+	struct svc_serv *serv = seq->private;
 	int ret = seq_release(inode, file);
-	struct net *net = inode->i_sb->s_fs_info;
 
 	mutex_lock(&nfsd_mutex);
-	nfsd_put(net);
+	svc_put(serv);
 	mutex_unlock(&nfsd_mutex);
 	return ret;
 }
-- 
2.43.0



