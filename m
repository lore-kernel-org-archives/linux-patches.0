Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243191F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9896BC433C7;
	Tue,  1 Aug 2023 09:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882880;
	bh=+0SUBqNuFZ0gY4kODQ9MpJrpgKOhAh0fzVNICRZ7OFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwA38rsYzggLStgr4TIJWaHYhCGu3KFLc8QgJ4PXuhbZYSiosAmlmMgQsUC9hyO5v
	 iFeH/dMlO5vtDTkkURPIxUXFynJRnrDh9oZZzFx0f+p+4AXvFJziacpxW7TJKMvZIf
	 E1lUvkGX3mhLjDTNQDwWlfZ5hIAXnDtsKpNqL4j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haren Myneni <haren@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 009/239] powerpc/pseries/vas: Hold mmap_mutex after mmap lock during window close
Date: Tue,  1 Aug 2023 11:17:53 +0200
Message-ID: <20230801091925.991537760@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit b59c9dc4d9d47b3c4572d826603fde507055b656 ]

Commit 8ef7b9e1765a ("powerpc/pseries/vas: Close windows with DLPAR
core removal") unmaps the window paste address and issues HCALL to
close window in the hypervisor for migration or DLPAR core removal
events. So holds mmap_mutex and then mmap lock before unmap the
paste address. But if the user space issue mmap paste address at
the same time with the migration event, coproc_mmap() is called
after holding the mmap lock which can trigger deadlock when trying
to acquire mmap_mutex in coproc_mmap().

t1: mmap() call to mmap              t2: Migration event
    window paste address

do_mmap2()                           migration_store()
 ksys_mmap_pgoff()                    pseries_migrate_partition()
  vm_mmap_pgoff()                      vas_migration_handler()
    Acquire mmap lock                   reconfig_close_windows()
    do_mmap()                             lock mmap_mutex
     mmap_region()                        Acquire mmap lock
      call_mmap()                         //Wait for mmap lock
       coproc_mmap()                        unmap vma
         lock mmap_mutex                    update window status
         //wait for mmap_mutex            Release mmap lock
          mmap vma                        unlock mmap_mutex
          update window status
         unlock mmap_mutex
    ...
    Release mmap lock

Fix this deadlock issue by holding mmap lock first before mmap_mutex
in reconfig_close_windows().

Fixes: 8ef7b9e1765a ("powerpc/pseries/vas: Close windows with DLPAR core removal")
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230716100506.7833-1-haren@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/vas.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 9a44a98ba3420..3fbc2a6aa319d 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -744,6 +744,12 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
 		}
 
 		task_ref = &win->vas_win.task_ref;
+		/*
+		 * VAS mmap (coproc_mmap()) and its fault handler
+		 * (vas_mmap_fault()) are called after holding mmap lock.
+		 * So hold mmap mutex after mmap_lock to avoid deadlock.
+		 */
+		mmap_write_lock(task_ref->mm);
 		mutex_lock(&task_ref->mmap_mutex);
 		vma = task_ref->vma;
 		/*
@@ -752,7 +758,6 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
 		 */
 		win->vas_win.status |= flag;
 
-		mmap_write_lock(task_ref->mm);
 		/*
 		 * vma is set in the original mapping. But this mapping
 		 * is done with mmap() after the window is opened with ioctl.
@@ -762,8 +767,8 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
 		if (vma)
 			zap_vma_pages(vma);
 
-		mmap_write_unlock(task_ref->mm);
 		mutex_unlock(&task_ref->mmap_mutex);
+		mmap_write_unlock(task_ref->mm);
 		/*
 		 * Close VAS window in the hypervisor, but do not
 		 * free vas_window struct since it may be reused
-- 
2.39.2



