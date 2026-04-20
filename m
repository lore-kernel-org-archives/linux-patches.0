Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA65A3C553A;
	Mon, 20 Apr 2026 13:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691054; cv=none; b=OC/sWbG2EIgLgu1MpkCNpXXjqDWHuMU1mYBdrPozZQRzJKidn/1BsWnVlsMHjPMA8fj7bXnzPPC8uYRlDIG5xv80/uiD154r7PIYjQeR+jjWhlza9sN+OoBe6pr5Ff0R62ZQKZXjBrbxhWX9rs0VoxDlDAwhWYAL52eGkkWIgEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691054; c=relaxed/simple;
	bh=2SxazbbS9oAi21Q7GCbtTy4MJm0ReOyr2NXSzDd7QZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tb5fKQfLe5BIWR2blr/bnKtIiWEvSIvMr9KsXCPjseZ2XruTydIztUAFYW4qLx92PSjGdOKfWTdZaFOenjViD2Z6Ffj0YZr3SelOlYXqXQgIqNIV7VQ7NPlj2paR7TJo2zamyvJOB4AHgUK6kC2el/bEfQipfazwZOH5Av3Omv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xwydb+Mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xwydb+Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BD5C2BCB6;
	Mon, 20 Apr 2026 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691054;
	bh=2SxazbbS9oAi21Q7GCbtTy4MJm0ReOyr2NXSzDd7QZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xwydb+MjE38Yz9wYsZXCGWZYWrHWsEcBXCdCsRZtkpXb41BtpGs6AlBxVvjQ3smkI
	 xw/QvsEQTRuPfzI7DWy/zEmrmCEg1VqEjcuz4KzbAIQH/VhHdNE7sqIeqo4Ir9DYYJ
	 bn+j345Wqv90UavNBj0FWgAE4Dq2oECYsudZJYrqQ5QLyrWL5gJB2zDrQGmCgopI8g
	 kCxReA9D8SGG4ijUdlo6jhYihcoTGJ5cL8ZyVeElzlZcLVBStVXT/C1+zgLWZM9Mi8
	 wXQ2fRkJqCggDws+bDDgfGcj+9rUDrTBui+tLfsxaNOlWYGfMBjLLi/8fVYIQ8oWbT
	 vbQIBf8tXZCQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	=?UTF-8?q?=EA=B9=80=EC=98=81=EB=AF=BC?= <osori@hspace.io>,
	Oleg Nesterov <oleg@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	surenb@google.com,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH AUTOSEL 6.18] x86: shadow stacks: proper error handling for mmap lock
Date: Mon, 20 Apr 2026 09:08:53 -0400
Message-ID: <20260420131539.986432-67-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 52f657e34d7b21b47434d9d8b26fa7f6778b63a0 ]

김영민 reports that shstk_pop_sigframe() doesn't check for errors from
mmap_read_lock_killable(), which is a silly oversight, and also shows
that we haven't marked those functions with "__must_check", which would
have immediately caught it.

So let's fix both issues.

Reported-by: 김영민 <osori@hspace.io>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/x86/kernel/shstk.c   | 3 ++-
 include/linux/mmap_lock.h | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 978232b6d48d7..ff8edea8511b4 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -351,7 +351,8 @@ static int shstk_pop_sigframe(unsigned long *ssp)
 	need_to_check_vma = PAGE_ALIGN(*ssp) == *ssp;
 
 	if (need_to_check_vma)
-		mmap_read_lock_killable(current->mm);
+		if (mmap_read_lock_killable(current->mm))
+			return -EINTR;
 
 	err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
 	if (unlikely(err))
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2c9fffa58714f..95ee1f224c492 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -322,7 +322,7 @@ static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
-static inline int mmap_write_lock_killable(struct mm_struct *mm)
+static inline int __must_check mmap_write_lock_killable(struct mm_struct *mm)
 {
 	int ret;
 
@@ -369,7 +369,7 @@ static inline void mmap_read_lock(struct mm_struct *mm)
 	__mmap_lock_trace_acquire_returned(mm, false, true);
 }
 
-static inline int mmap_read_lock_killable(struct mm_struct *mm)
+static inline int __must_check mmap_read_lock_killable(struct mm_struct *mm)
 {
 	int ret;
 
@@ -379,7 +379,7 @@ static inline int mmap_read_lock_killable(struct mm_struct *mm)
 	return ret;
 }
 
-static inline bool mmap_read_trylock(struct mm_struct *mm)
+static inline bool __must_check mmap_read_trylock(struct mm_struct *mm)
 {
 	bool ret;
 
-- 
2.53.0

