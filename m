Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8926974C02;
	Mon, 15 Apr 2024 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192059; cv=none; b=Rz1xdREHu+Db3DQG6YKJQsyS9MBP3xFh9h3neUPAfyA+4nH/yKDjm12kNfgJtQkD8w+aEvt0/vCtQueEZUlKj0+SheDT43+JAAeCSElKadBGHIKYTEjBx13FkewiV/21bBHm+8KYfXspnGIQbb7NrXdRg3UaYpFa4ajkhR/DeVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192059; c=relaxed/simple;
	bh=RA2kS7ynZBlfZgu/7EMbaHrDGwkwK4M47KjZtDQnCOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfez49Im5At+dsYApmwJ/eEqQlthMjjLMIpt1Wdr12l5lJFhyg0e4jT/4ismoJi9Pjwa431owIQAXUyoq/FepU2haGsd4lfFEA3/pU5IfQRjGRByrpUSXaFXZ0imxoEFQjp0RlNDPYdFuan7vrCZWmXdNDJxBdMWxzb7NmDdqSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOP0NeMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOP0NeMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9D1C113CC;
	Mon, 15 Apr 2024 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192059;
	bh=RA2kS7ynZBlfZgu/7EMbaHrDGwkwK4M47KjZtDQnCOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOP0NeMtkMcJe3jLVZMC1nyn2ncvRM/4Q6WxHoPEzcbqYdWXD2Tqib3vrm93biiMc
	 WvuckiUVX+5sGSwlwdGzS1m53TBXW3Awj38iqauC8e79M89qTuXNwhz/jMzujmEiWR
	 cEtWENZdcp2f8kUINFcv+6+f83xDxvOD7NXv3FJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/69] net: openvswitch: fix unwanted error log on timeout policy probing
Date: Mon, 15 Apr 2024 16:20:45 +0200
Message-ID: <20240415141946.600795105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 4539f91f2a801c0c028c252bffae56030cfb2cae ]

On startup, ovs-vswitchd probes different datapath features including
support for timeout policies.  While probing, it tries to execute
certain operations with OVS_PACKET_ATTR_PROBE or OVS_FLOW_ATTR_PROBE
attributes set.  These attributes tell the openvswitch module to not
log any errors when they occur as it is expected that some of the
probes will fail.

For some reason, setting the timeout policy ignores the PROBE attribute
and logs a failure anyway.  This is causing the following kernel log
on each re-start of ovs-vswitchd:

  kernel: Failed to associated timeout policy `ovs_test_tp'

Fix that by using the same logging macro that all other messages are
using.  The message will still be printed at info level when needed
and will be rate limited, but with a net rate limiter instead of
generic printk one.

The nf_ct_set_timeout() itself will still print some info messages,
but at least this change makes logging in openvswitch module more
consistent.

Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/20240403203803.2137962-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0591cfb289d50..e4ba86b84b9b1 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1711,8 +1711,9 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	if (ct_info.timeout[0]) {
 		if (nf_ct_set_timeout(net, ct_info.ct, family, key->ip.proto,
 				      ct_info.timeout))
-			pr_info_ratelimited("Failed to associated timeout "
-					    "policy `%s'\n", ct_info.timeout);
+			OVS_NLERR(log,
+				  "Failed to associated timeout policy '%s'",
+				  ct_info.timeout);
 		else
 			ct_info.nf_ct_timeout = rcu_dereference(
 				nf_ct_timeout_find(ct_info.ct)->timeout);
-- 
2.43.0



