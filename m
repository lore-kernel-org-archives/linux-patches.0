Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E8314198E;
	Thu, 13 Jun 2024 12:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281939; cv=none; b=aLqWado+IuVgsskeTvWzIIGren4vtHBVrd/k839abfSBEXMezhMMZxkOz0sjAOCZ6xiyhXz/gJ7HT0Lc6YviiKfC7Rk6CypgZU58uM/ly4mLdtvogbj+25Z4+H59O/vWH7wLTTteCPmjzswbinfgPZjyMgHIYGM/S0kMfVpzHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281939; c=relaxed/simple;
	bh=Rj/q9In1eimMngfxQFV07eMo0mMybxwtff2qqSXAlGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9QIyDziEK828XkNiw+ygqEpTpxMUXslM3t3N25KJ53JYyQ7GzCiFVgtE4wc48B//PkZfnvgdmJ55ztoqxTQP99KiB5JwvT3Fk5LiMXhLySflm8FrnPkvPLHtuvVQD/n5Ztz8Rf0MTNcEMv+7ZOHruImaUKD6yL8Bku1Zvv7J7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFOPXVkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFOPXVkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA71C2BBFC;
	Thu, 13 Jun 2024 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281938;
	bh=Rj/q9In1eimMngfxQFV07eMo0mMybxwtff2qqSXAlGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFOPXVkW1oG8fqB6fC+qn/g/L69i1Hq1Gr2za8DpSzlevLejJ2yg5OjS9Ou6t0dbW
	 W+h/eYzs24ZkVUDP7gpG+hHGuDE7czoDJNUJNlI/qfCYaTyrmAqgfN9XEDFPRlDXeD
	 N1WHybnM/rwexYjfkpkoFn2IHE7duhtUmm0PBg3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/402] m68k: Fix spinlock race in kernel thread creation
Date: Thu, 13 Jun 2024 13:31:04 +0200
Message-ID: <20240613113306.304795386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Schmitz <schmitzmic@gmail.com>

[ Upstream commit da89ce46f02470ef08f0f580755d14d547da59ed ]

Context switching does take care to retain the correct lock owner across
the switch from 'prev' to 'next' tasks.  This does rely on interrupts
remaining disabled for the entire duration of the switch.

This condition is guaranteed for normal process creation and context
switching between already running processes, because both 'prev' and
'next' already have interrupts disabled in their saved copies of the
status register.

The situation is different for newly created kernel threads.  The status
register is set to PS_S in copy_thread(), which does leave the IPL at 0.
Upon restoring the 'next' thread's status register in switch_to() aka
resume(), interrupts then become enabled prematurely.  resume() then
returns via ret_from_kernel_thread() and schedule_tail() where run queue
lock is released (see finish_task_switch() and finish_lock_switch()).

A timer interrupt calling scheduler_tick() before the lock is released
in finish_task_switch() will find the lock already taken, with the
current task as lock owner.  This causes a spinlock recursion warning as
reported by Guenter Roeck.

As far as I can ascertain, this race has been opened in commit
533e6903bea0 ("m68k: split ret_from_fork(), simplify kernel_thread()")
but I haven't done a detailed study of kernel history so it may well
predate that commit.

Interrupts cannot be disabled in the saved status register copy for
kernel threads (init will complain about interrupts disabled when
finally starting user space).  Disable interrupts temporarily when
switching the tasks' register sets in resume().

Note that a simple oriw 0x700,%sr after restoring sr is not enough here
- this leaves enough of a race for the 'spinlock recursion' warning to
still be observed.

Tested on ARAnyM and qemu (Quadra 800 emulation).

Fixes: 533e6903bea0 ("m68k: split ret_from_fork(), simplify kernel_thread()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/07811b26-677c-4d05-aeb4-996cd880b789@roeck-us.net
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20240411033631.16335-1-schmitzmic@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/entry.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 9f3663facaa0e..198c4c919c678 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -430,7 +430,9 @@ resume:
 	movec	%a0,%dfc
 
 	/* restore status register */
-	movew	%a1@(TASK_THREAD+THREAD_SR),%sr
+	movew	%a1@(TASK_THREAD+THREAD_SR),%d0
+	oriw	#0x0700,%d0
+	movew	%d0,%sr
 
 	rts
 
-- 
2.43.0



