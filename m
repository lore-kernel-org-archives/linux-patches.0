Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C992D94AF;
	Thu, 25 Jun 2026 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392754; cv=none; b=eVZd5QylcRzqTEnbz0726MWrbaRV5fxMPwZAnmnhGqBR5Upl+uCIhJ7sfLKWac5SYlr6fGKuOD4zvfV/Ll0Lf/41dpJSWL2HlYGsLKcI33aPA93vMmYfSONN08bp6Vf3+TACAwJkM8OgK+nIyzqTBJSFdF4vLoR2fBaRmH78iF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392754; c=relaxed/simple;
	bh=ElV4PeHnD+R3F4UMgfarJiMvVgP/YisZ8I/EaTtgxfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXn0Uj7OzrMmm56Qj7BmWtHXFAMOB7kKdnuPQ+geW0QUo9EO0Mql/qW62yGqMJYv9v0JsyWrFjWcqNgC/XByGgEAfNcsY1iJf2BveXoOTu74xAlN8g3vCQovHEtDKsr9k/VRTUZGk7gJaWW5EcadeHG6owKdH8DO3kIeOKugMJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVL4aYdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVL4aYdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C602F1F000E9;
	Thu, 25 Jun 2026 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392753;
	bh=bNCqM11/AeuoUPAKRRjNEQhRV5DLA5PVjJQ3jBQRL8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVL4aYdi+7z1wOoa4Ew69UCgp6V1+2ywmWS+FaEW6cqpvDs31LNHgPGe43A1ol2yr
	 bjcCn7DgA2VQd7cAt5b1Q2ySlG0M9v6PU0+9EakraLfIqZG0ci8vjeW7ZTME3X+ygj
	 sQOTpd8huCuKv7GzqcdWzj6HGqkNdbwLVi/9M7t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 05/60] debugobjects: Allow to refill the pool before SYSTEM_SCHEDULING
Date: Thu, 25 Jun 2026 14:02:50 +0100
Message-ID: <20260625125646.353749593@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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
index e4b7f77ece3b4f..9d59b797d1b507 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -731,7 +731,7 @@ static void debug_objects_fill_pool(void)
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



