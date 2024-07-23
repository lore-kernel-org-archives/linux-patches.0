Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E681586CB;
	Tue, 23 Jul 2024 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759521; cv=none; b=Yex2BJpUiKEI4V2p1pQ9LXbykvZ+ew/2mqdvX/OWm9o/hIz3JW3LzQIjiuc67ec5AVSe+hjhokmZUjJZnXHRciSEA0XgxeMeMj5uvtKZ1zhmv/b8hurYRyVmjliWzDznJzQsBpwWeqAbS549EPAv5cpyDvivLpnOg/iusD1FeVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759521; c=relaxed/simple;
	bh=sW9DboHZtV6ehGxJtSolLHOiYKhmcieDyYUQ0HGsh9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKNLQnb+V5rglwkEnCDJrYDEJiyuvQ1AvS4+wt7cTnMW22cel07w6afpO/0+E/797OU/BB3Uk2Rfk5MgqDrWDACUqkLrBUsraltqJILEK0Cpw3fe9hsKMybUtPkziAOuz2wBPqIeCMK9F3d3jzSANAnAqL+dwTsX+Yq8unY329k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKlGIP5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKlGIP5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C27AC4AF09;
	Tue, 23 Jul 2024 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759521;
	bh=sW9DboHZtV6ehGxJtSolLHOiYKhmcieDyYUQ0HGsh9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKlGIP5Wwx3hxwcDt2m4iTe1797RApHkXabwNSf14T5ILTQ186UXC5Dd4FgFmdgIC
	 vIQjxLw3ARczg4VDApAzt34FcZ+9vqUc9cZyS2ioxY9NJNa+DruMgfQDl61KbVYlge
	 XT1gmIy5q8APFge5CFFwvFZmQAO3dIl8LIAxLugA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/129] nfs: dont invalidate dentries on transient errors
Date: Tue, 23 Jul 2024 20:23:07 +0200
Message-ID: <20240723180406.300009651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 0c8c7c559740d2d8b66048162af6c4dba8f0c88c ]

This is a slight variation on a patch previously proposed by Neil Brown
that never got merged.

Prior to commit 5ceb9d7fdaaf ("NFS: Refactor nfs_lookup_revalidate()"),
any error from nfs_lookup_verify_inode() other than -ESTALE would result
in nfs_lookup_revalidate() returning that error (-ESTALE is mapped to
zero).

Since that commit, all errors result in nfs_lookup_revalidate()
returning zero, resulting in dentries being invalidated where they
previously were not (particularly in the case of -ERESTARTSYS).

Fix it by passing the actual error code to nfs_lookup_revalidate_done(),
and leaving the decision on whether to  map the error code to zero or
one to nfs_lookup_revalidate_done().

A simple reproducer is to run the following python code in a
subdirectory of an NFS mount (not in the root of the NFS mount):

---8<---
import os
import multiprocessing
import time

if __name__=="__main__":
    multiprocessing.set_start_method("spawn")

    count = 0
    while True:
        try:
            os.getcwd()
            pool = multiprocessing.Pool(10)
            pool.close()
            pool.terminate()
            count += 1
        except Exception as e:
            print(f"Failed after {count} iterations")
            print(e)
            break
---8<---

Prior to commit 5ceb9d7fdaaf, the above code would run indefinitely.
After commit 5ceb9d7fdaaf, it fails almost immediately with -ENOENT.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2a0f069d5a096..39f7549afcf5b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1625,7 +1625,16 @@ nfs_lookup_revalidate_done(struct inode *dir, struct dentry *dentry,
 	switch (error) {
 	case 1:
 		break;
-	case 0:
+	case -ETIMEDOUT:
+		if (inode && (IS_ROOT(dentry) ||
+			      NFS_SERVER(inode)->flags & NFS_MOUNT_SOFTREVAL))
+			error = 1;
+		break;
+	case -ESTALE:
+	case -ENOENT:
+		error = 0;
+		fallthrough;
+	default:
 		/*
 		 * We can't d_drop the root of a disconnected tree:
 		 * its d_hash is on the s_anon list and d_drop() would hide
@@ -1680,18 +1689,8 @@ static int nfs_lookup_revalidate_dentry(struct inode *dir,
 
 	dir_verifier = nfs_save_change_attribute(dir);
 	ret = NFS_PROTO(dir)->lookup(dir, dentry, fhandle, fattr);
-	if (ret < 0) {
-		switch (ret) {
-		case -ESTALE:
-		case -ENOENT:
-			ret = 0;
-			break;
-		case -ETIMEDOUT:
-			if (NFS_SERVER(inode)->flags & NFS_MOUNT_SOFTREVAL)
-				ret = 1;
-		}
+	if (ret < 0)
 		goto out;
-	}
 
 	/* Request help from readdirplus */
 	nfs_lookup_advise_force_readdirplus(dir, flags);
@@ -1735,7 +1734,7 @@ nfs_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
 			 unsigned int flags)
 {
 	struct inode *inode;
-	int error;
+	int error = 0;
 
 	nfs_inc_stats(dir, NFSIOS_DENTRYREVALIDATE);
 	inode = d_inode(dentry);
@@ -1780,7 +1779,7 @@ nfs_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
 out_bad:
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
-	return nfs_lookup_revalidate_done(dir, dentry, inode, 0);
+	return nfs_lookup_revalidate_done(dir, dentry, inode, error);
 }
 
 static int
-- 
2.43.0



