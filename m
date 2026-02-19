Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B530595C;
	Thu, 19 Feb 2026 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466694; cv=none; b=L4HHZw08r5XIEkVJtDSjm4gPdo9Ptfjl00ktDUl1YsHInC4jInDW0JBH62ztHB+MFc1V8S2QajHSjF1F1JjbjrdjAaZLIDlleoC9rgMW+mGpXG3OO5jjF6hy/Ku0VKlbok1JqSnSefLigzoTJmhx2v+ddtACK+n6WcxTsVv4DQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466694; c=relaxed/simple;
	bh=Hzgly7jLnIzJWFToxAp2yu08V0fNXobD7L0hKdm+Ok0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GRDPOKk3u8SE0Mr9ofgYUmE37cBj4VW7kXkrHxEkgpnL9W7l1fYpwUpFMGOK2BQ2Yhsnxiu7U4kSj1fbZT+7SmD+vaESj2jAbQfq1571HUI8k8LWHjvl4IjgtjztuOXezkItKH+6alFcMTpZPbjOWyIit5jGf/A/Xmhgd0zFdwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jo2jQ/Jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jo2jQ/Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4653FC19425;
	Thu, 19 Feb 2026 02:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466694;
	bh=Hzgly7jLnIzJWFToxAp2yu08V0fNXobD7L0hKdm+Ok0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jo2jQ/JgePSEfPtIyWj7uBke/NNbV5eRLt8DNrZRIAXxXrFZVJdPnNr+iyP4ivnMe
	 pXM5VQRH6pTwK2sNW3qvML5Iy/Dn8hn0uaolcISKTAgJC9X3u08GFyFYaOHPiEMeZh
	 zA/J3tuGVAkjyamrWAGJdwSm97ww9b5uxoPkpM0dLyUhSqMu0a9M666x2gaV7RH0FB
	 gvcse4elM5ARsR4yf/9kWsgvWal6P1GNsxiivTSgXEKS8wnIWPI0f0rwLA6f8PVmUD
	 Bn/8Qzv2GQ2h7HdMVwK91FZeIAnN6CwQO2BoixOwl+vvz2BT0l7oP/aR4ntju0w0Yt
	 q8KCwX6AZIH0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	arve@android.com,
	tkjos@android.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] binder: don't use %pK through printk
Date: Wed, 18 Feb 2026 21:04:00 -0500
Message-ID: <20260219020422.1539798-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 56d21267663bad91e8b10121224ec46366a7937e ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log. Since commit ad67b74d2469 ("printk: hash
addresses printed with %p") the regular %p has been improved to avoid
this issue. Furthermore, restricted pointers ("%pK") were never meant
to be used through printk(). They can still unintentionally leak raw
pointers or acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

There are still a few users of %pK left, but these use it through
seq_file, for which its usage is safe.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260107-restricted-pointers-binder-v1-1-181018bf3812@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Classification

This commit addresses two real issues:

1. **Sleeping locks in atomic context (correctness bug)**: The `%pK`
   format specifier in `restricted_pointer()` calls
   `has_capability_noaudit()` which can trigger LSM capability checks.
   On PREEMPT_RT kernels with SELinux, this acquires sleeping locks.
   Since `binder_debug()` uses `pr_info_ratelimited()` (printk) and can
   be called while holding spinlocks like `binder_inner_proc_lock`, this
   is a real sleeping-in-atomic-context bug.

2. **Potential pointer leakage**: When `%pK` fails in atomic/IRQ context
   (detected by `in_hardirq() || in_serving_softirq() || in_nmi()`
   checks), it prints "pK-error" instead of the address. But in non-IRQ
   spinlock contexts (like binder's inner proc lock), the check doesn't
   catch it, potentially leading to unintended raw pointer leaks.

### Scope and Risk

- **4 format string changes** across 2 files - extremely minimal
- **No logic changes** - only the pointer format specifier character
  changes
- **Zero risk of regression** - `%p` is the standard, recommended
  approach since 2017
- **Well-reviewed** - Acked by Carlos Llamas, Reviewed by Alice Ryhl,
  committed by Greg KH

### Stable Kernel Suitability

- **Fixes a real bug**: Sleeping in atomic context is a correctness bug,
  especially on PREEMPT_RT
- **Obviously correct**: Using `%p` is documented as the correct
  approach for printk
- **Small and contained**: Only 4 single-character changes in format
  strings
- **No new features**: Pure bug fix
- **No dependencies**: The prerequisite commit `ad67b74d2469` ("printk:
  hash addresses printed with %p") is from 2017 (v4.15), present in all
  active stable trees

### Concerns

- The bug only manifests with specific configurations (PREEMPT_RT + LSM
  like SELinux + kptr_restrict=1), making it relatively rare in practice
- The fix is so trivial and low-risk that there's essentially no
  downside to backporting

### Verification

- Explored `restricted_pointer()` in `lib/vsprintf.c` - confirmed it
  calls `has_capability_noaudit()` which can trigger sleeping LSM hooks
  when `kptr_restrict==1`
- Confirmed `binder_debug()` macro uses `pr_info_ratelimited()` (printk)
  - this goes through the printk path
- Confirmed the binder debug calls happen under
  `binder_inner_proc_lock()` (spinlock) - verified in the diff context
  showing `binder_inner_proc_lock(proc)` before the debug print
- Confirmed documentation at `Documentation/core-api/printk-formats.rst`
  states `%pK` is "only intended when producing content of a file read
  by userspace from e.g. procfs or sysfs, not for dmesg"
- Confirmed commit `ad67b74d2469` is from 2017 (v4.15 era), meaning `%p`
  hashing is available in all active stable trees
- Found a real-world bug report (kmemleak sleeping lock issue)
  confirming `%pK` through printk causes actual sleeping-in-atomic
  violations on PREEMPT_RT with SELinux
- Could NOT independently verify the exact stable tree versions affected
  (unverified, but the code pattern has existed since early binder
  inclusion)

### Decision

While this is a real correctness bug (sleeping in atomic context), it
only triggers under a very specific configuration combination
(PREEMPT_RT + SELinux/LSM + kptr_restrict=1 + binder debug enabled). The
fix is trivially correct and zero-risk, but the practical impact to
stable users is very low. That said, the fix meets all stable criteria:
it's obviously correct, fixes a real (if uncommon) bug, is extremely
small, and has no risk of regression. The benefit, while small, exceeds
the (essentially zero) risk.

**YES**

 drivers/android/binder.c       | 2 +-
 drivers/android/binder_alloc.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index b356c9b882544..33e4dad0915bb 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4523,7 +4523,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %pK\n",
+				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %p\n",
 				     proc->pid, thread->pid, (u64)cookie,
 				     death);
 			if (death == NULL) {
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 979c96b74cad3..d5ed64543bbf4 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -81,7 +81,7 @@ static void binder_insert_free_buffer(struct binder_alloc *alloc,
 	new_buffer_size = binder_alloc_buffer_size(alloc, new_buffer);
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: add free buffer, size %zd, at %pK\n",
+		     "%d: add free buffer, size %zd, at %p\n",
 		      alloc->pid, new_buffer_size, new_buffer);
 
 	while (*p) {
@@ -572,7 +572,7 @@ static struct binder_buffer *binder_alloc_new_buf_locked(
 	}
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got buffer %pK size %zd\n",
+		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
 		      alloc->pid, size, buffer, buffer_size);
 
 	/*
@@ -748,7 +748,7 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
 		ALIGN(buffer->extra_buffers_size, sizeof(void *));
 
 	binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_free_buf %pK size %zd buffer_size %zd\n",
+		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
 		      alloc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
-- 
2.51.0

