Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63C73E277C;
	Wed, 20 May 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302296; cv=none; b=XhiQShV8jQowoCNgfxKOWOuea1tfNDOiNYgafQPq+6mX+CSuU2q0Mhz/TpKhzCTG6dJ1ooCYcphgZHxnAJjUo5/X0TR+TkjLAfeORyTbeif5nOQsA0uksG6+qRtQCBW4lYC+CSkaueDUljMHY9FN8CyaeRkIk6X/RIttHUtqXTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302296; c=relaxed/simple;
	bh=2a6aCUz0zYyq+X9SJt7UEHzIQwzWSc3ELWC23qNdfwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdeb+v6k50IhtY1UAIOyLK94YqNghChy4dcWM/PwkncULZw/OWHUYbNne/Vyrttf1A4dGk9w8Qddvk4cv2w+Cjfw9rn+pue6ia8IdYCEednX+NwnihYX38HAiVcKh52Yh5ivcqO6NK7MUHs/bjnZn7L6T+b1t7FJgafUBnR4vCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PlOK8zj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PlOK8zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424681F000E9;
	Wed, 20 May 2026 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302295;
	bh=9zGl7Fr4g4dUndDGeyUpwcAXBWgYZIy1XTfnM4/Lz8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PlOK8zjMgwq73rXU8xsB9ynT90OHadMa06rJw2sfyLvrn8kXgJmt2P8Hc2wAgDYV
	 UcUAkEnamTh6doRxl3uctJCb4ZVcdrJjvaznMkns9LkUlKtpkDD7pFR6UD9zWVEMbF
	 2zbSePXHaTr6fsdiKhY4FrBDx4Dl+8lRapaxvQe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ea5108a1f5fb4fcc2d8@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/508] gfs2: Call unlock_new_inode before d_instantiate
Date: Wed, 20 May 2026 18:19:55 +0200
Message-ID: <20260520162102.364971216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 45040622d316e..18f75beea0890 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -805,7 +805,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock4;
 
 	mark_inode_dirty(inode);
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 	/* After instantiate, errors should result in evict which will destroy
 	 * both inode and iopen glocks properly. */
 	if (file) {
@@ -817,7 +817,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_glock_dq_uninit(&gh);
 	gfs2_glock_put(io_gl);
 	gfs2_qa_put(dip);
-	unlock_new_inode(inode);
 	return error;
 
 fail_gunlock4:
-- 
2.53.0



