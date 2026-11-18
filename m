Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057772;
	b=KrB35sXmOQhwcxWWKEJmuF5tSDzym/8dmvUTAOhgPT5k4ehrKaosKycfdryNgPDk/pUB
	 aN/t308RqD5H1Vgstnf2lK9RIVRrNPW6pVS2b1ciJW/KfrUAkMxyIvCF9KCcQE7Gg3u+K
	 kz+uVNe1PVkZk+0Bnipoch8nxaH0wF/1LyvBFnyJ0GmC3/7hUvXzLUgWOSKjE2evVqxq7
	 e2P7lGofhX47EXqpS4b0BcGp93Mjwc9jHE8ECmIg5ROX1DOaMDY+VKQXH3kpf37u32fIn
	 /+V5Rhspg38QN3qL222oK9lmA4J5rx27Us+nXUFq/wvU9gWgLtJtHEC/Kl6yYcEsiOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cZZQA7w/Ehte+r/3QDDjH8n6yN6uEFs8Rd/ribbz99E=;
	b=lmY3B4fA75mwha3odGkxu+DAxCububqgviMBF8FjtpzpENx5mlWlZnz9My7ZlHFp7RTu
	 e5sjn0CRn86E9l6ZtU3egiXyQL7iTOYzuYA5yYlSeITB7oL8io35v/kusY9slVCwyJzRI
	 CIAYSUAEvPiCTwRk14ZahUVpKlVEn3bNmGKS9/7MmGYw4QnE5dr9uWjTV25sv8QPx6Sd2
	 HPT58iju6NMuZMoYZOPaZ3epxs5GdUEmSFSNEj0GPnbk/sup1EBJRxZlsBNvgmqmoEE/Y
	 U3GCYH6uqvUZojzrGbYM4u7i8BaJVLeGlR7VOmrLNw6Ocn61AdcJPd8xPJyigszF9DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ELnJ0d/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1A606A32A;
	Thu, 19 Nov 2026 03:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELnJ0d/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B131F000C4;
	Thu, 19 Nov 2026 03:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057771;
	bh=cZZQA7w/Ehte+r/3QDDjH8n6yN6uEFs8Rd/ribbz99E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELnJ0d/SLYOPCE16ttw/S62xEE91Wx1xfOiuJUNSvXxXsKLGlyARHkMcbUr7TUQh6
	 aFnbggLrwqmhvcZMfOZ8HpC7T61v4hFPuE9QNojH1kvxAXKsY7fJvP/1WdbGZL6SUy
	 1CQ7qz+PEDwil+0bygA0T7v0rlplpb18sJ5tuVus=
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
Subject: [PATCH 5.10 0221/1848] openvswitch: defer tunnel netdev_put to RCU release
Date: Wed, 18 Nov 2026 15:37:39 +0100
Message-ID: <20261118145921.232186412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 70cc8854b8d53..8cbf787d1fcb6 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -191,8 +191,6 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
 		rtnl_delete_link(vport->dev);
-	dev_put(vport->dev);
-	vport->dev = NULL;
 	rtnl_unlock();
 
 	call_rcu(&vport->rcu, vport_netdev_free);
-- 
2.53.0



