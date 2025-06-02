Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE06221FAA;
	Mon,  2 Jun 2025 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873870; cv=none; b=HW+kRZczoB3byYhw8E1CeVs8B606wPnC5IVL9v3bNvoqZoKZPUbxci27I3Wl3y81j0yFZ2aNIh9G5f2/RKT62nw4rkJcO63oUjHS/Njv/L9Jk0XeornaL1tOn7XV3QRiHny5Rz9pmSzlAD7DZOZZRw2C7Vhne1Tnl/Vy6HYAJDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873870; c=relaxed/simple;
	bh=qaVQJsmjZ+5UNhzk2W9a+pEKBfERneO2+ZtdIsIBAWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU87iqvCf2ZVJIbvH/S40319G3VfjF30rcE1BWNafwy9JNJWHcT25iYGtpl9EWNFvQ5XeuQ15WLha1+zdudBVXuxy9b/NfcyNsh+/cRadh22EPvEa/ITcZRIKBcw3QsD9J4vSYQabZf+1yQsUPK3BTy0oY7VpPAAHYJ4pteVRuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj1ZtdQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj1ZtdQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866D5C4CEF0;
	Mon,  2 Jun 2025 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873869;
	bh=qaVQJsmjZ+5UNhzk2W9a+pEKBfERneO2+ZtdIsIBAWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj1ZtdQ1mO6Z2mDWBgLyU6KJ+dfJqL8Los0GZDLPUAelepytYQ/by7XnX2+NEjkuM
	 WHW+3480hqce8EyIz2r0XZt1W16sFbfU/2k4cvrIMC0CfWNh8BuABrCTx6jsIU8jjX
	 QHZYk6m0atll60WlksikXijnu+QP7I0uVF7OTsM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/444] rcu: handle unstable rdp in rcu_read_unlock_strict()
Date: Mon,  2 Jun 2025 15:45:45 +0200
Message-ID: <20250602134352.359452478@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index 72da69cc5764f..27531a0b3a6e7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -97,9 +97,9 @@ static inline void __rcu_read_lock(void)
 
 static inline void __rcu_read_unlock(void)
 {
-	preempt_enable();
 	if (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD))
 		rcu_read_unlock_strict();
+	preempt_enable();
 }
 
 static inline int rcu_preempt_depth(void)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index dccfc46496393..94b715139f52d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -821,8 +821,17 @@ void rcu_read_unlock_strict(void)
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



