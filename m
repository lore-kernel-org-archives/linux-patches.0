Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66363198E96;
	Wed,  6 Nov 2024 12:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896358; cv=none; b=LGyNQ6gN5LzLx5FQFo0hBGLGyNK5JlpVQOE6uAoGGmSj58awk9nwPayKSxzjWQYg33Gs/EjO0/R1jUpHCFlr3d6bhN7I6Q9i5eBCFC9+SLHoN9mru6sBf8K4Om3Vf2ScyctcrmsBRcBbgrUsv/Y31dJ5BZQ/7/WhzkBpbiZ1pSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896358; c=relaxed/simple;
	bh=gX4YlGd737+hsVe1Jl4yEnxNvoMgNunSEn7BCESLkKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjgMZTVb+KkEZ+HVKIA7ehj4Kg2vd6j+jdl/p3oa3320PdTqWPEdQlahLS5tp/vAFxk9ly4QeXcL3RnmATyOOiHebN9/23pomziYp3ixqeK7nJHh9U0/aksP+eM3awq7Tj36/Pu0EuJezqOnlsgGZvEN+YQicJJBpbWVp2CxVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8fNVCqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8fNVCqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B858DC4CECD;
	Wed,  6 Nov 2024 12:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896358;
	bh=gX4YlGd737+hsVe1Jl4yEnxNvoMgNunSEn7BCESLkKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8fNVCqv51xcJ4MSxSzvahDemWLunH6fTJ5BY+ufDmL1vPSdWwFZcEfqAxxv0SBsM
	 rNqqeV5RmIE/twzC0nm2oFGh2+GHkZ5Tvs8y5lGbMxP0ogssQKuVfQMFRyataNIEk6
	 Eby13WfSDE5TnZShNzmE8R+cugqZyhC9yNzHeDJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 175/245] fork: only invoke khugepaged, ksm hooks if no error
Date: Wed,  6 Nov 2024 13:03:48 +0100
Message-ID: <20241106120323.545855141@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 985da552a98e27096444508ce5d853244019111f ]

There is no reason to invoke these hooks early against an mm that is in an
incomplete state.

The change in commit d24062914837 ("fork: use __mt_dup() to duplicate
maple tree in dup_mmap()") makes this more pertinent as we may be in a
state where entries in the maple tree are not yet consistent.

Their placement early in dup_mmap() only appears to have been meaningful
for early error checking, and since functionally it'd require a very small
allocation to fail (in practice 'too small to fail') that'd only occur in
the most dire circumstances, meaning the fork would fail or be OOM'd in
any case.

Since both khugepaged and KSM tracking are there to provide optimisations
to memory performance rather than critical functionality, it doesn't
really matter all that much if, under such dire memory pressure, we fail
to register an mm with these.

As a result, we follow the example of commit d2081b2bf819 ("mm:
khugepaged: make khugepaged_enter() void function") and make ksm_fork() a
void function also.

We only expose the mm to these functions once we are done with them and
only if no error occurred in the fork operation.

Link: https://lkml.kernel.org/r/e0cb8b840c9d1d5a6e84d4f8eff5f3f2022aa10c.1729014377.git.lorenzo.stoakes@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ksm.h | 10 ++++------
 kernel/fork.c       |  7 ++-----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 11690dacd9868..ec9c05044d4fe 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -54,12 +54,11 @@ static inline long mm_ksm_zero_pages(struct mm_struct *mm)
 	return atomic_long_read(&mm->ksm_zero_pages);
 }
 
-static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
+	/* Adding mm to ksm is best effort on fork. */
 	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags))
-		return __ksm_enter(mm);
-
-	return 0;
+		__ksm_enter(mm);
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
@@ -107,9 +106,8 @@ static inline int ksm_disable(struct mm_struct *mm)
 	return 0;
 }
 
-static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	return 0;
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
diff --git a/kernel/fork.c b/kernel/fork.c
index 6423ce60b8f97..dc08a23747338 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -653,11 +653,6 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	mm->exec_vm = oldmm->exec_vm;
 	mm->stack_vm = oldmm->stack_vm;
 
-	retval = ksm_fork(mm, oldmm);
-	if (retval)
-		goto out;
-	khugepaged_fork(mm, oldmm);
-
 	/* Use __mt_dup() to efficiently build an identical maple tree. */
 	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
 	if (unlikely(retval))
@@ -760,6 +755,8 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	vma_iter_free(&vmi);
 	if (!retval) {
 		mt_set_in_rcu(vmi.mas.tree);
+		ksm_fork(mm, oldmm);
+		khugepaged_fork(mm, oldmm);
 	} else if (mpnt) {
 		/*
 		 * The entire maple tree has already been duplicated. If the
-- 
2.43.0



