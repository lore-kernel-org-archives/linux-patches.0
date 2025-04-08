Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C141DF27F;
	Tue,  8 Apr 2025 11:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112321; cv=none; b=a1hlObi+IDxi+SCKXTBvSpoy3BJQf5R3eXDTFSNE1sKdRBAsBSIL1WZQlaQ+E/QxHhnu379Fcbsz4JhmtBq7khlI0UKhoRcDdC6ImAboaVoK6Eq4DDuOq6wVRPxiFUP9Re6Oo6bwwn1Juc7JM5hIjuIei7y+X1aRWjSgjBFIY8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112321; c=relaxed/simple;
	bh=2rVENshSfZ/C0CFTJltZ8K2TDU8E+XMVRmQJwsoDwdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWU8fRL382PuH18vGm5i4n6Fa4QVPtTBdqAa756SlTWzcVTlAVSu/BGgssdfiJGwVXSQNSHbuW1WNa51BF2LTXlE81UT/fZDX2p+Sy5CKvgFomBUOo3Tq/EE81D0ytHl7LjQNtyeXMoKJjdJVE3eV2ohSnaHIylwBd+UltflJZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnhrLf2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnhrLf2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F114C4CEEA;
	Tue,  8 Apr 2025 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112320;
	bh=2rVENshSfZ/C0CFTJltZ8K2TDU8E+XMVRmQJwsoDwdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnhrLf2yk71TU5tBtotSG2whpKsjE068tuKEPy1VtibTqd12vF+yPa6/4yDnKlgSh
	 Esr6+kcOYx2itTcdV9nQJSttMD5Kj+IHTsV07Bm/sG0u1ZM0MDOgYfQmiPXNLhg5qd
	 KoM0FCiHyuub6//gg6u+yTowhOWR2hmZIi3PeK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/279] hrtimers: Mark is_migration_base() with __always_inline
Date: Tue,  8 Apr 2025 12:46:48 +0200
Message-ID: <20250408104827.063492122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 27af31e44949fa85550176520ef7086a0d00fd7b ]

When is_migration_base() is unused, it prevents kernel builds
with clang, `make W=1` and CONFIG_WERROR=y:

kernel/time/hrtimer.c:156:20: error: unused function 'is_migration_base' [-Werror,-Wunused-function]
  156 | static inline bool is_migration_base(struct hrtimer_clock_base *base)
      |                    ^~~~~~~~~~~~~~~~~

Fix this by marking it with __always_inline.

[ tglx: Use __always_inline instead of __maybe_unused and move it into the
  	usage sites conditional ]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250116160745.243358-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 9e91f69012a73..2e4b63f3c6dda 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -144,11 +144,6 @@ static struct hrtimer_cpu_base migration_cpu_base = {
 
 #define migration_base	migration_cpu_base.clock_base[0]
 
-static inline bool is_migration_base(struct hrtimer_clock_base *base)
-{
-	return base == &migration_base;
-}
-
 /*
  * We are using hashed locking: holding per_cpu(hrtimer_bases)[n].lock
  * means that all timers which are tied to this base via timer->base are
@@ -273,11 +268,6 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 
 #else /* CONFIG_SMP */
 
-static inline bool is_migration_base(struct hrtimer_clock_base *base)
-{
-	return false;
-}
-
 static inline struct hrtimer_clock_base *
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
@@ -1377,6 +1367,18 @@ static void hrtimer_sync_wait_running(struct hrtimer_cpu_base *cpu_base,
 	}
 }
 
+#ifdef CONFIG_SMP
+static __always_inline bool is_migration_base(struct hrtimer_clock_base *base)
+{
+	return base == &migration_base;
+}
+#else
+static __always_inline bool is_migration_base(struct hrtimer_clock_base *base)
+{
+	return false;
+}
+#endif
+
 /*
  * This function is called on PREEMPT_RT kernels when the fast path
  * deletion of a timer failed because the timer callback function was
-- 
2.39.5



