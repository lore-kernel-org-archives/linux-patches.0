Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A7D439010;
	Tue, 21 Jul 2026 22:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671699; cv=none; b=hhV9hG4TVaAvUbmGCkapuVJNYnC5BbVjt9ldI5o+u1nJON7kU0VtnJAdVRiHtVXnKb9HXZGW9/tLKTKTeAaJT70E9/pekzKzYeo98OecIxtkZO/2DeGtc3gD3PF0Lapli/PPn+5iKy31QkA0YISauW7aXOV8aOQf0iK0XlyBj30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671699; c=relaxed/simple;
	bh=vq4ceui/Dk/6ZjYPwu6e2W38R6WR+Nkh9rQ/HaFntcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrELuwp9WcFnP3OnrzvxHv0ESdqSijnvHgqZl3nyqVYH2g6mpml1JlWdqSlwTzcgPmYVbsJxWjZh4lvsl8uzZnp7o72/OFK+oSSRBNS65wVpXd3+b7id1w7FErokA6T0L2VeUc7lJjtWoVmDleJhehsD8oxxXv8Y4zDRextw28s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwnWjJ7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwnWjJ7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E601F000E9;
	Tue, 21 Jul 2026 22:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671693;
	bh=9uC3WHBBEa4Dppj8ElaHi46pHxmn69X22M8AEpeH/k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwnWjJ7L3A/7VdmXfauEUEAmcVwRO2aaxOglnH+d4FTJy88I1rRSE6ODIxW3idiXz
	 xqZn8cjs5VQgjjHggFp3BGlCgmuWmG+iiIORiLc8UEifys3ciZh4MFH+IoOjte5Chn
	 7gzoLQEoiFFk/PRHcpeRcfRuDY91aS2gnrjtSrGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/843] bridge: cfm: reject invalid CCM interval at configuration time
Date: Tue, 21 Jul 2026 17:19:37 +0200
Message-ID: <20260721152413.719852119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit f3e02edd8322b31b8e6517faa6ba053bf29d1e26 ]

ccm_tx_work_expired() re-arms itself via queue_delayed_work() using
the configured exp_interval converted by interval_to_us(). When
exp_interval is BR_CFM_CCM_INTERVAL_NONE or out of range,
interval_to_us() returns 0, causing the worker to fire immediately in
a tight loop that allocates skbs until OOM.

Fix this by validating exp_interval at configuration time:

 - Constrain IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL to the valid range
   [BR_CFM_CCM_INTERVAL_3_3_MS, BR_CFM_CCM_INTERVAL_10_MIN] in the
   netlink policy so userspace cannot set an invalid value.

 - Reject starting CCM TX in br_cfm_cc_ccm_tx() when exp_interval has
   not yet been configured (defaults to 0 from kzalloc).

Fixes: 2be665c3940d ("bridge: cfm: Netlink SET configuration Interface.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260609065116.2818837-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_cfm.c         | 6 ++++++
 net/bridge/br_cfm_netlink.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index a3c755d0a09de9..a89aec83141648 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -805,6 +805,12 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 		goto save;
 	}
 
+	if (!interval_to_us(mep->cc_config.exp_interval)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid CCM interval");
+		return -EINVAL;
+	}
+
 	/* Start delayed work to transmit CCM frames. It is done with zero delay
 	 * to send first frame immediately
 	 */
diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
index 2faab44652e7c0..91b9922dc3f25e 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -34,7 +34,9 @@ br_cfm_cc_config_policy[IFLA_BRIDGE_CFM_CC_CONFIG_MAX + 1] = {
 	[IFLA_BRIDGE_CFM_CC_CONFIG_UNSPEC]	 = { .type = NLA_REJECT },
 	[IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE]	 = { .type = NLA_U32 },
 	[IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE]	 = { .type = NLA_U32 },
-	[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL] = { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL] =
+		NLA_POLICY_RANGE(NLA_U32, BR_CFM_CCM_INTERVAL_3_3_MS,
+				 BR_CFM_CCM_INTERVAL_10_MIN),
 	[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]	 = {
 	.type = NLA_BINARY, .len = CFM_MAID_LENGTH },
 };
-- 
2.53.0



