Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BE418355;
	Sat, 12 Sep 2026 09:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203952; cv=none; b=XCLMzKCskgqwhZIUaldtFju2cfL8BYLae0nWvyB8Jl4I/K7enQmMSquF7/Axgttu0bYdPkGA9jW//uzoaYT8PU8H8sH4TQoAICm9eLzkLES1KRSFN6QFOwgFfVtNC2YBIe3MAbIYR4Qh2wz+OiGVm71+srU+9q3uvbK76RbfTJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203952; c=relaxed/simple;
	bh=DOggL1LloRHiBem5jxUlQSQVFw49ty10prN2+7xRDdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2yXN7oO+1n0JhIYLrJKIgDLZxQ/2JNqJOQCmvDn3+P924wPuuG4w4X/2VhIDzAlZf+RIDSuVWxebwgJgNpjatONolWKw6N7aFQdas6szCoOXb8Yu6Q+3A/GjUChP3So7eELFUSrsKn9R18xPY0PpAa8UkwsAzM/2ke4v32CbiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQ6sbMw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQ6sbMw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD6C1F000FF;
	Sat, 12 Sep 2026 09:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203951;
	bh=6OaJT/EZRrR4SZ7vaJ7NodK3rFysSSOvPYmSCt1lNAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQ6sbMw/pZyr6MZc/AOZYwX4kE20ilW7Yi0PRqGU82uhr1p+gsUa2rBNK0AlXmG3b
	 Sobx9fdX/1Lut34z1BUZdXCGhTShpAwn2fCLCJYiS4PnKjc5DL91Zb98rstJ7WjZSy
	 D0p/tVTyVMQ46xLqNmNuUXzMQwZgGE6MOCkCiX1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1470/1815] sched_ext: Make SCHED_CLASS_EXT select GENERIC_ALLOCATOR
Date: Sat, 12 Sep 2026 08:53:40 +0200
Message-ID: <20260912065723.517883888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 524ab50763af33d65e6e042cf7034cd8f82d437b ]

kernel/sched/ext/arena.c uses the gen_pool allocator, which is built only
when GENERIC_ALLOCATOR is set. SCHED_CLASS_EXT doesn't select it, so on
configs where nothing else does, the build fails to link:

  build_policy.o: undefined reference to `gen_pool_create'
  build_policy.o: undefined reference to `gen_pool_for_each_chunk'
  build_policy.o: undefined reference to `gen_pool_destroy'

Fixes: 9eca087deb0b ("sched_ext: Sub-allocator over kernel-claimed BPF arena pages")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608151315.tvN3X0Oq-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202608151632.3p91bTQj-lkp@intel.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/Kconfig.preempt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 88c594c6d7fcd..f95859e4e3f09 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -169,6 +169,7 @@ config SCHED_CORE
 config SCHED_CLASS_EXT
 	bool "Extensible Scheduling Class"
 	depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+	select GENERIC_ALLOCATOR
 	select STACKTRACE if STACKTRACE_SUPPORT
 	help
 	  This option enables a new scheduler class sched_ext (SCX), which
-- 
2.53.0



