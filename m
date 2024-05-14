Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5553139D09;
	Tue, 14 May 2024 11:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687047; cv=none; b=h+qtQS8Zgnsh1VExob1yl3ZxkRlCr3GoHkGKUvv4qSr9ln/UJLazYBp/drnvn3SM/MHUPKgg9AZD6j3g6iYlbJNwziQH5PCDCcyprOMrpu/wjHNCqierHU5n8LtwceeNPzefbKJxYa5qSALHDN46j36UF5MYNalkyni976MuNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687047; c=relaxed/simple;
	bh=VhLQb1yKZbywh2jiIMQ/kr7k4O/7XIJHhExzCl55GNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfPt/xKxErEPAPFjPwDh42v9tWTq50bQcHHj/wziNEuoIwMwWyJxd0RoL3k71ADKXUuxrdGcLQEWO2X36BNZe0sRTP19t76F2PxkZr6O52VYl2J8Sv/7KVKara9UDUDZwqVZr61u+k4DouM8dL38heOmkExzLekcTeXvBo2AkA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObkbbBEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObkbbBEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D43C2BD10;
	Tue, 14 May 2024 11:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687047;
	bh=VhLQb1yKZbywh2jiIMQ/kr7k4O/7XIJHhExzCl55GNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObkbbBEQudpDN6Hee/83zZP4LvGRp182k8WqanWAQkIO5E9gml0beN5XqoQuh0sOj
	 AIO/8nmyT0DaBn5Tpg66JgzTLGp2kRsOy8pwSZuGyCClWSW+nKlG1UwtGl6xqHmx6G
	 ZyR33SQmcccqdi3gcDWZBUmg13UpaS/rH9hf+4Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/84] scsi: target: Fix SELinux error when systemd-modules loads the target module
Date: Tue, 14 May 2024 12:19:58 +0200
Message-ID: <20240514100953.458848852@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e6e1755978602..4edabab65b879 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3458,6 +3458,8 @@ static int __init target_core_init_configfs(void)
 {
 	struct configfs_subsystem *subsys = &target_core_fabrics;
 	struct t10_alua_lu_gp *lu_gp;
+	struct cred *kern_cred;
+	const struct cred *old_cred;
 	int ret;
 
 	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
@@ -3534,11 +3536,21 @@ static int __init target_core_init_configfs(void)
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



