Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E34C46DFF2;
	Tue, 21 Jul 2026 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660617; cv=none; b=FDV6BRCFNQSVfvOU6A1HvSWcYW8YSmDW6vWHYQk8omPWypDE2CyP4Sgk3I/XoSheuToy0aHDlw67R5//TpckXMBuo8RUDcx1mxs7Ir6M2Qh2R+8Ydh59fRyCLMLMHtFibmR4e76PREjuu7x+71kAQsnCLN3MG4p/pz7sMGOAy+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660617; c=relaxed/simple;
	bh=fd7nBUL2FMse52CdvuzKdhDdw7JfoUO/LjrEMCiBEIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUJtdPcYO7k8Y8rS5O2eDjrKITQxWxgCAgLsGx6YVFYTPTsJfKzMn+aAytzJDXnqwrFz6yZyi0QFzDoGZaph1xiEWjE71HiV9iTI14Ig1HOoIEsrAUBB76gaw3UPg05+vYa3bIhU23LzKRrUBosAbdwIUShq4NzuKctGnY7DoKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfrKLkgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfrKLkgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77521F000E9;
	Tue, 21 Jul 2026 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660616;
	bh=T+ZbNpDXmLOulF4OF1LNplBlEV81JemxY/fBlQrzmOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfrKLkgWgBu5fNJKsqsSIsEOg6ZPT4Q8y22k0xmb0mB3G1TEHYgexa4WGteiTjbIm
	 SOLtJmGsVimqa98spDyUMFkHRU+q5F8jwoV4m+M4OLVfPOwxfKepsIzlOqBcY2GoZD
	 D9LMbOb+FCmNSv7WJ/UGGqmpCQPcRQOyuwHXxQOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1046/2077] apparmor: remove or add symlinks to rawdata according to export_binary
Date: Tue, 21 Jul 2026 17:11:59 +0200
Message-ID: <20260721152617.483422366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 725a69aa1c2a37..be924700ba6c90 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1757,6 +1757,80 @@ static const struct inode_operations rawdata_link_abi_iops = {
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
@@ -1832,31 +1906,9 @@ int __aafs_profile_mkdir(struct aa_profile *profile, struct dentry *parent)
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
index dd580594dfb70a..33243d11fd1060 100644
--- a/security/apparmor/include/apparmorfs.h
+++ b/security/apparmor/include/apparmorfs.h
@@ -120,6 +120,8 @@ struct aa_loaddata;
 #ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
 void __aa_fs_remove_rawdata(struct aa_loaddata *rawdata);
 int __aa_fs_create_rawdata(struct aa_ns *ns, struct aa_loaddata *rawdata);
+void __aa_remove_rawdata_symlink_dents(struct aa_profile *profile);
+int __aa_create_rawdata_symlink_dents(struct aa_profile *profile);
 #else
 static inline void __aa_fs_remove_rawdata(struct aa_loaddata *rawdata)
 {
@@ -131,6 +133,16 @@ static inline int __aa_fs_create_rawdata(struct aa_ns *ns,
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
index 6effddb46994a0..73101ddf0b8715 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1346,6 +1346,16 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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
@@ -1356,6 +1366,11 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



