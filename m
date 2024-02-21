Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5163469E00;
	Wed, 21 Feb 2024 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525437; cv=none; b=EMya8fT3yPFlPe1Ytazq74PoJS1YJ8qeQM1vXVANUOiLAokSIa5Qg1ev0j02Bd0ZwGh/Qj0fKyli5+dmVpkPB2LGdJia9CS/o3yc/upPhbzu/bVsLBHylAnyHIgVjwTOfVe2KqVkmUZoIQlJWWSFAydt13/9hExNMjnAzjV2KWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525437; c=relaxed/simple;
	bh=gELpO2MbBXKae89WYyHu29Xv0k+9vROipg2a9i41GZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoZfJBnflIQF93klrzZbmKPDZA0QGeOVMoEGT+uA5oK4MnLdLYKg3YLWFmliwFOR3Nnw13xv6pmfdk4fYYf2QiI3kCBu3d+bULJKN1xo9mOsYFia5O814OPDA8p+3Srry+GJgSsWmHBMq74c4QN+FDrWrCJEiVXjCJmxNdAsfMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EO7CxTf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EO7CxTf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7554BC433C7;
	Wed, 21 Feb 2024 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525436;
	bh=gELpO2MbBXKae89WYyHu29Xv0k+9vROipg2a9i41GZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EO7CxTf+OQJpnm7tdmiqVQXz0V5Q2AREIwPqoUrFzHItEEJ2W/op+lhpksTcU1YtH
	 KeLcWeYIdHt9n6YQrenfglqD/zliTz3HxpdpwsV+AZ1img0a2PFjtAogasrspEwXkb
	 Ayo04/PELKwaIGxQtwJXEoldlM7onfAP8WOAz39k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/267] ceph: fix deadlock or deadcode of misusing dget()
Date: Wed, 21 Feb 2024 14:08:16 +0100
Message-ID: <20240221125944.937499828@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4e88cb990723..45b8f6741f8d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4304,12 +4304,14 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
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
@@ -4319,14 +4321,9 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
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



