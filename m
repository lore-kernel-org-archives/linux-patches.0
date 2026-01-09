Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D133C53A;
	Fri,  9 Jan 2026 12:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962556; cv=none; b=IT2oPkNFVuXL4nVN5g1lDOgl359cAoZYAZ3BNCy/ia/qY7Mk0S4h2oSb7XAH/q9HT4po/UuBIJHs86+ixYbEY8A89KnABoCVQvlkoGZeDRDUE7Yoqr4FdLMGpulOC+eUzFHxwNMyWmPzRgXKuK+g5JRgXLhLE3S8wi0DrE5avbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962556; c=relaxed/simple;
	bh=xit5Pv/VI0QuADik4YBhzSp9SJcGWPxMgl1Gdb4UNrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zhl8W3aqfeFOHrGBOchCeoDZlm5FLWPlJWkS7Tb2Fd1W4XAcI+bSc8aDxpf8vrJ2z+AWNAWLHpOBAKbrVg+IObffDLnn46zkx7fofSGrRD+eU9BBpP4ya5m+rSw5ncw1avI2dcVz/7iB/FTUy1sTJfOyxB+n2bFUtD1kO5UuEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tr694bxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tr694bxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6495EC4CEF1;
	Fri,  9 Jan 2026 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962555;
	bh=xit5Pv/VI0QuADik4YBhzSp9SJcGWPxMgl1Gdb4UNrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tr694bxBgsXMwK99zsmvxWIMaSnR7iUjd2G7ldmfCmHbN4xxGKXLaOhxDEONZwzFR
	 QRjFch6I2FaMFZ3OiAlR5q3fZdOcqpyyER0WEc0s7KWLSu5tbi44t8/GUZbkFSk/tN
	 SrQoE1Tdo8AIElNB6OnTzeHONG8gVrX0axKTINBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 406/634] net: openvswitch: Avoid needlessly taking the RTNL on vport destroy
Date: Fri,  9 Jan 2026 12:41:24 +0100
Message-ID: <20260109112132.807674871@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 5498227676303e3ffa9a3a46214af96bc3e81314 ]

The openvswitch teardown code will immediately call
ovs_netdev_detach_dev() in response to a NETDEV_UNREGISTER notification.
It will then start the dp_notify_work workqueue, which will later end up
calling the vport destroy() callback. This callback takes the RTNL to do
another ovs_netdev_detach_port(), which in this case is unnecessary.
This causes extra pressure on the RTNL, in some cases leading to
"unregister_netdevice: waiting for XX to become free" warnings on
teardown.

We can straight-forwardly avoid the extra RTNL lock acquisition by
checking the device flags before taking the lock, and skip the locking
altogether if the IFF_OVS_DATAPATH flag has already been unset.

Fixes: b07c26511e94 ("openvswitch: fix vport-netdev unregister")
Tested-by: Adrian Moreno <amorenoz@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20251211115006.228876-1-toke@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 2f61d5bdce1a..7126ff104550 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -153,10 +153,19 @@ void ovs_netdev_detach_dev(struct vport *vport)
 
 static void netdev_destroy(struct vport *vport)
 {
-	rtnl_lock();
-	if (netif_is_ovs_port(vport->dev))
-		ovs_netdev_detach_dev(vport);
-	rtnl_unlock();
+	/* When called from ovs_db_notify_wq() after a dp_device_event(), the
+	 * port has already been detached, so we can avoid taking the RTNL by
+	 * checking this first.
+	 */
+	if (netif_is_ovs_port(vport->dev)) {
+		rtnl_lock();
+		/* Check again while holding the lock to ensure we don't race
+		 * with the netdev notifier and detach twice.
+		 */
+		if (netif_is_ovs_port(vport->dev))
+			ovs_netdev_detach_dev(vport);
+		rtnl_unlock();
+	}
 
 	call_rcu(&vport->rcu, vport_netdev_free);
 }
-- 
2.51.0



