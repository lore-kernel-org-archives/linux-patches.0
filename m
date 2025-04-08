Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3F72686AA;
	Tue,  8 Apr 2025 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115840; cv=none; b=oFEtFvHMQMev8WcITTfN2M6d566jMKqUyGQcDy00PLAoUQTTSUnW4BFtSJA/K90dnRMusn/INaMhqNsQ56t13oCB1WuLEXFd7Wp+1o/JUWxFRMyX1WG8hi6APsk95d9BQC7WJJbLEVWhAjDWL7WX/3MoVxif/6oVOqpo3dR4MFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115840; c=relaxed/simple;
	bh=u/lphPFJjDCbu25pUrIJlD/cjgjq0HHNOpbjKySDg2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luPGluYExHfP0flpW/YbGTkm1KKMD1u+xlFGZHm5ubNrqnh8y4KE7wHfhZbb81+b6qdZkcLXK/4P+vNDWPt3U+MZXk/5x+QPGqDSrTlBX3tdSwKzJWB1BIMZiviGJ8ylLUC/ZXMCJqYnnFjY87/VCGtNgjbyjc8UrV2St6Dg8kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSYVn57O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSYVn57O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2643C4CEE5;
	Tue,  8 Apr 2025 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115840;
	bh=u/lphPFJjDCbu25pUrIJlD/cjgjq0HHNOpbjKySDg2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSYVn57OHWSlon5M80Bg8BoPBxUT0va1MxDeMz61YNL0KlmO0pStU08Wmb4UpxjAt
	 H4y4AiF69mD/DfzN6k8P1KVLCbVyNSS6QMskruwmLzEslIqtCok49GKU8ow9CUjLH7
	 35/j6R9DEZluUc1orDgaJ3OUreneVHRMpdN6Wjbg=
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
Subject: [PATCH 6.1 125/204] rcu-tasks: Always inline rcu_irq_work_resched()
Date: Tue,  8 Apr 2025 12:50:55 +0200
Message-ID: <20250408104823.976545941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6858cae98da9e..d001a69fcb7d4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -133,7 +133,7 @@ static inline void rcu_sysrq_end(void) { }
 #if defined(CONFIG_NO_HZ_FULL) && (!defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK))
 void rcu_irq_work_resched(void);
 #else
-static inline void rcu_irq_work_resched(void) { }
+static __always_inline void rcu_irq_work_resched(void) { }
 #endif
 
 #ifdef CONFIG_RCU_NOCB_CPU
-- 
2.39.5



