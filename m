Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216665;
	b=A+AetlBS9VW2lli8QmvaFWnAtShK/QtJJY/CWbEngXdKf8PlONT5KG3HzyGAT+NGrgP4
	 sCo4UcWiMkLecozdix31WcrmEhgjO4DC0uzpkEZSd7k59zzlXZ10ji8dNMeNhR8Aq2PtR
	 onTaJPcetNupU/pHukxvFxe4IRGZHfgUgO+rkoT6P9AHlaGsCR+SSg+9zcfh7wDjI2ACK
	 QgxijvoesCZxm6che6opyFxnbgkVm91MW4htluUhfwpvgzpooQ1Bzo8Y5eT0fNy+YWe9/
	 xEbJM1O8hLXYeYNgBpgqfE+AUk6GsP26tmdyK5LWGGQc8vp4ecyMvDcb+nvf96eVFEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/m1B3sDLCVoyvBv02UTJE+6vvexg6pcv2mXIKfl27Wc=;
	b=QdBlng72YwjJGPsd+p4XCh9/WL/grWW+Q2X49qT5ROirLu/dzyk9yW+8I+c9ZattGjNP
	 aTCgwwiU7y+pZD3Gsyg4v6SS4N3sDuj3PQr6JH29J/NQN1ktwIWdI0cHD2K6S7iG8l0mp
	 JAw2RyQN58wC5J/ZDMj9EX4cnvHjfsbp7nsLhdAlcQOXJzHczu00J8jllrafwRr1qGx4Q
	 itAOTkdZ2TGEkA9gmZPJknIcQqVd096FOr/LxsvrDAzpn8iAduHbEAEsb8IaZCukDLZP/
	 8FDwAnUQ2LzeDyynLPXzSbNw1Vl6XIIWvrT3ScWqG4QJlTlbsZ34XlyjumckETXj2sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiuJo6ck;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04D606A31A;
	Wed, 28 Oct 2026 19:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiuJo6ck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7331F01825;
	Wed, 28 Oct 2026 19:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216665;
	bh=/m1B3sDLCVoyvBv02UTJE+6vvexg6pcv2mXIKfl27Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiuJo6ck5pX9m/qxRFlWlS6r+IEQauRB4c7XoSwkip90Pfj5LUSZL2S/9gMWtB5FA
	 HmSObR3owlozaG7POBf1b6iB4zzai/vSiHZtR93KM6x9BYz9wmVTaOzH8mdJLBPDcB
	 7/3rVHjyxLxxjbsFFWJrxNipjp3ZU0n9Yxl8mD5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <ridong.chen@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1635/1887] cgroup/cpuset: Make nr_deadline_tasks an atomic_t
Date: Wed, 28 Oct 2026 18:02:11 +0100
Message-ID: <20261028170536.673372869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 95220e1f18f6321008f021abc7d6f581f64bcb82 ]

The nr_deadline_tasks variable in the cpuset structure was introduced by
commit 6c24849f5515 ("sched/cpuset: Keep track of SCHED_DEADLINE task
in cpusets"). It is reported by sashiko [1] that nr_deadline_tasks
can currently be modified by inc_dl_tasks_cs() under rq->lock and
by cpuset_attach() under cpuset_mutex. So if both updates happen
simultaneously, the nr_deadline_tasks variable can be corrupted leading
to incorrect operations down the road.

Fix that by changing its type to atomic_t so that nr_deadline_tasks
are always atomically updated. This fix patch is a low hanging fruit.
It can handle some of the races between a concurrent sched_setscheduler()
and cpuset_can_attach()/cpuset_attach() calls, but not all of them like
the other issue raised by sashiko [2]. This will be handled hopefully
in a future follow up patch.

[1] https://sashiko.dev/#/patchset/20260626181923.133658-1-longman%40redhat.com
[2] https://sashiko.dev/#/patchset/20260630033344.352702-1-longman%40redhat.com

Fixes: 6c24849f5515 ("sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets")
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h |  2 +-
 kernel/cgroup/cpuset.c          | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index f8e300ed0c34d..8e5c275d730da 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -151,7 +151,7 @@ struct cpuset {
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
 	 */
-	int nr_deadline_tasks;
+	atomic_t nr_deadline_tasks;
 	int nr_migrate_dl_tasks;
 	u64 sum_migrate_dl_bw;
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2700e6a1307b7..61736a4e105bf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -122,14 +122,14 @@ void inc_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
 
-	cs->nr_deadline_tasks++;
+	atomic_inc(&cs->nr_deadline_tasks);
 }
 
 void dec_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
 
-	cs->nr_deadline_tasks--;
+	atomic_dec(&cs->nr_deadline_tasks);
 }
 
 static inline int is_partition_valid(const struct cpuset *cs)
@@ -925,7 +925,7 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	if (cs->nr_deadline_tasks == 0)
+	if (atomic_read(&cs->nr_deadline_tasks) == 0)
 		return;
 
 	css_task_iter_start(&cs->css, 0, &it);
@@ -2515,8 +2515,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
 
 	if (cs->nr_migrate_dl_tasks) {
-		cs->nr_deadline_tasks += cs->nr_migrate_dl_tasks;
-		oldcs->nr_deadline_tasks -= cs->nr_migrate_dl_tasks;
+		atomic_add(cs->nr_migrate_dl_tasks, &cs->nr_deadline_tasks);
+		atomic_sub(cs->nr_migrate_dl_tasks, &oldcs->nr_deadline_tasks);
 		reset_migrate_dl_data(cs);
 	}
 
-- 
2.53.0



