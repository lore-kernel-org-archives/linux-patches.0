Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7191FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B980C433D2;
	Mon, 15 May 2023 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169095;
	bh=1A8cTbF0jHBnPWhQbliv1Tr/O1ZW7+ZwNQliOUNT0lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiPclU5RHFP+RcIrsxM2ozCbtK5mx4YzDMtu5kKxi05tFqzNdXjVqkeJzDNO8TiNb
	 lrYJLobjqEKcMjdCnoT+OuCXTqHtrxsBBxouOdsMql5QC13CMyqFvtC+xIvh6JURBy
	 3RrQwSyJ+4Gx1ukqeCPEwZPzLP+36OaVdFTE+PTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	rcu <rcu@vger.kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/191] tick/nohz: Fix cpu_is_hotpluggable() by checking with nohz subsystem
Date: Mon, 15 May 2023 18:26:17 +0200
Message-Id: <20230515161712.486849684@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joel Fernandes (Google) <joel@joelfernandes.org>

[ Upstream commit 58d7668242647e661a20efe065519abd6454287e ]

For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
torture tests that do offlining to end up trying to offline this CPU causing
test failures. Such failure happens on all architectures.

Fix the repeated error messages thrown by this (even if the hotplug errors are
harmless) by asking the opinion of the nohz subsystem on whether the CPU can be
hotplugged.

[ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]

For drivers/base/ portion:
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: rcu <rcu@vger.kernel.org>
Cc: stable@vger.kernel.org
Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cpu.c       |  3 ++-
 include/linux/tick.h     |  2 ++
 kernel/time/tick-sched.c | 11 ++++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index ce5b3ffbd6eef..878ed43d87539 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -494,7 +494,8 @@ static const struct attribute_group *cpu_root_attr_groups[] = {
 bool cpu_is_hotpluggable(unsigned cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
-	return dev && container_of(dev, struct cpu, dev)->hotpluggable;
+	return dev && container_of(dev, struct cpu, dev)->hotpluggable
+		&& tick_nohz_cpu_hotpluggable(cpu);
 }
 EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 965163bdfe412..443726085f6c1 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -197,6 +197,7 @@ extern void tick_nohz_dep_set_signal(struct signal_struct *signal,
 				     enum tick_dep_bits bit);
 extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
 				       enum tick_dep_bits bit);
+extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
 
 /*
  * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
@@ -261,6 +262,7 @@ static inline void tick_nohz_full_add_cpus_to(struct cpumask *mask) { }
 
 static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit) { }
 static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit) { }
+static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { return true; }
 
 static inline void tick_dep_set(enum tick_dep_bits bit) { }
 static inline void tick_dep_clear(enum tick_dep_bits bit) { }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7228bdd2eabe2..25c6efa2c5577 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -406,7 +406,7 @@ void __init tick_nohz_full_setup(cpumask_var_t cpumask)
 	tick_nohz_full_running = true;
 }
 
-static int tick_nohz_cpu_down(unsigned int cpu)
+bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
 {
 	/*
 	 * The boot CPU handles housekeeping duty (unbound timers,
@@ -414,8 +414,13 @@ static int tick_nohz_cpu_down(unsigned int cpu)
 	 * CPUs. It must remain online when nohz full is enabled.
 	 */
 	if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
-		return -EBUSY;
-	return 0;
+		return false;
+	return true;
+}
+
+static int tick_nohz_cpu_down(unsigned int cpu)
+{
+	return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
 }
 
 void __init tick_nohz_init(void)
-- 
2.39.2



