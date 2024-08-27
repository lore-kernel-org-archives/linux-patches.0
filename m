Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D301CE71E;
	Tue, 27 Aug 2024 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772620; cv=none; b=CAh3DbkFikB27nHw8StFdu7xGd0AtPBJjE4obX2zoQxMpyNMgAGSpcBHGUHQlSOEZPZYlBkLFxsslg5Ml3a01deFETMpJ1jWhpzrsQ9pj3aC9TXIcHXuOzPo0HE3OyDSqHNWtbd3ctlcp4zm+L0jbW8dGnlgCRzt7GpwvefGx/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772620; c=relaxed/simple;
	bh=HTS32SPxh8lc6PJrREg31S5txXTl/pIcJTPEQ+gLZ4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SekiTOFe3ZTX8k86THwiGwyy+tN+LCCKFVpyYXlmC1ufRb31HnPvtS+AM9zToHjTiX1RLT9oIFXhe8GsYvECaRV3zh44KY5RkBLL+C+XtxcdWPTWX6Sgbgt2oFreffipN6E4UNyzvNULyIDjRyTy+RyG4l+yryIR3wCslFTZljU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLzT8eY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLzT8eY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23984C4AF64;
	Tue, 27 Aug 2024 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772620;
	bh=HTS32SPxh8lc6PJrREg31S5txXTl/pIcJTPEQ+gLZ4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLzT8eY43F87A4Z5QqIYPOFsGOJaTjN38MdCHhevfXBUAnjyqt2Zzd4ev37Am45JQ
	 +bnomsnpV19v/JJXbmHcviXMcM5fhW1gLhoBzya9DYFMnLEcLrQ93tF7mGPKe1xYDX
	 5rvpwYesi4oxFZeLyvDlTMcRIl4Fx53pgUruEJF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/321] bonding: fix bond_ipsec_offload_ok return type
Date: Tue, 27 Aug 2024 16:39:06 +0200
Message-ID: <20240827143847.295891422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index be5348d0b22e5..5c7b249a1bcfa 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -595,34 +595,28 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
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



