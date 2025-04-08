Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EBF26AAA3;
	Tue,  8 Apr 2025 12:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116739; cv=none; b=lgVpwobdO5pDZ1991/9e1MvFlpkpLCVcOdrGIeyr7bCU+tKbX9P+HvZmWzlLOb9E2/eaSO9jncj+RV+PTwA5ql3/dgzp3n66iyY8AOlm2O1gSz1yF4SoIo7Cn/GgCexbBJlZEJzeogFFuzf42GeIg2pETNQpdYv0ZbJFHzsFGk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116739; c=relaxed/simple;
	bh=rND0Ib0oUB7aoemYHguJn6aEFgMKNUanc9TyRyytpuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR8rsHxshgtMl4pYMUnZnd95ePovaVKcXJWIMbVZR/KdSHIBV+7DQU3TTiPaWAxx1iLlR81ZZ3N2hXUihJAEXZPPjHOJb/das7gKTvfnugRx5S0p7L+OLI20V47Yd5f4J4Bp3shP9evfkecVXB7FIciQUbAQUkPV3R0pzgweySs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i275KUmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i275KUmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEF3C4CEE5;
	Tue,  8 Apr 2025 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116739;
	bh=rND0Ib0oUB7aoemYHguJn6aEFgMKNUanc9TyRyytpuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i275KUmkgGKeIj1urTSgsC6qTl2p+Roe+JLDS8J9lHoWgzq37C3Rb+l+E0yHcY+C8
	 /QfMHU6QOvVzjWHFTBALq40bBc0mzxr8oBzacFIKLCNwi93VyUf8yYjO0hDwovn0Hd
	 eqxBK5d9U3/7svifNMocan0+l54EQmYHUfVHZyeE=
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
Subject: [PATCH 6.12 250/423] rcu-tasks: Always inline rcu_irq_work_resched()
Date: Tue,  8 Apr 2025 12:49:36 +0200
Message-ID: <20250408104851.560278014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



