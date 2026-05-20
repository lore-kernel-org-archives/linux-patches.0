Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075C9366816;
	Wed, 20 May 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295499; cv=none; b=Nl2TICKlh14STak8ggmOqU+RhdBaPTS87lY7iELyzJ32rQ2WMb1ehOSGSTn5u5dOPtWmknU/LNuhSxg1w39g6IIW66gbPYpK8z2ReyLelyRyWgP8ZeqUUSASjWVmDaMSAqnPKVr1byQ2ZCL/NU9WI1rBW2KCcBiSzhVxSQS8N/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295499; c=relaxed/simple;
	bh=HoJ8H8xgXtRBniRlbEcBEZrOhCb1903+4LoLmHyCeDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlH418pk1ISxLsaWdVijklRn+iJ3WbOt9G1/aJx9mlqZ4aXzFXN25W8RA9MFiitp1/Ckq6qyhFCgdk+vYONUiGyUvC95yWhQ9zV7/RiyAaOS8gKd9V73nMlgPH4H6aj17Blb+stX3sosIQ8oeqldS0Tw71MpT16Jsfl0GpGGMcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh89xU3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh89xU3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7E11F000E9;
	Wed, 20 May 2026 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295497;
	bh=zoKYOqfFGB7BxPJNDFlOHPi6WgvL5omBnTdjXg0QZxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh89xU3pBQjD7yrReR/acKCKFMrB90+wImSkiZ0C1/0VhypefSSBuNPcgSFN8FkY0
	 3zkgOfDcJG9G9EBwI1K9rAYDPg0iHcsMizbxAFnDOYYGBEYOoNE51YzspKfe9mTdfi
	 MM+AjuQH8JnoySB3IXvBu0RdEuypKuJZUJ93jotE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ea5108a1f5fb4fcc2d8@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0443/1146] gfs2: Call unlock_new_inode before d_instantiate
Date: Wed, 20 May 2026 18:11:33 +0200
Message-ID: <20260520162158.223898875@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 8344040ecaf79..e9bf4879c07f7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -892,7 +892,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock4;
 
 	mark_inode_dirty(inode);
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 	/* After instantiate, errors should result in evict which will destroy
 	 * both inode and iopen glocks properly. */
 	if (file) {
@@ -904,7 +904,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_glock_dq_uninit(&gh);
 	gfs2_glock_put(io_gl);
 	gfs2_qa_put(dip);
-	unlock_new_inode(inode);
 	return error;
 
 fail_gunlock4:
-- 
2.53.0



