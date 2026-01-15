Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46293C1FD9;
	Thu, 15 Jan 2026 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498192; cv=none; b=Ipa8TNde0kMag+zNz20t4bAqQY+KeCJhbxNuPRljqB3doUJTxBsaj/0DtBLwvwyiYM8y9ETVpe4Ljttp95jUkni1pVm7FsL8uK4qk3VEU5W9RjPvNmd7Bu6TNk11LkrIOsVU2uceJG7cXH3dXRJ7IHOcm/4iyrIwSefsJrXS/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498192; c=relaxed/simple;
	bh=+4l6IOPui9ijlHGLZWlLDApbuvjWiKNfV7mzOcY+zVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRkMImcMIrE+y+Zn5Ur4BvAAuvzYUf6fLJOE+J5oAW0ClspsSVGxdDXip//2iSOGKEilUNhHQEc0iKoczxblILFwsMj0SDIz/YjNxhjhgy6/9inZ7juTRU8jU92jr9J25vYRaknUPr9rN3Oop9U/S3iQFbkpdn4zK7EEolvs1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPF6EJp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPF6EJp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087A4C116D0;
	Thu, 15 Jan 2026 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498192;
	bh=+4l6IOPui9ijlHGLZWlLDApbuvjWiKNfV7mzOcY+zVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPF6EJp286wiQZuryGOLTyJ6gxF+RA5Ko6kBvSOYqZF0dJm+7huSg6rWfLO1J5Uva
	 6dWDENW/GQhjv1ApImZUrXLMlKRdgT8Mf5WQP31rDqfn0Yoa0JlWQq9gjPvct9oJBx
	 SzM1JBZkYcQTElwJeEvf0cNFmbxHfUkV5eurbYFE=
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
Subject: [PATCH 5.15 344/554] net: openvswitch: Avoid needlessly taking the RTNL on vport destroy
Date: Thu, 15 Jan 2026 17:46:50 +0100
Message-ID: <20260115164258.680728103@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e1a88f13622..3beec619283a 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -154,10 +154,19 @@ void ovs_netdev_detach_dev(struct vport *vport)
 
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



