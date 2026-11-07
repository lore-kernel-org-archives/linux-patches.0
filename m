Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063652;
	b=KQVHn8bLTgQSMOx/PWMw8AnxhJXY0XknQUV/URdQnSVuN+sG2ajOeIvlBUdFkRd1rEUr
	 YWOAOf2n+C4STTu3DrW+QL/B0SJ5P2VsB7ht5FtkQw9heccU7f47gKJEqB+yCOnfcqIvK
	 P3CBrKpZY+lxffbQJd0Te7MhEEuYU284l2lxkyjhj/c3Kl/AbcqasnyrS1FhNK7RWJwvI
	 v0iklRGFucUcnTc2X9LEvj2u1wKNWKk4wY1AkHlwcWKDb8nSbIOxBuGU2mpGKhqqF5QQN
	 fOLIFYWWiJZHpE8Taj+pvWZDkoRoiQL04FfO718gWzYTMx5xEf8kiLdYZwc2zyllJWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bP3Jn3IFCWF/sb2nK4NS0dtpz86DVYiXtONIg1XMhlg=;
	b=OXFRCsPVjHv/GS/kQoRGb8wRigbb2NPrd/E8Mf20TmWuwaXr0OGU5NWQQOAzo2sZpL8V
	 xj8B5FwUBBJxWsjYDX4DZNMVF8RZHl2BNbFs0ThkE8mMHa2iKeU9P2RjKcfpwMYgDbJdo
	 h4yJ31tl3pWqsBcKWyNs9k/GWvDsEJmkSP5tqY7CX2f+m8+I9M6JKkATteiMjIDRW7MOG
	 p6ZKraSs4MxBwgybxtkDOeW+7vCT3sCAeTwUUEw4DP1aQPPZcvYLoAs4MzXKbhpjEVDbG
	 5fLC6Z81mGV9TYpkGIAjoIHvz6xOEMj1pLA8Qf0ZxlGESep506h+nKZJ2RSMlrPCUhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zp3Bunil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C4606A9D4;
	Sat,  7 Nov 2026 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zp3Bunil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B731F0089F;
	Sat,  7 Nov 2026 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063652;
	bh=bP3Jn3IFCWF/sb2nK4NS0dtpz86DVYiXtONIg1XMhlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zp3BunilEyJyZixMUfRc0JEvG/oIAezTS2XyOGpMFl2Az9B/0RXApM3Fc9AUjtBtP
	 T7Iol5JL4WEcm7LxyZ5Fk09z9ayM9uqxkaXjzVngbrqPUva4mqymHhT6kAhKTdf2JR
	 6b8YC8cRHzdknS+Fh3U/mr8uTwTwDpVoT5p+2ilY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Eugene Lee <eugenehlee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 728/869] gve: fix out-of-bounds read in gve_get_flow_rule_entry()
Date: Sat,  7 Nov 2026 08:56:50 -0500
Message-ID: <20261107134917.470577147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



