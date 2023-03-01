Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F26B847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDBCC4339B;
	Wed,  1 Mar 2023 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694366;
	bh=UgMMYQnjloLMllC03q36eEOnyE86C1qp3Yo/SDIa4jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm0+UJCyukG74ZPPU9HyQMDsAUN4dLKqC2vo/oPcUO+csKz5ltKW0PIuPGDWp/v4w
	 JU75WZrfCITt+4mii4Wfqzq/JyjWTU9K2nm5NQRp2hA3ypwUPSS+7lWuG7VIb0k64g
	 A4/cEk8uqP0wzk/1jWoPZePv6u3jxbC4JOfKZfMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.1 38/42] attr: add setattr_should_drop_sgid()
Date: Wed,  1 Mar 2023 19:08:59 +0100
Message-Id: <20230301180658.743724053@linuxfoundation.org>
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

commit 72ae017c5451860443a16fb2a8c243bff3e396b8 upstream.

The current setgid stripping logic during write and ownership change
operations is inconsistent and strewn over multiple places. In order to
consolidate it and make more consistent we'll add a new helper
setattr_should_drop_sgid(). The function retains the old behavior where
we remove the S_ISGID bit unconditionally when S_IXGRP is set but also
when it isn't set and the caller is neither in the group of the inode
nor privileged over the inode.

We will use this helper both in write operation permission removal such
as file_remove_privs() as well as in ownership change operations.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c     |   28 ++++++++++++++++++++++++++++
 fs/internal.h |    6 ++++++
 2 files changed, 34 insertions(+)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,34 @@
 
 #include "internal.h"
 
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @mnt_userns:	user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(mnt_userns, inode,
+				 i_gid_into_vfsgid(mnt_userns, inode)))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -236,3 +236,9 @@ int do_setxattr(struct user_namespace *m
 		struct xattr_ctx *ctx);
 
 ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *pos);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);


