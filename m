Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006EF3EDE67;
	Tue, 12 May 2026 18:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609095; cv=none; b=FetysWHOm9HWBb6com68KSTsR4tLlIYL4kg5F/g7onWtZOPnGBenoAd2SEW4uabSXNK0yYqsJiTZjYkuCkAyLra7KCUra2jm0Yjmg6YHl1v66hz+L5nZwly6twRjnarmRT3tXeGjKB+LTy7VQR848FMY5rHoYfQg2itT7r9kHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609095; c=relaxed/simple;
	bh=9nR/Lhu6/CCrZcJyqaK7J61mLJB7IDDbc5JNd4M2Wmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU5cR6I40/jYjJVxEmAKfAqu0SHzaI/9fbbN7vmbjmIugyrnz0+AKMn+mIgBHyWxjVMWKyIC90tQNZaCfBj8JXrEmqZQS5p4za0nIgzSYcDu+7h7Wdb3vBr4z+vf1PoHNH5T+RNe6oshCk9ZFF6aDzBMem1/p08ft9WZ83GgUdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Olh/3GVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Olh/3GVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C555C2BCB0;
	Tue, 12 May 2026 18:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609094;
	bh=9nR/Lhu6/CCrZcJyqaK7J61mLJB7IDDbc5JNd4M2Wmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Olh/3GVBUg07eXLsGXvUFEkQAGYUYFMDy4m1ibkFfZNjJCnPu/ucSSbVOjIg5Kk0d
	 xRP2RSagOWA6zGBaDTDi2jgq620Y7H5IpCqVM7HHXOVO66zaEUKnHrE/HKIA4bckAI
	 3BvbC1i2HtO+sSGG8eY0qvtcpgN7OHBeR71V9iRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 062/307] selinux: prune /sys/fs/selinux/checkreqprot
Date: Tue, 12 May 2026 19:37:37 +0200
Message-ID: <20260512173941.430261536@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 644132a48f4e28a1d949d162160869286f3e75de upstream.

commit a7e4676e8e2cb ("selinux: remove the 'checkreqprot'
functionality") removed the ability to modify the checkreqprot setting
but left everything except the updating of the checkreqprot value
intact. Aside from unnecessary processing, this could produce a local
DoS from log spam and incorrectly calls selinux_ima_measure_state() on
each write even though no state has changed. Prune it to just log an
error message once and return count (i.e. all bytes written
successfully) so that userspace never breaks.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/selinuxfs.c |   47 ++++++-------------------------------------
 1 file changed, 7 insertions(+), 40 deletions(-)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -687,46 +687,13 @@ static ssize_t sel_read_checkreqprot(str
 static ssize_t sel_write_checkreqprot(struct file *file, const char __user *buf,
 				      size_t count, loff_t *ppos)
 {
-	char *page;
-	ssize_t length;
-	unsigned int new_value;
-
-	length = avc_has_perm(current_sid(), SECINITSID_SECURITY,
-			      SECCLASS_SECURITY, SECURITY__SETCHECKREQPROT,
-			      NULL);
-	if (length)
-		return length;
-
-	if (count >= PAGE_SIZE)
-		return -ENOMEM;
-
-	/* No partial writes. */
-	if (*ppos != 0)
-		return -EINVAL;
-
-	page = memdup_user_nul(buf, count);
-	if (IS_ERR(page))
-		return PTR_ERR(page);
-
-	if (sscanf(page, "%u", &new_value) != 1) {
-		length = -EINVAL;
-		goto out;
-	}
-	length = count;
-
-	if (new_value) {
-		char comm[sizeof(current->comm)];
-
-		strscpy(comm, current->comm);
-		pr_err("SELinux: %s (%d) set checkreqprot to 1. This is no longer supported.\n",
-		       comm, current->pid);
-	}
-
-	selinux_ima_measure_state();
-
-out:
-	kfree(page);
-	return length;
+	/*
+	 * Setting checkreqprot is no longer supported, see
+	 * https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-checkreqprot
+	 */
+	pr_err_once("SELinux: %s (%d) wrote to checkreqprot. This is no longer supported.\n",
+		    current->comm, current->pid);
+	return count;
 }
 static const struct file_operations sel_checkreqprot_ops = {
 	.read		= sel_read_checkreqprot,


