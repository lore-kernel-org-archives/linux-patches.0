Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BD435F619;
	Thu,  2 Jul 2026 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009868; cv=none; b=jfXP2OCLnWJP/DL5CqSSVHIhY/XA5oyBzdUAOG50tf/HTo/oWTEGmBiccee3uhQ4EJWctxBx1r71ynf+vJHjAOcQHK8Ptga1qIgdI0BWQS/BFtggLdM8++r4muY2HvA13ULr43jD1sfSbQWOAf1vK8gaAtgZ8RVh8u+CwaQvqfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009868; c=relaxed/simple;
	bh=11ZzRKYInPcBHmoyK5vCPt13wdGJz3ww3tE0hDkHOzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+NIP7uNJZwXvmMufvk8GM+Tcmi1Wxx/5nQz5DA07U/MzsdkYEpcfcDeXEa48x49K/x3cnSQXtK0Y1/kRg+TfdvDT2ZgVHT3l5ZpLnQU49IkNsU/ERzfl39ErzxCwhh6vSG4lnhsZxJYUZo8bg7i4uE4tKKkCJm7Cx0iIbJvF84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHxIOE+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHxIOE+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541831F000E9;
	Thu,  2 Jul 2026 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009867;
	bh=0OLX1JhUW8HyxLtxs0Si+cT2bSPhceHbGDK08DxkfOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHxIOE+0Sv7O0DVQmvwEDxHm1+HU+mssF+3YC+5cd6FEQvY0qHZYEKxW0tQG/zTdV
	 hBR3JqZDMY2Xbq9//UJO1Xh4+9gTWQkiiH+wWLqyq9MuEef9t4kAAv7UstVvdt+uvJ
	 NkfEYhhnBP7WdHzy7CkFKi/w8Gaehr77fJ1UJiqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/129] debugobjects: Allow to refill the pool before SYSTEM_SCHEDULING
Date: Thu,  2 Jul 2026 18:19:02 +0200
Message-ID: <20260702155112.642252863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 06e0ae988f6e3499785c407429953ade19c1096b upstream.

The pool of free objects is refilled on several occasions such as object
initialisation. On PREEMPT_RT refilling is limited to preemptible
sections due to sleeping locks used by the memory allocator. The system
boots with disabled interrupts so the pool can not be refilled.

If too many objects are initialized and the pool gets empty then
debugobjects disables itself.

Refiling can also happen early in the boot with disabled interrupts as
long as the scheduler is not operational. If the scheduler can not
preempt a task then a sleeping lock can not be contended.

Allow to additionally refill the pool if the scheduler is not
operational.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251127153652.291697-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 46eabbae69ccfc..bb5c909458535b 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -605,7 +605,7 @@ static void debug_objects_fill_pool(void)
 	 * raw_spinlock_t are basically the same type and this lock-type
 	 * inversion works just fine.
 	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible()) {
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible() || system_state < SYSTEM_SCHEDULING) {
 		/*
 		 * Annotate away the spinlock_t inside raw_spinlock_t warning
 		 * by temporarily raising the wait-type to WAIT_SLEEP, matching
-- 
2.53.0



