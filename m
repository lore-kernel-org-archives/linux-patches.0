Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92BA4F5E0E;
	Wed, 30 Sep 2026 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787378; cv=none; b=E8tjITMknse+1ebdvTk0J1rJvOTZ6JP6MsctSpNgUl9+y1bZnrKJC7KBetHhFkH+3o57sk5AryyKQQ0F8MteNumCy5Xn9cNUIbMuaq/Rm7DlEQfcya5J9DtemNsBsKG6nUv3q1r4eXakNhucwefTZKwhTHdqHqbw7Q1TDf4R4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787378; c=relaxed/simple;
	bh=ar8BtQow2cSypKBvcE3K6PoseSJrJWo7rIDlM7y+yrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvNH5kQ2JtbWBstn0ohX2TRT9vPu/zOgH4RhmB1RBQkqP0nQjMbNIzeesloFoBnkeiNwSMFSNrysmI48Fe8bU7a9+qXynTyrkp0nSR81LFwwxb+QwPgw9IQ3qqIh5O0WWR5tfgkzONqbKq5RMfDHodWUvsdwzz9dG6HefAihddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWKQJE0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWKQJE0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5851F000FF;
	Wed, 30 Sep 2026 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787376;
	bh=1UMvgx6gmOJmikti16q8Y6L+rXFLhdIPxgy8SgABlcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWKQJE0OaUD+N4RHuJ3T9VF6Y3gxc+0IZwHbJSSRjQY8gN0AAcNu1W2+p4cW8Uva4
	 iFqp6uOlDJvyE91LUNkov2cN1DNPjJOUz2RSkNrTepOPt4KrYNLWkk9EAdKLyESmen
	 wuIj7B7UtpeAopBbGI/h6Bbr1HvUu3FkeFIqG08U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Dai <zdai@linux.ibm.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 202/457] bonding: crypto offload enabled, non-offload slave failover, rekey failed
Date: Wed, 30 Sep 2026 17:25:07 +0200
Message-ID: <20260930152350.415392315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Dai <zdai@linux.ibm.com>

[ Upstream commit 00efbbd40bd5fd92c67b7cf1aab8904fa59a96f6 ]

Create a bonding device (i.e. bond0) in active-backup mode, 2 slaves.
Active slave: offload capable interface (i.e. eth1), primary interface.
Backup slave: non-offload capable interface(i.e. eth2).
Configure strongswan service swantl.conf child SA "hw_offload = crypto"
Start strongswan service
IPSec Crytpo Offload is enabled on top of bond0. i.e.
ip xfrm state |grep offload
        crypto offload parameters: dev bond0 dir out mode crypto
	crypto offload parameters: dev bond0 dir in mode crypto

Active slave eth1 takes adavantage of IPSec Crypto Offload capability.

If active slave eth1 is down for any reason (i.e. eth1 link down):
ip link set down dev eth1
non-offload capable interface eth2 failover to becomes active slave.
The existing SAs can continue use software IPsec after failover.
Traffic still keeps going properly.

However if eth1 link had not recovered yet, strongswan service does
new child SA rekey, or uses swanctl command to do new child SA rekey,
it will fail because active slave eth2 doesn't support crypto offload.
In bond_ipsec_add_sa routine, it returns -EINVAL now, which is
treated as fatal error by xfrm_dev_state_add routine in kernel xfrm.

To make the non-offload active slave survive the child SA rekey, need
to make bond_ipsec_add_sa routine returns -EOPNOTSUPP instead when
active slave doesn't support IPsec Crypto offload, the xfrm will
gracefully fallback to create new SA using Software IPsec.
Network traffic can keep going.

After offload capable interface eth1 link is up, becomes active slave,
next time strongswan child SA rekey will create a new SA which enables
crypto offload again.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: David Dai <zdai@linux.ibm.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260918211155.1664493-1-zdai@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6ea46a617ee60..34c5bbbed9aee 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -490,7 +490,7 @@ static int bond_ipsec_add_sa(struct net_device *bond_dev,
 	    !real_dev->xfrmdev_ops->xdo_dev_state_add ||
 	    netif_is_bond_master(real_dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Slave does not support ipsec offload");
-		err = -EINVAL;
+		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-- 
2.53.0



