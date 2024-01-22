Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DED1133411;
	Tue, 23 Jan 2024 00:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969129; cv=none; b=MwcxAhtIE9xDmCW+1EFB0wf0vanm5SvJHd9HyG8wy2fURfNKxDMPZglBzqPdg3bzyp9hW7YFnAu9ffHG2EY0Xxj8HAHg8FroBHzD2KGo9jpv4V0GQKYdzGdqJPIPiz/sTNLPYEpoua7wMH/hNdPYcaaV/ItvGbusTkyJ88b/2rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969129; c=relaxed/simple;
	bh=+eb8x5UyacvzGfzmn74wWjBMy7D7MBrVn80b6UpcJoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLOasxi9nmEMqqfIYOsz13UrukugAu0N3RmMOFz848p64bTbA1e9w4MrVAgmJEiNfYuYu2go9U60o+ytt8bl3fw57APf2kXZqlE/4M+l4b+p6CC3MiG7XmlGJbKP/Jau7G+RLyxl6ugwQaavVkIfJHHWJGbmy9VuycGINcfYmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEjP1UvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEjP1UvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2EAC433C7;
	Tue, 23 Jan 2024 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969129;
	bh=+eb8x5UyacvzGfzmn74wWjBMy7D7MBrVn80b6UpcJoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEjP1UvD4NLt7qAB4JfAofd+iQrWEPJLXqHCJb/gFi0cTMn21uLpm4E7c2c6kO1tE
	 IC2lEI6SVXxh+RLZKl2il+CNOOWsyWXCJR07/7uktBxMg4inOVsiGuh1G8cHO0Efwl
	 FNaYEC8oWuGe3P2g4zbLWzZyOZEs59b09uYY60xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	forza@tnonline.net,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 040/641] cpuidle: haltpoll: Do not enable interrupts when entering idle
Date: Mon, 22 Jan 2024 15:49:04 -0800
Message-ID: <20240122235819.344805721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit c8f5caec3df84a02b937d6d9cda1f7ffa8dc443f ]

The cpuidle drivers' ->enter() methods are supposed to be IRQ invariant:

  5e26aa933911 ("cpuidle/poll: Ensure IRQs stay disabled after cpuidle_state::enter() calls")
  bb7b11258561 ("cpuidle: Move IRQ state validation")

Do that in the haltpoll driver too.

Fixes: 5e26aa933911 ("cpuidle/poll: Ensure IRQs stay disabled after cpuidle_state::enter() calls")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218245
Reported-by: <forza@tnonline.net>
Tested-by: <forza@tnonline.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-haltpoll.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index e66df22f9695..d8515d5c0853 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -25,13 +25,12 @@ MODULE_PARM_DESC(force, "Load unconditionally");
 static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
 static enum cpuhp_state haltpoll_hp_state;
 
-static int default_enter_idle(struct cpuidle_device *dev,
-			      struct cpuidle_driver *drv, int index)
+static __cpuidle int default_enter_idle(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index)
 {
-	if (current_clr_polling_and_test()) {
-		local_irq_enable();
+	if (current_clr_polling_and_test())
 		return index;
-	}
+
 	arch_cpu_idle();
 	return index;
 }
-- 
2.43.0



