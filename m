Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED2820CCD8;
	Tue,  8 Apr 2025 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113442; cv=none; b=ZIYBFO5DNkpxvc7vsFgD+I3w2BD7fDJRqamiYkW3TQpUVhTfSsPL+HQUcE8s9BmrQ9NjNxt+Ue8BAHWe770fvg5YO1mMFFDXUuNEhkFj08le61A+rL6k3fG1t45hfUeKq6/HYI1m4ISJV2hLXLOjmuf3ZrArcR61bud1kiiDdvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113442; c=relaxed/simple;
	bh=6k8BLI5CgFS3o4UBCTMgboXADAiar8WyggyzenaYyQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsD33muZpBLj0qzQufz2x5iBw1n1Rrjtc1iGjj+0je8Msl4+EEQjuZqGwwfiIimFhuGBu4aWxgvnGGAW/Z8zsQbK60Xvml/CKMYysn45dPdv+qI3s6KfVNbu6RTZ7xQ9SLIItn8O8fTEAGAgHQsKqg2DzSKj7XrcPXfYDbd5+TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/yF9jDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/yF9jDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBC8C4CEE5;
	Tue,  8 Apr 2025 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113441;
	bh=6k8BLI5CgFS3o4UBCTMgboXADAiar8WyggyzenaYyQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/yF9jDBz1jqocskAaR4lEkHuHB95QsklITtdJ0JbPcMLWFtOjwOfIW0+MrNKRRR5
	 qteYd1wH60NEkeJZWuaAEaUJgqDr2vQ8mLgZOGjl4chfCWB1QFKPQ1ZPAoG6Ds2WEl
	 YlCOVKakbN9e1HQn1bbJoWpTR8V4rAjbWMaQ+/0o=
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
Subject: [PATCH 6.6 161/268] rcu-tasks: Always inline rcu_irq_work_resched()
Date: Tue,  8 Apr 2025 12:49:32 +0200
Message-ID: <20250408104832.890615390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7602d1f8a9ecb..72da69cc5764f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -142,7 +142,7 @@ static inline void rcu_sysrq_end(void) { }
 #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
 void rcu_irq_work_resched(void);
 #else
-static inline void rcu_irq_work_resched(void) { }
+static __always_inline void rcu_irq_work_resched(void) { }
 #endif
 
 #ifdef CONFIG_RCU_NOCB_CPU
-- 
2.39.5



