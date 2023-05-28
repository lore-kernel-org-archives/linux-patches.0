Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D916611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF4C433D2;
	Sun, 28 May 2023 19:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303334;
	bh=POgPahcTg1VFE65JOxLCqUFxAHkIII2BQn2FO8T9HIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3vRruzrhAvtIQzX7yY9AKUv+xXcFYDLNR/RzSHaXWfGDsOcrKh0ZlUBsEOsGb33Q
	 LNqeWIyw7qIJMMVpQxaS6Y8N2+58m7TNapcP/fD76sObOP7l1/GIlcfidTXcsyZ1sp
	 9XsLWceN0mnD9aVZBF4k59YlbFeRjCImqvROeXSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 09/69] ocfs2: Switch to security_inode_init_security()
Date: Sun, 28 May 2023 20:11:29 +0100
Message-Id: <20230528190828.692224648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

commit de3004c874e740304cc4f4a83d6200acb511bbda upstream.

In preparation for removing security_old_inode_init_security(), switch to
security_inode_init_security().

Extend the existing ocfs2_initxattrs() to take the
ocfs2_security_xattr_info structure from fs_info, and populate the
name/value/len triple with the first xattr provided by LSMs.

As fs_info was not used before, ocfs2_initxattrs() can now handle the case
of replicating the behavior of security_old_inode_init_security(), i.e.
just obtaining the xattr, in addition to setting all xattrs provided by
LSMs.

Supporting multiple xattrs is not currently supported where
security_old_inode_init_security() was called (mknod, symlink), as it
requires non-trivial changes that can be done at a later time. Like for
reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
not the first to set it, its xattr will be discarded; if it is the first,
it does not have xattrs to calculate the HMAC on).

Finally, since security_inode_init_security(), unlike
security_old_inode_init_security(), returns zero instead of -EOPNOTSUPP if
no xattrs were provided by LSMs or if inodes are private, additionally
check in ocfs2_init_security_get() if the xattr name is set.

If not, act as if security_old_inode_init_security() returned -EOPNOTSUPP,
and set si->enable to zero to notify to the functions following
ocfs2_init_security_get() that no xattrs are available.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/namei.c |    2 ++
 fs/ocfs2/xattr.c |   30 ++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_names
 	int want_meta = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
+		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota_inode = 0;
@@ -1805,6 +1806,7 @@ static int ocfs2_symlink(struct user_nam
 	int want_clusters = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
+		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota = 0, did_quota_inode = 0;
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(cons
 static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		     void *fs_info)
 {
+	struct ocfs2_security_xattr_info *si = fs_info;
 	const struct xattr *xattr;
 	int err = 0;
 
+	if (si) {
+		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
+				    GFP_KERNEL);
+		if (!si->value)
+			return -ENOMEM;
+
+		si->name = xattr_array->name;
+		si->value_len = xattr_array->value_len;
+		return 0;
+	}
+
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
 				      xattr->name, xattr->value,
@@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode
 			    const struct qstr *qstr,
 			    struct ocfs2_security_xattr_info *si)
 {
+	int ret;
+
 	/* check whether ocfs2 support feature xattr */
 	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
 		return -EOPNOTSUPP;
-	if (si)
-		return security_old_inode_init_security(inode, dir, qstr,
-							&si->name, &si->value,
-							&si->value_len);
+	if (si) {
+		ret = security_inode_init_security(inode, dir, qstr,
+						   &ocfs2_initxattrs, si);
+		/*
+		 * security_inode_init_security() does not return -EOPNOTSUPP,
+		 * we have to check the xattr ourselves.
+		 */
+		if (!ret && !si->name)
+			si->enable = 0;
+
+		return ret;
+	}
 
 	return security_inode_init_security(inode, dir, qstr,
 					    &ocfs2_initxattrs, NULL);


