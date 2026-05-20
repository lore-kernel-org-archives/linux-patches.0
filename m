Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8E74F5E0;
	Wed, 20 May 2026 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300644; cv=none; b=Is2yGRWwMcsisAhkiMl5vtOMfM302L9nDGlgturvkqPLfjfJnvIENyNJAnQMEOW9md39gPMU/X2r3hB3w6OFJf6X98xhCWwNU2sKJKFQYH1SI4PQ+u4VogDKhnclEX4nnm3PA1I5YfMHy4wUXx7ARjuFMfTqjBHSHBay3rgUWSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300644; c=relaxed/simple;
	bh=4DR4Mah4p8X4YdVKQ8bSBZd9mXnQlVmSANCa1gpb6eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB/wZxzKLwKp3YNw54z3L/uKOyOCiLxDGC9+iEOrMu966m5Gg2hDlwOFCrvZi8QKNQc9UptzpHJCRkJj4W1e3tGltnxiF22/+1A1c/f7Vc4tUYwtvKJJ1ycUGILC5un6OLQVS7faAW1rP3qsPhMbM3VNI8Tn/wRETskecJBcHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qu779zfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qu779zfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C491F000E9;
	Wed, 20 May 2026 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300643;
	bh=iVjSbWb+wRRmJ0/uJ/yEuwh7MQPbDca6+APcvIGebhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qu779zfTP+Y0yJ++RKDfnu2wMLowdtDI0ENFVVJ+FlGqDmyNA0dfy0KXeKtcFGOOj
	 9mlOW2aBl14hXiZlzeN/a3LqdALzBM6vq9dyqisAAQm38iLa/o4FwXuV03EJnpg8OL
	 znBheviWsxVdToaivhU0szPvQiwM7WmYlVcvqiN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ea5108a1f5fb4fcc2d8@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/666] gfs2: Call unlock_new_inode before d_instantiate
Date: Wed, 20 May 2026 18:17:42 +0200
Message-ID: <20260520162116.657750873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2ff7cf7e0640ff071ebc5c7e3dc2df024a7c91e6 ]

As Neil Brown describes in detail in the link referenced below, new
inodes must be unlocked before they can be instantiated.

An even better fix is to use d_instantiate_new(), which combines
d_instantiate() and unlock_new_inode().

Fixes: 3d36e57ff768 ("gfs2: gfs2_create_inode rework")
Reported-by: syzbot+0ea5108a1f5fb4fcc2d8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-fsdevel/177153754005.8396.8777398743501764194@noble.neil.brown.name/
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c37079718fdd5..e6fe1a95d9304 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -893,7 +893,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock4;
 
 	mark_inode_dirty(inode);
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 	/* After instantiate, errors should result in evict which will destroy
 	 * both inode and iopen glocks properly. */
 	if (file) {
@@ -905,7 +905,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_glock_dq_uninit(&gh);
 	gfs2_glock_put(io_gl);
 	gfs2_qa_put(dip);
-	unlock_new_inode(inode);
 	return error;
 
 fail_gunlock4:
-- 
2.53.0



