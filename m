Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E57A3376BD;
	Tue, 26 Aug 2025 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219440; cv=none; b=asi0UMmfvW2CpJzkerzG58bBOfmu+IlI0fHHscj9mvF6WNSeDU58d2JuZh5yin4+3yI4kt2p7roAgPQo5d5UEqLk3pNXtwqNxdygtN+Ba4UNiW1l+GAXCJLRktbr9Q4SU1iRBdA8e4JPda2bndi2Om5TBQdNcN2Xr1P1wA7fu8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219440; c=relaxed/simple;
	bh=u1y3eF1ajJBP0OvIEKI3PhK7i414ZWr5HV5m14aDp34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMsThx1drlh5xX/n8bDOrmn5J9RiwFgOSQczyKPe9AIHKkQEIIqi9jC3fAoTixP7VRx+rXlhqeSnCCCHV9QSb8MO3h7U4g+YyIppeYEV2IXjx34SxSJGIAfKweScmoSLbXzUYjT0paDvvYYHOLjXd3Ce9LqdW1El27VdRGRDx+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1vDIjul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1vDIjul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD30FC4CEF1;
	Tue, 26 Aug 2025 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219440;
	bh=u1y3eF1ajJBP0OvIEKI3PhK7i414ZWr5HV5m14aDp34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1vDIjuloLaY1C3y5ciaTg//vxQpAGcCzNfcn3qXyQyz1rpRIRwwXf3QEM3natWXO
	 cyPXnELRJdwGAS28kITnuUamuH1eGfuAgdOIvIGZaxDfWwwIFPToUB+YiK5ThwwACu
	 +DmMbxHCZtLWrPt0vT+m+89mkrNXV2ukmozAT/90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: [PATCH 5.4 381/403] mm: perform the mapping_map_writable() check after call_mmap()
Date: Tue, 26 Aug 2025 13:11:47 +0200
Message-ID: <20250826110917.544018390@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 158978945f3173b8c1a88f8c5684a629736a57ac ]

In order for a F_SEAL_WRITE sealed memfd mapping to have an opportunity to
clear VM_MAYWRITE, we must be able to invoke the appropriate
vm_ops->mmap() handler to do so.  We would otherwise fail the
mapping_map_writable() check before we had the opportunity to avoid it.

This patch moves this check after the call_mmap() invocation.  Only memfd
actively denies write access causing a potential failure here (in
memfd_add_seals()), so there should be no impact on non-memfd cases.

This patch makes the userland-visible change that MAP_SHARED, PROT_READ
mappings of an F_SEAL_WRITE sealed memfd mapping will now succeed.

There is a delicate situation with cleanup paths assuming that a writable
mapping must have occurred in circumstances where it may now not have.  In
order to ensure we do not accidentally mark a writable file unwritable by
mistake, we explicitly track whether we have a writable mapping and unmap
only if we do.

[lstoakes@gmail.com: do not set writable_file_mapping in inappropriate case]
  Link: https://lkml.kernel.org/r/c9eb4cc6-7db4-4c2b-838d-43a0b319a4f0@lucifer.local
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217238
Link: https://lkml.kernel.org/r/55e413d20678a1bb4c7cce889062bbb07b0df892.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
[isaacmanjarres: added error handling to cleanup the work done by the
mmap() callback and removed unused label.]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1718,6 +1718,7 @@ unsigned long mmap_region(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
+	bool writable_file_mapping = false;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
@@ -1785,11 +1786,6 @@ unsigned long mmap_region(struct file *f
 			if (error)
 				goto free_vma;
 		}
-		if (is_shared_maywrite(vm_flags)) {
-			error = mapping_map_writable(file->f_mapping);
-			if (error)
-				goto allow_write_and_free_vma;
-		}
 
 		/* ->mmap() can change vma->vm_file, but must guarantee that
 		 * vma_link() below can deny write-access if VM_DENYWRITE is set
@@ -1801,6 +1797,14 @@ unsigned long mmap_region(struct file *f
 		if (error)
 			goto unmap_and_free_vma;
 
+		if (vma_is_shared_maywrite(vma)) {
+			error = mapping_map_writable(file->f_mapping);
+			if (error)
+				goto close_and_free_vma;
+
+			writable_file_mapping = true;
+		}
+
 		/* Can addr have changed??
 		 *
 		 * Answer: Yes, several device drivers can do it in their
@@ -1823,7 +1827,7 @@ unsigned long mmap_region(struct file *f
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
-		if (is_shared_maywrite(vm_flags))
+		if (writable_file_mapping)
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
@@ -1858,15 +1862,17 @@ out:
 
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	vma->vm_file = NULL;
 	fput(file);
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	if (is_shared_maywrite(vm_flags))
+	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
-allow_write_and_free_vma:
 	if (vm_flags & VM_DENYWRITE)
 		allow_write_access(file);
 free_vma:


