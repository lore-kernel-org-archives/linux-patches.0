Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D40335CB91;
	Tue,  6 Jan 2026 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721634; cv=none; b=XtxxExLOoV5bqLYjh1H84mrTas5VX09JRqV+6aisp9WM7+1pnfg3+AEvEkEncNie65vmKNJ1fwIF8tu/Xh3f7uViGTrCuduVb+X5D/CW4jyV5kqQ72KGmT4OKTIinR7XPNTLQZPT1WMieCT5C1w5sMZ0HGv6sRdKCjdi0Hh17Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721634; c=relaxed/simple;
	bh=uTsua12XyVJdYMsP6DkkhjoraU+zl1RsYEyoZKfcvP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpBSNz2DVu4aK1qKqvuGJ/bfDf23wNcgGtwIOQ+T2ylTzJyW7ugCExdlYZNpWUhU63F72eDHUuD1D0wq3WSx9hJ4Z2/7puZpYZRcVXh+Gz+soOItLTY0XlQUjX8TzcJQHk2CsacSPh/MwnStEuE6fgR4BO4NtQYz07+ToTgmlNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwLOKpiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwLOKpiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1850C116C6;
	Tue,  6 Jan 2026 17:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721634;
	bh=uTsua12XyVJdYMsP6DkkhjoraU+zl1RsYEyoZKfcvP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwLOKpiY20ISTBi/l8U1DM+9fXGbs/GaUZUkYM1zaVogWdoQz2hwZPaO7geuVHV/j
	 32xo649KGmnz9KmCH1xdUa1ULKivNHJfoTeRUPf+tbcqjoMrblhTbckdBpB7Gj6Phy
	 oc1hWCfHaLJXdUzxUG8vzDGfUOzQmyoB2Xu4c6x8=
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
Subject: [PATCH 6.18 027/312] net: openvswitch: Avoid needlessly taking the RTNL on vport destroy
Date: Tue,  6 Jan 2026 18:01:41 +0100
Message-ID: <20260106170548.839332204@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 91a11067e458..6574f9bcdc02 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -160,10 +160,19 @@ void ovs_netdev_detach_dev(struct vport *vport)
 
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



