Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7436523BCEE;
	Thu,  2 Jul 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010328; cv=none; b=nXmG0W2XN2C0dbXehEnipw53A3eoEt/RVSonqfsbYuj8bsmmjUSKNfxqbggZtOxcqknEh2Ah+9FZzXb1Ei/UEOUIlXmYMc94ro1VlxoYCpugaoEQpnnvlKe1ibKyfYmR1b1UawF1cvlfxnDhWJQ1EVbtkQIFK39Q2ovsw0Vu6tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010328; c=relaxed/simple;
	bh=NfSzlw7kXCSqJtL33vaCczE0qEtENbMp17RQaC+4i8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gagLsFy6Pge5vol9mlB4yWDF+XlkwgHCyuXPCfsZpzx7D3JC4fMRbjVupsbB6sQkE2Pk7dX5EfS+SEKbqLkgM8dCFDsrIU+wGVzGJdiKMzJiwNyaT969T9D6p8SUZE1ccCvGNzWlaUO6T7k1cy6YzOLm3IIQS6VwyReyVl61fs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ps2qKjq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps2qKjq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8311F000E9;
	Thu,  2 Jul 2026 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010327;
	bh=0CubLSPliE624K7LWuauN1cvsfm0DcI3KRLnDw1t17E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ps2qKjq8xpA0u6GEUA5lCraNOC5B4OxQkpH2Jhf5q8eYkz5fsClesx4suNtNA72D4
	 pS6xAjxcFXRrjBGGtfSEorU33EVp5NbZVqWjwCiBY3watNNU2KUWwLV4EuBJTnZHJQ
	 /XzOo8yYgnj8IMtHZO9AvzTZAzvFi/VNuUJHjU08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/204] debugobjects: Allow to refill the pool before SYSTEM_SCHEDULING
Date: Thu,  2 Jul 2026 18:18:00 +0200
Message-ID: <20260702155119.149838268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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
index 932e2d8dbd9b9b..d69721bb78b797 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -604,7 +604,7 @@ static void debug_objects_fill_pool(void)
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



