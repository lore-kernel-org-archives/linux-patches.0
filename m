Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DADF9D4;
	Tue, 14 May 2024 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687807; cv=none; b=DgZ8iV/EQT2+7K0riJ0CvJG5Z7Gpy3LrVpy8EGU5Oc3wOFJMpsfpLnHucyXF8fzXBLE3V7BfUuXLGO8NEYwmFLAowPLXCSI5k1EXYMioR+resuP9kX2Ys1ZlunpqtZoQY3htS2JqbkACP6ZEXrp34R+eo6gParjAZOBpvjkMNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687807; c=relaxed/simple;
	bh=Cd86CMD44CO2FUulRfUWpy86nMZsG0DiORjU6CoBpog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO7v2f2A0/gjlpxVf3a6WJZx2/0NUBtyvMCBsOYl4diByHoOIXKxtXWIQcg5gazInBCZ/3SK1eijqqTPmmR0k95vMN4VNVvzF6mvzf44TFBKW063Z/Zg0iB3WPCe9a5dcIMsJ0q5UxKAfJqcPymib06Jueeid84QRiQqjG9SdGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5Y3MKup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5Y3MKup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9755C2BD10;
	Tue, 14 May 2024 11:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687807;
	bh=Cd86CMD44CO2FUulRfUWpy86nMZsG0DiORjU6CoBpog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5Y3MKuphIpAva6/YXYp8WjaSgnbY706BWX5SW5IU3Lds+rEjsESLPaWZGSGDMo9w
	 5OUdVlqKHFhkfqBQNmcMOQ2uhyQ55B1YYoeNKNbJEOHA/NTo2xsHzJe8p2nGBuptv5
	 K3juLt9WEpp4OafDWFiJx2mAGX6CghJDrFIpXZHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/168] scsi: target: Fix SELinux error when systemd-modules loads the target module
Date: Tue, 14 May 2024 12:19:38 +0200
Message-ID: <20240514101009.713984423@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 97a54ef596c3fd24ec2b227ba8aaf2cf5415e779 ]

If the systemd-modules service loads the target module, the credentials of
that userspace process will be used to validate the access to the target db
directory.  SELinux will prevent it, reporting an error like the following:

kernel: audit: type=1400 audit(1676301082.205:4): avc: denied  { read }
for  pid=1020 comm="systemd-modules" name="target" dev="dm-3"
ino=4657583 scontext=system_u:system_r:systemd_modules_load_t:s0
tcontext=system_u:object_r:targetd_etc_rw_t:s0 tclass=dir permissive=0

Fix the error by using the kernel credentials to access the db directory

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20240215143944.847184-2-mlombard@redhat.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_configfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 023bd4516a681..30ce3451bc6b0 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3566,6 +3566,8 @@ static int __init target_core_init_configfs(void)
 {
 	struct configfs_subsystem *subsys = &target_core_fabrics;
 	struct t10_alua_lu_gp *lu_gp;
+	struct cred *kern_cred;
+	const struct cred *old_cred;
 	int ret;
 
 	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
@@ -3642,11 +3644,21 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
+	/* We use the kernel credentials to access the target directory */
+	kern_cred = prepare_kernel_cred(&init_task);
+	if (!kern_cred) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	old_cred = override_creds(kern_cred);
 	target_init_dbroot();
+	revert_creds(old_cred);
+	put_cred(kern_cred);
 
 	return 0;
 
 out:
+	target_xcopy_release_pt();
 	configfs_unregister_subsystem(subsys);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
-- 
2.43.0



