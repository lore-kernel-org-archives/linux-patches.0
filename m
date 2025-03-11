Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B038221DA5;
	Tue, 11 Mar 2025 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707328; cv=none; b=BS6hyCqYLE6mh0Xp8VB5wesGHh/J9+eKTN4O2kIJuP/rxzlV2aVZvSq7YL3lEN2m+gEDPaSm/DI/0s2bq+X96nyez3XFEFbOqDYm4AOJHTdc4S5solW2a3kCLxunKIG+qedYNegsWgJPLKV+WxMGKIqUzRb9vDhgAaN7RzZzSBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707328; c=relaxed/simple;
	bh=kK41uRJClIiHTaM9UtIcExeOfS2KDmN81xc5kDNyLyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJuUOvUeNcHgVNP0w22igAS2j7KHjo9wa5yN+pxfgavWWMMuuIktmPLD3ZtiRR7oTnyjWi2FNR9HPJE5UGyqKu3aeQZsxV6pt5avnVSOZAsDGQI/sgrHQeN6SfdOUjWu+RRW096b/kQGsyQm9mMY7z1ha1aSDyiCG9aRClfdh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABw/UbMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABw/UbMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5ABC4CEE9;
	Tue, 11 Mar 2025 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707328;
	bh=kK41uRJClIiHTaM9UtIcExeOfS2KDmN81xc5kDNyLyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABw/UbMANBuKMESKU0jbQNRahWgHaW3Qb5B87w9lhpzcHhaPjZNgiHUZSodpu6fA6
	 YQ4YbJgiP6JSg7ScPBN21y5ab6xycIG+HEYReKq0j8UVOMdZQnnXLPi2gl56PhTuf5
	 +uO0dUNZW3nSkDe6VprvkAzcfwE0P3h4vJogpEQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Olivier Matz <olivier.matz@6wind.com>,
	Ivan Delalande <colona@arista.com>
Subject: [PATCH 5.10 310/462] vlan: move dev_put into vlan_dev_uninit
Date: Tue, 11 Mar 2025 15:59:36 +0100
Message-ID: <20250311145810.609278518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ivan Delalande <colona@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_dev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -629,7 +629,12 @@ void vlan_dev_free_egress_priority(const
 
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
@@ -821,9 +826,6 @@ static void vlan_dev_free(struct net_dev
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put(vlan->real_dev);
 }
 
 void vlan_setup(struct net_device *dev)


