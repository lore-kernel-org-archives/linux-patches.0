Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195C36405A;
	Wed, 20 May 2026 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299670; cv=none; b=P0E1D8tvK7jG9gmb5CRYG7w48XSYxJE38A+z7TnFsKE0zCX1NX5srPkLY+4CRwoKbByAaBAyRNR651fTG3sj3MI6a8VRAm6bD36qoh8AUyLsBAqD4GLS5czxoOmLZiCp632vwqvmupqBZOC96JsLGZFXWWT6xgtVwjsC3RZGC50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299670; c=relaxed/simple;
	bh=/kE+arFwWGQqUmDDv9Cwdn9chySVTZMUGIKKLkx2lOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZlJvC0zA+Zo4KOE/kN5lTIaO0Fjbt0sc5TADPLu6uQ0CeDWkDhbE+N0DlLohBE61jkve9JNacGQHFeop6mG5fCz1UrDGhXHI7FXYDreXZug1avblVapeZtpExs08dmRCYC93Sws6DchigMConPGkqTIoad+85wJKc8o6ZI86Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQ9DQmrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQ9DQmrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8876F1F000E9;
	Wed, 20 May 2026 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299669;
	bh=cxIElC+FfgFipylnqYWck/NaFS/K23ef31FQ36ieF9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ9DQmrUeaI+Fug00T15xCYSqoXKvzixM0OlvlYJu2GRFaVh+Z5wv93gXGqFmgeg0
	 cF5YurPTtocEIFVQK0wc9Y5Iy7Pp36Hwb84+3NlBjArpgUL4qKo7xwze3lbasKf5ys
	 0hNDJFf0J1z+sjtuuBmjIgdckfN7iRwv1xiq7SR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 860/957] Revert "pseries/papr-hvpipe: Fix race with interrupt handler"
Date: Wed, 20 May 2026 18:22:23 +0200
Message-ID: <20260520162153.215975642@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

This reverts commit 6542e180fa6e1c701aba446a555c65556e6fd1a5.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr-hvpipe.c b/arch/powerpc/platforms/pseries/papr-hvpipe.c
index a238db095b4ec..3d8672642c251 100644
--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -449,14 +449,13 @@ static int papr_hvpipe_handle_release(struct inode *inode,
 				struct file *file)
 {
 	struct hvpipe_source_info *src_info;
-	unsigned long flags;
 
 	/*
 	 * Hold the lock, remove source from src_list, reset the
 	 * hvpipe status and release the lock to prevent any race
 	 * with message event IRQ.
 	 */
-	spin_lock_irqsave(&hvpipe_src_list_lock, flags);
+	spin_lock(&hvpipe_src_list_lock);
 	src_info = file->private_data;
 	list_del(&src_info->list);
 	file->private_data = NULL;
@@ -467,10 +466,10 @@ static int papr_hvpipe_handle_release(struct inode *inode,
 	 */
 	if (src_info->hvpipe_status & HVPIPE_MSG_AVAILABLE) {
 		src_info->hvpipe_status = 0;
-		spin_unlock_irqrestore(&hvpipe_src_list_lock, flags);
+		spin_unlock(&hvpipe_src_list_lock);
 		hvpipe_rtas_recv_msg(NULL, 0);
 	} else
-		spin_unlock_irqrestore(&hvpipe_src_list_lock, flags);
+		spin_unlock(&hvpipe_src_list_lock);
 
 	kfree(src_info);
 	return 0;
@@ -486,21 +485,20 @@ static const struct file_operations papr_hvpipe_handle_ops = {
 static int papr_hvpipe_dev_create_handle(u32 srcID)
 {
 	struct hvpipe_source_info *src_info __free(kfree) = NULL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&hvpipe_src_list_lock, flags);
+	spin_lock(&hvpipe_src_list_lock);
 	/*
 	 * Do not allow more than one process communicates with
 	 * each source.
 	 */
 	src_info = hvpipe_find_source(srcID);
 	if (src_info) {
-		spin_unlock_irqrestore(&hvpipe_src_list_lock, flags);
+		spin_unlock(&hvpipe_src_list_lock);
 		pr_err("pid(%d) is already using the source(%d)\n",
 				src_info->tsk->pid, srcID);
 		return -EALREADY;
 	}
-	spin_unlock_irqrestore(&hvpipe_src_list_lock, flags);
+	spin_unlock(&hvpipe_src_list_lock);
 
 	src_info = kzalloc(sizeof(*src_info), GFP_KERNEL_ACCOUNT);
 	if (!src_info)
@@ -517,18 +515,18 @@ static int papr_hvpipe_dev_create_handle(u32 srcID)
 		return fdf.err;
 
 	retain_and_null_ptr(src_info);
-	spin_lock_irqsave(&hvpipe_src_list_lock, flags);
+	spin_lock(&hvpipe_src_list_lock);
 	/*
 	 * If two processes are executing ioctl() for the same
 	 * source ID concurrently, prevent the second process to
 	 * acquire FD.
 	 */
 	if (hvpipe_find_source(srcID)) {
-		spin_unlock_irqrestore(&hvpipe_src_list_lock, flags);
+		spin_unlock(&hvpipe_src_list_lock);
 		return -EALREADY;
 	}
 	list_add(&src_info->list, &hvpipe_src_list);
-	spin_unlock_irqrestore(&hvpipe_src_list_lock, flags);
+	spin_unlock(&hvpipe_src_list_lock);
 	return fd_publish(fdf);
 }
 
-- 
2.53.0



