Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76904E36C6;
	Fri,  9 Oct 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556127; cv=none; b=fVaBf6CGX0gu6R/p2NYjH1crRICbop4toW2W6CIOcX66XNjCHeMhjkFUn4aNjdt0LFMUPGKs0K5wGBD8CHhm53LNy19MSGcjFEoq0rSdgk/rtjMjCSRNj65Lzefsx0jerRtFu1zuHPtuFdysYPWioPMLbTVia7/kHqcO9VU2P5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556127; c=relaxed/simple;
	bh=8G8e9kPLnu4mfhEqeHYJUj846f4BEK1sDn5x+EmO+iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebReNs74AS0eD5vOT89Qvqc8iAhC65b4MWNT9c0qjraYLuZ3RRTOoAHnxIk2StZt9k8s9qksX61MZe4cz0z6JdsTofzWd9wurTBk1JuiRsvLvsFPrN3gTt4r7yYGmdezZvVWGVkUn4f5AAkgA00PJ2BoJwFLU1JnSw8d2gw+atU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd8VBmUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd8VBmUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4149E1F000FF;
	Fri,  9 Oct 2026 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556126;
	bh=7oVUv78y0mq7deWxURcYzFrGvUKq6ejFq129QxrqL1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hd8VBmUd0G/Ay7K5lLDYJ1od7Pd1fDxT+OiLAaeIwGYVnGDubwcZZfUGKtkl1a0/i
	 ZzeIjtEEAqBCnBvz8FbfgTLU3ApSUbHOXx83As5mmJm2OiBAngQmrGvMoSXfNx22ay
	 H68GBEIsRSDKwQ4MrSepFjC5MZTOQkFGhgGew+C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bradley Morgan <brads@mainlining.org>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 103/428] ARC: arch_cmpxchg_relaxed to use size of pointed type not pointer
Date: Fri,  9 Oct 2026 16:07:20 +0200
Message-ID: <20261009140948.475838184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@kernel.org>

[ Upstream commit f050c3e61d2a1aaece3170d459e4ce5fa2486c12 ]

Bradley spotted this snafu when working on two-byte cmpxchg emulation.
He originally folded this fix into his series but the fix itself
uncovered a pre-existing issue, missing arch_atomic64_cmpxchg_relaxed
which just needed to be wired up.

Fixes: e188f3330a13 ("ARC: cmpxchg/xchg: rewrite as macros to make type safe")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609240539.AkulvjVe-lkp@intel.com/
Suggested-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/atomic64-arcv2.h | 6 ++++++
 arch/arc/include/asm/cmpxchg.h        | 4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/atomic64-arcv2.h b/arch/arc/include/asm/atomic64-arcv2.h
index 73080a664369b..1ca4a1047fb37 100644
--- a/arch/arc/include/asm/atomic64-arcv2.h
+++ b/arch/arc/include/asm/atomic64-arcv2.h
@@ -156,6 +156,12 @@ static inline u64 __arch_cmpxchg64_relaxed(volatile void *ptr, u64 old, u64 new)
 }
 #define arch_cmpxchg64_relaxed __arch_cmpxchg64_relaxed
 
+static inline s64 arch_atomic64_cmpxchg_relaxed(atomic64_t *v, s64 old, s64 new)
+{
+	return arch_cmpxchg64_relaxed(&v->counter, old, new);
+}
+#define arch_atomic64_cmpxchg_relaxed arch_atomic64_cmpxchg_relaxed
+
 static inline s64 arch_atomic64_xchg(atomic64_t *ptr, s64 new)
 {
 	s64 prev;
diff --git a/arch/arc/include/asm/cmpxchg.h b/arch/arc/include/asm/cmpxchg.h
index 76f43db0890fc..66b3743c94008 100644
--- a/arch/arc/include/asm/cmpxchg.h
+++ b/arch/arc/include/asm/cmpxchg.h
@@ -46,7 +46,7 @@
 	__typeof__(*(ptr)) _n_ = (new);					\
 	__typeof__(*(ptr)) _prev_;					\
 									\
-	switch(sizeof((_p_))) {						\
+	switch (sizeof(*(_p_))) {						\
 	case 1:								\
 		_prev_ = (__typeof__(*(ptr)))cmpxchg_emu_u8((volatile u8 *__force)_p_, (uintptr_t)_o_, (uintptr_t)_n_);	\
 		break;							\
@@ -102,7 +102,7 @@
 	__typeof__(ptr) _p_ = (ptr);					\
 	__typeof__(*(ptr)) _val_ = (val);				\
 									\
-	switch(sizeof(*(_p_))) {					\
+	switch (sizeof(*(_p_))) {					\
 	case 4:								\
 		_val_ = __arch_xchg(_p_, _val_);			\
 		break;							\
-- 
2.53.0



