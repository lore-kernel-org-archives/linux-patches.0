Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD833F8A2;
	Sat, 30 May 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161234; cv=none; b=Lp8AvUJxXh8ZBN2g7lBdyt2yRIrwxaV2HV6Wh+qEfnu+HkL0W9EM7PV1kuJkyQOCrqyNuZOpzpUfbXnjJMshQ/6gviDUd09UdNLWtcGSnwb4r0E2BgBaAs38yfSvF4MuyRJB5kjvz7eCc+7QE4j6z2+gYlxyBigltK9ky2F2WA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161234; c=relaxed/simple;
	bh=mdSf650pbY2RE55QNkmg9eqjdOoXW/feUtQRMhp0Pis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jka/9AE/MDDuTXe/uH7N8CfBNK+FfF5+oXOGp3MLqSpg56Dx2egw/QP6LeN9CEu9oFBUIEsk7BarLoehfgxYuIb/8B+Wyss3u7SwVPvZGUqLP15tghnm6DZ6TSYapI17dLFSeyhNCzFm1A1IvdI+CpjdkfAUKaCaKxAEsd5/WhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkBv0MGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkBv0MGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E511F00893;
	Sat, 30 May 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161233;
	bh=cFMLg1FuTO8L+QGP5/XiNEPHT5Ig58YdCQ3VEp0Z3Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkBv0MGPM4HnSdrZNij8XMDCGU0d3vSIOHuMixTyeo2rmJY+D0eplhcq86A023wEm
	 gEq0nGXPozMMjMIOt3FOg+m9QkBpLLAn/tsg0ugW2RYXUzcLBKKbXckNuiQRZqIYvm
	 fMaKjfGFFBP0MsQ9LRD2nhWIrJeqRpMPt933dpak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ea5108a1f5fb4fcc2d8@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 563/969] gfs2: Call unlock_new_inode before d_instantiate
Date: Sat, 30 May 2026 18:01:27 +0200
Message-ID: <20260530160315.934717518@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 3048e3ca4b382..c291b9382e994 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -779,7 +779,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock4;
 
 	mark_inode_dirty(inode);
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 	/* After instantiate, errors should result in evict which will destroy
 	 * both inode and iopen glocks properly. */
 	if (file) {
@@ -791,7 +791,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_glock_dq_uninit(ghs + 1);
 	gfs2_glock_put(io_gl);
 	gfs2_qa_put(dip);
-	unlock_new_inode(inode);
 	return error;
 
 fail_gunlock4:
-- 
2.53.0



