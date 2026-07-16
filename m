Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6673D7D74;
	Thu, 16 Jul 2026 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210036; cv=none; b=fZvCJZLfZvOirZy576fuBrHy32CqgTL0lii8iKFOOHfVW39hQEBXcWjN0jC7R5w8QVmoBfKZ2zPfd3VoKkflFM/VWup5Mj/ct9YLhQBV/e6Cdte2HbvWXO0Qly91llPvllo0fgadrZmaH0u7m3nkpIwXg3DdUV4/4/gvrJBeuXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210036; c=relaxed/simple;
	bh=y9cB3lV8dah0t8da0NpB0CnsrTgdxp6q1slRKDpkOZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOQqV0dDOG1YdZiX8XT4mr4rYmRO6yF1TKXyerMD8/pSJraU1uDYLKRc0mb0nIXlSni3cOWpJ8jLK5pRdPuoeb6ebGFzKUmTKzceMsmmTtaeHeZWBEvoeSxN+z0/nrcbH0MjBjWM9L4gdGt6VSKflgcFEIea2lQ00NUTCGhqcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOPZoo53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOPZoo53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6BE1F000E9;
	Thu, 16 Jul 2026 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210035;
	bh=o/HOg2KqUh7+BkA7rxNIrK5UFcNLGx2VYF3pp1TGJtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOPZoo53yedbmdfS7U4dawxYteNHqsaCbcPEq+SekvGv1Hzy+ksm7WWxaJYeqfRHX
	 LtNMhr+SUEo8w0xrni2K+oGlKHtKn8/fz5vrSCjFQte58luHhCtTrc40QQsgIjtNhp
	 nDRRFKwHM39S4Qf1evwvATCKdltXZwsbgK+y/3UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7.1 414/518] rqspinlock: Fix order in raw_res_spin_(un)lock_irq to allow schedule
Date: Thu, 16 Jul 2026 15:31:22 +0200
Message-ID: <20260716133056.895637621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

commit b48bd16eb9fc57a463a337ca148516cdf3212d61 upstream.

raw_res_spin_unlock_irqrestore() calls raw_res_spin_unlock() and then
restores interrupts, this means preemption is enabled when interrupts
are still disabled (as part of raw_res_spin_unlock()) so this cannot
trigger an actual preemption.
This is inconsistent with other spinlock implementations
(raw_spin_unlock_irqrestore() and bpf_res_spin_unlock_irqrestore()
itself).

Adjust the macro to ensure interrupts are enabled before enabling
preemption, allowing to schedule at that point. Make the same
modification in the error path of raw_res_spin_lock_irqsave().

Fixes: 101acd2e78b1 ("rqspinlock: Add macros for rqspinlock usage")
Cc: stable@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de> # asm-generic
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/r/20260610090431.32427-1-gmonaco@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/rqspinlock.h |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/include/asm-generic/rqspinlock.h
+++ b/include/asm-generic/rqspinlock.h
@@ -243,12 +243,20 @@ static __always_inline void res_spin_unl
 	({                                        \
 		int __ret;                        \
 		local_irq_save(flags);            \
-		__ret = raw_res_spin_lock(lock);  \
-		if (__ret)                        \
+		preempt_disable();                \
+		__ret = res_spin_lock(lock);      \
+		if (__ret) {                      \
 			local_irq_restore(flags); \
+			preempt_enable();         \
+		}                                 \
 		__ret;                            \
 	})
 
-#define raw_res_spin_unlock_irqrestore(lock, flags) ({ raw_res_spin_unlock(lock); local_irq_restore(flags); })
+#define raw_res_spin_unlock_irqrestore(lock, flags) \
+	({                                          \
+		res_spin_unlock(lock);              \
+		local_irq_restore(flags);           \
+		preempt_enable();                   \
+	})
 
 #endif /* __ASM_GENERIC_RQSPINLOCK_H */


