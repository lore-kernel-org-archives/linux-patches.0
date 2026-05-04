Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4C22E2F0E;
	Mon,  4 May 2026 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903583; cv=none; b=pidd1pQHPHP650/PKCmSOxVqJvJhFoMt3qvxhx/qwhqMy/rYgdiAVE2GIskpki7Q+vKNcNpdKcgl2aCCDaMDDLvObUWbNrcANSO06g+11ymHWLzgYh5QnMbrfBIY8/PsuVn/fTSnHLutx19EzSHSqhhwMJNyNmQsJaj8greurpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903583; c=relaxed/simple;
	bh=wggb4D1wSnzYBXyKgc36p9S0ogor2iMOwa4rq48rTsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmPniuqs7qhJc0e6NfRQcU19g0Lg8vf4dNjdMFD0DwOFbqouPnM7sVrgQJVFSLYGmL/fszNJkLbPpUgb0vYujW8Ie2xcsAzN8uCpP7nJch2R3Vs87kAjnE4KwotAprrvmGS3abHndpX0R279S3/p2beOzGTdFg9DqXU86BUPw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hijSwaiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hijSwaiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A20C2BCB8;
	Mon,  4 May 2026 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903583;
	bh=wggb4D1wSnzYBXyKgc36p9S0ogor2iMOwa4rq48rTsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hijSwaiDz71C5hfXJPc3z5PQEK76S+L1xeD5dJ72rd28vtblpa6Yzh9B98C/wUPap
	 mPOQnCuo/fGiZg/Z4rM5+yfUl4nnC0CfyOL90G4zGdJttbQYVAcDZF05UEBORxVfZA
	 OiWfa+F4IZYjH7dslpWgZgb76FCYZGD3Bk0InFAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Bodo Stroesser <bostroesser@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Dexuan Cui <decui@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Long Li <longli@microsoft.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Richard Weinberger <richard@nod.at>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Wei Liu <wei.liu@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 291/307] mm: avoid deadlock when holding rmap on mmap_prepare error
Date: Mon,  4 May 2026 15:52:56 +0200
Message-ID: <20260504135153.740527989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>

[ Upstream commit f96e1d5f15b7c854a6a9ec1225d68a12fe7dcda6 ]

Commit ac0a3fc9c07d ("mm: add ability to take further action in
vm_area_desc") added the ability for drivers to instruct mm to take actions
after the .mmap_prepare callback is complete.

To make life simpler and safer, this is done before the VMA/mmap write lock
is dropped but when the VMA is completely established.

So on error, we simply munmap() the VMA.

As part of this implementation, unfortunately a horrible hack had to be
implemented to support some questionable behaviour hugetlb relies upon -
that is that the file rmap lock is held until the operation is complete.

The implementation, for convenience, did this in mmap_action_finish() so
both the VMA and mmap_prepare compatibility layer paths would have this
correctly handled.

However, it turns out there is a mistake here - the rmap lock cannot be
held on munmap, as free_pgtables() -> unlink_file_vma_batch_add() ->
unlink_file_vma_batch_process() takes the file rmap lock.

We therefore currently have a deadlock issue that might arise.

Resolve this by leaving it to callers to handle the unmap.

The compatibility layer does not support this rmap behaviour, so we simply
have it unmap on error after calling mmap_action_complete().

In the VMA implementation, we only perform the unmap after the rmap lock is
dropped.

This resolves the issue by ensuring the rmap lock is always dropped when
the unmap occurs.

Link: https://lkml.kernel.org/r/d44248be9da68258b07c2c59d4e73485ee0ca943.1774045440.git.ljs@kernel.org
Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |   12 +++++++-----
 mm/vma.c  |   13 ++++++++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -1186,7 +1186,13 @@ int compat_vma_mmap(struct file *file, s
 		return err;
 
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
+	err = mmap_action_complete(vma, &desc.action);
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+	return err;
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
@@ -1279,10 +1285,6 @@ static int mmap_action_finish(struct vm_
 	 * invoked if we do NOT merge, so we only clean up the VMA we created.
 	 */
 	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-
 		if (action->error_hook) {
 			/* We may want to filter the error. */
 			err = action->error_hook(err);
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2706,9 +2706,9 @@ static int call_action_complete(struct m
 				struct mmap_action *action,
 				struct vm_area_struct *vma)
 {
-	int ret;
+	int err;
 
-	ret = mmap_action_complete(vma, action);
+	err = mmap_action_complete(vma, action);
 
 	/* If we held the file rmap we need to release it. */
 	if (map->hold_file_rmap_lock) {
@@ -2716,7 +2716,14 @@ static int call_action_complete(struct m
 
 		i_mmap_unlock_write(file->f_mapping);
 	}
-	return ret;
+
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+
+	return err;
 }
 
 static unsigned long __mmap_region(struct file *file, unsigned long addr,


