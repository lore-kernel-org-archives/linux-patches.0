Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C8379F2;
	Tue,  5 Dec 2023 03:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8mj8QtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF0EC433C7;
	Tue,  5 Dec 2023 03:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747673;
	bh=Jd8pz4VSHjIewZv9Gha4slNuXD1WFx5XVcCIaJ+U3vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8mj8QtU2tLbJTJkkMAF971Klt5APp9N2TojGZkCT0eTKpBJzoOo/cG0/BsgDMhol
	 0LTHSaIougQE141Dct8Dls2nGV32IYIt6sakhnGkI8MZ9baR6AjbZljoIUdfHmBCm/
	 C7W/smNrdj134gP7nI322nVsO1801qNGyPgCDs1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Olivier Matz <olivier.matz@6wind.com>
Subject: [PATCH 5.15 26/67] vlan: move dev_put into vlan_dev_uninit
Date: Tue,  5 Dec 2023 12:17:11 +0900
Message-ID: <20231205031521.311405664@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit d6ff94afd90b0ce8d1715f8ef77d4347d7a7f2c0 upstream.

Shuang Li reported an QinQ issue by simply doing:

  # ip link add dummy0 type dummy
  # ip link add link dummy0 name dummy0.1 type vlan id 1
  # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
  # rmmod 8021q

 unregister_netdevice: waiting for dummy0.1 to become free. Usage count = 1

When rmmods 8021q, all vlan devs are deleted from their real_dev's vlan grp
and added into list_kill by unregister_vlan_dev(). dummy0.1 is unregistered
before dummy0.1.2, as it's using for_each_netdev() in __rtnl_kill_links().

When unregisters dummy0.1, dummy0.1.2 is not unregistered in the event of
NETDEV_UNREGISTER, as it's been deleted from dummy0.1's vlan grp. However,
due to dummy0.1.2 still holding dummy0.1, dummy0.1 will keep waiting in
netdev_wait_allrefs(), while dummy0.1.2 will never get unregistered and
release dummy0.1, as it delays dev_put until calling dev->priv_destructor,
vlan_dev_free().

This issue was introduced by Commit 563bcbae3ba2 ("net: vlan: fix a UAF in
vlan_dev_real_dev()"), and this patch is to fix it by moving dev_put() into
vlan_dev_uninit(), which is called after NETDEV_UNREGISTER event but before
netdev_wait_allrefs().

Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_dev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -638,7 +638,12 @@ void vlan_dev_free_egress_priority(const
 
 static void vlan_dev_uninit(struct net_device *dev)
 {
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+
 	vlan_dev_free_egress_priority(dev);
+
+	/* Get rid of the vlan's reference to real_dev */
+	dev_put(vlan->real_dev);
 }
 
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
@@ -851,9 +856,6 @@ static void vlan_dev_free(struct net_dev
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put(vlan->real_dev);
 }
 
 void vlan_setup(struct net_device *dev)


