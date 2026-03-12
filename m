Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B3402434;
	Thu, 12 Mar 2026 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346351; cv=none; b=NLrQr8FqWOq/eigbFLoQIisxHL28bVuCi68WyysUy7hnIXTnWbHVpSDaCtfJm5LUDtEmbEoFeCKD7Bm7HgKM+AOsIhW/xOvBoYKMspVWi5jRTNyCLSk/NBp+jXZUyNYgyMbvbXXsgEviesG7KHSd60I3LWgx3vpsqnrIZEJ7Bbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346351; c=relaxed/simple;
	bh=mVSo9BeD4Z2WI3AeStJuOSfNIDmhn/xoxEsyi8yqWvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDjqTk3mzX1U5MidlMsQ4M1ZdXol742TXABwQD1ITdI88P2fWjb8Bd4ZvhivjESedpong+HAIx4T/lenFnFFH6YuYE4/mqTyAQi1TOIHmJI93i4aa5CLcFNdcmVxr4X4psvLKDNd9JeBTV2iQVTDtD4DGkXVmqyXTo9kDc18H+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgTJ5nZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgTJ5nZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906A2C4CEF7;
	Thu, 12 Mar 2026 20:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346351;
	bh=mVSo9BeD4Z2WI3AeStJuOSfNIDmhn/xoxEsyi8yqWvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgTJ5nZW4hhbCSjmJ3PVkrlLu2QSk5Q0XAu8EV8YX9v+lYqpNEIKKuXS08umCx3Gi
	 KOmVcrbUnx2f5IMf/n8RN73Abyf0plAgQIob3BSSRzQBPIhVPdNrckpiZLgiCvE6G5
	 M/WvafVi8DqdUOpIsWhfg6h/+AepKi4LUJ1+pde4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/265] s390/vtime: Fix virtual timer forwarding
Date: Thu, 12 Mar 2026 21:06:49 +0100
Message-ID: <20260312201018.983362490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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



