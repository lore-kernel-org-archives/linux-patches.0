Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBEB125B2;
	Mon,  9 Feb 2026 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647729; cv=none; b=esBimOzZpy/KQlHnNOjCLOOs5CkhR6f9ZXrJYN/uRsxMDja+TQKmtkSl9MG21jxfVRvF3InAY25pm21ITF5ZbL8h52jGvEZTS1b1BUiyPJLkyOSVrSk2fvHnFrNn3CtktPIEd57ChOcOJtFcbm+aZs0VLgXJI3RfRMSA7WG9ACc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647729; c=relaxed/simple;
	bh=C7Xx0Y3ZkHBDKOqntUdRs9jKji+qriP5ZLwhd0CshlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUmpWCf3dWG+eXGbTtE2yTjNkO27vo67nxSWSfR7fKU5qxE7k0mnUcOoVp/7+B6hBqoHggx0Pl3mlos5ZkKnzXNIRXHwiBUlWOe5EiBc2YKcppvdJD5S6anuIRdgosRNnwTGP4q5cRHwZNZjpe9dMLnXOpxJB/WMQmVU+LClYgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFI7CGp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFI7CGp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D76FC116C6;
	Mon,  9 Feb 2026 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647729;
	bh=C7Xx0Y3ZkHBDKOqntUdRs9jKji+qriP5ZLwhd0CshlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFI7CGp12KU3IMFTDubce8Lr5mY0/iRqPIb6uLCsIaLzZxeIw78dnfSqYjtXDVlsa
	 MfjmcO3q9V31mURJw38pXthj0pC9ZsDb42+w31WOI2BG+9phjFFjMSwxUk/aCc+Q/B
	 WUkv4VZoGenBHF+THx/9/ss1sqkvjX2iz/PcvesA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Patrick Donnelly <pdonnell@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 012/113] ceph: fix NULL pointer dereference in ceph_mds_auth_match()
Date: Mon,  9 Feb 2026 15:22:41 +0100
Message-ID: <20260209142310.653461923@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

commit 7987cce375ac8ce98e170a77aa2399f2cf6eb99f upstream.

The CephFS kernel client has regression starting from 6.18-rc1.
We have issue in ceph_mds_auth_match() if fs_name == NULL:

    const char fs_name = mdsc->fsc->mount_options->mds_namespace;
    ...
    if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
            / fsname mismatch, try next one */
            return 0;
    }

Patrick Donnelly suggested that: In summary, we should definitely start
decoding `fs_name` from the MDSMap and do strict authorizations checks
against it. Note that the `-o mds_namespace=foo` should only be used for
selecting the file system to mount and nothing else. It's possible
no mds_namespace is specified but the kernel will mount the only
file system that exists which may have name "foo".

This patch reworks ceph_mdsmap_decode() and namespace_equals() with
the goal of supporting the suggested concept. Now struct ceph_mdsmap
contains m_fs_name field that receives copy of extracted FS name
by ceph_extract_encoded_string(). For the case of "old" CephFS file
systems, it is used "cephfs" name.

