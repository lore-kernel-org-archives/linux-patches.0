Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210031;
	b=YyObPNQpaVtu8Dy+AVSaEf3DsyM5sLrF+uS9TC14NNFKeFT0LBoi9CrTwr2ICz3bTunL
	 Lr7wAj3bLudp5pQoJynK51U2Dq3rpk8+CIL/2F5uvQjMutXp8j+Ro6YInsj4LBEL77y5Z
	 awxtSMU9CvYYd2kj9rAMf0vSKOSbvUcjhJXjaY7p+ZyT11R2+ueLatEx3t+IqKeSMnFZ2
	 MRFCrSxhkKSeIrCx9T4YCt5wi+737aYvfIqIO7NNcrsTnwiRJS07GArO+pBFjmRa9yfnn
	 iieau5b6d5QTt4GwbHJ/8v4b+HW4r8LmJzvQiNidCK/q1PjOJx/ZL1Q9b4+AxvzUi8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rPGSEoWPCxIO1nPmFT1o6z4LRZu1TLrcl3WWtFd4eVQ=;
	b=Bug2HkHC4JGpfePt71ijOYdIriTwf0DGwhYXAl5vQIBdCQWUG5x55iGEil03Ohi5nqc1
	 HyuWBQxkImWToSCFgPCLBTeSGtt1eSBJepGw4PL9KsH3V43fU5YdDZchwMkX7OYQuWb1U
	 RioqMC1QG48KNfLPv+kNey8YJ6IoREnVcDtmNvso2JCcfhNBAXwXm2n3fGMraUBd7oONM
	 VUnV8hWCcK3ap/RnCRlIEM7u/O1y15rjzmtwBCWhq3pY2o2pmcmv3Z4bfTCqfw1YbtDdv
	 fl+rVxPPe7VG/Lw/S8P+JdbMoY+P6Rnm4Yffuhd7ZwnF2qDj6lKWgz531UhdFnZBWZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tfhhEi1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EEA606A31C;
	Wed, 28 Oct 2026 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tfhhEi1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2EF1F01825;
	Wed, 28 Oct 2026 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210030;
	bh=rPGSEoWPCxIO1nPmFT1o6z4LRZu1TLrcl3WWtFd4eVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tfhhEi1LvIKuHu8Y4TyQAxinChJP6IgO5C6g1IoBtPcUjeRj/EZiS48kmAswTOA6
	 tLiL3zlof3+vZLwrt8iuWga3bE9yDylfn+rkEzoKyz5JibVyeIuipBeGzKpaY+8vci
	 DG7ilTgQKTDzp3PGgd1YbaOYePAudog5cKftHn88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Michael Kelley <mhkelley@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/168] Drivers: hv: Avoid infinite retry loop in init_vp_index()
Date: Wed, 28 Oct 2026 17:59:03 +0100
Message-ID: <20261028165943.267721671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



