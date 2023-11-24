Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2832739FF3;
	Fri, 24 Nov 2023 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkWkmV2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A908BC433C9;
	Fri, 24 Nov 2023 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850011;
	bh=z32SZn2KwJ6BWhoKwi4o1W0SKLRMuMh6/s7mqrwvlI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkWkmV2tFdrOX553+w4EnRr10Rl5SfNeeqd7GuabiAaZBj8sNI7jHMyzOYWkfBQfv
	 V4QhLiZ2yGfUFD/RF/e92xg0p/yuMW+ZOOlE9vJN3Fhyu+RSmRk4uYS3Wc1JNgZsks
	 8klJxQ3YlL4WwhBgSpO6de4LpnWs86rvjmb+xoEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Steinmetz <anstein99@googlemail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 402/530] apparmor: Fix regression in mount mediation
Date: Fri, 24 Nov 2023 17:49:28 +0000
Message-ID: <20231124172040.271700318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 157a3537d6bc28ceb9a11fc8cb67f2152d860146 ]

commit 2db154b3ea8e ("vfs: syscall: Add move_mount(2) to move mounts around")

introduced a new move_mount(2) system call and a corresponding new LSM
security_move_mount hook but did not implement this hook for any
existing LSM. This creates a regression for AppArmor mediation of
mount. This patch provides a base mapping of the move_mount syscall to
the existing mount mediation. In the future we may introduce
additional mediations around the new mount calls.

Fixes: 2db154b3ea8e ("vfs: syscall: Add move_mount(2) to move mounts around")
CC: stable@vger.kernel.org
Reported-by: Andreas Steinmetz <anstein99@googlemail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/mount.h |  7 +++--
 security/apparmor/lsm.c           | 20 ++++++++++++--
 security/apparmor/mount.c         | 46 +++++++++++++++++++------------
 3 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/security/apparmor/include/mount.h b/security/apparmor/include/mount.h
index 10c76f906a653..46834f8281794 100644
--- a/security/apparmor/include/mount.h
+++ b/security/apparmor/include/mount.h
@@ -38,9 +38,12 @@ int aa_mount_change_type(const struct cred *subj_cred,
 			 struct aa_label *label, const struct path *path,
 			 unsigned long flags);
 
+int aa_move_mount_old(const struct cred *subj_cred,
+		      struct aa_label *label, const struct path *path,
+		      const char *old_name);
 int aa_move_mount(const struct cred *subj_cred,
-		  struct aa_label *label, const struct path *path,
-		  const char *old_name);
+		  struct aa_label *label, const struct path *from_path,
+		  const struct path *to_path);
 
 int aa_new_mount(const struct cred *subj_cred,
 		 struct aa_label *label, const char *dev_name,
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 60f95cc4532a8..6fdab1b5ede5c 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -607,8 +607,8 @@ static int apparmor_sb_mount(const char *dev_name, const struct path *path,
 			error = aa_mount_change_type(current_cred(), label,
 						     path, flags);
 		else if (flags & MS_MOVE)
-			error = aa_move_mount(current_cred(), label, path,
-					      dev_name);
+			error = aa_move_mount_old(current_cred(), label, path,
+						  dev_name);
 		else
 			error = aa_new_mount(current_cred(), label, dev_name,
 					     path, type, flags, data);
@@ -618,6 +618,21 @@ static int apparmor_sb_mount(const char *dev_name, const struct path *path,
 	return error;
 }
 
+static int apparmor_move_mount(const struct path *from_path,
+			       const struct path *to_path)
+{
+	struct aa_label *label;
+	int error = 0;
+
+	label = __begin_current_label_crit_section();
+	if (!unconfined(label))
+		error = aa_move_mount(current_cred(), label, from_path,
+				      to_path);
+	__end_current_label_crit_section(label);
+
+	return error;
+}
+
 static int apparmor_sb_umount(struct vfsmount *mnt, int flags)
 {
 	struct aa_label *label;
@@ -1240,6 +1255,7 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capget, apparmor_capget),
 	LSM_HOOK_INIT(capable, apparmor_capable),
 
+	LSM_HOOK_INIT(move_mount, apparmor_move_mount),
 	LSM_HOOK_INIT(sb_mount, apparmor_sb_mount),
 	LSM_HOOK_INIT(sb_umount, apparmor_sb_umount),
 	LSM_HOOK_INIT(sb_pivotroot, apparmor_sb_pivotroot),
diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 2bb77aacc49ae..f2a114e540079 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -483,36 +483,46 @@ int aa_mount_change_type(const struct cred *subj_cred,
 }
 
 int aa_move_mount(const struct cred *subj_cred,
-		  struct aa_label *label, const struct path *path,
-		  const char *orig_name)
+		  struct aa_label *label, const struct path *from_path,
+		  const struct path *to_path)
 {
 	struct aa_profile *profile;
-	char *buffer = NULL, *old_buffer = NULL;
-	struct path old_path;
+	char *to_buffer = NULL, *from_buffer = NULL;
 	int error;
 
 	AA_BUG(!label);
-	AA_BUG(!path);
+	AA_BUG(!from_path);
+	AA_BUG(!to_path);
+
+	to_buffer = aa_get_buffer(false);
+	from_buffer = aa_get_buffer(false);
+	error = -ENOMEM;
+	if (!to_buffer || !from_buffer)
+		goto out;
+	error = fn_for_each_confined(label, profile,
+			match_mnt(subj_cred, profile, to_path, to_buffer,
+				  from_path, from_buffer,
+				  NULL, MS_MOVE, NULL, false));
+out:
+	aa_put_buffer(to_buffer);
+	aa_put_buffer(from_buffer);
+
+	return error;
+}
+
+int aa_move_mount_old(const struct cred *subj_cred, struct aa_label *label,
+		      const struct path *path, const char *orig_name)
+{
+	struct path old_path;
+	int error;
 
 	if (!orig_name || !*orig_name)
 		return -EINVAL;
-
 	error = kern_path(orig_name, LOOKUP_FOLLOW, &old_path);
 	if (error)
 		return error;
 
-	buffer = aa_get_buffer(false);
-	old_buffer = aa_get_buffer(false);
-	error = -ENOMEM;
-	if (!buffer || !old_buffer)
-		goto out;
-	error = fn_for_each_confined(label, profile,
-			match_mnt(subj_cred, profile, path, buffer, &old_path,
-				  old_buffer,
-				  NULL, MS_MOVE, NULL, false));
-out:
-	aa_put_buffer(buffer);
-	aa_put_buffer(old_buffer);
+	error = aa_move_mount(subj_cred, label, &old_path, path);
 	path_put(&old_path);
 
 	return error;
-- 
2.42.0



