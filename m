Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0D03F23A4;
	Wed, 20 May 2026 17:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299667; cv=none; b=Pu7dRP8eQC7d6f7AzrTUxSDE/MpBmSYidfDjo6NONW/KJCKHpfhUVWSZ/l8GYHFwiBIhi+De81zCMHA2nse14YqbDBsvgINn6IIj/UQl+LkiNoMz22lebNvqcYxMijhtgxGK9Ll/O0A2Y8req/tKvMhQO97537U5yX4G+k4EWyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299667; c=relaxed/simple;
	bh=2DeGGLwyS8KzRrgvm5BEmq7ato29uYA1z0dh/krImww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGz/7sYiWBnr5T2YXe0nDBB7EXO6njs2Yf9FLm1JwhIRUWrvbPUPZoFZpsnQFJf2Ttf3yZuTrXOf8qyIA5lZfeqv3v38PEhok4u4zUfZzqKnQBS+h21+XnXpD9WzYDAPfRiC0HLUigjdIYzTBEcrHC4TIP09j8s41rebi+ba7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAaUjLVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAaUjLVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F411F000E9;
	Wed, 20 May 2026 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299666;
	bh=WUuN+Y3yFSRdyNp/AtDJBn+byovCjyV6objlV4XGUj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAaUjLVkrco8kh8UxdeneZu30nN3av3uDfK1k6MUEnoEq4Rap6dbf5QXsez0aYnTk
	 MZapo7aYT6s9wrYvwheT9XOfVa94id+wRzvE46aBn92zIUumGcGp8rRMxPkPQpgyYH
	 f0Fo18otAvHMbWXlxSiow9Mr7IeWEQjOcAeiIopU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 859/957] futex: Drop CLONE_THREAD requirement for private default hash alloc
Date: Wed, 20 May 2026 18:22:22 +0200
Message-ID: <20260520162153.193871024@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit ee9dce44362b2d8132c32964656ab6dff7dfbc6a ]

Currently need_futex_hash_allocate_default() depends on strict pthread
semantics, abusing CLONE_THREAD.  This breaks the non-concurrency
assumptions when doing the mm->futex_ref pcpu allocations, leading to
bugs[0] when sharing the mm in other ways; ie:

    BUG: KASAN: slab-use-after-free in futex_hash_put

... where the +1 bias can end up on a percpu counter that mm->futex_ref
no longer points at.

Loosen the check to cover any CLONE_VM clone, except vfork().  Excluding
vfork keeps the existing paths untouched (no overhead), and we can't
race in the first place: either the parent is suspended and the child
runs alone, or mm->futex_ref is already allocated from an earlier
CLONE_VM.

Link: https://lore.kernel.org/all/CAL_bE8LsmCQ-FAtYDuwbJhOkt9p2wwYQwAbMh=PifC=VsiBM6A@mail.gmail.com/ [0]
Fixes: d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3ad76c2cf5af5..1215d3f52c6d2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1911,9 +1911,11 @@ static void rv_task_fork(struct task_struct *p)
 
 static bool need_futex_hash_allocate_default(u64 clone_flags)
 {
-	if ((clone_flags & (CLONE_THREAD | CLONE_VM)) != (CLONE_THREAD | CLONE_VM))
-		return false;
-	return true;
+	/*
+	 * Allocate a default futex hash for any sibling that will
+	 * share the parent's mm, except vfork.
+	 */
+	return (clone_flags & (CLONE_VM | CLONE_VFORK)) == CLONE_VM;
 }
 
 /*
@@ -2296,10 +2298,6 @@ __latent_entropy struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_cancel_cgroup;
 
-	/*
-	 * Allocate a default futex hash for the user process once the first
-	 * thread spawns.
-	 */
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-- 
2.53.0



