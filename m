Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F224F471257;
	Tue, 21 Jul 2026 19:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662706; cv=none; b=qabgaib/EoCB1RN7pwgHgO85syygs/35qtYKHIDFIGOCcQGqUGoXEJf87APLuIFvIXs56XoVaotAElp+Ru2CVDu1WrcbjMSktlchFKvEQ5n86xBmyi5cM6zBCKGBShdCH3rcwJb5eT4a4+iWhK3QxsIIKoUYe7ji0YBEk+M7ymA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662706; c=relaxed/simple;
	bh=Y8Ap5zFzdPH2PJ6XZnOJQSb/IO/BigX2HCy3A1A0Byg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo0vZOORUiTXTTbW2yDBuV6j8I3bn4g3MJutdLCrT3V+4tZ2H+NVZdYZPLaEifVrsxsG2kB7/0OmzmKIiWeA76Toz4bipkprDJOXYpXPiZmIL/mwumUMIZzBxNojow+Vf29aoo+B+3wkTUocJh0aTcoW7T5WQJyzYLikeCQH65I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj+qJhrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj+qJhrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C54C1F00A3E;
	Tue, 21 Jul 2026 19:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662697;
	bh=Z4L2zmmrnoC+CwDilIHGvcUdX78dAvTThVEZvwv5tp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sj+qJhrjiKYLr10bF9HhaHOzG476lsySniz6wf/hwBttsQuwWoGsa//3TaUqw4bYb
	 lAT1Ud+45Gvpdwpz2n8fns+qDPHm+Umc4IiHt+PN2VZtFP6e80+QGNp07NPvpHog+N
	 gn43NsPiwE25OjPcU4KXkkL6bUev9gpIBlUeBEx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0542/1276] apparmor: remove or add symlinks to rawdata according to export_binary
Date: Tue, 21 Jul 2026 17:16:25 +0200
Message-ID: <20260721152458.249597310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit 59fe6fbc4cd45582bc8893de0a382a36562317b3 ]

When the export_binary parameter is set, then rawdata is available and
there should be a symbolic link for the rawdata in the profile
directory in apparmorfs. If the parameter is unset, then the symlinks
should not exist.

The issue arises when changing the value of export_binary on runtime
and replacing profiles. If export_binary was set when the profile was
originally loaded, then changed to 0 and the profile was reloaded,
then the symbolic links would still exist but would return ENOENT
because the rawdata no longer exists.

On the opposite side, if export_binary was unset when the profile was
originally loaded, then changed to 1 and the profile was reloaded,
then the symbolic links would not exist, even though the rawdata does.

