Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8085ABA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D16C433EF;
	Tue,  7 Mar 2023 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214604;
	bh=Clc2LlgU3DfcK5nn/4ngzN3/NLuDljWS9YTrhLlzDE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUtpmyWmaVEQOMKb4W0kUaynzC7UtKEkKFI2XhR65mZZUQsTYkMVJDf3Yxb3DLOln
	 tHexGA/kDkpoiuyWP8/XuokP3gdzhGFkFkjxu7Xm8dAqDfBpYHRhE2+ZIqP7F7kP8E
	 ZUQUPOC5d20YU1B7M8Tuq+bJzQiEUWV3RzhgcNa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Sistare <steven.sistare@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 876/885] vfio/type1: track locked_vm per dma
Date: Tue,  7 Mar 2023 18:03:30 +0100
Message-Id: <20230307170039.846599476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve Sistare <steven.sistare@oracle.com>

commit 18e292705ba21cc9b3227b9ad5b1c28973605ee5 upstream.

Track locked_vm per dma struct, and create a new subroutine, both for use
in a subsequent patch.  No functional change.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1675184289-267876-4-git-send-email-steven.sistare@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,7 @@ struct vfio_dma {
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
 	struct mm_struct	*mm;
+	size_t			locked_vm;
 };
 
 struct vfio_batch {
@@ -413,6 +414,19 @@ static int vfio_iova_put_vfio_pfn(struct
 	return ret;
 }
 
+static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
+			bool lock_cap, long npage)
+{
+	int ret = mmap_write_lock_killable(mm);
+
+	if (ret)
+		return ret;
+
+	ret = __account_locked_vm(mm, abs(npage), npage > 0, task, lock_cap);
+	mmap_write_unlock(mm);
+	return ret;
+}
+
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct mm_struct *mm;
@@ -425,12 +439,9 @@ static int vfio_lock_acct(struct vfio_dm
 	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
+	ret = mm_lock_acct(dma->task, mm, dma->lock_cap, npage);
+	if (!ret)
+		dma->locked_vm += npage;
 
 	if (async)
 		mmput(mm);


