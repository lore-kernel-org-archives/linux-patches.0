Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021936;
	b=2mglTPOnioj/puA/h703s8EjBPs1yQP6OoPsDNfK4gLH0f5DggS71Y40MvN40x4C8ZRr
	 c5MR04UodbfPDUUMT0o2kQ/4gpD9Ps9UckpkkyixEIYXGQ8rlh5VruebZtVksTXFzkquv
	 dIgWZlwcGMmH4BHUQvBYRX0AYHOg30diPtC2RYbHmGRtL9G2rB0+nZ02gZCIBfkz1eHc2
	 Py/xeaO0Sl1o74qmtilcleFBmh7Y36hy6o29Ah7/LtCEWQasMKthTJlTKipjX9MmUbMDQ
	 9zSReLh3XXTT3GXOMXcxvsESFuKWoNzOhk7ayw/QeEYqBEkS8yLc+/ENUNJh0QRtnKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ttrp5bztsCdftF7LBzibONSuSlyR7GeX1VSqO6vVCs=;
	b=BTawc9/d3aIXJABmEjkZo2X4/ekwQgnY6LEOpcJhExNKDN8cEKix3T9RjVzGfkeNekLj
	 BiCqWekKphjWK9aJYpvr8E7T6jo500h15+Tt3ec17AWSXAWQmVKFS4wiDnHpITkhStUaI
	 R9hfC5Z/dlzZgJQTxsuLuGBDJf1wnuo+SIIZCLXVLbs3ibb+UtfiWt+zikVbHmiHh2VGh
	 WNX0+YTXjhmfQ9pWkV+5svx4gfQSSoelMJYBo8k2B2WpSrovXPoTWzFratKzOzX/CfAX5
	 lJ3JdBqXHTuuPNFuxcqMCnoA9qh+gzvaPo5ASdYaXpPVzewF3r13O6H3K26MAyPBmYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2AZkzHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA9E606A31C;
	Wed, 18 Nov 2026 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2AZkzHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8331F000C4;
	Wed, 18 Nov 2026 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021936;
	bh=+ttrp5bztsCdftF7LBzibONSuSlyR7GeX1VSqO6vVCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2AZkzHwsCoRnzaEZxpy1Hqt9MMpS+8JJOrbfV0eYY3jKxu8d+iEQV7DFX1M8YPqv
	 wq9ZfXmYblWHsqzoOGh0axfJulJLdojNrZztvVDaSnQC+CHudhNwzMgDYmLHVv0XZh
	 Amav6Q9QWiixQsewgmObHr/nnUhcfgSlI2o7dvdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2483/2651] sched_ext: Fix the bypass load balancer stranding tasks on cpus where the host lacks SCX_CAP_BASE
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150414.300016924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 53cc8dd06944979fd6a4754958aa8d6fa159f2da ]

The bypass load balancer spreads a host's bypassed tasks over the cpus of a
node by moving them between its per-cpu bypass DSQs. It counts every cpu of
the node as capacity and takes any cpu below the target as a donee. A cpu's
dispatch only descends into schedulers holding SCX_CAP_BASE on it, so a
bypass DSQ on a cpu where the host lacks BASE is never consumed. A task
moved there sits until the host regains the cap or the bypass window ends.

Count only cpus where the host holds BASE as capacity and pick donees from
them. The target rises to spread the node's tasks over the cpus that can run
them, and a capless cpu receives nothing. A capless cpu with tasks is still
an ordinary donor, offloaded down to the donor target when its queue grows
past the threshold; draining it is left to the following patches.

Fixes: 147d1885f390 ("sched_ext: Add the SCX_CAP_ENQ_IMMED cap")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 996ebfca769c4..0faa4877d8a6b 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -6036,7 +6036,9 @@ static void bypass_lb_node(struct scx_sched *sch, int node)
 		u32 nr = READ_ONCE(scx_bypass_dsq(sch, cpu)->nr);
 
 		nr_tasks += nr;
-		nr_cpus++;
+		/* only a cpu whose dispatch consumes its DSQ is capacity */
+		if (!scx_missing_caps(sch, cpu, SCX_CAP_BASE))
+			nr_cpus++;
 
 		before_min = min(nr, before_min);
 		before_max = max(nr, before_max);
@@ -6055,7 +6057,9 @@ static void bypass_lb_node(struct scx_sched *sch, int node)
 
 	cpumask_clear(donee_mask);
 	for_each_cpu_and(cpu, cpu_online_mask, node_mask) {
-		if (READ_ONCE(scx_bypass_dsq(sch, cpu)->nr) < nr_target)
+		/* a donee's DSQ is consumed only if @sch holds %SCX_CAP_BASE */
+		if (READ_ONCE(scx_bypass_dsq(sch, cpu)->nr) < nr_target &&
+		    !scx_missing_caps(sch, cpu, SCX_CAP_BASE))
 			cpumask_set_cpu(cpu, donee_mask);
 	}
 
-- 
2.53.0



