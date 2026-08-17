Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA5F42643C;
	Mon, 17 Aug 2026 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974603; cv=none; b=ExoqWxlJbqLOCsvOBOe4zmk4SO0oKaDhYkZi0WERxOvNPAsbZc9KbQcSyA+dCD7UEEmzVhzgQ1g6bqhaIdz9y8vQcNyZRzblsSs2GjstNlGK6zghq6KQk2OK4lqeEyi3vbp/BTOhhz3nmRHh0oBrrPm4ZSEi+ydBlz0qSgtUNNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974603; c=relaxed/simple;
	bh=74oHSjISF2CIbIOjOXp9ub9PDbXFkUnB10n0pPrvNbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyZkLG+oD05SS8W0giGPUXaugwYBdsuJ/SC6F1cL5Mf3vf8cLGXSjw/+0c5jSy0liX4f558BJ3eQhBxtddGPeMHmwCz5t6Q6kC+0+jAzxQ8ED6KCfVEu1H/6fCItua/lnMSMsg1qUVRNlyy6W8Ixg5IXF7rLX0eTkn5k+3ieMkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLmmQ/vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLmmQ/vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9B81F00A3D;
	Mon, 17 Aug 2026 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974597;
	bh=uctj8PD2JA4PJ+Y7SSxT/Y7TKuFpN62azv6XgMscnBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLmmQ/vyR3cqHa9xAK4r5eloqStPAnqwyZuZEWQgrWDw0EV0BeHwRHYkhp2AsTpyZ
	 WlQTa1ldf/tWj4+vLeDkmySfvirH/5JDdJDsAl0XEvuZIA5dHLAM7V2O7WwD/Jc9Uj
	 St9/r7+NPMjatZs58cjI/HrlKCYRA5/ZonWHBEOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 7.1 261/271] ima: Instantiate file_truncate and path_truncate hooks
Date: Mon, 17 Aug 2026 15:33:06 +0200
Message-ID: <20260817132547.469928763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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
@@ -687,6 +687,43 @@ static int ima_file_check(struct file *f
 					   MAY_APPEND), FILE_CHECK, 0, false);
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
@@ -1300,11 +1337,13 @@ static struct security_hook_list ima_hoo
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


