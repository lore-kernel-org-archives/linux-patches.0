Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3649479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4E6C433D2;
	Thu, 12 Jan 2023 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533375;
	bh=U3p1l0uvuumIupTf2Eh0Wc+HOPh3+9k/dv9xsFLziQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OsdB2bP46/E73ucoxIiHTqEKTh3fLJQlqwvnwZ9KpYP1ONQRiQ5S/DwlR87pZpdk
	 TuJ76QS7c8zQ6e8FV2YpEN/9xxz5QHnSwz5awlvysqBjy9nBmmCX4X9XCXCJ0Q8UV3
	 qZ7U6rYClPZ/3TBV9Q8yf/2wKfLmvj0QoQfaLfj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Emeel Hakim <ehakim@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/783] net: macsec: fix net device access prior to holding a lock
Date: Thu, 12 Jan 2023 14:52:54 +0100
Message-Id: <20230112135545.490678779@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit f3b4a00f0f62da252c598310698dfc82ef2f2e2e ]

Currently macsec offload selection update routine accesses
the net device prior to holding the relevant lock.
Fix by holding the lock prior to the device access.

Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Link: https://lore.kernel.org/r/20221211075532.28099-1-ehakim@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index eb029456b594..4fdb970e3482 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2584,7 +2584,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
-	int ret;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -2597,28 +2597,36 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 					macsec_genl_offload_policy, NULL))
 		return -EINVAL;
 
+	rtnl_lock();
+
 	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto out;
+	}
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
-		return -EINVAL;
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
-		return 0;
+		goto out;
 
 	/* Check if the offloading mode is supported by the underlying layers */
 	if (offload != MACSEC_OFFLOAD_OFF &&
-	    !macsec_check_offload(offload, macsec))
-		return -EOPNOTSUPP;
+	    !macsec_check_offload(offload, macsec)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	/* Check if the net device is busy. */
-	if (netif_running(dev))
-		return -EBUSY;
-
-	rtnl_lock();
+	if (netif_running(dev)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	prev_offload = macsec->offload;
 	macsec->offload = offload;
@@ -2653,7 +2661,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 rollback:
 	macsec->offload = prev_offload;
-
+out:
 	rtnl_unlock();
 	return ret;
 }
-- 
2.35.1



