Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02031D435F;
	Mon, 17 Aug 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975326; cv=none; b=SkOvTqPAFV0Z34LF7LY2Z7W9PIqgspIkwSNlsi/9E3CRuEzD9/9rxvfPi5uJQmnqfS6In/YXBPMh5fpJqkpHAjiAuhWy2YOGleXusYqxavDvP9Qc7dPtTSrICIoGwkO7pXCD0FCU3PkmZxrSETC6gyul2Z0W93TmtpiP6uoI3vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975326; c=relaxed/simple;
	bh=YyDFOaYwVeigTKcJQhC/ut6X2qPyKvQMFOlHBRI1rN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8xet8+KmOkbOXkkZL/r2oDVWg79fKXSJPaKOYj7jfxVkxvgk5cz0tX67uZ+pCJJGaF+X8ADFwCMuJGTXuH2gjlxn+BesTI7gSaYaZJ/HrqX75miHX/eFwIy30iv7jWNwDEV1Kf2e0zmqbIwfHcWBmwxdPAFZOwKCWtqj0nFmzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Bwx+Hu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Bwx+Hu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1076A1F00A3A;
	Mon, 17 Aug 2026 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975325;
	bh=pIzvtgQEpBsjPb7SEIG0YMlLSlFQzQ5SVjXirIMycrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Bwx+Hu3ZFvd4aanBTFXmEebgrIggyGI4Zu185l6F2x4HP58+UrZj7oFlHDAdkgPC
	 Xy4/M/DDV9ldL0QvcGSgafS+HoLF9CrQNr3R6vtUukBynutZiZd/ITKzcEhU0GMmMV
	 B1qyKVnER69Z3/dFcDg4bijLpAeZOCwam9FQ571o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.18 238/250] ima: Instantiate file_truncate and path_truncate hooks
Date: Mon, 17 Aug 2026 15:33:19 +0200
Message-ID: <20260817132546.212726253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.ibm.com>

commit b80bed5c871a80151351342c065579405ce77145 upstream.

Instantiate the file_truncate and path_truncate LSM hooks to reset the
action cache flags (IMA_DONE_MASK) as soon as truncation is requested,
so the file, based on policy, is re-collected, re-measured, re-audited,
and re-appraised on next access.

Tested-by: Frederick Lawler <fred@cloudflare.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_main.c |   39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -658,6 +658,43 @@ static int ima_file_check(struct file *f
 					   MAY_APPEND), FILE_CHECK);
 }
 
+/*
+ * ima_reset_action_flags - invalidate action flags after a content change
+ * @inode: inode of the file whose content is about to be truncated
+ *
+ * Clear IMA_DONE_MASK so the file is re-collected, re-measured,
+ * re-audited, and re-appraised on next access.
+ */
+static void ima_reset_action_flags(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
+		return;
+
+	iint = ima_iint_find(inode);
+	if (!iint)
+		return;
+
+	mutex_lock(&iint->mutex);
+	iint->flags &= ~IMA_DONE_MASK;
+	iint->measured_pcrs = 0;
+	mutex_unlock(&iint->mutex);
+	return;
+}
+
+static int ima_path_truncate(const struct path *path)
+{
+	ima_reset_action_flags(path->dentry->d_inode);
+	return 0;
+}
+
+static int ima_file_truncate(struct file *file)
+{
+	ima_reset_action_flags(file_inode(file));
+	return 0;
+}
+
 static int __ima_inode_hash(struct inode *inode, struct file *file, char *buf,
 			    size_t buf_size)
 {
@@ -1271,11 +1308,13 @@ static struct security_hook_list ima_hoo
 	LSM_HOOK_INIT(file_release, ima_file_free),
 	LSM_HOOK_INIT(mmap_file, ima_file_mmap),
 	LSM_HOOK_INIT(file_mprotect, ima_file_mprotect),
+	LSM_HOOK_INIT(file_truncate, ima_file_truncate),
 	LSM_HOOK_INIT(kernel_load_data, ima_load_data),
 	LSM_HOOK_INIT(kernel_post_load_data, ima_post_load_data),
 	LSM_HOOK_INIT(kernel_read_file, ima_read_file),
 	LSM_HOOK_INIT(kernel_post_read_file, ima_post_read_file),
 	LSM_HOOK_INIT(path_post_mknod, ima_post_path_mknod),
+	LSM_HOOK_INIT(path_truncate, ima_path_truncate),
 #ifdef CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS
 	LSM_HOOK_INIT(key_post_create_or_update, ima_post_key_create_or_update),
 #endif


