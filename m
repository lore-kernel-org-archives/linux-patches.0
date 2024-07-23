Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C1B14EC58;
	Tue, 23 Jul 2024 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760021; cv=none; b=WxyPTUZltEtjru2/EAowEbm+N/OFkFRYayjpfqKGUdNYdDvcBuLilDcTRgViGNOhGjgXa+vTfm9vvAhLSz0YSpjh0UCAPp9D0BwFdyyEtY/DOYigGTmfkAF4995/m+pw12kcmvjIMN5PMlX1stbCpc2sw7xBJxWLqr6mFQkbNAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760021; c=relaxed/simple;
	bh=BQJtVNELg4qIFi/kU56tFKUES4oXSOKwyh9VWjRY488=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IihDI1XGU87K9cmINhFj7oKqD5xmihEpPCcnnkbJWSjxoWTl2p81072vR92TLCHQU+lrlW6zEcsHT375Ethq15iAwgzITJYcopSFCNvb65WJ29WY2QXeVkZ4b637nYi2Axprb3DfyOLWYwIVsZdqUtbQmfm9jwVI0SL6i0o8ORc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwnfICq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwnfICq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D540CC4AF0B;
	Tue, 23 Jul 2024 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760021;
	bh=BQJtVNELg4qIFi/kU56tFKUES4oXSOKwyh9VWjRY488=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwnfICq2CdNHb+WsvZe6LXhDNhvuU+QFtysWDDUSO14NNPa/pcc1tXfHhJbqTO7aY
	 B3kulAkAOqA8TNWM4AezvhN2XZJ7lGz38SsKhBPoGpQtCdhNHID/c/dq+20XvkZp2G
	 aC2nTncO65VdZuopZqlTz7LZF1S6ex5geyA0zQG8=
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
Subject: [PATCH 6.9 077/163] cpumask: limit FORCE_NR_CPUS to just the UP case
Date: Tue, 23 Jul 2024 20:23:26 +0200
Message-ID: <20240723180146.443689988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 4557bb8a52565..c98e11c7330ec 100644
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



