Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7179243AD9;
	Sat,  3 Feb 2024 04:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933663; cv=none; b=tHzdq7JisYhd7JcFmbjAvaBrN/Rg7i0w22a/pHwXF2DqONYGgkt7L9OtqzAALsrGqWQMxKbIdqygb0b/Fw0T1gRF2rJcQULokwp1aPfRTbOV8tr9fMNMK3wG5/X0q0EkTTL3p2E8xJa9cWJ16p6wec6MHvRq0063yfm63t9HqJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933663; c=relaxed/simple;
	bh=eVnnqzkcU+PbqUTLOU+jYLr7BB2XUfV5aUSHvTIhxbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1HIxKpgasfUhxp5PR1kYZ1tC+eaj9OTpNPQUT8oIvYS7yf/XJGV2BsuNzk3cHmp8O3+7G/PVgYSDG+0Rs2NB8gLqn56lq3YOByEcaKDI+lkGRvvyboOQ7DV144iP1esSkOfUJe7Ztb7W/Wzi/5bF6Qqe5qz2pDQ4xOzXXYAB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXQarzgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXQarzgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3A1C43390;
	Sat,  3 Feb 2024 04:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933663;
	bh=eVnnqzkcU+PbqUTLOU+jYLr7BB2XUfV5aUSHvTIhxbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXQarzgi5IZS27m1rq665gouqcAqsCUjfd+bZa1InnWf/m7XrIVepNQ9qihY0oSrx
	 g7PeGOK4muiwqxGjTmVlr6enMSTnR5hTstNqcgCcivnVFSPtSlfHzEkmb9Eg/KVEM0
	 dUG93eIrkYcit1swbUSwgSF8HQIa5PK64MTslP7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/322] ceph: fix deadlock or deadcode of misusing dget()
Date: Fri,  2 Feb 2024 20:05:48 -0800
Message-ID: <20240203035407.271307253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit b493ad718b1f0357394d2cdecbf00a44a36fa085 ]

The lock order is incorrect between denty and its parent, we should
always make sure that the parent get the lock first.

But since this deadcode is never used and the parent dir will always
be set from the callers, let's just remove it.

Link: https://lore.kernel.org/r/20231116081919.GZ1957730@ZenIV
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 14215ec646f7..7f7e5f5d643c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4780,12 +4780,14 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 			       struct inode *dir,
 			       int mds, int drop, int unless)
 {
-	struct dentry *parent = NULL;
 	struct ceph_mds_request_release *rel = *p;
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
 	int force = 0;
 	int ret;
 
+	/* This shouldn't happen */
+	BUG_ON(!dir);
+
 	/*
 	 * force an record for the directory caps if we have a dentry lease.
 	 * this is racy (can't take i_ceph_lock and d_lock together), but it
@@ -4795,14 +4797,9 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	spin_lock(&dentry->d_lock);
 	if (di->lease_session && di->lease_session->s_mds == mds)
 		force = 1;
-	if (!dir) {
-		parent = dget(dentry->d_parent);
-		dir = d_inode(parent);
-	}
 	spin_unlock(&dentry->d_lock);
 
 	ret = ceph_encode_inode_release(p, dir, mds, drop, unless, force);
-	dput(parent);
 
 	spin_lock(&dentry->d_lock);
 	if (ret && di->lease_session && di->lease_session->s_mds == mds) {
-- 
2.43.0



