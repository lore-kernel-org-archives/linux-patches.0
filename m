Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED080208A7;
	Sun,  1 Sep 2024 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209622; cv=none; b=SPVA6Zl0vJh+X6B7Ik/Mpsk06PsVCO+7pVxYuUlX9jGUPOAfdjbdpmbji4sJDByLEvEQ12dapDMpMw0FTAHSZAjFmFtNPVqkm/MTW9NTV+mWFLWvV1yT7zbEggC4zuyfoi4xtMYlUx9nsNRULaSqg5E0xJNpkXYorNuT3GdDWL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209622; c=relaxed/simple;
	bh=sw8kQ4hLEBrK4XWe4JsOUn295LAepCsU6jWfQzlhFKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK4KgrisQ1Il329ezkTj9hmUfcGlk1zl+gOkUDAkGV/bePvBtKDVC9Eg4RoUeOvNjrkdRvUEjXL57E7mIKqrYVj42rk+5qNjhyg2yBHoVcPS2MSdbE6kZ196GQbji9+w7+duCvo+y+Puw8q6I5QlzCpDwNIuzhLEjg1dHlaMf28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLo3krW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLo3krW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F7EC4CEC3;
	Sun,  1 Sep 2024 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209621;
	bh=sw8kQ4hLEBrK4XWe4JsOUn295LAepCsU6jWfQzlhFKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLo3krW1w1QC9IH2afqhHtpOk8KM2te/czXsYw3Z2ZYH1Zf7PCm7PbhiDQOC4gbso
	 kLgg8KEz40GaqP274hlcy5mkBOj70RQ008jC/knLDuCcjOLCRzT9jGPtr/cdSgghxZ
	 8iZKYDZ6SgGLASNgRXC/ZgLGlYh3HZo9kwpl30BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/151] bonding: fix bond_ipsec_offload_ok return type
Date: Sun,  1 Sep 2024 18:17:32 +0200
Message-ID: <20240901160817.577293685@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit fc59b9a5f7201b9f7272944596113a82cc7773d5 ]

Fix the return type which should be bool.

Fixes: 955b785ec6b3 ("bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c07b9bac1a6a0..349f1c9dd5881 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -557,34 +557,28 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	struct net_device *real_dev;
 	struct slave *curr_active;
 	struct bonding *bond;
-	int err;
+	bool ok = false;
 
 	bond = netdev_priv(bond_dev);
 	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
 	real_dev = curr_active->dev;
 
-	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		err = false;
+	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 		goto out;
-	}
 
-	if (!xs->xso.real_dev) {
-		err = false;
+	if (!xs->xso.real_dev)
 		goto out;
-	}
 
 	if (!real_dev->xfrmdev_ops ||
 	    !real_dev->xfrmdev_ops->xdo_dev_offload_ok ||
-	    netif_is_bond_master(real_dev)) {
-		err = false;
+	    netif_is_bond_master(real_dev))
 		goto out;
-	}
 
-	err = real_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+	ok = real_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
 out:
 	rcu_read_unlock();
-	return err;
+	return ok;
 }
 
 static const struct xfrmdev_ops bond_xfrmdev_ops = {
-- 
2.43.0



