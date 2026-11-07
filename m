Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062539;
	b=KpB3cb7D/h7ZXd9QIeh++SbzmLgg58Gg/kBr+fOLDv1yqpd/+h3KbHh13rfMKvxHZiB/
	 PArTDNUNvS82r6ZKkFTL41DC1bvmZMIwLgyTfdM7MRs5MyXGIotohkZCLyElkQu9Gmq3i
	 y/JkXJT/N2Clka7SsylPJm2o3FY57TQVm241r2EeO8Jxa2gjwDAl19/Q7BtsU2u+4Y/sq
	 ZUNUnr9P0CVVru6bIVG7qN+AhVeiZQ2AiEMlNtB2f3nt0/QN55JwIsgxIuqD4NOt0ISPA
	 U68/1zlLT7CdjAkC8xu2xlvyUsoRtkCiJb5vdPUilc9xX/GiNg8KSY72ynpl/6gKXLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8qbPpYyGCmwlSnTovXC+rbtH4wfFsINi70b1hLEM3w4=;
	b=dvjq9AaMCqT5tqb/rmMh/BcxyxfAPVRscq1ZB9ZSIrNmuBoCXI/PS377TPDcQ858mKPw
	 Mpz7WWc73rRgM6m0o+fH2s2tzemn1dUbA2zS+/MDxras9elIiLFG5H32FIHuaMGb4qnT5
	 bEVn0H844F2Pxt5BDx2tnUQFPKPwLPTLIWp1Jw6UnUDyXmsKsbyXBqUfbT8gI3jhHYeq5
	 VxJrnToWKmwmAMu96OznCs2N1j7N70FU/z4Ops4N29pJvWJImFU9ZMlDnI/RiRA4MaJ68
	 U9OZpnYyyr0139MQtthMepcj7nsGsmJLAq6uILkHpMEujh1xNwVlmFFESWuVAM4tTtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eITc8rQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF21606D80A;
	Sat,  7 Nov 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eITc8rQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB99D1F008A2;
	Sat,  7 Nov 2026 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062539;
	bh=8qbPpYyGCmwlSnTovXC+rbtH4wfFsINi70b1hLEM3w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eITc8rQFlU4UOdF3M29dlHYDURMKdEEXMs3pu8v0B9s2fHCmyAf/9wfDiKI/nPmq6
	 wVx8hCgkF1neRcM8+lClS6P9owCWbD5ZR6kRdRs5fdP4JdaY6clCg8n9grgxiY/mVi
	 +eHuDVfNmgCMj3Qzc5CYgW19Su0o046jyw43uh5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Eugene Lee <eugenehlee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1429/1536] gve: fix out-of-bounds read in gve_get_flow_rule_entry()
Date: Sat,  7 Nov 2026 08:57:25 -0500
Message-ID: <20261107135037.970175187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit 45e0a63f9c86a558afc70d79b6df38f8ec7f502a ]

gve_get_flow_rule_entry() checks the requested location against the
first and last cached rules, but rules_cache_num can be 0 while
rules_cache_synced is true: GVE_FLOW_RULE_QUERY_RULES returns the rules
from the requested location onwards, so a request past the last
installed rule - or any request when no rules are installed - returns
zero rules, which the driver accepts and marks as synced.

The next query evaluates rules_cache[*cache_num - 1] with
*cache_num == 0. The zero-initialised cache does not trip the earlier
comparison, *cache_num - 1 wraps to 0xFFFFFFFF in u32, and the read
faults about 352 GiB past the cache. ETHTOOL_GRXCLSRULE needs no
capability, so an unprivileged user can trigger it:

    BUG: unable to handle page fault for address: ff240996c4c64fa8
    #PF: supervisor read access in kernel mode
    RIP: gve_get_flow_rule_entry+0xd4/0x110 [gve]

Treat an empty cache as a cache miss and re-query.

Fixes: 6f3bc487565d ("gve: Add flow steering ethtool support")
Cc: stable@vger.kernel.org
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Eugene Lee <eugenehlee@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/AS8P251MB0001135AF3233180DC42DCD1C8672@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_flow_rule.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_flow_rule.c b/drivers/net/ethernet/google/gve/gve_flow_rule.c
index 0bb8cd1876a3f..426a264af8b26 100644
--- a/drivers/net/ethernet/google/gve/gve_flow_rule.c
+++ b/drivers/net/ethernet/google/gve/gve_flow_rule.c
@@ -206,6 +206,7 @@ int gve_get_flow_rule_entry(struct gve_priv *priv, struct ethtool_rxnfc *cmd)
 		return -EOPNOTSUPP;
 
 	if (!priv->flow_rules_cache.rules_cache_synced ||
+	    !*cache_num ||
 	    fsp->location < be32_to_cpu(rules_cache[0].location) ||
 	    fsp->location > be32_to_cpu(rules_cache[*cache_num - 1].location)) {
 		err = gve_adminq_query_flow_rules(priv, GVE_FLOW_RULE_QUERY_RULES, fsp->location);
-- 
2.53.0



