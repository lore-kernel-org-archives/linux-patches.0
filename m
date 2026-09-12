Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B9035F602;
	Sat, 12 Sep 2026 09:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204847; cv=none; b=DGq2fpEdRkKAxSXN1XdM8qDd9bmAXjsFNXb8vQ0L+FlqEbqZC3E8NUhCwGKuzN1gOFalx3R9n7I8/3/lwxwMcHxLn68KpsUXJsLXxbN7+O86+EwXHAg9fN+2biRkSHQ1hxN3968wsoB9LEADxTC3jN487hLlXUU4dPLLyc5PhoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204847; c=relaxed/simple;
	bh=8vhwPj+9aunEeQzL0f8Lh9wFX1oVWsM2PN+DCNFgiM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kU1AcKHTJYUY39S1OvghJirWYGQ8UYbRSbFTJrSNchKWiCDhuZn8qG6cfpXmYY40n98YRAfQkWt2arbZDyC6IjzTNhXHFJ/kR+HAQNDgCekUCVhthBlDX1nwDcc5WZR9DfOf96qluLR7V9Hek0cSVspfvVYCdTiKNKtn33UP1pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ag8uKMgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ag8uKMgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CCF1F000FF;
	Sat, 12 Sep 2026 09:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204846;
	bh=+wagyrGhbI0vKnzM+f6pFd9+DygKAdqzkh7WpiFAHdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ag8uKMgIFOiwKML2QGF5VqA1j2HMp873hKXpCh5eRyGSoKvjeLhbK4WkKL9bgdvNA
	 LFC7LZ30oe2wxka+AFZsQdnp4zzDhUb03yo34B5Nvg6ntgYswvqJ29bz4dmLItPF82
	 fcnVgrPjOTtowwAc2rjxuERLpjfzbwsAGVfhAfcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Waiman Long <longman@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: [PATCH 7.2 1654/1815] sched/topology: Add a cpus_read_lock to rebuild_sched_domains()
Date: Sat, 12 Sep 2026 08:56:44 +0200
Message-ID: <20260912065727.822573989@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 666a32836c8f9daf9b0067c49b04d5201fb8f3ba ]

A read from /proc/sys/kernel/sched_rt_runtime_us leads to backtrace due
to missing cpu_hotplug_lock with CONFIG_CPUSETS=n. The callchain is
sched_rt_handler() -> partition_sched_domains() -> sched_cache_set() ->
static_key_enable_cpuslocked(&sched_cache_present).

sched_cache_set() itself is also invoked from sched_init_domains() which
is early during the boot, holding just the sched_domains_mutex_lock().
Here is no warning because it happens before user space is running (and
hotplug operations are not possible).

There is also sched_cache_active_set() which acquires the hotplug lock
before invoking any of the _cpuslocked() functions.

This is only a problem with CONFIG_CPUSETS=n because in the =y case the
other implementation of rebuild_sched_domains acquires the CPU-hotplug
lock.

Acquire CPU hotplug lock before in rebuild_sched_domains(), before
partition_sched_domains() is invoked for the CONFIG_CPUSETS=n case.

Fixes: a7660ce1590fc ("sched/cache: Fix has_multi_llcs iff at least one partition has multiple LLCs")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reivewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://patch.msgid.link/20260813073855.ji2UrtVh@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpuset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 65d76a38974ba..bf3999daa080a 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -273,6 +273,7 @@ static inline void dl_rebuild_rd_accounting(void)
 
 static inline void rebuild_sched_domains(void)
 {
+	guard(cpus_read_lock)();
 	partition_sched_domains(1, NULL, NULL);
 }
 
-- 
2.53.0



