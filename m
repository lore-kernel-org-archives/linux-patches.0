Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ED8269B0D;
	Tue,  8 Apr 2025 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115059; cv=none; b=Nipu9VD2iveTPXvgmGZnO0EncfQt0GJLgxNAxzJQfUofRZWOhlQv24QR9vghgyxyCz6hthPKdBIHNnX8YKwl3sxHHnypK5jAFLBu/fu8EdWk4jDwpCyIufvZWAx8Vks12vA0diU/u2rQ0LtPHkRBoKq5aJJin+jQLLekf1QP6Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115059; c=relaxed/simple;
	bh=YUPfclKZo4fZ05WQwDt5e1V6vUUe+BPMFBxT9pD20B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Soak6bZVd3DdSGV48UQCcV28ZRdjI20wxo9NzNpDi7yjFOq1InK4hF+uSVjW4IHgFejUJ10vJ5P8ohFqjzTJVFSc2BshuHCKgh7/amG6Sg7hFze84LO0ujKXxVV29/8apSm3EgWkqx4wg2jaTskpFwtg/FcToLvKichZnYhJe2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBmb4Yuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBmb4Yuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B74C4CEE5;
	Tue,  8 Apr 2025 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115059;
	bh=YUPfclKZo4fZ05WQwDt5e1V6vUUe+BPMFBxT9pD20B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBmb4YuuphnkaILf/FvrraqLvFj9OlIsxd/pYFmqdoALq+4v/10+u5elq15R4xae1
	 lLdjc5rzgnBlIh5vHe3P1hD9YrxYREz0m2tEio2tmeZnUFoNkpw7ADtbix+9VDMOWp
	 vzozbLq3h5itPTLyEakAzZ83g1F1QMLUaii/PMsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 297/499] rcu-tasks: Always inline rcu_irq_work_resched()
Date: Tue,  8 Apr 2025 12:48:29 +0200
Message-ID: <20250408104858.622734436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 6309a5c43b0dc629851f25b2e5ef8beff61d08e5 ]

Thanks to CONFIG_DEBUG_SECTION_MISMATCH, empty functions can be
generated out of line.  rcu_irq_work_resched() can be called from
noinstr code, so make sure it's always inlined.

Fixes: 564506495ca9 ("rcu/context-tracking: Move deferred nocb resched to context tracking")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/e84f15f013c07e4c410d972e75620c53b62c1b3e.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/d1eca076-fdde-484a-b33e-70e0d167c36d@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 48e5c03df1dd8..bd69ddc102fbc 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -138,7 +138,7 @@ static inline void rcu_sysrq_end(void) { }
 #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
 void rcu_irq_work_resched(void);
 #else
-static inline void rcu_irq_work_resched(void) { }
+static __always_inline void rcu_irq_work_resched(void) { }
 #endif
 
 #ifdef CONFIG_RCU_NOCB_CPU
-- 
2.39.5



