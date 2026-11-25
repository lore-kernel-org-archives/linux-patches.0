Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624923;
	b=ZiF2Ppbv62GrXHBKnDI/dEq1J0aiJRioumMFGiNn+lgzEdGZ+DfsgxinropoRhEzUOuP
	 9cpjIwpWVyzQTufqkeXHQL3p1LOiQGl668C7UKrHk7SP4irm+Lz/4elK4AwZuwWB1ugus
	 ozKIUv/tyb2OcuWIWxAw25PaKqYGP741g3OAgIk+sWQgMaBvJk8DtnnCmYDYojAcC17li
	 /g+0YprKmxIUuZzBMvLqHLIDaLhrQJfD1WUBtvB7X4puRmlB0O7UP4kF/9nLB4FFn745Z
	 ya3m0YoADiYtJ9kjlqE3OCRwvglpC+t6+Mgyu8gfHcqLQzOrIZ+jJgRDCa2ZGFrR88w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hj5zgoJzDpygYpk9fTWBGbvnEVz7Ll9tbSoanIYZDYM=;
	b=cKw/47FCaEQAGudZv+oajkUx3oLhLIU7NDQCzI0NBs+wx0psx1sI7/ob/8ZLqcHmHHIv
	 ExFYcK2s1ri+dfyU6Hy9BoiU0uGfMqWEbpGnpSezW21fyIfmqQNo+SxGrV87We4G5e+CT
	 +fBszPsiwmIfLZ+2qmh940aonJYI7s6zV5FvOV4TLVHoRBXSgq0O3Sn47aGT8zSBastKJ
	 WTXNaAldYI8xBmjGWWjMzZSpS3eLaCJI4rxgjOVXJL9rtzMvnHFw7uCXo4yHqMlsUKpzy
	 nv8kMaN/zu5/1DakzdBETKBwR26r4Wq2GjpGGwQHvSWAVDlRCzl/vUeD1njx4whNBpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLRg41c2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E117606A323;
	Wed, 25 Nov 2026 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLRg41c2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507C41F000F0;
	Wed, 25 Nov 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624922;
	bh=hj5zgoJzDpygYpk9fTWBGbvnEVz7Ll9tbSoanIYZDYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLRg41c2YMbRC5xGkGqmXB4r2+HHADs7iUXTtzFEIAYhsycp5owpp6t9grRruYnJq
	 CA/aP/aeRrUxl81mWCnOacgEZio35nxZ9TW8nOZ+mRtAvHY3KK7B/edyvFXRYKEW+u
	 EvQwUwWTDEJjzUmtZ8ds5/egfiTy/Lc3Pvy62Rrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/816] bonding: fix slave_cnt leak on XDP enslave failure
Date: Wed, 25 Nov 2026 15:31:10 +0100
Message-ID: <20261125143856.655716010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 75332e50fcc51..ee95b5a9fb8ec 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2363,7 +2363,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
 				     "Slave does not support XDP");
 			res = -EOPNOTSUPP;
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 	} else if (bond->xdp_prog) {
 		struct netdev_bpf xdp = {
@@ -2377,14 +2377,14 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
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
@@ -2406,6 +2406,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	return 0;
 
 /* Undo stages on error */
+err_dec_slave_cnt:
+	WRITE_ONCE(bond->slave_cnt, bond->slave_cnt - 1);
+
 err_sysfs_del:
 	bond_sysfs_slave_del(new_slave);
 
-- 
2.53.0



