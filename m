Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1054231842;
	Wed, 20 May 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297010; cv=none; b=pVf0k+j7HpLIy9m+v2kF7UnfqrGMZbA+fEsgwTjrPvZRZ2AAMz0FvSJKtibuutpkYYbjbV1s3b5sWDLs2CAH3YNWl62Qf7/RNJaHakxGFpP3gGgiBWbRG9FWaYyJNefUsCWiaxOoxrzURVC3Xq9vgO0GNdjCpD2gf6IcZU2hoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297010; c=relaxed/simple;
	bh=FWynegx31euydPh2JlkNlV/FGJ3Qp9IFKVqwYxc6Wms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGze3vcGzD0hp0M0MH9+T9TRE5dtL7duYLYCEtHyIBJfc5VL6N7z2rqK/RKJTnQYqQP4cgRRbtmk5ua0e3SV10Mq68h54VeFH5zYHNPUVo8HomP427xgdNRWqr7+76mRpDA0XzNSUmvCj/j+bnqXvOmSKZfG72oVU9CLw+f6Fuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xp56E5Ls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xp56E5Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D1F1F000E9;
	Wed, 20 May 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297009;
	bh=7C2aNz0JgS71lOJson9pSzolRV8+3H+GkHjv41Zk0PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xp56E5Lsvbjqm4Sbg9c1AH6u+DEu+QymrrSJaYmfVcSwExtMzM0l8rwjUS2UmQEci
	 2NPFB1GTQFDCSjQYePpfXPbfLrw2RRi4WHqDBqK+o7WR2sNAM+7Y2tSGti3FwTM8uY
	 8n7PIEyP6X52IC/4H3v0zoZZFHMKdMs5TwpI5QFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1017/1146] bonding: print churn state via netlink
Date: Wed, 20 May 2026 18:21:07 +0200
Message-ID: <20260520162211.247422735@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e9b5f79e1ee17..83a96c56b8cad 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1568,6 +1568,8 @@ enum {
 	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
 	IFLA_BOND_SLAVE_PRIO,
 	IFLA_BOND_SLAVE_ACTOR_PORT_PRIO,
+	IFLA_BOND_SLAVE_AD_CHURN_ACTOR_STATE,
+	IFLA_BOND_SLAVE_AD_CHURN_PARTNER_STATE,
 	__IFLA_BOND_SLAVE_MAX,
 };
 
-- 
2.53.0



