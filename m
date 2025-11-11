Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06E17640E;
	Tue, 11 Nov 2025 01:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825281; cv=none; b=iWI58ms+EngtwZDkMWlaVrHyKe9npVUiADvRFjFlfmV+7csdLPtZtAXoLovWtbLFXzTd1wqMCSBT5LcUHAZEbzfK81S9HrtzrjxPjOwIs+28bTydMftQx53ynDfkSsPStp01GOMkpQhPOroTc4Fk4zI/nOibtYrmWn0/7mBNkvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825281; c=relaxed/simple;
	bh=TEH8EWbQA8LvwdN6T5rJ134mJcwpxvxBLR2mvibYBXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8cTvV90DRkoA+qCwJspRudBSHyrXNvXG3Rz6+7nuGGZDtqh6t1R4vtQIM8xEnu75Ry+qd85uWzkqig4uPOSNvg6LXCmDebwAQaUkRnXvxi7ZPuF5bLIBLnYCBQXxGft0feRBj6TRU0QU4CkWeiTgKv+LLQCT+mzxurAZh887aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGNpjQeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGNpjQeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91549C19422;
	Tue, 11 Nov 2025 01:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825280;
	bh=TEH8EWbQA8LvwdN6T5rJ134mJcwpxvxBLR2mvibYBXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGNpjQeEwIBsx2QJLPpY6IjXHOjlyBSJvfuu61s0kUKgIKkIOryMn9ZgDd9YOvFni
	 SAA+//6dOkNMWKARm7D7dHrDAsJUiPQf+7L4OBq8EjK+shLBYN3YggwyQgRBN3tYhw
	 yvs77GNy376NCBMgXyVZiPbpA8htE+EcxJcbeECI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kotresh HR <khiremat@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 736/849] ceph: fix multifs mds auth caps issue
Date: Tue, 11 Nov 2025 09:45:06 +0900
Message-ID: <20251111004554.233540766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kotresh HR <khiremat@redhat.com>

[ Upstream commit 22c73d52a6d05c5a2053385c0d6cd9984732799d ]

The mds auth caps check should also validate the
fsname along with the associated caps. Not doing
so would result in applying the mds auth caps of
one fs on to the other fs in a multifs ceph cluster.
The bug causes multiple issues w.r.t user
authentication, following is one such example.

Steps to Reproduce (on vstart cluster):
1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
2. Authorize read only permission to the user 'client.usr' on fs 'fsname1'
    $ceph fs authorize fsname1 client.usr / r
3. Authorize read and write permission to the same user 'client.usr' on fs 'fsname2'
    $ceph fs authorize fsname2 client.usr / rw
4. Update the keyring
    $ceph auth get client.usr >> ./keyring

With above permssions for the user 'client.usr', following is the
expectation.
  a. The 'client.usr' should be able to only read the contents
     and not allowed to create or delete files on file system 'fsname1'.
  b. The 'client.usr' should be able to read/write on file system 'fsname2'.

But, with this bug, the 'client.usr' is allowed to read/write on file
system 'fsname1'. See below.

5. Mount the file system 'fsname1' with the user 'client.usr'
     $sudo bin/mount.ceph usr@.fsname1=/ /kmnt_fsname1_usr/
6. Try creating a file on file system 'fsname1' with user 'client.usr'. This
   should fail but passes with this bug.
     $touch /kmnt_fsname1_usr/file1
7. Mount the file system 'fsname1' with the user 'client.admin' and create a
   file.
     $sudo bin/mount.ceph admin@.fsname1=/ /kmnt_fsname1_admin
     $echo "data" > /kmnt_fsname1_admin/admin_file1
8. Try removing an existing file on file system 'fsname1' with the user
   'client.usr'. This shoudn't succeed but succeeds with the bug.
     $rm -f /kmnt_fsname1_usr/admin_file1

For more information, please take a look at the corresponding mds/fuse patch
and tests added by looking into the tracker mentioned below.

