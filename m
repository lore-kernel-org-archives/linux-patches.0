Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623003;
	b=BT+GvPS6LA3T1cima4RUwHalVbQBdRaYjxNPSKwwL2ydwkD5fK7mbgqp47KKzjeB/Dgi
	 oOcDjUo2rtL2yjw12RJL9A6ThFADw9QKPeE6V8VItttjBossDIlolue9Y3ryZxCe7So9G
	 wurGznw6IiN5s0/LUAtuGi3yXAARMnV0SmIGtKPhEE9rNUvTNGF+zgzH2sA8g9unTlT83
	 yvdxrSLF33FwaionXXx3i2Jj6lqgt5W0WqNa1tCmj8SF+QSYHEzzsLtqkZkWoH1B7QdoN
	 Dcu7g0DBaImYXL9U7kfGo+CFEuwKOSZoU/mWE3YOf0LCn08cO4ArdXjef3Vk6W/ED4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxtnl09ARr+7TuOyKyuZ1Vo6qrITK2Y/ELSsTyD55AU=;
	b=0VowkSyqLONkcGqonPIab2OK3AIDxAc+pQx9tkHt5TkHWHSpswwEgXRdfd9QvxAGd1Jg
	 oC8tkj8nq+F7tB6oW6GqddMGmlHvSV1/Nq3rSxifDMGkteS59fb5ipPuoiG+RcOVU4ObK
	 GaQnmiiKLo0PULwnOgEL5LUuz+tl8bs3N86KOKKXsDsJT6I/XkkjAoa1sYcBCBRpZwjj4
	 HEgy6xEtxeDE9M6tKjuLYZWWYf1Gq2Ylq19md1ByQFw6wI+VvbzAQoA4C0SGGkoxGPQ2V
	 sBm+NiWxEHk5XhgCyVmxoZ93r0HnOrpiUmFO/ABGCi+dtbdt3OuKygan0mdzBwbtV4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lscSj425;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6E5606A321;
	Wed, 25 Nov 2026 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lscSj425
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DFD1F000D1;
	Wed, 25 Nov 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623002;
	bh=nxtnl09ARr+7TuOyKyuZ1Vo6qrITK2Y/ELSsTyD55AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lscSj425cHC6YZeYEZH6ElTIK9zTFv1naZRAPlmdn4JWjh8LJa+RIPYv0uje6SjRp
	 Y0XUnMd7wvQPOubC7RX/K7GC45RQo6a2JZxgKHwoCiwO+HBy1qTNG9hc40ne7a9vyW
	 8qr8mfRFpbygIfNyvmWeW6qV87996c2a6dB2gn5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 717/990] ipvs: fix protocol data lifetime during namespace teardown
Date: Wed, 25 Nov 2026 15:34:44 +0100
Message-ID: <20261125143838.876675373@linuxfoundation.org>
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
@@ -2319,12 +2319,12 @@ static int __net_init __ip_vs_init(struc
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
 
@@ -2344,10 +2344,10 @@ sync_fail:
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
@@ -2364,8 +2364,8 @@ static void __net_exit __ip_vs_cleanup_b
 		ipvs = net_ipvs(net);
 		ip_vs_conn_net_cleanup(ipvs);
 		ip_vs_app_net_cleanup(ipvs);
-		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_control_net_cleanup(ipvs);
+		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_estimator_net_cleanup(ipvs);
 		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
 		net->ipvs = NULL;


