Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9601C4EE2;
	Tue, 27 Aug 2024 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769725; cv=none; b=cUni9gZXZE6ETr2nr/S/Yt6hZwpNRQzIURGw7kXUTB+GMy4YlhT6eGgbYLwh/En3pV40sOLpc0dEKjS121oDEHjoqj/oODTg8cUC6E6iEhxLokZYiU4xrgTWh31clqYlNWq4W02IQlV/EJXVBZxn2rq7k9x9bX+NduEHRV4jFkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769725; c=relaxed/simple;
	bh=7UsyHrCxwEWLgp95q/1iIjZYsP0IpZ4SPgOYfY3GJJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8LvOMLLfFfRv0+/QUHEhS25rxV2smcmPqRUlXWtlf0skc08w/4L0nSC7KYBkxLPYJ2R7/acBpRIyHjATGLz/f2K2j8WzuqCqU0LI3WyNjOFK5b+vkhtpdQBJ5kmL2iCpHS5tr0VFbTCEKkIhDH1oShKSiEPKI+8uGCkGyy09lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8Szf7Ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8Szf7Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F02FC4AF15;
	Tue, 27 Aug 2024 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769725;
	bh=7UsyHrCxwEWLgp95q/1iIjZYsP0IpZ4SPgOYfY3GJJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8Szf7Kyw7oiw9oywfC4ph3WvmP4hSO38tQ7gaprVqvUBO32iSTiClU+uPD/Alyre
	 0xqZxgL5qyUoLb8Cju6hMtr0VKsDhqJfbOQ5Fu1E5mzUA+MMytezw+ktO++ILrgzm6
	 S1AfuZe3QW+AveBR6WCaKFzrTjYbKWDJxkWxDQwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Reisner <reisner.marc@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 006/341] selinux: revert our use of vma_is_initial_heap()
Date: Tue, 27 Aug 2024 16:33:57 +0200
Message-ID: <20240827143843.647654407@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <paul@paul-moore.com>

commit 05a3d6e9307250a5911d75308e4363466794ab21 upstream.

Unfortunately it appears that vma_is_initial_heap() is currently broken
for applications that do not currently have any heap allocated, e.g.
brk == start_brk.  The breakage is such that it will cause SELinux to
check for the process/execheap permission on memory regions that cross
brk/start_brk even when there is no heap.

The proper fix would be to correct vma_is_initial_heap(), but as there
are multiple callers I am hesitant to unilaterally modify the helper
out of concern that I would end up breaking some other subsystem.  The
mm developers have been made aware of the situation and hopefully they
will have a fix at some point in the future, but we need a fix soon so
we are simply going to revert our use of vma_is_initial_heap() in favor
of our old logic/code which works as expected, even in the face of a
zero size heap.  We can return to using vma_is_initial_heap() at some
point in the future when it is fixed.

Cc: stable@vger.kernel.org
Reported-by: Marc Reisner <reisner.marc@gmail.com>
Closes: https://lore.kernel.org/all/ZrPmoLKJEf1wiFmM@marcreisner.com
Fixes: 68df1baf158f ("selinux: use vma_is_initial_stack() and vma_is_initial_heap()")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3835,7 +3835,17 @@ static int selinux_file_mprotect(struct
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
 		int rc = 0;
-		if (vma_is_initial_heap(vma)) {
+		/*
+		 * We don't use the vma_is_initial_heap() helper as it has
+		 * a history of problems and is currently broken on systems
+		 * where there is no heap, e.g. brk == start_brk.  Before
+		 * replacing the conditional below with vma_is_initial_heap(),
+		 * or something similar, please ensure that the logic is the
+		 * same as what we have below or you have tested every possible
+		 * corner case you can think to test.
+		 */
+		if (vma->vm_start >= vma->vm_mm->start_brk &&
+		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECHEAP, NULL);
 		} else if (!vma->vm_file && (vma_is_initial_stack(vma) ||