v2: Fix a possible null dereference in doutc
v3: Don't store fsname from mdsmap, validate against
    ceph_mount_options's fsname and use it
v4: Code refactor, better warning message and
    fix possible compiler warning

[ Slava.Dubeyko: "fsname check failed" -> "fsname mismatch" ]

Link: https://tracker.ceph.com/issues/72167
Signed-off-by: Kotresh HR <khiremat@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c |  8 ++++++++
 fs/ceph/mdsmap.c     | 14 +++++++++++++-
 fs/ceph/super.c      | 14 --------------
 fs/ceph/super.h      | 14 ++++++++++++++
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3bc72b47fe4d4..3efbc11596e00 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5649,11 +5649,19 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
+	const char *fs_name = mdsc->fsc->mount_options->mds_namespace;
 	const char *spath = mdsc->fsc->mount_options->server_path;
 	bool gid_matched = false;
 	u32 gid, tlen, len;
 	int i, j;
 
+	doutc(cl, "fsname check fs_name=%s  match.fs_name=%s\n",
+	      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
+	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
+		/* fsname mismatch, try next one */
+		return 0;
+	}
+
 	doutc(cl, "match.uid %lld\n", auth->match.uid);
 	if (auth->match.uid != MDS_AUTH_UID_ANY) {
 		if (auth->match.uid != caller_uid)
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8109aba66e023..2c7b151a7c95c 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -353,10 +353,22 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		__decode_and_drop_type(p, end, u8, bad_ext);
 	}
 	if (mdsmap_ev >= 8) {
+		u32 fsname_len;
 		/* enabled */
 		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
 		/* fs_name */
-		ceph_decode_skip_string(p, end, bad_ext);
+		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
+
+		/* validate fsname against mds_namespace */
+		if (!namespace_equals(mdsc->fsc->mount_options, *p,
+				      fsname_len)) {
+			pr_warn_client(cl, "fsname %*pE doesn't match mds_namespace %s\n",
+				       (int)fsname_len, (char *)*p,
+				       mdsc->fsc->mount_options->mds_namespace);
+			goto bad;
+		}
+		/* skip fsname after validation */
+		ceph_decode_skip_n(p, end, fsname_len, bad);
 	}
 	/* damaged */
 	if (mdsmap_ev >= 9) {
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c3eb651862c55..ebef5244ae25a 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -246,20 +246,6 @@ static void canonicalize_path(char *path)
 	path[j] = '\0';
 }
 
-/*
- * Check if the mds namespace in ceph_mount_options matches
- * the passed in namespace string. First time match (when
- * ->mds_namespace is NULL) is treated specially, since
- * ->mds_namespace needs to be initialized by the caller.
- */
-static int namespace_equals(struct ceph_mount_options *fsopt,
-			    const char *namespace, size_t len)
-{
-	return !(fsopt->mds_namespace &&
-		 (strlen(fsopt->mds_namespace) != len ||
-		  strncmp(fsopt->mds_namespace, namespace, len)));
-}
-
 static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
 				 struct fs_context *fc)
 {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index cf176aab0f823..4ac6561285b18 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -104,6 +104,20 @@ struct ceph_mount_options {
 	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
+/*
+ * Check if the mds namespace in ceph_mount_options matches
+ * the passed in namespace string. First time match (when
+ * ->mds_namespace is NULL) is treated specially, since
+ * ->mds_namespace needs to be initialized by the caller.
+ */
+static inline int namespace_equals(struct ceph_mount_options *fsopt,
+				   const char *namespace, size_t len)
+{
+	return !(fsopt->mds_namespace &&
+		 (strlen(fsopt->mds_namespace) != len ||
+		  strncmp(fsopt->mds_namespace, namespace, len)));
+}
+
 /* mount state */
 enum {
 	CEPH_MOUNT_MOUNTING,
-- 
2.51.0



