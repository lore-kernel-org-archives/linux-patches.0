Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211536;
	b=ufkcOYcIDm+fU1vCsajt6yglYlUD7ZBhvAtHXH5jp6GSkHz5tSOetgsuvhwlxh72zVdz
	 a5aroRwRz+bpWGvdIB0QtKw2WsMFxP2JzWVl2j2iz6ua2lUPrA26EWQzlVBXX/+cJEXr/
	 DQED2UGXyBgqhsNSte5hxvvooxXR1SpaKb4cIbgEHa6y36mjZXYq37vwZPx3EqFQzCpAN
	 9VUVM1mhanEFJn7D0AbD8mMdEGXRCUFSTshFCS6LRMgXYfgGScF9cDtztT8nY8MH+ZxWW
	 KEk1n0y3kIQVxHVDKzliyahWu2kMa0tx89ouKie8o9ceSJZIcx2TtNpMJKqqbrKYcLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VaA88n3Iv+mVNmr0qzAmagTxG3eV+iuT48/x5HYXxpM=;
	b=O15A8qH3ReIvvvY3nN4091FsrLAPWLrms7FrBylwTiAVTnKk8DqxKMhXbtVBeKaRb4po
	 wECKod3+ukFhjAtpmtwxNJXoMHJvlsjIO0Gn+s6pEo2t0FEemcomJIMcUjUQ4+46Ced/X
	 WoJ+cj19ldjXyh+17ejDPytJi50dFvMscLb69JEORem7X5A08dZJHCV3av9aCK4JE8Qcg
	 86osaK2095THx5rnS6uUvUKqNjjOM7N/Kz4xrDFoJDlGAOQ48/UWHH6iBgw/QYJdlsxLA
	 GYFfoFI5urn8eCRmkJT6dNbN2HghxeYl4KJ+6Hc6Rze1FOQTu6a9SJsftE1P19w/GrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QwrN+5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8AF606A31C;
	Wed, 28 Oct 2026 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QwrN+5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2BD1F01825;
	Wed, 28 Oct 2026 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211535;
	bh=VaA88n3Iv+mVNmr0qzAmagTxG3eV+iuT48/x5HYXxpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QwrN+5AjPcaL1NphtDI5s6Xdce1G4q5Z6vqcUbY3+JJtmWNNhBSoHiWtVzJtf79x
	 BFjYTcCpVsgagcpezCg3/cOaC3BYcqH/xI1p/3ztWgxrwdt+B2j19e1akv3nl9c5Pg
	 D8Gpk5IaE7l7U8U82o7f+82v5gU+T/kpJqSpr/Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/571] openvswitch: vport: fix self-deadlock on release of tunnel ports
Date: Wed, 28 Oct 2026 17:59:17 +0100
Message-ID: <20261028170017.743185144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit aa69918bd418e700309fdd08509dba324fb24296 ]

vports are used concurrently and protected by RCU, so netdev_put()
must happen after the RCU grace period.  So, either in an RCU call or
after the synchronize_net().  The rtnl_delete_link() must happen under
RTNL and so can't be executed in RCU context.  Calling synchronize_net()
while holding RTNL is not a good idea for performance and system
stability under load in general, so calling netdev_put() in RCU call
is the right solution here.

However,
when the device is deleted, rtnl_unlock() will call netdev_run_todo()
and block until all the references are gone.  In the current code this
means that we never reach the call_rcu() and the vport is never freed
and the reference is never released, causing a self-deadlock on device
removal.

Fix that by moving the rcu_call() before the rtnl_unlock(), so the
scheduled RCU callback will be executed when synchronize_net() is
called from the rtnl_unlock()->netdev_run_todo() while the RTNL itself
is already released.

Fixes: 6931d21f87bc ("openvswitch: defer tunnel netdev_put to RCU release")
Cc: stable@vger.kernel.org
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260430233848.440994-2-i.maximets@ovn.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit aa69918bd418e700309fdd08509dba324fb24296)
[Harshit: Resolved minor conflicts because 5.15.y has one-argument
rtnl_delete_link() call.]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 7e8fc1e027501..7c31995618d6c 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -190,9 +190,13 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev);
-	rtnl_unlock();
 
+	/* We can't put the device reference yet, since it can still be in
+	 * use, but rtnl_unlock()->netdev_run_todo() will block until all
+	 * the references are released, so the RCU call must be before it.
+	 */
 	call_rcu(&vport->rcu, vport_netdev_free);
+	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(ovs_netdev_tunnel_destroy);
 
-- 
2.53.0