[ idryomov: replace redundant %*pE with %s in ceph_mdsmap_decode(),
  get rid of a series of strlen() calls in ceph_namespace_match(),
  drop changes to namespace_equals() body to avoid treating empty
  mds_namespace as equal, drop changes to ceph_mdsc_handle_fsmap()
  as namespace_equals() isn't an equivalent substitution there ]

Cc: stable@vger.kernel.org
Fixes: 22c73d52a6d0 ("ceph: fix multifs mds auth caps issue")
Link: https://tracker.ceph.com/issues/73886
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>
Tested-by: Patrick Donnelly <pdonnell@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c         |    5 +++--
 fs/ceph/mdsmap.c             |   26 +++++++++++++++++++-------
 fs/ceph/mdsmap.h             |    1 +
 fs/ceph/super.h              |   16 ++++++++++++++--
 include/linux/ceph/ceph_fs.h |    6 ++++++
 5 files changed, 43 insertions(+), 11 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5652,7 +5652,7 @@ static int ceph_mds_auth_match(struct ce
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
-	const char *fs_name = mdsc->fsc->mount_options->mds_namespace;
+	const char *fs_name = mdsc->mdsmap->m_fs_name;
 	const char *spath = mdsc->fsc->mount_options->server_path;
 	bool gid_matched = false;
 	u32 gid, tlen, len;
@@ -5660,7 +5660,8 @@ static int ceph_mds_auth_match(struct ce
 
 	doutc(cl, "fsname check fs_name=%s  match.fs_name=%s\n",
 	      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
-	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
+
+	if (!ceph_namespace_match(auth->match.fs_name, fs_name)) {
 		/* fsname mismatch, try next one */
 		return 0;
 	}
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -353,22 +353,33 @@ struct ceph_mdsmap *ceph_mdsmap_decode(s
 		__decode_and_drop_type(p, end, u8, bad_ext);
 	}
 	if (mdsmap_ev >= 8) {
-		u32 fsname_len;
+		size_t fsname_len;
+
 		/* enabled */
 		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
+
 		/* fs_name */
-		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
+		m->m_fs_name = ceph_extract_encoded_string(p, end,
+							   &fsname_len,
+							   GFP_NOFS);
+		if (IS_ERR(m->m_fs_name)) {
+			m->m_fs_name = NULL;
+			goto nomem;
+		}
 
 		/* validate fsname against mds_namespace */
-		if (!namespace_equals(mdsc->fsc->mount_options, *p,
+		if (!namespace_equals(mdsc->fsc->mount_options, m->m_fs_name,
 				      fsname_len)) {
-			pr_warn_client(cl, "fsname %*pE doesn't match mds_namespace %s\n",
-				       (int)fsname_len, (char *)*p,
+			pr_warn_client(cl, "fsname %s doesn't match mds_namespace %s\n",
+				       m->m_fs_name,
 				       mdsc->fsc->mount_options->mds_namespace);
 			goto bad;
 		}
-		/* skip fsname after validation */
-		ceph_decode_skip_n(p, end, fsname_len, bad);
+	} else {
+		m->m_enabled = false;
+		m->m_fs_name = kstrdup(CEPH_OLD_FS_NAME, GFP_NOFS);
+		if (!m->m_fs_name)
+			goto nomem;
 	}
 	/* damaged */
 	if (mdsmap_ev >= 9) {
@@ -430,6 +441,7 @@ void ceph_mdsmap_destroy(struct ceph_mds
 		kfree(m->m_info);
 	}
 	kfree(m->m_data_pg_pools);
+	kfree(m->m_fs_name);
 	kfree(m);
 }
 
--- a/fs/ceph/mdsmap.h
+++ b/fs/ceph/mdsmap.h
@@ -45,6 +45,7 @@ struct ceph_mdsmap {
 	bool m_enabled;
 	bool m_damaged;
 	int m_num_laggy;
+	char *m_fs_name;
 };
 
 static inline struct ceph_entity_addr *
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -104,14 +104,26 @@ struct ceph_mount_options {
 	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
+#define CEPH_NAMESPACE_WILDCARD		"*"
+
+static inline bool ceph_namespace_match(const char *pattern,
+					const char *target)
+{
+	if (!pattern || !pattern[0] ||
+	    !strcmp(pattern, CEPH_NAMESPACE_WILDCARD))
+		return true;
+
+	return !strcmp(pattern, target);
+}
+
 /*
  * Check if the mds namespace in ceph_mount_options matches
  * the passed in namespace string. First time match (when
  * ->mds_namespace is NULL) is treated specially, since
  * ->mds_namespace needs to be initialized by the caller.
  */
-static inline int namespace_equals(struct ceph_mount_options *fsopt,
-				   const char *namespace, size_t len)
+static inline bool namespace_equals(struct ceph_mount_options *fsopt,
+				    const char *namespace, size_t len)
 {
 	return !(fsopt->mds_namespace &&
 		 (strlen(fsopt->mds_namespace) != len ||
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -31,6 +31,12 @@
 #define CEPH_INO_CEPH   2            /* hidden .ceph dir */
 #define CEPH_INO_GLOBAL_SNAPREALM  3 /* global dummy snaprealm */
 
+/*
+ * name for "old" CephFS file systems,
+ * see ceph.git e2b151d009640114b2565c901d6f41f6cd5ec652
+ */
+#define CEPH_OLD_FS_NAME	"cephfs"
+
 /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
 #define CEPH_MAX_MON   31
 


