Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705286;
	b=HBdC29mERgBb52CfYbKyB8DjeN8eNOZAPAz5p+joF7YMCocjeC0gSppsW1XsaXqbDD9g
	 TqjJBbRHx2uHEzNtP3HdbGPRUHPKuCwXjDqHfJwOicAp6Ww98EUOc38pb8rsx3xyiYOCL
	 UV5ON6DpAZ0yjKeeVaAwh/xY4jBhHf1JRIf6HyuwVnSmAwdqKb0XQaTwAfwDEBc6dFKLw
	 SueRzJ8If6qCFj/MOGZiBqpbqghhX2aHG0WGHN4dIIHzYaWPOfOlIbzHvMvdV5hwcFMbw
	 dpc4B1dIzO+8rG1l2FGRDshN7SoTiaHdNiL4v3UZ04yyERDYie0vWQHJJG++yKWl5tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZnwY/kVK1PyaIKjFzPwpUeOEOPw2dpxLElFZKnJMnpM=;
	b=YVBzkx5j3cK7CojRGl89k329m8wnt132EDr05lidiLwV91iBj322duvb6jUa5u0KPL6T
	 tz/03rrzYe5vD0oS4wYtDUDjwH9YLD6madkpQ1JSxw0lAZxTbRIy1JCxjEKu41SmaenEK
	 6H+1pNBwBCcgdIbIDPVirnvJqzVW/GPoRJaERB4jtE+fIw1DLg5sNksVgWdsdU6Tuu0K1
	 x8gF8oRBYaxVBEW6/bbA91XApB5lbtuF6MoTt1LEOqTUvZr+cYXpMD9twHxR4OYV0BrAQ
	 QJ9lD2rygLtP8KlhivhRGGGqGrh4BYFNEerPAxJR3t/RfZLA8AYGL+nwt2MsWzdRZxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IyxqflKc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C34E606A31E;
	Thu, 26 Nov 2026 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IyxqflKc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FE01F000C4;
	Thu, 26 Nov 2026 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705285;
	bh=ZnwY/kVK1PyaIKjFzPwpUeOEOPw2dpxLElFZKnJMnpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyxqflKc1FtWqIN6iWpM11K7ISNVKktk6Uz5kDf9FY6v5YhUl2pKazjF34B6ZE52A
	 P0997+akB5Z2ISqCckELBCWQ/1tzlSa6snGkaD7ecXCmK/wfkB8iSUTufur7FD6H52
	 Tz5amLMsJENpmINht2VFzZF1OR6EY5Ny+YOria3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/319] bonding: fix slave_cnt leak on XDP enslave failure
Date: Thu, 26 Nov 2026 15:38:35 +0100
Message-ID: <20261126144010.065654735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 17f08b7dd5395..13c85464842ab 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2195,7 +2195,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
 				     "Slave does not support XDP");
 			res = -EOPNOTSUPP;
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 	} else if (bond->xdp_prog) {
 		struct netdev_bpf xdp = {
@@ -2209,14 +2209,14 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
 				     "Slave has XDP program loaded, please unload before enslaving");
 			res = -EOPNOTSUPP;
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 
 		res = slave_dev->netdev_ops->ndo_bpf(slave_dev, &xdp);
 		if (res < 0) {
 			/* ndo_bpf() sets extack error message */
 			slave_dbg(bond_dev, slave_dev, "Error %d calling ndo_bpf\n", res);
-			goto err_sysfs_del;
+			goto err_dec_slave_cnt;
 		}
 		if (bond->xdp_prog)
 			bpf_prog_inc(bond->xdp_prog);
@@ -2231,6 +2231,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	return 0;
 
 /* Undo stages on error */
+err_dec_slave_cnt:
+	WRITE_ONCE(bond->slave_cnt, bond->slave_cnt - 1);
+
 err_sysfs_del:
 	bond_sysfs_slave_del(new_slave);
 
-- 
2.53.0



