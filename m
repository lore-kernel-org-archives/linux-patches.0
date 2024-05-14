Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71213D28D;
	Tue, 14 May 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686827; cv=none; b=ToJWCHR7lTlCqzd5ghdXpa0ZtOp2BmmkGZg7n4Uk8VPFrbrZ+9qyeCHho/sTCsCwdjMKCDINiZUShtnsfi6iBtBe7ZVQo7iWCiqkInkLROm36DupQutfHpLjDEhtmZs6Sn2bFAbhxufcw80ynAUV0KFGi4TwOHKlyIciACQ5a2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686827; c=relaxed/simple;
	bh=zgXrxs5jirDEVQ7V3Px2uaRtKyNSmg/PYy/SrTrmB9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAdFNru87pS982QRDfAPwKx1QQlr9cFuXQ0yD4hWdlJKutpCtVy5HFH1q/S2KYu5AaW3X3CrUJrXYT1erUjy/NJj8Mz8iw/vd533ELTW59ODjbBCTgnAWh9MDIrc3USLhKhaDRFxsu5+kbuPRJ5GVFJJ1Cgn9/nAUqu6T33aVYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHhtTqOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHhtTqOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF3EC2BD10;
	Tue, 14 May 2024 11:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686826;
	bh=zgXrxs5jirDEVQ7V3Px2uaRtKyNSmg/PYy/SrTrmB9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHhtTqOzjhrbjy6Y+Bk6dbr8srvF/6QF9aD4MB5N1aSo1OW49kFbA6CPsKUJ0mhhf
	 YIsBVZYlMRjQrq6beBO/sxR+VXQMuV4fEEs1On/u9B/W0PG+u0ar2HVkduwt0pCXI5
	 XQkNGy2+/xcsdERjAZvfdGIs6pvm46iwytGsw39I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/63] scsi: target: Fix SELinux error when systemd-modules loads the target module
Date: Tue, 14 May 2024 12:19:56 +0200
Message-ID: <20240514100949.340518891@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f6b1549f41422..10fbfa7df46ab 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3240,6 +3240,8 @@ static int __init target_core_init_configfs(void)
 {
 	struct configfs_subsystem *subsys = &target_core_fabrics;
 	struct t10_alua_lu_gp *lu_gp;
+	struct cred *kern_cred;
+	const struct cred *old_cred;
 	int ret;
 
 	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
@@ -3316,11 +3318,21 @@ static int __init target_core_init_configfs(void)
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



