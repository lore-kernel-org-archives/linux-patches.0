Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AE0198E96;
	Wed,  6 Nov 2024 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896352; cv=none; b=jFcikHFEjQJGyO7wp+u8aTzLB0U/Cjbe8iADVL+vDwe5uAYuk7BNXRPCyF49P8rX4oLhqLUP/U6rDRkKuOud9ALdNxCj3hAkUdT9pQZFXkS2iv4yWCK4FTt+HUZ9LuXroQiObyqxBD9o+2M9Vp4U111ybMKSKqJZZoH2QuPY9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896352; c=relaxed/simple;
	bh=x5Ryqz3IzcgO3oZ6R+vwDqz6Ynj2spMjZB4U8vIYVZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUKAWqsYHafKBcZit55ZcaHUA+GT1w81R8HmKQlzsWHiiN7+Od4idzWi9T7R+tvZYh6XgTYP0iJ3AhO5fyc5ZJDPFM1WeQk8S7wuCOKtGCj9vT/a7PqTU/Mn6BeYJfnW7/YltxrsUFe3R+Y0GASK+zeFYq+bmm26uzQknp0jjYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK0Kmnb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK0Kmnb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A2CC4CECD;
	Wed,  6 Nov 2024 12:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896352;
	bh=x5Ryqz3IzcgO3oZ6R+vwDqz6Ynj2spMjZB4U8vIYVZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rK0Kmnb6bRmVIgsw90wh1BFDOH43bk+G61Q/rZQEq8+ppAhqXMskTxo9Kz6cxSr9p
	 mWTJQ+nHMVYcA1XbIGCXDWHl3MO1pH0mb5i9ab0TgD4Tk2B1dWIWTatvmnatUGcmsF
	 5c3PgNqDVDC/h5wX4dMK6SKztn88+S3dKYwbUbqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 174/245] fork: do not invoke uffd on fork if error occurs
Date: Wed,  6 Nov 2024 13:03:47 +0100
Message-ID: <20241106120323.519951776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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
Message-ID: <20241106120347.BGpuneB6xhKwe4eef97T8kj8GVmxJALQFf3918TtKlg@z>

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit f64e67e5d3a45a4a04286c47afade4b518acd47b ]

Patch series "fork: do not expose incomplete mm on fork".

During fork we may place the virtual memory address space into an
inconsistent state before the fork operation is complete.

In addition, we may encounter an error during the fork operation that
indicates that the virtual memory address space is invalidated.

As a result, we should not be exposing it in any way to external machinery
that might interact with the mm or VMAs, machinery that is not designed to
deal with incomplete state.

We specifically update the fork logic to defer khugepaged and ksm to the
end of the operation and only to be invoked if no error arose, and
disallow uffd from observing fork events should an error have occurred.

This patch (of 2):

Currently on fork we expose the virtual address space of a process to
userland unconditionally if uffd is registered in VMAs, regardless of
whether an error arose in the fork.

This is performed in dup_userfaultfd_complete() which is invoked
unconditionally, and performs two duties - invoking registered handlers
for the UFFD_EVENT_FORK event via dup_fctx(), and clearing down
userfaultfd_fork_ctx objects established in dup_userfaultfd().

This is problematic, because the virtual address space may not yet be
correctly initialised if an error arose.

The change in commit d24062914837 ("fork: use __mt_dup() to duplicate
maple tree in dup_mmap()") makes this more pertinent as we may be in a
state where entries in the maple tree are not yet consistent.

We address this by, on fork error, ensuring that we roll back state that
we would otherwise expect to clean up through the event being handled by
userland and perform the memory freeing duty otherwise performed by
dup_userfaultfd_complete().

We do this by implementing a new function, dup_userfaultfd_fail(), which
performs the same loop, only decrementing reference counts.

Note that we perform mmgrab() on the parent and child mm's, however
userfaultfd_ctx_put() will mmdrop() this once the reference count drops to
zero, so we will avoid memory leaks correctly here.

Link: https://lkml.kernel.org/r/cover.1729014377.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/d3691d58bb58712b6fb3df2be441d175bd3cdf07.1729014377.git.lorenzo.stoakes@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c              | 28 ++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h |  5 +++++
 kernel/fork.c                 |  5 ++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 27a3e9285fbf6..2f302da629cb4 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -731,6 +731,34 @@ void dup_userfaultfd_complete(struct list_head *fcs)
 	}
 }
 
+void dup_userfaultfd_fail(struct list_head *fcs)
+{
+	struct userfaultfd_fork_ctx *fctx, *n;
+
+	/*
+	 * An error has occurred on fork, we will tear memory down, but have
+	 * allocated memory for fctx's and raised reference counts for both the
+	 * original and child contexts (and on the mm for each as a result).
+	 *
+	 * These would ordinarily be taken care of by a user handling the event,
+	 * but we are no longer doing so, so manually clean up here.
+	 *
+	 * mm tear down will take care of cleaning up VMA contexts.
+	 */
+	list_for_each_entry_safe(fctx, n, fcs, list) {
+		struct userfaultfd_ctx *octx = fctx->orig;
+		struct userfaultfd_ctx *ctx = fctx->new;
+
+		atomic_dec(&octx->mmap_changing);
+		VM_BUG_ON(atomic_read(&octx->mmap_changing) < 0);
+		userfaultfd_ctx_put(octx);
+		userfaultfd_ctx_put(ctx);
+
+		list_del(&fctx->list);
+		kfree(fctx);
+	}
+}
+
 void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 			     struct vm_userfaultfd_ctx *vm_ctx)
 {
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a12bcf042551e..f4a45a37229ad 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -249,6 +249,7 @@ static inline bool vma_can_userfault(struct vm_area_struct *vma,
 
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
+void dup_userfaultfd_fail(struct list_head *);
 
 extern void mremap_userfaultfd_prep(struct vm_area_struct *,
 				    struct vm_userfaultfd_ctx *);
@@ -332,6 +333,10 @@ static inline void dup_userfaultfd_complete(struct list_head *l)
 {
 }
 
+static inline void dup_userfaultfd_fail(struct list_head *l)
+{
+}
+
 static inline void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 					   struct vm_userfaultfd_ctx *ctx)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index dbf3c5d81df3b..6423ce60b8f97 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -775,7 +775,10 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
 	mmap_write_unlock(oldmm);
-	dup_userfaultfd_complete(&uf);
+	if (!retval)
+		dup_userfaultfd_complete(&uf);
+	else
+		dup_userfaultfd_fail(&uf);
 fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
-- 
2.43.0



