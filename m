Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779571F03D7;
	Fri, 21 Nov 2025 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731852; cv=none; b=K6qLOV+VaDNZ91MfRYPciUFrzIjbs70OcjA1Zs/qR9gJYSduTB78WwBhOoBijmgYEkWR8PoEagPb9NtEMxel+uf1AoE9qbfjtmD0Iqb9YX4YlGK8RN8eHp7pYwl82HPbfm+KRL6TMIQmmkOn6zf/9IIIpVFb8ucKxAaQMbT8IfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731852; c=relaxed/simple;
	bh=UlKZVUhtFVEKL3VH77v6xqsVZBgoDh0un4OxvFmyHvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rs58iG55Sl/+c5fg1dNwa8wKQ0pW0WqT1u2b0U12FCMNbPGD0ApZmiq3bsV14OmG8aT9q5P7nD6zbAhUpUjbdCZtzzchXmiJsRdT2dHM3U9QRxObzUUrv5p/9w76M7MqU2iR7tcaPkSE688TOixaz81eOZ0+Jeya9HxRnGNaAgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o37SEM+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o37SEM+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41BBC4CEF1;
	Fri, 21 Nov 2025 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731852;
	bh=UlKZVUhtFVEKL3VH77v6xqsVZBgoDh0un4OxvFmyHvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o37SEM+oyk1EK/e4rA71yH6asAAAtneUJKX7EiUU4thWO2BgpP//IIfYPDsy4VzQb
	 ofp9mzlbR3mDkTE5xPMO6utSRnfqrovcKcxLh1NB9dIlGfBhsJ/hMuFLT5BokK7esv
	 WL/I2e17f1ghhG0FPdy65oRscx9xzO03W03zV8MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f9238a0a31f9b5603fef@syzkaller.appspotmail.com,
	Penglei Jiang <superman.xpt@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Christian Brauner <brauner@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jeff layton <jlayton@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	xu xin <xu.xin16@zte.com.cn>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakub Acs <acsjakub@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/185] proc: fix the issue of proc_mem_open returning NULL
Date: Fri, 21 Nov 2025 14:11:53 +0100
Message-ID: <20251121130146.971272499@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Penglei Jiang <superman.xpt@gmail.com>

[ Upstream commit 65c66047259fad1b868d4454bc5af95b46a5f954 ]

proc_mem_open() can return an errno, NULL, or mm_struct*.  If it fails to
acquire mm, it returns NULL, but the caller does not check for the case
when the return value is NULL.

The following conditions lead to failure in acquiring mm:

  - The task is a kernel thread (PF_KTHREAD)
  - The task is exiting (PF_EXITING)

Changes:

  - Add documentation comments for the return value of proc_mem_open().
  - Add checks in the caller to return -ESRCH when proc_mem_open()
    returns NULL.

Link: https://lkml.kernel.org/r/20250404063357.78891-1-superman.xpt@gmail.com
Reported-by: syzbot+f9238a0a31f9b5603fef@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000f52642060d4e3750@google.com
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: Jeff layton <jlayton@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ acsjakub: applied cleanly ]
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c       | 12 +++++++++---
 fs/proc/task_mmu.c   | 12 ++++++------
 fs/proc/task_nommu.c |  4 ++--
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a2541f5204af0..d060af34a6e83 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -828,7 +828,13 @@ static const struct file_operations proc_single_file_operations = {
 	.release	= single_release,
 };
 
-
+/*
+ * proc_mem_open() can return errno, NULL or mm_struct*.
+ *
+ *   - Returns NULL if the task has no mm (PF_KTHREAD or PF_EXITING)
+ *   - Returns mm_struct* on success
+ *   - Returns error code on failure
+ */
 struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode)
 {
 	struct task_struct *task = get_proc_task(inode);
@@ -853,8 +859,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 {
 	struct mm_struct *mm = proc_mem_open(inode, mode);
 
-	if (IS_ERR(mm))
-		return PTR_ERR(mm);
+	if (IS_ERR_OR_NULL(mm))
+		return mm ? PTR_ERR(mm) : -ESRCH;
 
 	file->private_data = mm;
 	return 0;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8f5ad591d7625..08a06fd37f0e1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -212,8 +212,8 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		int err = PTR_ERR(priv->mm);
+	if (IS_ERR_OR_NULL(priv->mm)) {
+		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
@@ -1316,8 +1316,8 @@ static int smaps_rollup_open(struct inode *inode, struct file *file)
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		ret = PTR_ERR(priv->mm);
+	if (IS_ERR_OR_NULL(priv->mm)) {
+		ret = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
 
 		single_release(inode, file);
 		goto out_free;
@@ -2049,8 +2049,8 @@ static int pagemap_open(struct inode *inode, struct file *file)
 	struct mm_struct *mm;
 
 	mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(mm))
-		return PTR_ERR(mm);
+	if (IS_ERR_OR_NULL(mm))
+		return mm ? PTR_ERR(mm) : -ESRCH;
 	file->private_data = mm;
 	return 0;
 }
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index bce6745330003..59bfd61d653aa 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -260,8 +260,8 @@ static int maps_open(struct inode *inode, struct file *file,
 
 	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		int err = PTR_ERR(priv->mm);
+	if (IS_ERR_OR_NULL(priv->mm)) {
+		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
-- 
2.51.0



