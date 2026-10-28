Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207440;
	b=ydALvS1ugiwAf5A6UZCcaBErY3NRF5qqb4VLKxMkd4IAthBLcVIbCOObKKGS2ObkFx4i
	 OiD5kXAnmYtgHCrvtlqHTlGPiBSpbIYP6jQdqHXRujmVcMnXr4gkJh6+PQ/k3ZMYzgXTe
	 KPFWEGK6qvAWNMMq67q4fTyMzGkDThPBVGU/CP41lPEttXmo6JcrijBtGoOML/BAoMDjm
	 gCfXGzWtnBgTUoNVSmQWfK/vAuMqH10Oa9QhWu/XrS8y4L3LAnMlbSn/KAKxpHWVZArlF
	 R6hzJN7GyrkIZTT9U1rCkKdCnQnKNjLvkl4fgSxlE1OwWlKZfutsdiu/rpzLiE4T6sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vuh5tu5OrtKGHy3JTUynN79mgFwS3rt3Smzdk4owx5Q=;
	b=Il9lqMKitu8acSWlC68Ago1ZYwOyVFgjU2W/s0vc9xP2BBA/Y+Hd1xAt52sl6rVaeslX
	 xtToTZPcO7rio5kBOrEN4ggZU2eVnDZKerbL3Lm6Ovxw4REuAYqIJ6GyTTuPYlLlUwbql
	 5U1hBypG016tNBFln/76buG3KPkxIAacwmDmmaXPsthI6GPuR8iZvQYfkd/0vONhVkfgx
	 V+PrHKjWLmSnHjE1UP/yU7sMIScd0A8whqZk1XkgngGHi3aFeyb4GIjDqPSE2C374ej9/
	 MvV7NYJmog4kYwk1FrcuMfTArgwicAS7A6V87r8eeCeWD6AhRu65tWSBnpXnoyu0a8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XH4r7EbH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC2E606A31A;
	Wed, 28 Oct 2026 17:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XH4r7EbH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5F71F01825;
	Wed, 28 Oct 2026 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207439;
	bh=Vuh5tu5OrtKGHy3JTUynN79mgFwS3rt3Smzdk4owx5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XH4r7EbH4Rl2IBOy9buvEtFTyVKs8phfWqV1jcaaJjJxlJGKVKvbFGZc0G/eWlSax
	 IFCXNxWt1hdEWifWm1NeHAwcU6eUvZvSSte1RSuDelyngRIpRNbIxQEKxGigAvYFHs
	 vrx8Z0dE2dm1RMnw33bVaXgJjQ0nzdjWZDD7tn4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Michael Kelley <mhkelley@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/247] Drivers: hv: Avoid infinite retry loop in init_vp_index()
Date: Wed, 28 Oct 2026 17:57:01 +0100
Message-ID: <20261028165947.791342987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 32ea0a33e3a0fb7c10c601b43e1b2f6c06a3f5fd ]

There is a retry loop in init_vp_index() where the CPUs from a certain
node are stripped out if they have already been in the allocated cpumask
or not in HK_TYPE_MANAGED_IRQ housekeeping cpumask. If there is no
CPU left, the allocated cpumask is ignored and the process is retried
again. However, if the HK_TYPE_MANAGED_IRQ housekeeping cpumask turns
out not to contain any CPU in that particular node, that will become an
infinite retry loop.  This particular problem was reported by sashiko
[1]. This should rarely happen, but we still need to guard against this.

Fix this infinite loop problem by also skipping NUMA node that has no
housekeeping CPU in the inner while loop of init_vp_index(). Also update
the early abort check to check for the absence of online housekeeping
CPUs instead of just the emptiness of the cpumask. As the outer for
loop will only be reached if the housekeeping cpumask has at least one
online CPU, a NUMA node with housekeeping CPUs will eventually be found.

Link: https://sashiko.dev/#/message/20260422030903.E1BFCC2BCB0%40smtp.kernel.org [1]
Fixes: 6640b5df1a38 ("Drivers: hv: vmbus: Don't assign VMbus channel interrupts to isolated CPUs")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Michael Kelley <mhkelley@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 3c6011a48dabe..914d479d78723 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -743,13 +743,14 @@ static void init_vp_index(struct vmbus_channel *channel)
 	u32 i, ncpu = num_online_cpus();
 	cpumask_var_t available_mask;
 	struct cpumask *allocated_mask;
+	const struct cpumask *node_mask;
 	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 	u32 target_cpu;
 	int numa_node;
 
 	if (!perf_chn ||
 	    !alloc_cpumask_var(&available_mask, GFP_KERNEL) ||
-	    cpumask_empty(hk_mask)) {
+	    !cpumask_intersects(hk_mask, cpu_online_mask)) {
 		/*
 		 * If the channel is not a performance critical
 		 * channel, bind it to VMBUS_CONNECT_CPU.
@@ -771,14 +772,19 @@ static void init_vp_index(struct vmbus_channel *channel)
 				next_numa_node_id = 0;
 				continue;
 			}
-			if (cpumask_empty(cpumask_of_node(numa_node)))
+			/*
+			 * Try next NUMA node if current NUMA node has no CPU
+			 * or doesn't contain any housekeeping CPU.
+			 */
+			node_mask = cpumask_of_node(numa_node);
+			if (!cpumask_intersects(node_mask, hk_mask))
 				continue;
 			break;
 		}
 		allocated_mask = &hv_context.hv_numa_map[numa_node];
 
 retry:
-		cpumask_xor(available_mask, allocated_mask, cpumask_of_node(numa_node));
+		cpumask_xor(available_mask, allocated_mask, node_mask);
 		cpumask_and(available_mask, available_mask, hk_mask);
 
 		if (cpumask_empty(available_mask)) {
-- 
2.53.0



