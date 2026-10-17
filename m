Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52A3C0630;
	Sat, 17 Oct 2026 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258455; cv=none; b=gkm5bP9t9/9YqCUWmXAFLVEpyRdLUbRGAnexpIVe6MY3o6hIxnN8emHIgAN8KsIij7wCTo6fExdNprxEtYb2R4QJTPAzeHSDJ9P0FS8E3yqqYXxKrRml6R/9XMoSPPXh/U7GYHMHxuBLqL9M2bIWobB52+MpVJTNhSBgfuEt2mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258455; c=relaxed/simple;
	bh=0xvVvPqwr9NwUbjZB4xEf2SYFyGkFQ397wEU2TyPjY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dimVJpWfQrwDK+Y5ek1znUancUfPjrZwG+4I9DDRpqsyODeLsot0cW1daQyR+uB+aFZy1ygdlclxO2lewW/BrSY12EmY5Kl0Bydzof3HIrjB+74s6sKfq3VG2+5q4GdhaQkv7IQSJNKJ4kvJouVIGw7cwt3arCmrSSJJ3fONh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNWml5ww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNWml5ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B1F1F000C6;
	Sat, 17 Oct 2026 17:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258454;
	bh=+JAOAB9LHhK8g/hGxeJB/9H2gE77zxi9wQkcRpiVb3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNWml5wwZFOnQwDpjyIRejwJOwdN4Zhx6fmbiQiPvTrmu699lLOe292azw7K62TUE
	 3YpbL2HLHQB5RepYq6X/zOd8gEfZ3aJbUqocMe+4UH8Y6or03y2c+xnIVFsJsPSjKl
	 SW1HGFZYl3SFMrUJsMdWNP7Jmpi0o3nNESjyG5l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0840/1674] functionfs, gadgetfs: use simple_recursive_removal()
Date: Sat, 17 Oct 2026 17:51:52 +0200
Message-ID: <20261017160452.689559601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bad356bb50e64170f8af14a00797a04313846aeb ]

usual mount leaks if something had been bound on top of disappearing
files there.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: e5bf5ee26663 ("functionfs: fix the open/removal races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 3 +--
 drivers/usb/gadget/legacy/inode.c  | 7 +------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index f2705e22ed732..253b8d08ce7df 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1934,8 +1934,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
-			d_delete(epfile->dentry);
-			dput(epfile->dentry);
+			simple_recursive_removal(epfile->dentry, NULL);
 			epfile->dentry = NULL;
 		}
 	}
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 07b1efc944281..3889b0ebdb90a 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1547,7 +1547,6 @@ static void destroy_ep_files (struct dev_data *dev)
 	spin_lock_irq (&dev->lock);
 	while (!list_empty(&dev->epfiles)) {
 		struct ep_data	*ep;
-		struct inode	*parent;
 		struct dentry	*dentry;
 
 		/* break link to FS */
@@ -1557,7 +1556,6 @@ static void destroy_ep_files (struct dev_data *dev)
 
 		dentry = ep->dentry;
 		ep->dentry = NULL;
-		parent = d_inode(dentry->d_parent);
 
 		/* break link to controller */
 		mutex_lock(&ep->lock);
@@ -1572,10 +1570,7 @@ static void destroy_ep_files (struct dev_data *dev)
 		put_ep (ep);
 
 		/* break link to dcache */
-		inode_lock(parent);
-		d_delete (dentry);
-		dput (dentry);
-		inode_unlock(parent);
+		simple_recursive_removal(dentry, NULL);
 
 		spin_lock_irq (&dev->lock);
 	}
-- 
2.53.0