Fixes: d61c57fde8191 ("apparmor: make export of raw binary profile to userspace optional")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c         | 102 +++++++++++++++++++------
 security/apparmor/include/apparmorfs.h |  12 +++
 security/apparmor/policy.c             |  15 ++++
 3 files changed, 104 insertions(+), 25 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 0064a06cea162d..c94c7c9f227bae 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1751,6 +1751,80 @@ static const struct inode_operations rawdata_link_abi_iops = {
 static const struct inode_operations rawdata_link_data_iops = {
 	.get_link	= rawdata_get_link_data,
 };
+
+/*
+ * Requires: @profile->ns->lock held
+ */
+void __aa_remove_rawdata_symlink_dents(struct aa_profile *profile)
+{
+	aafs_remove(profile->dents[AAFS_PROF_RAW_HASH]);
+	profile->dents[AAFS_PROF_RAW_HASH] = NULL;
+	aafs_remove(profile->dents[AAFS_PROF_RAW_ABI]);
+	profile->dents[AAFS_PROF_RAW_ABI] = NULL;
+	aafs_remove(profile->dents[AAFS_PROF_RAW_DATA]);
+	profile->dents[AAFS_PROF_RAW_DATA] = NULL;
+}
+
+static inline int create_symlink_dent(struct aa_profile *profile,
+				      const char *name,
+				      enum aafs_prof_type type,
+				      const struct inode_operations *iops)
+{
+	struct dentry *dent = NULL;
+	struct dentry *dir = prof_dir(profile);
+
+	if (profile->dents[type])
+		return 0;
+
+	dent = aafs_create(name, S_IFLNK | 0444, dir,
+			   &profile->label.proxy->count, NULL, NULL, iops);
+	if (IS_ERR(dent))
+		return PTR_ERR(dent);
+
+	profile->dents[type] = dent;
+	return 0;
+}
+
+/*
+ * Requires: @profile->ns->lock held
+ */
+int __aa_create_rawdata_symlink_dents(struct aa_profile *profile)
+{
+	int error;
+
+	if (!profile ||
+	    (profile->dents[AAFS_PROF_RAW_HASH] &&
+	     profile->dents[AAFS_PROF_RAW_ABI] &&
+	     profile->dents[AAFS_PROF_RAW_DATA]))
+		return 0;
+
+	if (!profile->rawdata)
+		return 0;
+
+	if (aa_g_hash_policy) {
+		error = create_symlink_dent(profile, "raw_sha256",
+					    AAFS_PROF_RAW_HASH,
+					    &rawdata_link_sha256_iops);
+		if (error)
+			return error;
+	}
+
+	error = create_symlink_dent(profile, "raw_abi",
+				    AAFS_PROF_RAW_ABI,
+				    &rawdata_link_abi_iops);
+	if (error)
+		return error;
+
+
+	error = create_symlink_dent(profile, "raw_data",
+				    AAFS_PROF_RAW_DATA,
+				    &rawdata_link_data_iops);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 #endif /* CONFIG_SECURITY_APPARMOR_EXPORT_BINARY */
 
 /*
@@ -1826,31 +1900,9 @@ int __aafs_profile_mkdir(struct aa_profile *profile, struct dentry *parent)
 		profile->dents[AAFS_PROF_HASH] = dent;
 	}
 
-#ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
-	if (profile->rawdata) {
-		if (aa_g_hash_policy) {
-			dent = aafs_create("raw_sha256", S_IFLNK | 0444, dir,
-					   &profile->label.proxy->count, NULL,
-					   NULL, &rawdata_link_sha256_iops);
-			if (IS_ERR(dent))
-				goto fail;
-			profile->dents[AAFS_PROF_RAW_HASH] = dent;
-		}
-		dent = aafs_create("raw_abi", S_IFLNK | 0444, dir,
-				   &profile->label.proxy->count, NULL, NULL,
-				   &rawdata_link_abi_iops);
-		if (IS_ERR(dent))
-			goto fail;
-		profile->dents[AAFS_PROF_RAW_ABI] = dent;
-
-		dent = aafs_create("raw_data", S_IFLNK | 0444, dir,
-				   &profile->label.proxy->count, NULL, NULL,
-				   &rawdata_link_data_iops);
-		if (IS_ERR(dent))
-			goto fail;
-		profile->dents[AAFS_PROF_RAW_DATA] = dent;
-	}
-#endif /*CONFIG_SECURITY_APPARMOR_EXPORT_BINARY */
+	error = __aa_create_rawdata_symlink_dents(profile);
+	if (error)
+		goto fail2;
 
 	list_for_each_entry(child, &profile->base.profiles, base.list) {
 		error = __aafs_profile_mkdir(child, prof_child_dir(profile));
diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
index 1e94904f68d905..9224497736fdfd 100644
--- a/security/apparmor/include/apparmorfs.h
+++ b/security/apparmor/include/apparmorfs.h
@@ -118,6 +118,8 @@ struct aa_loaddata;
 #ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
 void __aa_fs_remove_rawdata(struct aa_loaddata *rawdata);
 int __aa_fs_create_rawdata(struct aa_ns *ns, struct aa_loaddata *rawdata);
+void __aa_remove_rawdata_symlink_dents(struct aa_profile *profile);
+int __aa_create_rawdata_symlink_dents(struct aa_profile *profile);
 #else
 static inline void __aa_fs_remove_rawdata(struct aa_loaddata *rawdata)
 {
@@ -129,6 +131,16 @@ static inline int __aa_fs_create_rawdata(struct aa_ns *ns,
 {
 	return 0;
 }
+
+static inline void __aa_remove_rawdata_symlink_dents(struct aa_profile *profile)
+{
+	/* empty stub */
+}
+
+static inline int __aa_create_rawdata_symlink_dents(struct aa_profile *profile)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY_APPARMOR_EXPORT_BINARY */
 
 #endif /* __AA_APPARMORFS_H */
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 7fa1d2a08913af..5e359cddd109e7 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1298,6 +1298,16 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			goto skip;
 		}
 
+		if (!aa_g_export_binary) {
+			if (ent->old && ent->old->rawdata &&
+			    ent->old->dents[AAFS_LOADDATA_DIR]) {
+				/* remove rawdata symlinks because the symlink
+				 * target will be removed
+				 */
+				__aa_remove_rawdata_symlink_dents(ent->old);
+			}
+		}
+
 		/*
 		 * TODO: finer dedup based on profile range in data. Load set
 		 * can differ but profile may remain unchanged
@@ -1308,6 +1318,11 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 		if (ent->old) {
 			share_name(ent->old, ent->new);
 			__replace_profile(ent->old, ent->new);
+			if (aa_g_export_binary) {
+				/* recreate rawdata symlinks */
+				if (!ent->old->rawdata)
+					__aa_create_rawdata_symlink_dents(ent->new);
+			}
 		} else {
 			struct list_head *lh;
 
-- 
2.53.0



