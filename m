Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEF9402B9B;
	Tue, 31 Mar 2026 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974938; cv=none; b=F2NnbT2E0hk9ZNzQ45po4jgvPE+XUJfel9ggtkFV5ejcvaeG527+5ZcRDMHgypOsyCJ3u8VUt24SWcMRysNeEq/Nu+EF46HFqzJrjQlMYb3YnrvgPK/9EdmJ9/iw63qCIixb9Hbw44UccgZJaKXmD0dPc3pOuM911BpOdLFa84Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974938; c=relaxed/simple;
	bh=lu3pF75Z3UmUOT/4rSSVSgr0OVbM/oDsrEjgdqPTWWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbIGYooFpOCEQp+xqMsYm32SPYJtDRA+qbC/vSxKUTeGuGsHzeRS1SSlRE+LilTxVaxFJR+BvZeF/gWbZfybaW34k5534MvXmMQ3wU9v+a0Trt8sWjU9BZYpnLfC/z2Xkv6bDUkFRsKxZfoVhPtooyyyrqXdZBslVJ6Bbp55FYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWbZJ9pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWbZJ9pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30923C19423;
	Tue, 31 Mar 2026 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974938;
	bh=lu3pF75Z3UmUOT/4rSSVSgr0OVbM/oDsrEjgdqPTWWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWbZJ9pvgz8D1ROyPOuLAhHc5Hx7+mmC5DKJD13BY+/qzQIaUjX1R8N4Hq248+qx2
	 9im+rkVNuKVxuOqJBZ9QanXR+TOceA3czobFmKSxGOXCODMODe2q+G4lqq0N8rQ+Li
	 0yFRhceqt66BtXBZImqvprtE68XRUIQKsbFxXOgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 103/342] openvswitch: defer tunnel netdev_put to RCU release
Date: Tue, 31 Mar 2026 18:18:56 +0200
Message-ID: <20260331161802.803415203@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <n05ec@lzu.edu.cn>

[ Upstream commit 6931d21f87bc6d657f145798fad0bf077b82486c ]

ovs_netdev_tunnel_destroy() may run after NETDEV_UNREGISTER already
detached the device. Dropping the netdev reference in destroy can race
with concurrent readers that still observe vport->dev.

Do not release vport->dev in ovs_netdev_tunnel_destroy(). Instead, let
vport_netdev_free() drop the reference from the RCU callback, matching
the non-tunnel destroy path and avoiding additional synchronization
under RTNL.

Fixes: a9020fde67a6 ("openvswitch: Move tunnel destroy function to oppenvswitch module.")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260319074241.3405262-1-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index c688dee96503f..12055af832dc0 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -196,8 +196,6 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev, 0, NULL);
-	netdev_put(vport->dev, &vport->dev_tracker);
-	vport->dev = NULL;
 	rtnl_unlock();
 
 	call_rcu(&vport->rcu, vport_netdev_free);
-- 
2.51.0



