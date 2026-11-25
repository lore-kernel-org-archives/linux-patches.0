Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619039;
	b=Hh0HusDbNiKxc+LwaKkv6jHwgGp9kmMjrKx9VByFR0VN0cmj84xXHUitZlm6Txe1e3FS
	 GoAahVKMl6ZbdxT1IGskFbY8ulUZJi1ehm1jXIEQO6uwmCqpt+1KdtUq84vNXOTT2wsre
	 dpgNvmTTA6BQuWSab8/hV+QXCYF144jU5xmvRsS985DEJz+pg6gl7P+GA7Ahv0dVGY7xY
	 QMGp8M73q1KvWzfpzDnvxi+XrWgaGVXJC9Z/a0AKTD5Y3Z6C0ArZBxQedYduN0X/VsU8f
	 10dCGVdYjCPCJbOOu4KDrDaeyW39fRzxx5wgdxjThRNLCogtx+oFXpiXEUBpo/7kJDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ODFxbGoOHM3evWs3z04v0ZVj7M/5DK379NaKWKoqQFg=;
	b=j4P9ZRRgi4aSrnitiL7jXTJieyK0hqb0zCeMjme5I33YHPsAMvqwCE3CMbkh7BD7NqhJ
	 IcjC3aXHhXVD0vKIxrwMiTwifhvgSiSE/YTHxfEHC79vYSTMeeH53k8L/OoJeaY4lXFLW
	 Dqqm5FGf8UbgxjvUB/WxSLjWVHW4lDB/jWrqNncZ66ZbrFO4HCz57bxkJqMcK54Q2d4V7
	 3teF3bCFDbad6zAfomu6tSZu5VlpeXBHbZDBp+L7XTmnUPOFsi+Jvh3EGj7oeppPN9ksk
	 SqpqMeEhlO6bgXoH1ajQZG2M6v+hhQtW57smcsJDH84nLLKcUp7hkM+FxgTc2tfjUDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uV0gmH7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B0F606A321;
	Wed, 25 Nov 2026 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uV0gmH7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934441F000CA;
	Wed, 25 Nov 2026 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619039;
	bh=ODFxbGoOHM3evWs3z04v0ZVj7M/5DK379NaKWKoqQFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uV0gmH7Z/bk4EA9vNWYpeldNe4meboedY4gPZ30Ijm/lbs74KTVwCFTu5pUtBy99v
	 jGZd1X2kqyupW3JeM5AAvVEV8nCgSa+yBfudsaesEow3MqlsAxpIx3xolIs7SVjIMR
	 ua0qkx1Nlelvc+G2pCZWrgN35KdNmyKLTiIX4910=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0470/1005] bonding: fix slave_cnt leak on XDP enslave failure
Date: Wed, 25 Nov 2026 15:30:08 +0100
Message-ID: <20261125143832.755861778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit a978095699641d4f83a32b499a981c419c94abca ]

bond_enslave() increments bond->slave_cnt before setting up XDP on the
new slave. If that setup fails (slave has no XDP support, already has
an XDP program, or dev_xdp_propagate() fails), the error path jumps to
err_sysfs_del, which never decrements slave_cnt.

Each failed enslave therefore leaves slave_cnt one too high:
- SIOCBONDINFOQUERY reports a wrong num_slaves,
- balance-rr picks slave ids beyond the end of the slave list, so
  bond_get_slave_by_id() falls back to the first usable slave and
  transmit is skewed toward it.

Reproducer:

  ip link add bond0 type bond mode balance-rr
  ip link set bond0 xdpdrv obj xdp_dummy.bpf.o sec xdp
  for i in 0 1 2; do
    ip link add d$i type dummy
    ip link set d$i master bond0   # fails: Slave does not support XDP
  done

num_slaves read via SIOCBONDINFOQUERY is 3 before this patch, 0 after.

Add an err_dec_slave_cnt label ahead of err_sysfs_del and use it from
the three XDP failure paths, which are the only failures after the
increment.

Fixes: 9e2ee5c7e7c3 ("net, bonding: Add XDP support to the bonding driver")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261104092851.688361-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a1c156c145b2d..e9f5e753f6770 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2305,7 +2305,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
 				     "Slave does not support XDP");
 			res = -EOPNOTSUPP;
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 	} else if (bond->xdp_prog) {
 		struct netdev_bpf xdp = {
@@ -2319,14 +2319,14 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
 				     "Slave has XDP program loaded, please unload before enslaving");
 			res = -EOPNOTSUPP;
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 
 		res = dev_xdp_propagate(slave_dev, &xdp);
 		if (res < 0) {
 			/* ndo_bpf() sets extack error message */
 			slave_dbg(bond_dev, slave_dev, "Error %d calling ndo_bpf\n", res);
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 		if (bond->xdp_prog)
 			bpf_prog_inc(bond->xdp_prog);
@@ -2348,6 +2348,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	return 0;
 
 /* Undo stages on error */
+err_dec_slave_cnt:
+	WRITE_ONCE(bond->slave_cnt, bond->slave_cnt - 1);
+
 err_sysfs_del:
 	bond_sysfs_slave_del(new_slave);
 
-- 
2.53.0



