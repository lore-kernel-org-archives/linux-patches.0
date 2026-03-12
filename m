Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645B1A0712;
	Thu, 12 Mar 2026 20:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346795; cv=none; b=MJrX4uK3S3xdhu4mt3jakEhnPN/UEFbm5fkLPYvpH0eLMiZJFkj9a91r9iVCIQYEJeWlh/7/d2kEYQKeXDVl44tu9JdKVFuB3ekMZv/TYkHUDR273UE79Ja4Y1Tt+K84EbGYC2ZXTePx6AqLA8zzFA7PO4SJMyZoOKKManF9VO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346795; c=relaxed/simple;
	bh=tLWDRQSbqw6AvvAblW2crVM7S37AN6KnR3M/r2GGuo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHy2aJadf49q8BqbScTem5fvEyvy0+Lag3Q5nyfWmQ6eyL+pEuDg152+i8V1KsAY5CXRkD70k0VkObZhp71yAAyIHx4ApfaB/z9CS4A3sfRl24eeosauv08YyjZEfCJyOUoZcscXgFFTgDgQ72jwnMIb6S+GMdC8/6LxoHORHYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7hDwShk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7hDwShk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987FCC4CEF7;
	Thu, 12 Mar 2026 20:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346795;
	bh=tLWDRQSbqw6AvvAblW2crVM7S37AN6KnR3M/r2GGuo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7hDwShkox1Lt8XakgBC3ls7jAjbJ169Hz9UkP2eRw2XERaxaOvJ0Yy4u3/gdGiOl
	 5jEkFSVrY1clP/oJOJHZNMnUmdzQNCyrbLXirYMXesuUe9hmlr3YHitESTxCS5Pr7w
	 MCspLpAmbI5sTOMiDP0scNSTOncnmmJD3B4fwP8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/265] LoongArch/orc: Use RCU in all users of __module_address().
Date: Thu, 12 Mar 2026 21:08:25 +0100
Message-ID: <20260312201022.504112831@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f99d27d9feb755aee9350fc89f57814d7e1b4880 ]

__module_address() can be invoked within a RCU section, there is no
requirement to have preemption disabled.

Replace the preempt_disable() section around __module_address() with
RCU.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250108090457.512198-19-bigeasy@linutronix.de
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: 055c7e75190e ("LoongArch: Handle percpu handler address for ORC unwinder")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index 471652c0c8653..59809c3406c03 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -399,7 +399,7 @@ bool unwind_next_frame(struct unwind_state *state)
 		return false;
 
 	/* Don't let modules unload while we're reading their ORC data. */
-	preempt_disable();
+	guard(rcu)();
 
 	if (is_entry_func(state->pc))
 		goto end;
@@ -514,14 +514,12 @@ bool unwind_next_frame(struct unwind_state *state)
 	if (!__kernel_text_address(state->pc))
 		goto err;
 
-	preempt_enable();
 	return true;
 
 err:
 	state->error = true;
 
 end:
-	preempt_enable();
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
 	return false;
 }
-- 
2.51.0



