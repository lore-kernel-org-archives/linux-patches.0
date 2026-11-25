Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622742;
	b=vvG26yg3Pvtlf1X6QlF+pzFtYvpmFeYWcklmHl+WzIV7XC/B7bajxmynhYjspwfQmtcI
	 7v4dkWC+T/GGAb2e8V8I/UmdaWiRHzToEkm88CZmisXDvJLN2dZB4RyueBZK4YVCJ4i0P
	 2dg3AhtJSo6lweuSQ5KAKI/10YT3bZFv991KRxiUrYzSc94CbVPfIibS2v30TFPqpOeko
	 O4hPVEMRbwrIJE/0p2mAT7NmcC+vMEHKuE/cR5OYwUBhlV+Ll39aePmLw3iYV3noXEsO4
	 pG10AHJX7jQatrr984o1jLeyN89VBt5PW/QlVWmsUIcXXwl6xnsCrJfaewdc9oN4Pwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/1GzfEOS0mEVfgIf+YpxxsQDF+XWUfzNYBDnwscqqWU=;
	b=gc81rrU4XMov3RKUNUp1h0rSXKHCBgP73sjAqbH51Pstm/Ok96EEV2UZceDl0tb9wlLj
	 pr3Zjc9WBRcj/Kwxyg9/y/Gmn209ealTXF/XLYQG16nV2UeRzYnBs25l+Ow/v6J4a33EU
	 xNjH4tjIhAmysxVhIZQkGnTdrcEJr0Fds+tqAzuoafDHvEwJcVmC35rbmYStRntr3o50+
	 D6YrJNn4DR6V8cRZqxb9Qi8dTYJeeqRzgAmqWEK6vbnQRENvzFBx2mpMumPmuFcpr02Fo
	 Hu56EccerGj+E7XKFOGfZRYmy8Ud+SO6ws16aZZSWUGYHYjJhvTSYrTxK9U2MqJ5A5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMiokcim;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA10F606A31E;
	Wed, 25 Nov 2026 16:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMiokcim
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A431F000C6;
	Wed, 25 Nov 2026 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622742;
	bh=/1GzfEOS0mEVfgIf+YpxxsQDF+XWUfzNYBDnwscqqWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMiokcimDNIuRwluWc71Q1vDfpgK/ZUgP8uVN22bC9rAmvct5UtGKAzy/XHZXZMeY
	 lFL57T4NeH/eKY7WSCJQ6DDCHMwkjVcVy2Ttl+YqabwdZpKcffj5azB2j1lnFcUULo
	 l8JNsx/aPnsrloIItQMZh9BIOnFi5gsKv5eOLQCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 631/990] cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()
Date: Wed, 25 Nov 2026 15:33:18 +0100
Message-ID: <20261125143836.878292810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 10a6f00d82544a1baa901de8d28f41f28c364995 ]

Guopeng reports that changing the cpumask of a remote partition root
may set the effective_cpus of the top_cpuset incorrectly. It is
due to the following call sequence:

  update_cpumask()
   -> partition_cpus_change()
    -> remote_cpus_update()
     -> update_sibling_cpumasks()
      -> update_cpumasks_hier()
       -> remote_cpus_update()

The second remote_cpus_update() call passes in the cs->effective_xcpus
instead of the trialcs->effective_xcpus of the first remote_cpus_update()
call.  As a result, the second call can revert what has been done in
the first call leading to incorrect effective_cpus of the top_cpuset
as well as subpartitions_cpus.

Fix that by adding a new remote_partition_updating flag into the cpuset
structure to indicate that a remote partition is being updated and
update_cpumasks_hier() should skip the whole subtree as update_cpumask()
or update_exclusive_cpumask() which calls partition_cpus_change()
will eventually calls update_cpumasks_hier() for that subtree anyway.

This new flag is currently set only in remote_cpus_update() to prevent
recursive call of remote_cpus_update() on the same cpuset.

A test case is added to test_cpuset_prs.sh to verify this change.

Reported-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Link: https://lore.kernel.org/lkml/20261010075947.333549-2-guopeng.zhang@linux.dev
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: adjusted struct field placement because remote_partition bool is missing, and added :S+ to the new selftest row to match this tree's row format. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h                   |  5 +++++
 kernel/cgroup/cpuset.c                            | 13 +++++++++----
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 0eb9ebd4fcb92..89acf907e7354 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -161,6 +161,11 @@ struct cpuset {
 	/* partition root state */
 	int partition_root_state;
 
+	/*
+	 * Set to true when a remote partition is undergoing update.
+	 */
+	bool remote_partition_updating;
+
 	/*
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index d2bedfbd533de..b63489f9d3765 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1833,6 +1833,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			goto invalidate;
 	}
 
+	cs->remote_partition_updating = true;
 	spin_lock_irq(&callback_lock);
 	if (adding)
 		isolcpus_updated += partition_xcpus_add(prs, NULL, tmp->addmask);
@@ -1855,6 +1856,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	 */
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
+	cs->remote_partition_updating = false;
 	return;
 
 invalidate:
@@ -2323,16 +2325,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		old_prs = new_prs = cp->partition_root_state;
 
 		/*
-		 * For child remote partition root (!= cs), we need to call
-		 * remote_cpus_update() if effective_xcpus will be changed.
-		 * Otherwise, we can skip the whole subtree.
+		 * For a child remote partition with remote_partition_updating
+		 * set, we can skip the whole subtree as the this function will
+		 * be called eventually. We can also skip the subtree if the
+		 * effective_xcpus isn't going to be changed. Otherwise, we
+		 * will have to call remote_cpus_update().
 		 *
 		 * remote_cpus_update() will reuse tmp->new_cpus only after
 		 * its value is being processed.
 		 */
 		if (remote && (cp != cs)) {
 			compute_excpus(cp, tmp->new_cpus);
-			if (cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
+			if (cp->remote_partition_updating ||
+			    cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
 				pos_css = css_rightmost_descendant(pos_css);
 				continue;
 			}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7a077f4365072..bd06324af3843 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -277,6 +277,7 @@ TEST_MATRIX=(
 	" C0-3:S+ C1-3:S+ C2-3    C4    X2-3   X2-3  X2-3:P2 P2:C4-5 0 A3:2-3|B1:4-5 A3:P2|B1:P2 2-5"
 	" C4:X0-3:S+ X1-3:S+ X2-3  .      .      P2     .      .     0 A1:4|A2:1-3|A3:1-3 A2:P2 1-3"
 	" C4:X0-3:S+ X1-3:S+ X2-3  .      .      .      P2     .     0 A1:4|A2:4|A3:2-3 A3:P2 2-3"
+	" CX1-6:S+ C1-4:P1 .    C4-5     .    C1-3     .      .     0 A1:4-6|A2:1-3|B1:4-5 A2:P1"
 
 	# Nested remote/local partition tests
 	" C0-3:S+ C1-3:S+ C2-3   C4-5   X2-3  X2-3:P1   P2     P1    0 A1:0-1|A2:|A3:2-3|B1:4-5 \
-- 
2.53.0



