Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692EB38654F;
	Sat, 17 Oct 2026 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254293; cv=none; b=u70KY+A+U11dvVP6yKe5nnzs54jLJdsR5AzN9ZT2+ewaOtvYB/wOvsguUNnpdz/g6rmiuKrxaqDfDsMIG6vmVSZDP3k/7x9FvJ0TqUli8CLT6jIyPhZzVxnC4YH6jxc+xG4G1DcrBHi5gDNZShJ7Co6ZrDvLX+VcokmWV4Taq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254293; c=relaxed/simple;
	bh=6KBAjcVbLSqPHJlu6QH2DqEYhb3b72Z+skwGq6DgbvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/xxYRfBux0mfWjFnphtmufg+Vg+qznhJfwSMuagoJDmISDOVPlkFBFcvBKSA3PZMhuc4OfcqVQXd64R/JETvYN8X6rdwxiXVIWc2xMyLQhNKhOF55rnVz5xDeX/HAskNU0f+ZWA5pdq1FDuJFk2GN+Iurq4se9rng/uAuooGGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hz1GE51u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hz1GE51u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58A51F000C4;
	Sat, 17 Oct 2026 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254292;
	bh=ZkCp5hgGJ0hR98g/6PuUVhRvWr3utlFJrLby/hUDeaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hz1GE51uxxsdedobNChDwdbKZ+g3jbNhuxuJ6H46lSCVuPVay3AcOsnf3T4j9m7tc
	 iCs9/5Jr+39iy666rhTtuWg7f/KH8wg7ChOdU5BGqyZVv1pUkmDqQmrLHYsNcP5F1J
	 uf7Agv17JqRNgeT5SAx55jTNE2oyLE62k+Y0E7cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 399/869] rcu: add rcu_read_lock_dont_migrate()
Date: Sat, 17 Oct 2026 17:54:00 +0200
Message-ID: <20261017160047.351880550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 1b93c03fb319d72a1f5f4723abd5df15ce40f4e2 ]

migrate_disable() is called to disable migration in the kernel, and it is
often used together with rcu_read_lock().

However, with PREEMPT_RCU disabled, it's unnecessary, as rcu_read_lock()
will always disable preemption, which will also disable migration.

Introduce rcu_read_lock_dont_migrate() and rcu_read_unlock_migrate(),
which will do the migration enable and disable only when PREEMPT_RCU.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20250821090609.42508-2-dongml2@chinatelecom.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7cbd0c4cebe4 ("bpf: Fix UAF in sock clone early bailouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0844ab3288519..05cc0d07f5890 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -971,6 +971,20 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	preempt_enable_notrace();
 }
 
+static __always_inline void rcu_read_lock_dont_migrate(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
+		migrate_disable();
+	rcu_read_lock();
+}
+
+static inline void rcu_read_unlock_migrate(void)
+{
+	rcu_read_unlock();
+	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
+		migrate_enable();
+}
+
 /**
  * RCU_INIT_POINTER() - initialize an RCU protected pointer
  * @p: The pointer to be initialized.
-- 
2.53.0



