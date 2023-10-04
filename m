Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5051D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNMgy+eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7DFC433C9;
	Wed,  4 Oct 2023 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444030;
	bh=jkvekIAWo/EoE6ZP0qvU3sgJ5uR/FzdxHdRCgwUtZTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNMgy+eQAfMbWH7D6UZ4/7aIm4NmsgNzAWW4L0Y0l5cCPR4vEMf1nGCXjCuA9mQ2/
	 LHav3uglppuKFiHcyX/UmEs3fN4PABtV+fhbC+m6SdF7DWAYeFu3qeEbajGqD1I1nE
	 RZLV5xn6YVPg6NlN9YBpT5lXi/lO0OpeT6pMCPsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Giulio Benetti <giulio.benetti@benettiengineering.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 105/321] proc: nommu: fix empty /proc/<pid>/maps
Date: Wed,  4 Oct 2023 19:54:10 +0200
Message-ID: <20231004175234.106640406@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Wolsieffer <ben.wolsieffer@hefring.com>

[ Upstream commit fe4419801617514765974f3e796269bc512ad146 ]

On no-MMU, /proc/<pid>/maps reads as an empty file.  This happens because
find_vma(mm, 0) always returns NULL (assuming no vma actually contains the
zero address, which is normally the case).

To fix this bug and improve the maintainability in the future, this patch
makes the no-MMU implementation as similar as possible to the MMU
implementation.

The only remaining differences are the lack of hold/release_task_mempolicy
and the extra code to shoehorn the gate vma into the iterator.

This has been tested on top of 6.5.3 on an STM32F746.

Link: https://lkml.kernel.org/r/20230915160055.971059-2-ben.wolsieffer@hefring.com
Fixes: 0c563f148043 ("proc: remove VMA rbtree use from nommu")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/internal.h   |  2 --
 fs/proc/task_nommu.c | 37 ++++++++++++++++++++++---------------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 9dda7e54b2d0d..9a8f32f21ff56 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -289,9 +289,7 @@ struct proc_maps_private {
 	struct inode *inode;
 	struct task_struct *task;
 	struct mm_struct *mm;
-#ifdef CONFIG_MMU
 	struct vma_iterator iter;
-#endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 061bd3f82756e..d3e19080df4af 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -188,15 +188,28 @@ static int show_map(struct seq_file *m, void *_p)
 	return nommu_vma_show(m, _p);
 }
 
-static void *m_start(struct seq_file *m, loff_t *pos)
+static struct vm_area_struct *proc_get_vma(struct proc_maps_private *priv,
+						loff_t *ppos)
+{
+	struct vm_area_struct *vma = vma_next(&priv->iter);
+
+	if (vma) {
+		*ppos = vma->vm_start;
+	} else {
+		*ppos = -1UL;
+	}
+
+	return vma;
+}
+
+static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
+	unsigned long last_addr = *ppos;
 	struct mm_struct *mm;
-	struct vm_area_struct *vma;
-	unsigned long addr = *pos;
 
-	/* See m_next(). Zero at the start or after lseek. */
-	if (addr == -1UL)
+	/* See proc_get_vma(). Zero at the start or after lseek. */
+	if (last_addr == -1UL)
 		return NULL;
 
 	/* pin the task and mm whilst we play with them */
@@ -218,12 +231,9 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-EINTR);
 	}
 
-	/* start the next element from addr */
-	vma = find_vma(mm, addr);
-	if (vma)
-		return vma;
+	vma_iter_init(&priv->iter, mm, last_addr);
 
-	return NULL;
+	return proc_get_vma(priv, ppos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -240,12 +250,9 @@ static void m_stop(struct seq_file *m, void *v)
 	priv->task = NULL;
 }
 
-static void *m_next(struct seq_file *m, void *_p, loff_t *pos)
+static void *m_next(struct seq_file *m, void *_p, loff_t *ppos)
 {
-	struct vm_area_struct *vma = _p;
-
-	*pos = vma->vm_end;
-	return find_vma(vma->vm_mm, vma->vm_end);
+	return proc_get_vma(m->private, ppos);
 }
 
 static const struct seq_operations proc_pid_maps_ops = {
-- 
2.40.1



