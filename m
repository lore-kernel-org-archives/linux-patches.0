Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704552;
	b=4brCESjwjSnqjgu7b9/kv7CitAfzCzeaoyHmSDhkuujLGYnaBzjiphzk+GTRNDGQmO75
	 tWqiykGMCHQb58hmFqOHD8tTtwrEoQhIiH9IRqlKYnXvJQpFyiknQO4X5rKQmc9M8RCzR
	 UmbOQeFlNV1WwAqsSKcam8Lsmt6TjOmfJNzJWccn95/gPMUDCDjokZTv+6QPi+XDPOKuI
	 uwiRE0RpbLU3mf+MYnUsJV4TV6qmXoaVVCG1Jdek2MrqXGHTuPPR1R/Zd9l1fuNqeIYcv
	 lLbmKBdNjOObX0cmaA8Qa7l40u5VjkKCCMuTH8iTB1l+31JZpe7lwzyjzAM/55myIDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CgJgckPsIBcr+QhLYafc7Lc/R6brcTPKElmxBMAZS4U=;
	b=Xck7XXDGYp05gqLGpyVwkbdR1siW7aW7XJa5cY9L9UEQg+ZH2jZ3kd5vx99Wq7K+ct0J
	 fKHm+f4cys1MrAKKY4PeNeJRmZhG/ehNkMQbkidt0eb7mY8XA5NKoxvSHyKyeegQsHu43
	 xNd/nK9DYDCO6YjmBWjA0XT3ijFvTtwi8iRWQ9ENcgL24ROaRltSOLx1RnAdyRrLy1Dzc
	 Xgs/AYYyBF2F4X1yppEo9VrTygmFIMY0CDyytVhgkA/alR4PWVV8QkgZRNNJMEj69Mks2
	 PKuFT8hEQ/AvQNSCRO8SSxfDOEDz4QGGZ5/G/xP4oB56ErgXI1ujt21psTubNpuw+TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHzV3WzZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE2A606A31C;
	Thu, 26 Nov 2026 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHzV3WzZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCBF1F000C0;
	Thu, 26 Nov 2026 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704552;
	bh=CgJgckPsIBcr+QhLYafc7Lc/R6brcTPKElmxBMAZS4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHzV3WzZNrGiJs7kJ5/ZPDhKNliedoHe3u48lIZOncCRjROCRipyxy/LcsQqfCc5k
	 lXjgEgoSskuR6/16UYHicj0i04Xp8OFwEZg/k5RpuKRL/ycF8FVXIgY7EdYgghyIcX
	 zT1d5VbZ980NaqG2xFcQcVmt/0s/GPeM1mM7vcn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 164/265] ipvs: fix protocol data lifetime during namespace teardown
Date: Thu, 26 Nov 2026 15:38:14 +0100
Message-ID: <20261126143616.603825399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 832aa3e89e806bb2667fe4e656b705f4088b3c9d upstream.

IPVS frees its per-net protocol data before control cleanup cancels
defense work and unregisters the sysctl table. A defense worker can load
a protocol data pointer, then namespace cleanup can unlink and free that
object before the worker dereferences pd->pp or pd->next. The worker's
securetcp_lock does not serialize with protocol cleanup. A concurrent
defense-mode sysctl write can reach the same timeout update path.

KASAN reported:

  BUG: KASAN: slab-use-after-free in ip_vs_protocol_timeout_change
  Workqueue: events_long defense_work_handler
  Call Trace:
   ip_vs_protocol_timeout_change+0x1b4/0x1e0
   update_defense_level+0x63e/0xd80
   defense_work_handler+0x1e/0xc0
  Allocated by task 125:
   ip_vs_protocol_net_init+0xda/0x2f0
   __ip_vs_init+0x16b/0x240
   setup_net+0xfc/0x310
  Freed by task 12:
   ip_vs_protocol_net_cleanup+0x1d6/0x2e0
   __ip_vs_cleanup_batch+0x7d/0x100
   cleanup_net+0x38c/0x770

Run control cleanup before protocol cleanup so that defense work and
active sysctl handlers have finished before their protocol data is freed.
Initialize protocols before exposing the control interface, and unwind
in reverse order, to enforce the same lifetime on initialization failure.
Protocol initialization and exit do not depend on control state.

Fixes: 9330419d9aa4 ("IPVS: netns, use ip_vs_proto_data as param.")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2436,12 +2436,12 @@ static int __net_init __ip_vs_init(struc
 	if (ip_vs_estimator_net_init(ipvs) < 0)
 		goto estimator_fail;
 
-	if (ip_vs_control_net_init(ipvs) < 0)
-		goto control_fail;
-
 	if (ip_vs_protocol_net_init(ipvs) < 0)
 		goto protocol_fail;
 
+	if (ip_vs_control_net_init(ipvs) < 0)
+		goto control_fail;
+
 	if (ip_vs_app_net_init(ipvs) < 0)
 		goto app_fail;
 
@@ -2461,10 +2461,10 @@ sync_fail:
 conn_fail:
 	ip_vs_app_net_cleanup(ipvs);
 app_fail:
-	ip_vs_protocol_net_cleanup(ipvs);
-protocol_fail:
 	ip_vs_control_net_cleanup(ipvs);
 control_fail:
+	ip_vs_protocol_net_cleanup(ipvs);
+protocol_fail:
 	ip_vs_estimator_net_cleanup(ipvs);
 estimator_fail:
 	net->ipvs = NULL;
@@ -2481,8 +2481,8 @@ static void __net_exit __ip_vs_cleanup_b
 		ipvs = net_ipvs(net);
 		ip_vs_conn_net_cleanup(ipvs);
 		ip_vs_app_net_cleanup(ipvs);
-		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_control_net_cleanup(ipvs);
+		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_estimator_net_cleanup(ipvs);
 		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
 		net->ipvs = NULL;


