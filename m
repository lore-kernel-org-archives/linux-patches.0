Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00490847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70776C4339C;
	Wed,  1 Mar 2023 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694360;
	bh=OiZPvwZVrucXWalxQzzGbavRpgeH7WYhAYki02rIth0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJgN0kyTJcvY2t+KIBbE846oV9aADjpvoDd1hWWdzMlVmJh1bbh62mr+wBieJYTKJ
	 MYvQDwkgKOk6XdhqAo7h6Lu534Xuudru7Zs5WHlKspX/c1RF8+bhekfKbu6T1AVh0D
	 7aZ07O84BqUA8q466f6xJ5AM2mJLfyReNUpNP6uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.1 36/42] attr: add in_group_or_capable()
Date: Wed,  1 Mar 2023 19:08:57 +0100
Message-Id: <20230301180658.658059985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

In setattr_{copy,prepare}() we need to perform the same permission
checks to determine whether we need to drop the setgid bit or not.
Instead of open-coding it twice add a simple helper the encapsulates the
logic. We will reuse this helpers to make dropping the setgid bit during
write operations more consistent in a follow up patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c     |   10 +++++-----
 fs/inode.c    |   28 ++++++++++++++++++++++++----
 fs/internal.h |    2 ++
 3 files changed, 31 insertions(+), 9 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
@@ -140,8 +142,7 @@ int setattr_prepare(struct user_namespac
 			vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
 		/* Also check the setgid bit! */
-		if (!vfsgid_in_group_p(vfsgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, vfsgid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -251,9 +252,8 @@ void setattr_copy(struct user_namespace
 		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-		vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
-		if (!vfsgid_in_group_p(vfsgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode,
+					 i_gid_into_vfsgid(mnt_userns, inode)))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2488,6 +2488,28 @@ struct timespec64 current_time(struct in
 EXPORT_SYMBOL(current_time);
 
 /**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @mnt_userns: user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ * @vfsgid:	the new/current vfsgid of @inode
+ *
+ * Check wether @vfsgid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, vfsgid_t vfsgid)
+{
+	if (vfsgid_in_group_p(vfsgid))
+		return true;
+	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
+/**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @mnt_userns: User namespace of the mount the inode was created from
  * @dir: parent directory inode
@@ -2508,11 +2530,9 @@ umode_t mode_strip_sgid(struct user_name
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
+	if (in_group_or_capable(mnt_userns, dir,
+				i_gid_into_vfsgid(mnt_userns, dir)))
 		return mode;
-	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
-		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -151,6 +151,8 @@ extern int vfs_open(const struct path *,
  */
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, vfsgid_t vfsgid);
 
 /*
  * fs-writeback.c


