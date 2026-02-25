Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20926561A;
	Wed, 25 Feb 2026 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983634; cv=none; b=A1ZHJ4fhMIW0Ymaqqku5ZjGjlLkA+DuXPK4GV8TYfhu4M7Ks5lHMZaHyEJy9XeILMm+0kL/wk2PNeMf9I/qPTWjY4UgIvZQU1x19dOy+H/DE9jL7ZT5XFxegAPRCvZBrgKducZGmg4TMPywA4olGD5JNItPo3OMGP8ZQW6gVMJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983634; c=relaxed/simple;
	bh=1GjDhQrqN/UzCQcyCUOmJ1KFI+qiuNve2U+tf/J5Hgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYtAEQp3iLQ+mjYp7eQVXeQLFcl3nnGbCg67hglROJeUtdM8SJI0WXSuKKYVHw73udP+7BpqG+QuSfsqH6o5cho/5C47Jr/D1paRcCU4VIJxaRGKzEtbDHO31GzpAAS06ekDx0tkvAIEFBWl67hmR7RNAkX7kgwyhqce4peVvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br0TTgY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br0TTgY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F9C116D0;
	Wed, 25 Feb 2026 01:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983634;
	bh=1GjDhQrqN/UzCQcyCUOmJ1KFI+qiuNve2U+tf/J5Hgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Br0TTgY1DUu8TPcHHsrRwHiO24jYPrp6vHRCb7uKBkmLzhvczKMfO0EL1N4rSpaMj
	 ZJpAR3kvFwKc72ac4fDmE5zmxGb0ZvCaCdMRhTvIDG8WjwzYnU4T6jsVYvNf9a2e0p
	 ERmd7rBrABSF4tejf9bS9nO7SUa6R72Vd+9FrZgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@tyhicks.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 697/781] apparmor: drop in_atomic flag in common_mmap, and common_file_perm
Date: Tue, 24 Feb 2026 17:23:26 -0800
Message-ID: <20260225012416.853110100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit c3f27ccdb2dce3f0f2814574d06017f46c11fa29 ]

with the previous changes to mmap the in_atomic flag is now always
false, so drop it.

Suggested-by: Tyler Hicks <code@tyhicks.com>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index acca3d6efdbc8..e59e9bc7250bf 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -520,8 +520,7 @@ static void apparmor_file_free_security(struct file *file)
 		aa_put_label(rcu_access_pointer(ctx->label));
 }
 
-static int common_file_perm(const char *op, struct file *file, u32 mask,
-			    bool in_atomic)
+static int common_file_perm(const char *op, struct file *file, u32 mask)
 {
 	struct aa_label *label;
 	int error = 0;
@@ -532,7 +531,7 @@ static int common_file_perm(const char *op, struct file *file, u32 mask,
 		return -EACCES;
 
 	label = __begin_current_label_crit_section(&needput);
-	error = aa_file_perm(op, current_cred(), label, file, mask, in_atomic);
+	error = aa_file_perm(op, current_cred(), label, file, mask, false);
 	__end_current_label_crit_section(label, needput);
 
 	return error;
@@ -540,13 +539,12 @@ static int common_file_perm(const char *op, struct file *file, u32 mask,
 
 static int apparmor_file_receive(struct file *file)
 {
-	return common_file_perm(OP_FRECEIVE, file, aa_map_file_to_perms(file),
-				false);
+	return common_file_perm(OP_FRECEIVE, file, aa_map_file_to_perms(file));
 }
 
 static int apparmor_file_permission(struct file *file, int mask)
 {
-	return common_file_perm(OP_FPERM, file, mask, false);
+	return common_file_perm(OP_FPERM, file, mask);
 }
 
 static int apparmor_file_lock(struct file *file, unsigned int cmd)
@@ -556,11 +554,11 @@ static int apparmor_file_lock(struct file *file, unsigned int cmd)
 	if (cmd == F_WRLCK)
 		mask |= MAY_WRITE;
 
-	return common_file_perm(OP_FLOCK, file, mask, false);
+	return common_file_perm(OP_FLOCK, file, mask);
 }
 
 static int common_mmap(const char *op, struct file *file, unsigned long prot,
-		       unsigned long flags, bool in_atomic)
+		       unsigned long flags)
 {
 	int mask = 0;
 
@@ -578,21 +576,20 @@ static int common_mmap(const char *op, struct file *file, unsigned long prot,
 	if (prot & PROT_EXEC)
 		mask |= AA_EXEC_MMAP;
 
-	return common_file_perm(op, file, mask, in_atomic);
+	return common_file_perm(op, file, mask);
 }
 
 static int apparmor_mmap_file(struct file *file, unsigned long reqprot,
 			      unsigned long prot, unsigned long flags)
 {
-	return common_mmap(OP_FMMAP, file, prot, flags, false);
+	return common_mmap(OP_FMMAP, file, prot, flags);
 }
 
 static int apparmor_file_mprotect(struct vm_area_struct *vma,
 				  unsigned long reqprot, unsigned long prot)
 {
 	return common_mmap(OP_FMPROT, vma->vm_file, prot,
-			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0,
-			   false);
+			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0);
 }
 
 #ifdef CONFIG_IO_URING
-- 
2.51.0



