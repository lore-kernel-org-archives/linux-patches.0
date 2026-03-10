Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B70E387368;
	Tue, 10 Mar 2026 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141920; cv=none; b=K4dfzBeD2qfmSKb2kGeTJr22XnM0oMeJQ+Bej0aPgS0Gya+oayYsR8K5kWy1bELuOeTIH6F5bntbUSP1XDL+jZ+/YHF0eT+gLRKIQAc54mC7u8+z1XkOi+hxdGzfBxBtDdTZGogFSiQOIoAAolZCY/l7jwlgluOdet/edkyXzOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141920; c=relaxed/simple;
	bh=EOT4YfhniW5i6lt6OGUrYUNuJ7+PtjrNe/NkflHT940=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VG5Iazoma/UfErsnoZF5wSfZq8HqmPfKhqLSNTC+VVKqCAnteZiN/IdAMar4Re643BpYweqmPKjWLR0qKMf2K74fSSC7z4nZGYsiBFPsuVyypGuYXD3itQodDbaMl9SXNKhMOQ/QISV7X3oxvrMi9nsCBXqs2PajT7+WmZBE/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmaELXun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmaELXun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C116C2BCAF;
	Tue, 10 Mar 2026 11:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141920;
	bh=EOT4YfhniW5i6lt6OGUrYUNuJ7+PtjrNe/NkflHT940=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmaELXunoiei7kJff4wNQwA2qPXRE/C2JfRKo2R1mdULfmlNDRZnOvXA2FsUOW3Tq
	 OXul9X1xRiCGl5IWdHbf7SIilqVoZyok3qTYiPeHkM7sVvScbrLQjoAfN3BVx8Pdg9
	 jHeeOYW7uJUwjP7d9SiwwlR6zkunn1zqO5jDEnzcRMzI6mXHmZbaNIsKOOiIxrMamv
	 qDwcKW70XWtnbfOZ0cZj6vNuYATCXbb/UzeTuMUHi5Y/VGV4c/4tquCVM1Z8t45vDD
	 NfWYSv1pMkhlFiJve+oyOTKGfnjKQgnFakVFRMxV7haEmC6fHWeVaD101+g95BS4wA
	 NCtjagjqkQLLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/314] s390/vtime: Fix virtual timer forwarding
Date: Tue, 10 Mar 2026 07:15:03 -0400
Message-ID: <0ba66cf34d3689c33836b07dbe80c567f7eedaee.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit dbc0fb35679ed5d0adecf7d02137ac2c77244b3b ]

Since delayed accounting of system time [1] the virtual timer is
forwarded by do_account_vtime() but also vtime_account_kernel(),
vtime_account_softirq(), and vtime_account_hardirq(). This leads
to double accounting of system, guest, softirq, and hardirq time.

Remove accounting from the vtime_account*() family to restore old behavior.

There is only one user of the vtimer interface, which might explain
why nobody noticed this so far.

Fixes: b7394a5f4ce9 ("sched/cputime, s390: Implement delayed accounting of system time") [1]
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vtime.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 234a0ba305108..122d30b104401 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -225,10 +225,6 @@ static u64 vtime_delta(void)
 	return timer - lc->last_update_timer;
 }
 
-/*
- * Update process times based on virtual cpu times stored by entry.S
- * to the lowcore fields user_timer, system_timer & steal_clock.
- */
 void vtime_account_kernel(struct task_struct *tsk)
 {
 	struct lowcore *lc = get_lowcore();
@@ -238,27 +234,17 @@ void vtime_account_kernel(struct task_struct *tsk)
 		lc->guest_timer += delta;
 	else
 		lc->system_timer += delta;
-
-	virt_timer_forward(delta);
 }
 EXPORT_SYMBOL_GPL(vtime_account_kernel);
 
 void vtime_account_softirq(struct task_struct *tsk)
 {
-	u64 delta = vtime_delta();
-
-	get_lowcore()->softirq_timer += delta;
-
-	virt_timer_forward(delta);
+	get_lowcore()->softirq_timer += vtime_delta();
 }
 
 void vtime_account_hardirq(struct task_struct *tsk)
 {
-	u64 delta = vtime_delta();
-
-	get_lowcore()->hardirq_timer += delta;
-
-	virt_timer_forward(delta);
+	get_lowcore()->hardirq_timer += vtime_delta();
 }
 
 /*
-- 
2.51.0

