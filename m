Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211533;
	b=EsvVQ384+wQjp8P2BEGuKcl0TzCCAJFmzygpNr/xcoFZW21/dMKao+W1c7Ykj7OiZI66
	 FfRRFGqjZ65TeZFmE0XTGlTdNAMWBjJe6J+mjrVdQ3j1UWXBaePFuu4FXIo9NU6huOj5h
	 TIfhNOc3JQhaj1GwXfAjQ9Dvs/ROsf1epNoZ0dLOJYOhXLp3gPqtBKul1kq+3tFQcNilV
	 Eg3A9jrkrKJ4RbWiDqqqtguIPRIRiUH8WdeEQyNgH9uj5kKUrIZVlRHCO+R1L6+ER3h+d
	 4Y0oRJUCd2VaCwYjTZ7QnKFw/Z0S/pOe25K7cDRuWe4CXzVyJymYW6W5eh5hUkuGWZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOZDZKEPCY6WXg4gUyBADCsJQitpgRL5B82nx4cM0aA=;
	b=l7CiYNhJAOGzPDeIqNa2Kh3H0d0KRjVUH8ESxkb14NU+39k5HePUmPpPF+Ljd5UU+4tu
	 s+p9OmspspYjnpZyLBSt023FWCNnRBqA7yExHo5o7yT+kPi9qK8DP50+X/a1K3ghz361h
	 hdAUvPLYcBbZCGJWoANbfuBUi8pimLJ4oTvgu1fhFz+P4ueZK9TsqrZi4zoqlNociqyTG
	 bczrvG2qeXh+teIPDhhOrJrOPVLAbvqQmXgyqTTZY/zSPl344Lfzd6zOWgAwxYmfZgepf
	 0vUNClkHoCg34BXIGxy3BwXK4FwXugEuHWbOp06ygnRvpgO2hlZ4QqclkL/FBerLz9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbGM4bge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D024606A31A;
	Wed, 28 Oct 2026 18:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbGM4bge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665561F01825;
	Wed, 28 Oct 2026 18:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211532;
	bh=OOZDZKEPCY6WXg4gUyBADCsJQitpgRL5B82nx4cM0aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbGM4bgeX8yPNOKgxcswuacnQ4c8YNqdWqxr8Q28c1l/APxNvsahw3U4Y7F8QzCb4
	 tCrRWrCzEAuahcHetqOaww16OyMU7dkX22u+fnNHtZzAJdYeb/6fQdwg7tAmUxmGO0
	 WFM0MYO+e6W4x1hewaVRMlOWRBnZsRiw2rkHKu8k=
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
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/571] openvswitch: defer tunnel netdev_put to RCU release
Date: Wed, 28 Oct 2026 17:59:16 +0100
Message-ID: <20261028170017.717954258@linuxfoundation.org>
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
(cherry picked from commit 6931d21f87bc6d657f145798fad0bf077b82486c)
[Harshit: Adapt the lifetime fix to dev_put() and one-argument rtnl_delete_link().]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 10e30a85d5c5c..7e8fc1e027501 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -190,8 +190,6 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev);
-	dev_put(vport->dev);
-	vport->dev = NULL;
 	rtnl_unlock();
 
 	call_rcu(&vport->rcu, vport_netdev_free);
-- 
2.53.0



