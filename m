Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ADD25A627;
	Tue, 27 May 2025 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368018; cv=none; b=IO1R/FweWUJ1N+yEuzNUnPx9G71xlexxueaXIpD0ZRShAoMA6TubzKGu4WuoFhv+HaMgmaujJBPT0MSw8nJIl2d3cxfySPTKIQYisvtTWqIEFJyViUr6Xrr1MHDyPZLvsgwqK0+kkAN3iB6dlEVRzK0u+JSJ8L+O4MN4WnEo91E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368018; c=relaxed/simple;
	bh=yKlcvWhp+O+bPLo/GLI4ww2r2MvaXBHwaB7D/DrRBsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhOaJX/18eDzfWJlFDCqWJANZ1A7vOHBG1YlZZnuzV8+dgoNcSFJmHyf6VHPkJ6shx/KjEbSJZeC66nw0uyr9EyuXKaXoBM0JtMHC2QmL1vVhKqJ/DmlI8xLQue1A9xp++wD+Fe8f0AgFxpqzwfW/1YWXwMUYIBjmN+3mcrUnKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgCbtH6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgCbtH6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDBCC4CEE9;
	Tue, 27 May 2025 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368017;
	bh=yKlcvWhp+O+bPLo/GLI4ww2r2MvaXBHwaB7D/DrRBsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgCbtH6nXoZyJwXbYahqJbNvZJx/SmBue/vhIOWAW6WfkZ/7hcA48VF9n3vVDPtzs
	 1T/Gvs7DnF7dLzZHE7cUQUIXBhsYMz551UXS3pvpiz7IfHr3nqbVGfdzB8FjrZ+uss
	 it1LLr5oPP+me/dwzOVCOP55J7lbHZYAku6dzqdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 571/783] rcu: handle unstable rdp in rcu_read_unlock_strict()
Date: Tue, 27 May 2025 18:26:08 +0200
Message-ID: <20250527162536.395892385@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankur Arora <ankur.a.arora@oracle.com>

[ Upstream commit fcf0e25ad4c8d14d2faab4d9a17040f31efce205 ]

rcu_read_unlock_strict() can be called with preemption enabled
which can make for an unstable rdp and a racy norm value.

Fix this by dropping the preempt-count in __rcu_read_unlock()
after the call to rcu_read_unlock_strict(), adjusting the
preempt-count check appropriately.

Suggested-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h |  2 +-
 kernel/rcu/tree_plugin.h | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index bd69ddc102fbc..0844ab3288519 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -95,9 +95,9 @@ static inline void __rcu_read_lock(void)
 
 static inline void __rcu_read_unlock(void)
 {
-	preempt_enable();
 	if (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD))
 		rcu_read_unlock_strict();
+	preempt_enable();
 }
 
 static inline int rcu_preempt_depth(void)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 4328ff3252a35..3c0bbbbb686fe 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -833,8 +833,17 @@ void rcu_read_unlock_strict(void)
 {
 	struct rcu_data *rdp;
 
-	if (irqs_disabled() || preempt_count() || !rcu_state.gp_kthread)
+	if (irqs_disabled() || in_atomic_preempt_off() || !rcu_state.gp_kthread)
 		return;
+
+	/*
+	 * rcu_report_qs_rdp() can only be invoked with a stable rdp and
+	 * from the local CPU.
+	 *
+	 * The in_atomic_preempt_off() check ensures that we come here holding
+	 * the last preempt_count (which will get dropped once we return to
+	 * __rcu_read_unlock().
+	 */
 	rdp = this_cpu_ptr(&rcu_data);
 	rdp->cpu_no_qs.b.norm = false;
 	rcu_report_qs_rdp(rdp);
-- 
2.39.5



