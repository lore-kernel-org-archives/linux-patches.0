Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F7111705;
	Sat,  3 Feb 2024 04:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933923; cv=none; b=mKaaXnKSJ5WXTzJXes9sAg2OVuKDreuYc5N54osSs+TPWcTr+GSFjgPDwgg3NbBrGqMP5EUQqF8h0MYVzXhq/WEmGqV1b6b0suU+/1lrG9xzJzN2fx1BQnZDRzl91PDq2CJd6MqNJdcKuxRxrXi1rKL2chp+hwuTH9sCVp3c+aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933923; c=relaxed/simple;
	bh=SoPZCF6a+waGbRmxLTZUW9zNu8Im2HpVj4AAPKAy7EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Atp22COqFOzadxbZMQw6cXNNKN9rzN06euyQHwGS8gv8+mUfcoI1ZKgyDETG0a9lcaP/4csH1ICf5S3B330bvvboQOVtjDAcz02lEb7Y9/XfYGOxPostrI4SmDxIAmQFjQqe9PrXxS7CSPEjBn71EyPFNmMMNCQpzfRec2CRzY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJP4Di9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJP4Di9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4F5C43394;
	Sat,  3 Feb 2024 04:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933923;
	bh=SoPZCF6a+waGbRmxLTZUW9zNu8Im2HpVj4AAPKAy7EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJP4Di9vObqYk/jbNOirJLAZ7O8NmvMN1V6j2+xeSeGQLqWgpEwdQinIHwX/NimKu
	 VwGInHVRAQ1h5075Qrzv2LSB8O0vkpcVn/fjqWL9XQaMpXhIFgdZ4ZhAmzAQq1/QKF
	 /R1myLe7cWk09eeJPu7wd1mgufdBvBqd/6lqGh0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 279/353] ceph: fix deadlock or deadcode of misusing dget()
Date: Fri,  2 Feb 2024 20:06:37 -0800
Message-ID: <20240203035412.600441339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 2c0b8dc3dd0d..9c02f328c966 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4887,13 +4887,15 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 			       struct inode *dir,
 			       int mds, int drop, int unless)
 {
-	struct dentry *parent = NULL;
 	struct ceph_mds_request_release *rel = *p;
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
 	struct ceph_client *cl;
 	int force = 0;
 	int ret;
 
+	/* This shouldn't happen */
+	BUG_ON(!dir);
+
 	/*
 	 * force an record for the directory caps if we have a dentry lease.
 	 * this is racy (can't take i_ceph_lock and d_lock together), but it
@@ -4903,14 +4905,9 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
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
 
 	cl = ceph_inode_to_client(dir);
 	spin_lock(&dentry->d_lock);
-- 
2.43.0



