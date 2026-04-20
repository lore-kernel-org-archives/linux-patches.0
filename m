Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DC933C19E;
	Mon, 20 Apr 2026 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700675; cv=none; b=mTnQJJWeEOMJuEUuJadE+sBY+kA+ANZg//I4/dXp5sR/ka4fkDgQUI/GZ5PKZnsMnIqYZZIddCxrZweIbQPRWoSoI9NoFehQoo5ZZvFOE5g1AJta0pKNrlPZkJ3eUZALcyidOp6pQ6aQmhYBWWSex7J6ufn+Rdn7hQZMN/zILz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700675; c=relaxed/simple;
	bh=b228TxizukoDc/+1BN0H4KGYA/xUy+TwKchIISLNjww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqTXYjj6oAN8oUV9GdPvCYtc75Iyy6l3LA23zhxXklezaogQcaBitMzYzwQfghsVr0tzqVptC793XBLNZFRv6Rubhc/PbkucoeqPdx+XlODVuv3mzZdvo7yhtfmM+kI30Yvqc+H7olUTAKDn1rdxXWh6BG8rOEepCjbjxX9JSYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCiHvB5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCiHvB5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F4DC19425;
	Mon, 20 Apr 2026 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700675;
	bh=b228TxizukoDc/+1BN0H4KGYA/xUy+TwKchIISLNjww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCiHvB5L+r8iZg/hAVBFWPVQo7MH5UVh9jrg5HpOjuCNOardIQFrrtvR0q2Xj5qgq
	 uTKOnfSl6Ogrn+plc6hwcGtnPzMiYBteKqOxoEmfTpgChpmi0ar0K39azaAb4+tOz9
	 /Ov+sRr8xLIXhc1d6WEnlV5Qh/Bv3Kiv/gW/8omU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EA=B9=80=EC=98=81=EB=AF=BC?= <osori@hspace.io>,
	Oleg Nesterov <oleg@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/198] x86: shadow stacks: proper error handling for mmap lock
Date: Mon, 20 Apr 2026 17:40:23 +0200
Message-ID: <20260420153937.204016469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



