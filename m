Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF963F1AD9;
	Wed, 20 May 2026 17:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299617; cv=none; b=RATXW4aS11FVzeYS8opk7pgewtNNYE5FefHi87zHDj1YcJrXwvKPKmfgEZ+9jjcTO6uizgVvCZ4Iz9RhnKyGbhHqHgeYmEgFNJf2T3hlIATqXarp778LSn2C/bdC6hA/v+O3jc6DgElJKThjxwM9dvq18awD71ImhiyWWM+cXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299617; c=relaxed/simple;
	bh=jcLjCe0/qUTIY4ej+5pauQYKK6ofaTonCUry7ir2cyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klyiRc+0paCse9F0ESSrb211U8Av8UaC579FjEJ5b1ieWtX38aaOVI7HTFcFHV4+ctOyVwoSCbYLdKnkcIL2mBPEPdypUCdwCzatVEZ+TQ65jPGZdZw5BsLbtdW47kbtqFgG9J6WCZKrdaT2GT0Yu9BlPPn1ARgHP6IB7V3NeSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ld8BICsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ld8BICsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D8E1F000E9;
	Wed, 20 May 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299616;
	bh=C9u04gzvcFWqVyZ4L522o/2ktZc3bnc5jceYxUb3Vv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ld8BICsinzZkyclxjaOBl9Yar3VS3fPCSr0N5NmneY11P5aemITopnKA4AjjysxUv
	 DEgdRAnxyaL9sKVQPHWu3St2/Uu9X6JsgTpgzlE1DAFhMTQStKYa++Op1q9/OlpuOV
	 vQubGNA8jyAVMsA2maJsMgTVhyB3E8XNa/OBqRAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 838/957] bonding: print churn state via netlink
Date: Wed, 20 May 2026 18:22:01 +0200
Message-ID: <20260520162152.735182536@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4916f2e2f3fc9aef289fcd07949301e5c29094c2 ]

Currently, the churn state is printed only in sysfs. Add netlink support
so users could get the state via netlink.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260224020215.6012-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c4f050ce06c5 ("bonding: 3ad: implement proper RCU rules for port->aggregator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_netlink.c | 9 +++++++++
 include/uapi/linux/if_link.h       | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 286f11c517f76..ea1a80e658aeb 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -29,6 +29,8 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
 		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE */
 		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
 		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_ACTOR_PORT_PRIO */
+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_CHURN_ACTOR_STATE */
+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_CHURN_PARTNER_STATE */
 		0;
 }
 
@@ -77,6 +79,13 @@ static int bond_fill_slave_info(struct sk_buff *skb,
 					IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
 					ad_port->partner_oper.port_state))
 				goto nla_put_failure;
+
+			if (nla_put_u8(skb, IFLA_BOND_SLAVE_AD_CHURN_ACTOR_STATE,
+				       ad_port->sm_churn_actor_state))
+				goto nla_put_failure;
+			if (nla_put_u8(skb, IFLA_BOND_SLAVE_AD_CHURN_PARTNER_STATE,
+				       ad_port->sm_churn_partner_state))
+				goto nla_put_failure;
 		}
 
 		if (nla_put_u16(skb, IFLA_BOND_SLAVE_ACTOR_PORT_PRIO,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 3b491d96e52eb..69f19759b79d5 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1567,6 +1567,8 @@ enum {
 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
 	IFLA_BOND_SLAVE_PRIO,
 	IFLA_BOND_SLAVE_ACTOR_PORT_PRIO,
+	IFLA_BOND_SLAVE_AD_CHURN_ACTOR_STATE,
+	IFLA_BOND_SLAVE_AD_CHURN_PARTNER_STATE,
 	__IFLA_BOND_SLAVE_MAX,
 };
 
-- 
2.53.0



