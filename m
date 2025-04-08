Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4208264A70;
	Tue,  8 Apr 2025 11:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111823; cv=none; b=r/t+uqEESw0Ts86CLAneUaFKmRNUWBHnDF71PwjSnhYXV+vZAhK4HkF0fd3wxjzkV13kvhfxBwTDJTYXrsTN+DftcxTV9I5IEiwJoxSsnBgCxA4Azm+J4w7GKE4NzHZwtDXbc346oqDu/tyQWJiXgCYo43DqO2C3DgfoiygQj6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111823; c=relaxed/simple;
	bh=l7RT9vPaUkoRCF9xi5B9bCje9orUwmrCMBZUYR8Ey+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0xXMaVV+s7mBlLvkRZyT3xMGi7Ub6Y0GjssfxECCB8/B4uobGx5IfcwPkgcCThujYKs28h89aqqZsiXpGENhtMxcM/jjjVeb23QEDywr4mhWHGwPxKbWYf6+tTY+z34QAt0M864MaxMXbcaOoK4W15LpT5FWoNJPGSG/VT3yjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKhgxGrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKhgxGrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B52C4CEE5;
	Tue,  8 Apr 2025 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111823;
	bh=l7RT9vPaUkoRCF9xi5B9bCje9orUwmrCMBZUYR8Ey+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKhgxGrdULJVuocog+1BYY0owqvYnTI2+XYrYgCdAs23Hr7LWDlgN31F/O/HioVpd
	 tYh9SyaLRdgqRerynYl/8in5eH5dpwLEopAoGtQfJNkte+kAPZHFpr6NA32yarCe2l
	 3iBNV0JGmnmuAd44oXI3SJ7v4NjqxQ5YNJ7eplwU=
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
Subject: [PATCH 6.14 573/731] rcu-tasks: Always inline rcu_irq_work_resched()
Date: Tue,  8 Apr 2025 12:47:50 +0200
Message-ID: <20250408104927.600971038@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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



