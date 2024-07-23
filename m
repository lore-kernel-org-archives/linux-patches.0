Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C87513D600;
	Tue, 23 Jul 2024 18:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759701; cv=none; b=Zh/2ySvl2M31BnGB4dXtfnUxVfJ4PY6V2hYKSYU8v6sJ9qARsBAUQLG9SIXAy4nRcrn2A6lBAVpDmKWao8oiK02t1UE1APJK40R/Qah7ko6ygFkZIW8jtquJtDpSAuJQjT2PrDFMk8dVwO/BT9vTjkQJBVi8I77REaaG64tpSY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759701; c=relaxed/simple;
	bh=IVxorn6x0MQokyVuKm9pQc+8wuskafIaqx9A+/iWGjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHVMKdHBvmYX1hdpsKLf403V8Od7GR6jD8KbNqYKZFyXvxwqNho/tcz5tFTQU6wWgchEquavsIsSZCMEji8Qb3k3r71rTMANge/VKrf411Z0vkDBArEhdrut4P+CBYJONzXyFKze6Q5VjqWt/dQf3jakCLzNsdnpJabTT7cfxPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K94J/Ct8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K94J/Ct8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DC4C4AF0B;
	Tue, 23 Jul 2024 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759700;
	bh=IVxorn6x0MQokyVuKm9pQc+8wuskafIaqx9A+/iWGjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K94J/Ct8kyTr926FWSOKhrNoxr+yhEoIntFnzW+7dEyoYPPvSJjRBPE41ja3VU+4c
	 CtKUIKPlRw2sr6oCnb+B3iFb1zI370Jr/iEBO0zgpd64Mos8R4xNyxodYhxoxgyeMm
	 rp54uPSz83AFugJfijvK4OzZwZt8I3UqVo/7YQaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Paul McKenney <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Yury Norov <yury.norov@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/129] cpumask: limit FORCE_NR_CPUS to just the UP case
Date: Tue, 23 Jul 2024 20:23:26 +0200
Message-ID: <20240723180407.028991113@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 5d272dd1b3430bb31fa30042490fa081512424e4 ]

Hardcoding the number of CPUs at compile time does improve code
generation, but if you get it wrong the result will be confusion.

We already limited this earlier to only "experts" (see commit
fe5759d5bfda "cpumask: limit visibility of FORCE_NR_CPUS"), but with
distro kernel configs often having EXPERT enabled, that turns out to not
be much of a limit.

To quote the philosophers at Disney: "Everyone can be an expert. And
when everyone's an expert, no one will be".

There's a runtime warning if you then set nr_cpus to anything but the
forced number, but apparently that can be ignored too [1] and by then
it's pretty much too late anyway.

If we had some real way to limit this to "embedded only", maybe it would
be worth it, but let's see if anybody even notices that the option is
gone.  We need to simplify kernel configuration anyway.

Link: https://lore.kernel.org/all/20240618105036.208a8860@rorschach.local.home/ [1]
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul McKenney <paulmck@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index c686f4adc1246..ee365b7402f19 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -539,13 +539,7 @@ config CPUMASK_OFFSTACK
 	  stack overflow.
 
 config FORCE_NR_CPUS
-       bool "Set number of CPUs at compile time"
-       depends on SMP && EXPERT && !COMPILE_TEST
-       help
-         Say Yes if you have NR_CPUS set to an actual number of possible
-         CPUs in your system, not to a default value. This forces the core
-         code to rely on compile-time value and optimize kernel routines
-         better.
+	def_bool !SMP
 
 config CPU_RMAP
 	bool
-- 
2.43.0



